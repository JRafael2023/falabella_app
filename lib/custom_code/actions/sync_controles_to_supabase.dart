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
import 'dart:convert';
import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBProyectos.dart';
import '/custom_code/sqlite_helper.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/custom_functions.dart' as functions;

Future<String> syncControlesToSupabase(
  List<dynamic> listSQLiteControles,
  List<ControlsRow> listSupabaseControles,
) async {
  try {
    // 1️⃣ VERIFICAR CONEXIÓN A INTERNET
    bool? conectado = await checkInternetConecction();

    if (conectado == null || !conectado) {
      return "❌ Sin conexión a internet. Conéctate para sincronizar.";
    }

    // 2️⃣ VALIDAR PARÁMETROS
    if (listSQLiteControles.isEmpty) {
      return "ℹ️ No hay controles en la base de datos local";
    }

    if (listSupabaseControles.isEmpty) {
      return "ℹ️ No hay controles en Supabase";
    }

    print('📦 SQLite: ${listSQLiteControles.length} controles');
    print('📦 Supabase: ${listSupabaseControles.length} controles');

    // 3️⃣ CONVERTIR CONTROLES DE SQLITE (JSON) A OBJETOS CONTROL
    List<Control> controlesSQLite = [];
    for (var jsonControl in listSQLiteControles) {
      if (jsonControl is Map<String, dynamic>) {
        controlesSQLite.add(Control.fromMap(jsonControl));
      }
    }

    // 4️⃣ CREAR MAPA DE CONTROLES SUPABASE PARA COMPARACIÓN RÁPIDA
    final Map<String, dynamic> mapaSupabase = {};
    for (var control in listSupabaseControles) {
      mapaSupabase[control.idControl ?? ''] = {
        'completed': control.completed ?? false,
        'description': control.description ?? '',
        'finding_status': control.findingStatus,
        'photos': control.photos,
        'video': control.video,
        'archives': control.archives,
        // ⭐ NUEVOS CAMPOS NULLABLE
        'observacion': control.observacion,
        'gerencia': control.gerencia,
        'ecosistema': control.ecosistema,
        'fecha': control.fecha,
        'descripcion_hallazgo': control.descripcionHallazgo,
        'recomendacion': control.recomendacion,
        'proceso_propuesto': control.procesoPropuesto,
        'titulo': control.titulo,
        'nivel_riesgo': control.nivelRiesgo,
        'control_text': control.controlText,
        // ⭐ v19 — estos campos no vienen en ControlsRow,
        // se tratan como null para que siempre se sincronicen si el local tiene valor
        'titulo_observacion': null,
        'risk_level_id': null,
        'publication_status_id': null,
        'estado_publicacion': null,
        'impact_type_id': null,
        'tipo_impacto': null,
        'ecosystem_support_id': null,
        'soporte_ecosistema': null,
        'risk_type_id': null,
        'tipo_riesgo': null,
        'risk_typology_id': null,
        'tipologia_riesgo': null,
        'gerente_responsable': null,
        'auditor_responsable': null,
        'descripcion_riesgo': null,
        'observation_scope_id': null,
        'alcance_observacion': null,
        'risk_actual_level_id': null,
        'riesgo_actual': null,
        'causa_raiz': null,
      };
    }

    // 5️⃣ RESOLVER NOMBRE DEL PROYECTO DESDE SQLITE (fallback robusto)
    String projectName = FFAppState().projectName;
    if (projectName.isEmpty) {
      final proyecto = await DBProyectos.getProyectoByIdProject(FFAppState().idproyect);
      projectName = proyecto?.name ?? '';
      if (projectName.isNotEmpty) {
        print('📦 projectName resuelto desde SQLite: $projectName');
      }
    }

    // 6️⃣ COMPARAR Y PREPARAR TAREAS (sin I/O) — luego ejecutar en paralelo
    int sincronizados = 0;
    int omitidos = 0;
    int errores = 0;
    List<String> erroresDetalle = [];
    // ⚡ Supabase updates se acumulan y corren en paralelo al final
    final List<Future> supabasePendientes = [];
    bool highbondFallo = false;

    // ── FASE A: comparar todos los controles y acumular tareas (sin I/O) ───
    // Cada tarea incluye: control + dataToUpdate + flag needsHighbond
    final List<Map<String, dynamic>> _tareas = [];

    for (var controlLocal in controlesSQLite) {
      try {
        final idControl = controlLocal.idControl;

        if (!mapaSupabase.containsKey(idControl)) {
          print('⚠️ Control $idControl existe en SQLite pero NO en Supabase');
          omitidos++;
          continue;
        }

        final controlRemoto = mapaSupabase[idControl];

        // COMPARAR CAMPOS
        bool completedDiferente =
            controlLocal.completed != controlRemoto['completed'];
        bool descriptionDiferente =
            controlLocal.description != controlRemoto['description'];
        bool findingDiferente =
            controlLocal.findingStatus != controlRemoto['finding_status'];

        // ⚡ Comparar attachments por CANTIDAD (no por contenido).
        // GZIP no es determinístico: re-comprimir el mismo dato produce bytes distintos,
        // por lo que comparar el string GZIP:base64 siempre falla aunque el contenido sea igual.
        int _countVal(dynamic val) {
          if (val == null) return 0;
          if (val is List) return val.length;
          if (val is String) {
            if (val.isEmpty || val == 'null' || val == '[]') return 0;
            try { return (jsonDecode(val) as List).length; } catch (_) {}
            return val.split('|||').where((s) => s.isNotEmpty).length;
          }
          return 0;
        }
        final int localPhotosCount   = controlLocal.getPhotosList()?.length   ?? 0;
        final int localVideosCount   = controlLocal.getVideosList()?.length   ?? 0;
        final int localArchivesCount = controlLocal.getArchivesList()?.length ?? 0;
        final int supaPhotosCount    = _countVal(controlRemoto['photos']);
        final int supaVideosCount    = _countVal(controlRemoto['video']);
        final int supaArchivesCount  = _countVal(controlRemoto['archives']);

        bool photosDiferente   = localPhotosCount   != supaPhotosCount;
        bool videoDiferente    = localVideosCount   != supaVideosCount;
        bool archivesDiferente = localArchivesCount != supaArchivesCount;

        // ⭐ COMPARAR NUEVOS CAMPOS NULLABLE
        bool observacionDiferente =
            controlLocal.observacion != controlRemoto['observacion'];
        bool gerenciaDiferente =
            controlLocal.gerencia != controlRemoto['gerencia'];
        bool ecosistemaDiferente =
            controlLocal.ecosistema != controlRemoto['ecosistema'];
        bool fechaDiferente = controlLocal.fecha != controlRemoto['fecha'];
        bool descripcionHallazgoDiferente =
            controlLocal.descripcionHallazgo !=
                controlRemoto['descripcion_hallazgo'];
        bool recomendacionDiferente =
            controlLocal.recomendacion != controlRemoto['recomendacion'];
        bool procesoPropuestoDiferente = controlLocal.procesoPropuesto !=
            controlRemoto['proceso_propuesto'];
        bool tituloDiferente = controlLocal.titulo != controlRemoto['titulo'];
        bool nivelRiesgoDiferente =
            controlLocal.nivelRiesgo != controlRemoto['nivel_riesgo'];
        bool controlTextDiferente =
            controlLocal.controlText != controlRemoto['control_text'];

        // ⭐ v19 — COMPARAR CAMPOS ADICIONALES
        bool tituloObservacionDiferente = controlLocal.tituloObservacion != controlRemoto['titulo_observacion'];
        bool riskLevelIdDiferente = controlLocal.riskLevelId != controlRemoto['risk_level_id'];
        bool publicationStatusIdDiferente = controlLocal.publicationStatusId != controlRemoto['publication_status_id'];
        bool estadoPublicacionDiferente = controlLocal.estadoPublicacion != controlRemoto['estado_publicacion'];
        bool impactTypeIdDiferente = controlLocal.impactTypeId != controlRemoto['impact_type_id'];
        bool tipoImpactoDiferente = controlLocal.tipoImpacto != controlRemoto['tipo_impacto'];
        bool ecosystemSupportIdDiferente = controlLocal.ecosystemSupportId != controlRemoto['ecosystem_support_id'];
        bool soporteEcosistemaDiferente = controlLocal.soporteEcosistema != controlRemoto['soporte_ecosistema'];
        bool riskTypeIdDiferente = controlLocal.riskTypeId != controlRemoto['risk_type_id'];
        bool tipoRiesgoDiferente = controlLocal.tipoRiesgo != controlRemoto['tipo_riesgo'];
        bool riskTypologyIdDiferente = controlLocal.riskTypologyId != controlRemoto['risk_typology_id'];
        bool tipologiaRiesgoDiferente = controlLocal.tipologiaRiesgo != controlRemoto['tipologia_riesgo'];
        bool gerenteResponsableDiferente = controlLocal.gerenteResponsable != controlRemoto['gerente_responsable'];
        bool auditorResponsableDiferente = controlLocal.auditorResponsable != controlRemoto['auditor_responsable'];
        bool descripcionRiesgoDiferente = controlLocal.descripcionRiesgo != controlRemoto['descripcion_riesgo'];
        bool observationScopeIdDiferente = controlLocal.observationScopeId != controlRemoto['observation_scope_id'];
        bool alcanceObservacionDiferente = controlLocal.alcanceObservacion != controlRemoto['alcance_observacion'];
        bool riskActualLevelIdDiferente = controlLocal.riskActualLevelId != controlRemoto['risk_actual_level_id'];
        bool riesgoActualDiferente = controlLocal.riesgoActual != controlRemoto['riesgo_actual'];
        bool causaRaizDiferente = controlLocal.causaRaiz != controlRemoto['causa_raiz'];

        // ⚡ SIEMPRE sincronizar — los controles ya vienen pre-filtrados por pendiente_sync=1.
        // La comparación ya no decide si sincronizar, solo qué campos incluir en dataToUpdate.
        bool necesitaSincronizacion = true;

        if (necesitaSincronizacion) {
          print('🔄 Preparando $idControl para sincronizar...');

          final projectIdValido = FFAppState().idproyect.isNotEmpty && FFAppState().idproyect != '0';
          final needsHighbond = controlLocal.completed &&
              controlLocal.walkthroughId != null &&
              controlLocal.walkthroughId!.isNotEmpty &&
              projectIdValido;

          // Construir dataToUpdate (sin I/O — puro en memoria)
          Map<String, dynamic> dataToUpdate = {
            'completed': controlLocal.completed,
            'updated_at': DateTime.now().toIso8601String(),
          };

          if (controlLocal.description != null && controlLocal.description!.isNotEmpty) {
            dataToUpdate['description'] = controlLocal.description;
          }
          if (controlLocal.completed && controlLocal.findingStatus != null) {
            dataToUpdate['finding_status'] = controlLocal.findingStatus;
          }
          // 🔥 Photos, video, archives: siempre sincronizar el estado actual.
          // Si local tiene datos → subir. Si local está vacío → limpiar en Supabase (null).
          // Esto cubre el caso de borrar un archivo: SQLite ya lo borró, Supabase debe quedar igual.
          dataToUpdate['photos'] = (controlLocal.photos != null && controlLocal.photos!.isNotEmpty)
              ? functions.convertirFormatoSQLiteAJSON(controlLocal.photos)
              : null;
          dataToUpdate['video'] = (controlLocal.video != null && controlLocal.video!.isNotEmpty)
              ? functions.convertirFormatoSQLiteAJSON(controlLocal.video)
              : null;
          dataToUpdate['archives'] = (controlLocal.archives != null && controlLocal.archives!.isNotEmpty)
              ? functions.convertirFormatoSQLiteAJSON(controlLocal.archives)
              : null;
          if (controlLocal.observacion != null && controlLocal.observacion!.isNotEmpty) dataToUpdate['observacion'] = controlLocal.observacion;
          if (controlLocal.gerencia != null && controlLocal.gerencia!.isNotEmpty) dataToUpdate['gerencia'] = controlLocal.gerencia;
          if (controlLocal.ecosistema != null && controlLocal.ecosistema!.isNotEmpty) dataToUpdate['ecosistema'] = controlLocal.ecosistema;
          if (controlLocal.fecha != null && controlLocal.fecha!.isNotEmpty) dataToUpdate['fecha'] = controlLocal.fecha;
          if (controlLocal.descripcionHallazgo != null && controlLocal.descripcionHallazgo!.isNotEmpty) dataToUpdate['descripcion_hallazgo'] = controlLocal.descripcionHallazgo;
          if (controlLocal.recomendacion != null && controlLocal.recomendacion!.isNotEmpty) dataToUpdate['recomendacion'] = controlLocal.recomendacion;
          if (controlLocal.procesoPropuesto != null && controlLocal.procesoPropuesto!.isNotEmpty) dataToUpdate['proceso_propuesto'] = controlLocal.procesoPropuesto;
          if (controlLocal.titulo != null && controlLocal.titulo!.isNotEmpty) dataToUpdate['titulo'] = controlLocal.titulo;
          if (controlLocal.nivelRiesgo != null && controlLocal.nivelRiesgo!.isNotEmpty) dataToUpdate['nivel_riesgo'] = controlLocal.nivelRiesgo;
          if (controlLocal.controlText != null && controlLocal.controlText!.isNotEmpty) dataToUpdate['control_text'] = controlLocal.controlText;
          if (controlLocal.tituloObservacion != null && controlLocal.tituloObservacion!.isNotEmpty) dataToUpdate['titulo_observacion'] = controlLocal.tituloObservacion;
          if (controlLocal.riskLevelId != null && controlLocal.riskLevelId!.isNotEmpty) dataToUpdate['risk_level_id'] = controlLocal.riskLevelId;
          if (controlLocal.publicationStatusId != null && controlLocal.publicationStatusId!.isNotEmpty) dataToUpdate['publication_status_id'] = controlLocal.publicationStatusId;
          if (controlLocal.estadoPublicacion != null && controlLocal.estadoPublicacion!.isNotEmpty) dataToUpdate['estado_publicacion'] = controlLocal.estadoPublicacion;
          if (controlLocal.impactTypeId != null && controlLocal.impactTypeId!.isNotEmpty) dataToUpdate['impact_type_id'] = controlLocal.impactTypeId;
          if (controlLocal.tipoImpacto != null && controlLocal.tipoImpacto!.isNotEmpty) dataToUpdate['tipo_impacto'] = controlLocal.tipoImpacto;
          if (controlLocal.ecosystemSupportId != null && controlLocal.ecosystemSupportId!.isNotEmpty) dataToUpdate['ecosystem_support_id'] = controlLocal.ecosystemSupportId;
          if (controlLocal.soporteEcosistema != null && controlLocal.soporteEcosistema!.isNotEmpty) dataToUpdate['soporte_ecosistema'] = controlLocal.soporteEcosistema;
          if (controlLocal.riskTypeId != null && controlLocal.riskTypeId!.isNotEmpty) dataToUpdate['risk_type_id'] = controlLocal.riskTypeId;
          if (controlLocal.tipoRiesgo != null && controlLocal.tipoRiesgo!.isNotEmpty) dataToUpdate['tipo_riesgo'] = controlLocal.tipoRiesgo;
          if (controlLocal.riskTypologyId != null && controlLocal.riskTypologyId!.isNotEmpty) dataToUpdate['risk_typology_id'] = controlLocal.riskTypologyId;
          if (controlLocal.tipologiaRiesgo != null && controlLocal.tipologiaRiesgo!.isNotEmpty) dataToUpdate['tipologia_riesgo'] = controlLocal.tipologiaRiesgo;
          if (controlLocal.gerenteResponsable != null && controlLocal.gerenteResponsable!.isNotEmpty) dataToUpdate['gerente_responsable'] = controlLocal.gerenteResponsable;
          if (controlLocal.auditorResponsable != null && controlLocal.auditorResponsable!.isNotEmpty) dataToUpdate['auditor_responsable'] = controlLocal.auditorResponsable;
          if (controlLocal.descripcionRiesgo != null && controlLocal.descripcionRiesgo!.isNotEmpty) dataToUpdate['descripcion_riesgo'] = controlLocal.descripcionRiesgo;
          if (controlLocal.observationScopeId != null && controlLocal.observationScopeId!.isNotEmpty) dataToUpdate['observation_scope_id'] = controlLocal.observationScopeId;
          if (controlLocal.alcanceObservacion != null && controlLocal.alcanceObservacion!.isNotEmpty) dataToUpdate['alcance_observacion'] = controlLocal.alcanceObservacion;
          if (controlLocal.riskActualLevelId != null && controlLocal.riskActualLevelId!.isNotEmpty) dataToUpdate['risk_actual_level_id'] = controlLocal.riskActualLevelId;
          if (controlLocal.riesgoActual != null && controlLocal.riesgoActual!.isNotEmpty) dataToUpdate['riesgo_actual'] = controlLocal.riesgoActual;
          if (controlLocal.causaRaiz != null && controlLocal.causaRaiz!.isNotEmpty) dataToUpdate['causa_raiz'] = controlLocal.causaRaiz;

          _tareas.add({
            'control': controlLocal,
            'needsHighbond': needsHighbond,
            'dataToUpdate': dataToUpdate,
          });
        } else {
          // ✅ SIN DIFERENCIAS → OMITIR
          omitidos++;
        }
      } catch (e) {
        errores++;
        String error = '${controlLocal.title}: ${e.toString()}';
        erroresDetalle.add(error);
        print('❌ Error al procesar ${controlLocal.idControl}: $e');
      }
    }

    // ── Separar tareas: solo-Supabase vs. necesitan HighBond ───────────────
    final _tareasHighbond  = _tareas.where((t) => t['needsHighbond'] == true).toList();
    final _tareasSoloSupa  = _tareas.where((t) => t['needsHighbond'] == false).toList();

    print('📋 Tareas: ${_tareasHighbond.length} con HighBond, ${_tareasSoloSupa.length} solo-Supabase, $omitidos sin cambios');

    // ── FASE B1: controles solo-Supabase → todos en paralelo de una vez ────
    for (final tarea in _tareasSoloSupa) {
      final ctrl = tarea['control'] as Control;
      final capturedData = Map<String, dynamic>.from(tarea['dataToUpdate'] as Map<String, dynamic>);
      final capturedId = ctrl.idControl;
      supabasePendientes.add(ControlsTable().update(
        data: capturedData,
        matchingRows: (rows) => rows.eqOrNull('id_control', capturedId),
      ));
      sincronizados++;
    }
    if (_tareasSoloSupa.isNotEmpty) {
      print('⚡ ${_tareasSoloSupa.length} controles solo-Supabase encolados en paralelo');
    }

    // ── FASE B2: controles con HighBond → lotes de 8 en paralelo ───────────
    // 8 simultáneos: ~3x más rápido que el batch de 3 anterior.
    // Límite para no saturar la API de HighBond ni causar timeouts con adjuntos grandes.
    const int _hbBatch = 8;
    for (int _bi = 0; _bi < _tareasHighbond.length; _bi += _hbBatch) {
      final _lote = _tareasHighbond.skip(_bi).take(_hbBatch).toList();
      print('⚡ Lote HighBond ${(_bi ~/ _hbBatch) + 1}: ${_lote.length} controles en paralelo...');
      await Future.wait(_lote.map((tarea) async {
        final controlLocal = tarea['control'] as Control;
        final idControl = controlLocal.idControl;

        // PASO 1: API HighBond
        if (tarea['needsHighbond'] as bool) {
          try {
            final photosList = controlLocal.getPhotosList();
            final videosList = controlLocal.getVideosList();
            final archivosList = controlLocal.getArchivesList();
            final tieneAdjuntos = (photosList != null && photosList.isNotEmpty) ||
                (videosList != null && videosList.isNotEmpty) ||
                (archivosList != null && archivosList.isNotEmpty);

            // ⭐ NUEVA API: crear observación en Highbond solo para inefectivo
            if (controlLocal.findingStatus == 0) {
              print('🔄 Creando issue Highbond para $idControl');
              final createIssueResponse = await SupabaseFunctionsGroup
                  .createIssueHighbondCall
                  .call(
                projectId: FFAppState().idproyect,
                title: controlLocal.observacion?.isNotEmpty == true
                    ? controlLocal.observacion
                    : controlLocal.tituloObservacion,
                description: controlLocal.descripcionHallazgo,
                owner: controlLocal.gerencia,
                recommendation: controlLocal.recomendacion,
                deficiencyType: controlLocal.ecosistema,
                severity: controlLocal.nivelRiesgo,
                published: false,
                identifiedAt: controlLocal.fecha,
                risk: controlLocal.descripcionRiesgo,
                scope: controlLocal.alcanceObservacion,
                escalation: controlLocal.riesgoActual,
                cause: controlLocal.causaRaiz,
                executiveOwner: controlLocal.gerenteResponsable,
                projectOwner: controlLocal.auditorResponsable,
                tipoImpacto: controlLocal.tipoImpacto,
                soporteEcosistema: controlLocal.soporteEcosistema,
                tipoRiesgo: controlLocal.tipoRiesgo,
                tipologiaRiesgo: controlLocal.tipologiaRiesgo,
              );
              if (!createIssueResponse.succeeded) {
                print('⚠️ Create Issue Highbond falló para $idControl, continuando...');
                highbondFallo = true;
              }
            }

            if (tieneAdjuntos) {
              print('🔄 API evidencias para $idControl (adjuntos=$tieneAdjuntos)');
              final apiInefectivoResponse = await SupabaseFunctionsGroup
                  .updateControlHighbondInefectivoCall
                  .call(
                projectId: FFAppState().idproyect,
                idControl: controlLocal.idControl,
                procesoPropuesto: controlLocal.procesoPropuesto,
                tituloObservacion: controlLocal.observacion,
                titulo: controlLocal.titulo,
                gerencia: controlLocal.gerencia,
                ecosistema: controlLocal.ecosistema,
                fecha: controlLocal.fecha,
                nivelRiesgo: controlLocal.nivelRiesgo,
                descripcion: controlLocal.descripcionHallazgo,
                recomendacion: controlLocal.recomendacion,
                imagesList: functions.decompressGzipBase64List(photosList),
                videosList: functions.decompressGzipBase64List(videosList),
                archivosList: functions.decompressGzipBase64List(archivosList),
                projectName: projectName,
                controlText: controlLocal.title,
              );
              if (!apiInefectivoResponse.succeeded) {
                print('⚠️ API evidencias HighBond falló para $idControl, continuando...');
                highbondFallo = true;
              }
            }

            // Luego API principal (tanto para Efectivo como Inefectivo)
            final apiResponse =
                await SupabaseFunctionsGroup.updateControlHighbondCall.call(
              idWalkthrough: controlLocal.walkthroughId,
              walkthroughResults: (controlLocal.controlText != null && controlLocal.controlText!.isNotEmpty)
                  ? controlLocal.controlText!
                  : controlLocal.description,
              controlDesign: controlLocal.findingStatus == 1,
            );
            if (!apiResponse.succeeded) {
              print('⚠️ API HighBond falló para $idControl, continuando con Supabase...');
              highbondFallo = true;
            }
          } catch (apiError) {
            print('⚠️ Error en API HighBond para $idControl: $apiError, continuando...');
            highbondFallo = true;
          }
        }

        // PASO 2: Encolar update de Supabase para ejecución paralela al final
        final capturedData = Map<String, dynamic>.from(tarea['dataToUpdate'] as Map<String, dynamic>);
        final capturedId = idControl;
        supabasePendientes.add(ControlsTable().update(
          data: capturedData,
          matchingRows: (rows) => rows.eqOrNull('id_control', capturedId),
        ));
        sincronizados++;
        await DBControles.resetPendienteSync(idControl);
        print('✅ Control $idControl sincronizado');
      }));
    }

    // ⚡ Ejecutar todos los updates de Supabase en paralelo
    if (supabasePendientes.isNotEmpty) {
      print('⚡ Ejecutando ${supabasePendientes.length} updates Supabase en paralelo...');
      await Future.wait(supabasePendientes);
    }

    // Reset pendiente_sync para controles solo-Supabase
    if (_tareasSoloSupa.isNotEmpty) {
      await Future.wait(_tareasSoloSupa.map((t) {
        final ctrl = t['control'] as Control;
        return DBControles.resetPendienteSync(ctrl.idControl);
      }));
    }

    // 6️⃣ RETORNAR RESULTADO
    String resultado = '';

    if (sincronizados > 0) {
      resultado += '✅ Sincronización completada\n';
      resultado += '   • Controles actualizados: $sincronizados\n';
    }

    if (omitidos > 0) {
      resultado += '   • Sin cambios: $omitidos\n';
    }

    if (errores > 0) {
      resultado += '⚠️ Errores: $errores\n';
      resultado += '\nDetalles:\n';
      for (var error in erroresDetalle.take(3)) {
        resultado += '   - $error\n';
      }
      if (erroresDetalle.length > 3) {
        resultado += '   ... y ${erroresDetalle.length - 3} más\n';
      }
    }

    // Mensajes específicos
    if (sincronizados > 0 && errores == 0) {
      resultado =
          '✅ ¡Perfecto! Se sincronizaron $sincronizados controles a la nube.';
      if (omitidos > 0) {
        resultado += '\n($omitidos ya estaban sincronizados)';
      }
    } else if (sincronizados == 0 && errores == 0) {
      resultado = 'ℹ️ No hay cambios para sincronizar.\nTodo está actualizado.';
    } else if (sincronizados == 0 && errores > 0) {
      resultado = '❌ No se pudo sincronizar ningún control.\n' + resultado;
    }

    print(resultado);

    // 7️⃣ ACTUALIZAR PROGRESS DEL PROYECTO EN SUPABASE
    try {
      if (controlesSQLite.isNotEmpty) {
        final primerControl = controlesSQLite.first;
        final objectiveId = primerControl.objectiveId;

        if (objectiveId != null && objectiveId.isNotEmpty) {
          final objetivo = await DBObjetivos.getObjetivoByIdObjetivo(objectiveId);

          if (objetivo != null && objetivo.projectId.isNotEmpty) {
            print('🔄 Actualizando progress del proyecto ${objetivo.projectId} en Supabase...');
            final progressActualizado = await actualizarProgressProyectoSupabase(objetivo.projectId);
            print('✅ Progress actualizado en Supabase: $progressActualizado%');
          }
        }
      }
    } catch (e) {
      print('⚠️ Error al actualizar progress del proyecto en Supabase: $e');
    }

    return highbondFallo ? 'exito_highbond_fallo' : 'exito';
  } catch (e) {
    String errorMsg = '❌ Error general en la sincronización: $e';
    print(errorMsg);
    return errorMsg;
  }
}
