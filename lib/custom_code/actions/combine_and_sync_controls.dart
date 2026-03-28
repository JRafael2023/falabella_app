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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBControlAttachments.dart';
import '/flutter_flow/custom_functions.dart' as functions;

Future<String> combineAndSyncControls(
  List<dynamic> apiResponseDescription,
  List<dynamic> apiResponseWalkthrough,
  String? objectiveId,
) async {
  try {
    final supabase = SupaFlow.client;
    final startTime = DateTime.now();

    // 🔹 VALIDAR parámetros
    if (objectiveId == null || objectiveId.isEmpty) {
      return 'Error: objectiveId es requerido';
    }

    // Solo bloqueamos si la lista de controles principales está vacía.
    // La lista de walkthroughs puede ser vacía (el walkthroughMap quedará vacío
    // y los controles se guardarán sin walkthrough_id, lo cual es válido).
    if (apiResponseDescription.isEmpty) {
      return 'Error: La API de controles no retornó datos';
    }

    print('📥 Procesando ${apiResponseDescription.length} controles');

    // 🔹 PASO 1: CREAR mapa de walkthrough_ids (OPTIMIZADO)
    final walkthroughMap = Map<String, String>.fromEntries(
      apiResponseWalkthrough
          .where(
              (c) => c['relationships']?['walkthrough']?['data']?['id'] != null)
          .map((c) => MapEntry(
                c['id'].toString(),
                c['relationships']['walkthrough']['data']['id'].toString(),
              )),
    );

    // 🔹 PASO 2: OBTENER controles existentes CON TODOS LOS CAMPOS ✅
    final existingControlsFuture = supabase.from('Controls').select('''
          id,
          id_control,
          completed,
          finding_status,
          photos,
          video,
          archives,
          status,
          observacion,
          gerencia,
          ecosistema,
          fecha,
          descripcion_hallazgo,
          recomendacion,
          proceso_propuesto,
          titulo,
          nivel_riesgo,
          control_text,
          titulo_observacion,
          publication_status_id,
          estado_publicacion,
          impact_type_id,
          tipo_impacto,
          ecosystem_support_id,
          soporte_ecosistema,
          risk_type_id,
          tipo_riesgo,
          risk_typology_id,
          tipologia_riesgo,
          risk_level_id,
          gerente_responsable,
          auditor_responsable,
          descripcion_riesgo,
          observation_scope_id,
          alcance_observacion,
          risk_actual_level_id,
          riesgo_actual,
          causa_raiz
        ''').eq('id_objective', objectiveId!);

    // 🔹 PASO 3: ESPERAR resultado de Supabase
    final existingControls = await existingControlsFuture as List<dynamic>;

    // Crear mapa de existentes CON TODOS LOS DATOS ✅
    final existingMap = Map<String, Map<String, dynamic>>.fromEntries(
      existingControls.map((c) => MapEntry(
            c['id_control'] as String,
            c as Map<String, dynamic>,
          )),
    );

    print(
        '📊 Existentes: ${existingMap.length}, Nuevos: ${apiResponseDescription.length - existingMap.length}');

    // 🔹 PASO 4: PREPARAR operaciones (UPDATE vs INSERT)
    final toUpdate = <Map<String, dynamic>>[];
    final toInsert = <Map<String, dynamic>>[];
    final combinedControls = <Control>[];

    for (final controlData in apiResponseDescription) {
      final controlId = controlData['id'].toString();
      final existing = existingMap[controlId];

      if (existing != null) {
        // ⚡ CRÍTICO: SI YA EXISTE EN SQLITE, PRESERVAR completed/finding_status/photos/etc
        // Solo actualizar title/description/walkthrough_id de la API
        print(
            '🔄 Control $controlId existente - preservando completed=${existing['completed']}, finding=${existing['finding_status']}');

        // Crear Control con TODOS los datos de SQLite, actualizando solo campos de API
        final existingCompleted = existing['completed'] == true || existing['completed'] == 1;
        // ⚡ Convertir fotos/videos/archivos de formato JSON (Supabase) a formato SQLite (|||)
        final photosConvertido = functions.convertirJSONaFormatoSQLite(existing['photos']);
        final videoConvertido = functions.convertirJSONaFormatoSQLite(existing['video']);
        final archivesConvertido = functions.convertirJSONaFormatoSQLite(existing['archives']);

        final control = Control(
          idControl: controlId,
          title: controlData['attributes']?['title']?.toString() ?? existing['title']?.toString() ?? '',
          description: controlData['attributes']?['description']?.toString() ?? existing['description']?.toString() ?? '',
          objectiveId: objectiveId,
          walkthroughId: walkthroughMap[controlId] ?? existing['walkthrough_id']?.toString(),
          // ⚡ PRESERVAR finding_status SOLO si el control fue completado (evaluado por auditor)
          // Si completed=false, el control nunca fue evaluado → finding_status debe ser null
          findingStatus: existingCompleted ? existing['finding_status'] : null,
          // ⚡ CRÍTICO: Si Supabase tiene null para adjuntos/control_text, preservar datos
          // locales de SQLite (pueden ser cambios offline pendientes de subir a Supabase).
          photos: await _resolveAttachment(photosConvertido, () => DBControlAttachments.obtenerPhotos(controlId)),
          video: await _resolveAttachment(videoConvertido, () => DBControlAttachments.obtenerVideos(controlId)),
          archives: await _resolveAttachment(archivesConvertido, () => DBControlAttachments.obtenerArchives(controlId)),
          status: existing['status'] ?? true,
          completed: existingCompleted,
          createdAt: existing['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          updatedAt: existing['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
          // ⚡ PRESERVAR campos de hallazgo
          observacion: existing['observacion']?.toString(),
          gerencia: existing['gerencia']?.toString(),
          ecosistema: existing['ecosistema']?.toString(),
          fecha: existing['fecha']?.toString(),
          descripcionHallazgo: existing['descripcion_hallazgo']?.toString(),
          recomendacion: existing['recomendacion']?.toString(),
          procesoPropuesto: existing['proceso_propuesto']?.toString(),
          titulo: existing['titulo']?.toString(),
          nivelRiesgo: existing['nivel_riesgo']?.toString(),
          // ⚡ CRÍTICO: Preservar control_text local si Supabase tiene null
          controlText: (existing['control_text'] != null && existing['control_text'].toString().isNotEmpty)
              ? existing['control_text'].toString()
              : await DBControles.obtenerControlText(controlId),
          // ⭐ CAMPOS v19 - preservar
          tituloObservacion: existing['titulo_observacion']?.toString(),
          riskLevelId: existing['risk_level_id']?.toString(),
          publicationStatusId: existing['publication_status_id']?.toString(),
          estadoPublicacion: existing['estado_publicacion']?.toString(),
          impactTypeId: existing['impact_type_id']?.toString(),
          tipoImpacto: existing['tipo_impacto']?.toString(),
          ecosystemSupportId: existing['ecosystem_support_id']?.toString(),
          soporteEcosistema: existing['soporte_ecosistema']?.toString(),
          riskTypeId: existing['risk_type_id']?.toString(),
          tipoRiesgo: existing['tipo_riesgo']?.toString(),
          riskTypologyId: existing['risk_typology_id']?.toString(),
          tipologiaRiesgo: existing['tipologia_riesgo']?.toString(),
          gerenteResponsable: existing['gerente_responsable']?.toString(),
          auditorResponsable: existing['auditor_responsable']?.toString(),
          descripcionRiesgo: existing['descripcion_riesgo']?.toString(),
          observationScopeId: existing['observation_scope_id']?.toString(),
          alcanceObservacion: existing['alcance_observacion']?.toString(),
          riskActualLevelId: existing['risk_actual_level_id']?.toString(),
          riesgoActual: existing['riesgo_actual']?.toString(),
          causaRaiz: existing['causa_raiz']?.toString(),
        );

        combinedControls.add(control);

        // Actualizar en Supabase SOLO title/description/walkthrough_id
        toUpdate.add({
          'id': existing['id'],
          'data': {
            'title': control.title,
            'description': control.description,
            'walkthrough_id': control.walkthroughId,
          },
        });
      } else {
        // ✅ SI NO EXISTE: Crear con valores NULL explícitos
        final control = Control(
          idControl: controlId,
          title: controlData['attributes']?['title']?.toString() ?? '',
          description:
              controlData['attributes']?['description']?.toString() ?? '',
          objectiveId: objectiveId,
          walkthroughId: walkthroughMap[controlId],
          // ✅ NULL para nuevos controles
          findingStatus: null,
          photos: null,
          video: null,
          archives: null,
          status: true,
          completed: false,
          createdAt: controlData['attributes']?['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          updatedAt: controlData['attributes']?['updated_at']?.toString() ??
              DateTime.now().toIso8601String(),
        );

        combinedControls.add(control);

        // ✅ Crear JSON manualmente para GARANTIZAR nulls
        toInsert.add({
          'id_control': control.idControl,
          'title': control.title,
          'description': control.description,
          'id_objective': control.objectiveId,
          'walkthrough_id': control.walkthroughId,
          'finding_status': null, // ✅ NULL explícito
          'photos': null, // ✅ NULL explícito
          'video': null, // ✅ NULL explícito
          'archives': null, // ✅ NULL explícito
          'status': control.status,
          'completed': control.completed,
          'created_at': control.createdAt,
          'updated_at': control.updatedAt,
          // Todos los demás campos NULL por defecto en Supabase
        });
      }
    }

    // 🔹 PASO 5: GUARDAR EN SUPABASE Y SQLITE EN PARALELO
    final supabaseFuture = Future(() async {
      int updated = 0;
      int inserted = 0;

      // UPDATE en lotes de 50
      for (int i = 0; i < toUpdate.length; i += 50) {
        final batch = toUpdate.skip(i).take(50);
        await Future.wait(batch.map((item) => supabase
            .from('Controls')
            .update(item['data'])
            .eq('id', item['id'])));
        updated += batch.length;
      }

      // INSERT en lotes de 100
      for (int i = 0; i < toInsert.length; i += 100) {
        final batch = toInsert.skip(i).take(100).toList();
        await supabase.from('Controls').insert(batch);
        inserted += batch.length;
      }

      return {'updated': updated, 'inserted': inserted};
    });

    final sqliteFuture =
        DBControles.insertControlesMasivos(combinedControls, objectiveId);

    // Esperar ambos en paralelo
    final results = await Future.wait([supabaseFuture, sqliteFuture]);
    final supabaseResult = results[0] as Map<String, int>;
    final sqliteResult = results[1] as String;

    final duration = DateTime.now().difference(startTime).inMilliseconds;

    final message = '✅ Sincronización en ${duration}ms: '
        '${supabaseResult['updated']} actualizados, '
        '${supabaseResult['inserted']} insertados';

    print(message);
    print('📱 SQLite: $sqliteResult');

    return message;
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('📋 Stack: $stackTrace');
    return 'Error: $e';
  }
}

/// Resuelve el valor final de un adjunto:
/// - Si Supabase tiene datos → usar esos (son la fuente de verdad una vez sincronizados)
/// - Si Supabase tiene null → preservar datos locales de SQLite (offline pendiente de subir)
Future<String?> _resolveAttachment(
  String? supabaseValue,
  Future<List<String>> Function() loadLocal,
) async {
  if (supabaseValue != null && supabaseValue.isNotEmpty) {
    return supabaseValue; // Supabase tiene datos → usar esos
  }
  // Supabase no tiene datos → preservar local si existe
  try {
    final localList = await loadLocal();
    if (localList.isNotEmpty) {
      print('⚡ Preservando ${localList.length} adjuntos locales (Supabase tiene null)');
      return localList.join(Control.separator);
    }
  } catch (_) {}
  return null;
}
