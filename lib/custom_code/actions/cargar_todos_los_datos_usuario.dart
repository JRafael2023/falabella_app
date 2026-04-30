// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBControlAttachments.dart';
import '../sqlite_helper.dart';
import '/custom_code/Objetivo.dart';
import '/custom_code/Control.dart';
import '/backend/api_requests/api_calls.dart' as api_calls;

/// Corrige el campo `completed` de los controles comparando SQLite vs Supabase.
/// Regla: completed = localCompleted OR supabaseCompleted
/// También actualiza SQLite para que futuros arranques sean correctos.
Future<List<Map<String, dynamic>>> _patchCompletedDesdeSupabase(
  List<Map<String, dynamic>> controlesLocales,
  String idObjetivo,
) async {
  if (controlesLocales.isEmpty) return controlesLocales;
  try {
    final supabase = SupaFlow.client;
    final rows = await supabase
        .from('Controls')
        .select('id_control, completed, finding_status')
        .eq('id_objective', idObjetivo);

    if (rows.isEmpty) return controlesLocales;

    final supabaseMap = <String, Map<String, dynamic>>{};
    for (final r in rows) {
      supabaseMap[r['id_control'].toString()] = r as Map<String, dynamic>;
    }

    final db = await DBHelper.db;
    final corregidos = <Map<String, dynamic>>[];

    for (final c in controlesLocales) {
      final idControl = c['id_control'].toString();
      final supa = supabaseMap[idControl];
      if (supa == null) {
        corregidos.add(c);
        continue;
      }
      final localCompleted = c['completed'] == 1 || c['completed'] == true;
      final supaCompleted = supa['completed'] == true || supa['completed'] == 1;
      final resolved = localCompleted || supaCompleted;

      if (resolved != localCompleted) {
        // Actualizar SQLite para que próximos arranques sean correctos
        try {
          await db?.update(
            'Controles',
            {
              'completed': resolved ? 1 : 0,
              if (supa['finding_status'] != null)
                'finding_status': supa['finding_status'],
            },
            where: 'id_control = ?',
            whereArgs: [idControl],
          );
        } catch (_) {}
        corregidos.add({...c, 'completed': resolved ? 1 : 0});
      } else {
        corregidos.add(c);
      }
    }
    return corregidos;
  } catch (_) {
    return controlesLocales;
  }
}

/// Sincroniza fotos/video/archives desde Supabase hacia ControlAttachments
/// solo para objetivos que tienen controles con 0 attachments locales.
/// Si todo ya está sincronizado, no hace ninguna llamada de red.
Future<void> _sincronizarFotosFaltantes(List<String> idsObjetivos) async {
  try {
    // ── Paso 1: revisar LOCAL cuáles objetivos tienen controles sin attachments
    final controlesEnMemoria = FFAppState().jsonControles;

    // Agrupar ids de controles sin attachments por objetivo
    final Map<String, List<String>> objetivosSinFotos = {};
    for (final c in controlesEnMemoria) {
      final photosCount = c['photos_count'] as int? ?? 0;
      final archivesCount = c['archives_count'] as int? ?? 0;
      final hasVideo = c['has_video'] as int? ?? 0;
      if (photosCount > 0 || archivesCount > 0 || hasVideo > 0) continue;

      final idControl = c['id_control']?.toString() ?? '';
      final idObj = c['id_objective']?.toString() ??
          c['objective_id']?.toString() ?? '';
      if (idControl.isEmpty || idObj.isEmpty) continue;

      objetivosSinFotos.putIfAbsent(idObj, () => []).add(idControl);
    }

    // Si ningún control tiene 0 attachments → ya todo está sincronizado, salir
    if (objetivosSinFotos.isEmpty) return;

    // ── Paso 2: solo consultar Supabase para los objetivos que necesitan sync
    final supabase = SupaFlow.client;
    bool huboActualizaciones = false;

    for (final idObjetivo in objetivosSinFotos.keys) {
      if (!idsObjetivos.contains(idObjetivo)) continue;
      try {
        final rows = await supabase
            .from('Controls')
            .select('id_control, photos, video, archives')
            .eq('id_objective', idObjetivo);

        for (final row in rows) {
          final idControl = row['id_control']?.toString();
          if (idControl == null || idControl.isEmpty) continue;

          final tienePhotosSupabase = row['photos'] != null;
          final tieneVideoSupabase = row['video'] != null;
          final tieneArchivesSupabase = row['archives'] != null;
          if (!tienePhotosSupabase && !tieneVideoSupabase && !tieneArchivesSupabase) continue;

          if (tienePhotosSupabase) {
            final countPhotos = await DBControlAttachments.contarPhotos(idControl);
            if (countPhotos == 0) {
              final gzip = convertirJSONaFormatoSQLite(row['photos']);
              if (gzip != null && gzip.isNotEmpty) {
                await DBControlAttachments.guardarPhotos(idControl, gzip.split('|||'));
                huboActualizaciones = true;
              }
            }
          }
          if (tieneVideoSupabase) {
            final tieneVideoLocal = await DBControlAttachments.tieneVideo(idControl);
            if (!tieneVideoLocal) {
              final gzip = convertirJSONaFormatoSQLite(row['video']);
              if (gzip != null && gzip.isNotEmpty) {
                await DBControlAttachments.guardarVideos(idControl, gzip.split('|||'));
                huboActualizaciones = true;
              }
            }
          }
          if (tieneArchivesSupabase) {
            final countArchives = await DBControlAttachments.contarArchives(idControl);
            if (countArchives == 0) {
              final gzip = convertirJSONaFormatoSQLite(row['archives']);
              if (gzip != null && gzip.isNotEmpty) {
                await DBControlAttachments.guardarArchives(idControl, gzip.split('|||'));
                huboActualizaciones = true;
              }
            }
          }
        }
      } catch (_) {}
    }

    if (huboActualizaciones) {
      try {
        final idsControles = controlesEnMemoria
            .map((c) => c['id_control']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList();

        if (idsControles.isNotEmpty) {
          final counts =
              await DBControlAttachments.contarAttachmentsPorLote(idsControles);
          final updatedControles = controlesEnMemoria.map((c) {
            final idControl = c['id_control']?.toString() ?? '';
            final info = counts[idControl];
            if (info == null) return c;
            return {
              ...(c as Map<String, dynamic>),
              'photos_count': info['photos'] ?? 0,
              'archives_count': info['archives'] ?? 0,
              'has_video': (info['hasVideo'] == true) ? 1 : 0,
            };
          }).toList();
          FFAppState().jsonControles = updatedControles;
          FFAppState().update(() {});
        }
      } catch (_) {}
    }
  } catch (_) {}
}

Future cargarTodosLosDatosUsuario(String userId) async {
  try {


    String userUid = FFAppState().currentUser.uidUsuario ?? '';

    if (userUid.isEmpty || userUid == 'null') {
      if (userId.isNotEmpty && userId != 'null') {
        try {
          final usuarioSupabase = await UsersTable().queryRows(
            queryFn: (q) => q!.eq('id', userId),
          );
          if (usuarioSupabase.isNotEmpty) {
            userUid = usuarioSupabase.first.userUid ?? '';
          }
        } catch (e) {
        }
      }
    }

    if (userUid.isEmpty || userUid == 'null') {
      FFAppState().jsonObjetivos = [];
      FFAppState().jsonControles = [];
      return;
    }


    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userUid),
    );

    if (proyectosSupabase.isEmpty) {
      FFAppState().jsonObjetivos = [];
      FFAppState().jsonControles = [];
      return;
    }


    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();



    List<dynamic> todosObjetivosJSON = [];
    List<String> proyectosConObjetivos = [];
    int totalObjetivos = 0;

    final Map<String, List<Map<String, dynamic>>> controlesCache = {};

    final batchSize = 5;
    for (var i = 0; i < idsProyectos.length; i += batchSize) {
      final batch = idsProyectos.skip(i).take(batchSize).toList();

      await Future.wait(batch.map((idProyecto) async {
        try {

          final apiObjetivos = await api_calls.SupabaseFunctionsGroup
              .getObjetivesHighbondCall
              .call(idProject: idProyecto);

          if (apiObjetivos?.succeeded ?? false) {

            await sqLiteSaveObjetivosMasivo(
              getJsonField(apiObjetivos?.jsonBody ?? '', r'''$.data.data'''),
            );

            final objetivosSQLite =
                await DBObjetivos.listarObjetivosPorProyecto(idProyecto);

            if (objetivosSQLite.isNotEmpty) {
              proyectosConObjetivos.add(idProyecto);

              final objetivosJSON = await Future.wait(objetivosSQLite.map((obj) async {
                final controlesRaw = await DBControles.listarControlesJson(obj.idObjetivo);
                // Corregir completed comparando Supabase (arregla datos corruptos del bug anterior)
                final controles = await _patchCompletedDesdeSupabase(controlesRaw, obj.idObjetivo);
                controlesCache[obj.idObjetivo] = controles;
                final totalControles = controles.length;
                final completados = controles.where((c) => c['completed'] == 1 || c['completed'] == true).length;
                final progressReal = totalControles > 0 ? (completados / totalControles) : 0.0;

                return {
                  'id_objective': obj.idObjetivo,
                  'id_project': obj.projectId,
                  'title': obj.title,
                  'category': obj.divisionDepartment,
                  'description': obj.description,
                  'progress': progressReal,
                  'completed': obj.status,
                };
              })).then((list) => list.toList());

              todosObjetivosJSON.addAll(objetivosJSON);
              totalObjetivos += objetivosJSON.length;
            }
          } else {
            final objetivosSQLite =
                await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
            if (objetivosSQLite.isNotEmpty) {
              proyectosConObjetivos.add(idProyecto);
              final objetivosJSON = await Future.wait(objetivosSQLite.map((obj) async {
                // Offline: sin Supabase, usar SQLite tal cual
                final controles = await DBControles.listarControlesJson(obj.idObjetivo);
                controlesCache[obj.idObjetivo] = controles;
                final totalControles = controles.length;
                final completados = controles.where((c) => c['completed'] == 1 || c['completed'] == true).length;
                final progressReal = totalControles > 0 ? (completados / totalControles) : 0.0;
                return {
                  'id_objective': obj.idObjetivo,
                  'id_project': obj.projectId,
                  'title': obj.title,
                  'category': obj.divisionDepartment,
                  'description': obj.description,
                  'progress': progressReal,
                  'completed': obj.status,
                };
              })).then((list) => list.toList());
              todosObjetivosJSON.addAll(objetivosJSON);
              totalObjetivos += objetivosJSON.length;
            }
          }
        } catch (e) {
        }
      }));
    }


    FFAppState().jsonObjetivos = todosObjetivosJSON;


    List<dynamic> todosControlesJSON = [];
    int totalControles = 0;

    final Map<String, String> objetivoAProyecto = {
      for (final obj in todosObjetivosJSON)
        if ((obj['id_objective']?.toString() ?? '').isNotEmpty &&
            (obj['id_project']?.toString() ?? '').isNotEmpty)
          obj['id_objective'].toString(): obj['id_project'].toString(),
    };

    final idsObjetivos = todosObjetivosJSON
        .map((obj) => obj['id_objective']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsObjetivos.isEmpty) {
      FFAppState().jsonControles = [];
      return;
    }

    final batchSizeControles = 2;
    for (var i = 0; i < idsObjetivos.length; i += batchSizeControles) {
      final batch = idsObjetivos.skip(i).take(batchSizeControles).toList();

      final resultados = await Future.wait(batch.map((idObjetivo) async {
        Future<List<dynamic>> cargarControlesConRetry(int intento) async {
          try {
            final controlesCached = controlesCache[idObjetivo];
            if (controlesCached != null && controlesCached.isNotEmpty) {
              return controlesCached;
            }

            final controlesSQLite =
                await DBControles.listarControlesJson(idObjetivo);

            if (controlesSQLite.isNotEmpty) {
              return controlesSQLite;
            } else {

              final results = await Future.wait([
                api_calls.SupabaseFunctionsGroup.getControlsDescriptionHighbondCall
                    .call(idObjective: idObjetivo),
                api_calls.SupabaseFunctionsGroup.getControlsWalkthroughHighbondCall
                    .call(idObjective: idObjetivo),
              ]);

              final apiControls = results[0];
              final apiControlWalk = results[1];

              if (apiControls?.succeeded ?? false) {
                await combineAndSyncControls(
                  getJsonField(apiControls?.jsonBody ?? '', r'''$.data.data''', true)!,
                  getJsonField(
                      apiControlWalk?.jsonBody ?? '', r'''$.data.data''', true)!,
                  idObjetivo,
                  projectId: objetivoAProyecto[idObjetivo],
                );

                final controlesNuevos =
                    await DBControles.listarControlesJson(idObjetivo);

                if (controlesNuevos.isNotEmpty) return controlesNuevos;
              }

              // Fallback: cargar directamente de Supabase si HighBond falla o retorna vacío
              try {
                final supabase = SupaFlow.client;
                final rows = await supabase
                    .from('Controls')
                    .select(
                      'id_control, title, description, finding_status, id_objective, '
                      'completed, walkthrough_id, status, observacion, gerencia, '
                      'ecosistema, fecha, descripcion_hallazgo, recomendacion, '
                      'proceso_propuesto, titulo, nivel_riesgo, control_text, '
                      'titulo_observacion, publication_status_id, estado_publicacion, '
                      'impact_type_id, tipo_impacto, ecosystem_support_id, soporte_ecosistema, '
                      'risk_type_id, tipo_riesgo, risk_typology_id, tipologia_riesgo, '
                      'risk_level_id, gerente_responsable, auditor_responsable, '
                      'descripcion_riesgo, observation_scope_id, alcance_observacion, '
                      'risk_actual_level_id, riesgo_actual, causa_raiz, '
                      'created_at, updated_at',
                    )
                    .eq('id_objective', idObjetivo);

                if (rows.isNotEmpty) {
                  final controles = rows.map<Control>((row) {
                    final c = Control.fromSupabase(row);
                    c.projectId = objetivoAProyecto[idObjetivo];
                    return c;
                  }).toList();
                  await DBControles.insertControlesMasivos(controles, idObjetivo);
                  return await DBControles.listarControlesJson(idObjetivo);
                }
              } catch (_) {}
            }
          } catch (e) {
            final esRetriable = e.toString().contains('57014') ||
                e.toString().contains('statement timeout') ||
                e.toString().contains('canceling statement') ||
                e.toString().contains('Connection closed') ||
                e.toString().contains('ClientException') ||
                e.toString().contains('SocketException') ||
                e.toString().contains('Connection reset');
            if (esRetriable && intento < 2) {
              await Future.delayed(const Duration(seconds: 2));
              return cargarControlesConRetry(intento + 1);
            }
          }
          return <dynamic>[];
        }

        return cargarControlesConRetry(1);
      }));

      for (var controles in resultados) {
        todosControlesJSON.addAll(controles);
        totalControles += controles.length;
      }
    }


    // Recalcular progreso de objetivos con los controles ya completos
    // (la primera pasada puede haber calculado 0% si los controles no estaban en SQLite)
    for (var i = 0; i < todosObjetivosJSON.length; i++) {
      final idObj = todosObjetivosJSON[i]['id_objective']?.toString() ?? '';
      if (idObj.isEmpty) continue;
      final controles = todosControlesJSON
          .where((c) =>
              c['objective_id']?.toString() == idObj ||
              c['id_objective']?.toString() == idObj)
          .toList();
      if (controles.isEmpty) continue;
      final total = controles.length;
      final completados = controles
          .where((c) => c['completed'] == 1 || c['completed'] == true)
          .length;
      todosObjetivosJSON[i] = {
        ...(todosObjetivosJSON[i] as Map<String, dynamic>),
        'progress': completados / total,
      };
    }

    FFAppState().jsonObjetivos = todosObjetivosJSON;
    FFAppState().jsonControles = todosControlesJSON;
    FFAppState().update(() {});

    // Background: sync photos/video/archives missing from ControlAttachments
    // (fixes controls that were previously synced without attachments)
    _sincronizarFotosFaltantes(idsObjetivos).catchError((_) {});

  } catch (e, stackTrace) {
    FFAppState().jsonObjetivos = [];
    FFAppState().jsonControles = [];
  }
}
