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

    if (objectiveId == null || objectiveId.isEmpty) {
      return 'Error: objectiveId es requerido';
    }

    if (apiResponseDescription.isEmpty) {
      return 'Error: La API de controles no retornó datos';
    }


    final walkthroughMap = Map<String, String>.fromEntries(
      apiResponseWalkthrough
          .where(
              (c) => c['relationships']?['walkthrough']?['data']?['id'] != null)
          .map((c) => MapEntry(
                c['id'].toString(),
                c['relationships']['walkthrough']['data']['id'].toString(),
              )),
    );

    const _pageSize = 50;
    List<dynamic> existingControls = [];
    int _pageFrom = 0;
    bool _hasMore = true;

    while (_hasMore) {
      List<dynamic> page = [];
      for (int _attempt = 1; _attempt <= 3; _attempt++) {
        try {
          page = await supabase.from('Controls').select('''
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
          ''').eq('id_objective', objectiveId!).range(_pageFrom, _pageFrom + _pageSize - 1);
          break;
        } catch (e) {
          final isRetriable = e.toString().contains('57014') ||
              e.toString().contains('statement timeout') ||
              e.toString().contains('canceling statement') ||
              e.toString().contains('Connection closed') ||
              e.toString().contains('ClientException') ||
              e.toString().contains('SocketException') ||
              e.toString().contains('Connection reset');
          if (!isRetriable || _attempt == 3) rethrow;
          await Future.delayed(Duration(seconds: _attempt));
        }
      }

      existingControls.addAll(page);
      if (page.length < _pageSize) {
        _hasMore = false; // última página
      } else {
        _pageFrom += _pageSize;
      }
    }


    final existingMap = Map<String, Map<String, dynamic>>.fromEntries(
      existingControls.map((c) => MapEntry(
            c['id_control'] as String,
            c as Map<String, dynamic>,
          )),
    );


    final toUpdate = <Map<String, dynamic>>[];
    final toInsert = <Map<String, dynamic>>[];
    final combinedControls = <Control>[];

    for (final controlData in apiResponseDescription) {
      final controlId = controlData['id'].toString();
      final existing = existingMap[controlId];

      if (existing != null) {

        final localData = await DBControles.obtenerControlCompleto(controlId);

        final existingCompleted = existing['completed'] == true || existing['completed'] == 1;

        final control = Control(
          idControl: controlId,
          title: controlData['attributes']?['title']?.toString() ?? existing['title']?.toString() ?? '',
          description: controlData['attributes']?['description']?.toString() ?? existing['description']?.toString() ?? '',
          objectiveId: objectiveId,
          walkthroughId: walkthroughMap[controlId] ?? existing['walkthrough_id']?.toString(),
          findingStatus: existingCompleted ? existing['finding_status'] : null,
          photos: await _resolveAttachment(() => DBControlAttachments.obtenerPhotos(controlId),
              functions.convertirJSONaFormatoSQLite(existing['photos'])),
          video: await _resolveAttachment(() => DBControlAttachments.obtenerVideos(controlId),
              functions.convertirJSONaFormatoSQLite(existing['video'])),
          archives: await _resolveAttachment(() => DBControlAttachments.obtenerArchives(controlId),
              functions.convertirJSONaFormatoSQLite(existing['archives'])),
          status: existing['status'] ?? true,
          completed: existingCompleted,
          createdAt: existing['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          updatedAt: existing['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
          observacion: _localFirst(localData?['observacion']?.toString(), existing['observacion']),
          gerencia: _localFirst(localData?['gerencia']?.toString(), existing['gerencia']),
          ecosistema: _localFirst(localData?['ecosistema']?.toString(), existing['ecosistema']),
          fecha: _localFirst(localData?['fecha']?.toString(), existing['fecha']),
          descripcionHallazgo: _localFirst(localData?['descripcion_hallazgo']?.toString(), existing['descripcion_hallazgo']),
          recomendacion: _localFirst(localData?['recomendacion']?.toString(), existing['recomendacion']),
          procesoPropuesto: _localFirst(localData?['proceso_propuesto']?.toString(), existing['proceso_propuesto']),
          titulo: _localFirst(localData?['titulo']?.toString(), existing['titulo']),
          nivelRiesgo: _localFirst(localData?['nivel_riesgo']?.toString(), existing['nivel_riesgo']),
          controlText: _localFirst(localData?['control_text']?.toString(), existing['control_text']),
          tituloObservacion: _localFirst(localData?['titulo_observacion']?.toString(), existing['titulo_observacion']),
          riskLevelId: _localFirst(localData?['risk_level_id']?.toString(), existing['risk_level_id']),
          publicationStatusId: _localFirst(localData?['publication_status_id']?.toString(), existing['publication_status_id']),
          estadoPublicacion: _localFirst(localData?['estado_publicacion']?.toString(), existing['estado_publicacion']),
          impactTypeId: _localFirst(localData?['impact_type_id']?.toString(), existing['impact_type_id']),
          tipoImpacto: _localFirst(localData?['tipo_impacto']?.toString(), existing['tipo_impacto']),
          ecosystemSupportId: _localFirst(localData?['ecosystem_support_id']?.toString(), existing['ecosystem_support_id']),
          soporteEcosistema: _localFirst(localData?['soporte_ecosistema']?.toString(), existing['soporte_ecosistema']),
          riskTypeId: _localFirst(localData?['risk_type_id']?.toString(), existing['risk_type_id']),
          tipoRiesgo: _localFirst(localData?['tipo_riesgo']?.toString(), existing['tipo_riesgo']),
          riskTypologyId: _localFirst(localData?['risk_typology_id']?.toString(), existing['risk_typology_id']),
          tipologiaRiesgo: _localFirst(localData?['tipologia_riesgo']?.toString(), existing['tipologia_riesgo']),
          gerenteResponsable: _localFirst(localData?['gerente_responsable']?.toString(), existing['gerente_responsable']),
          auditorResponsable: _localFirst(localData?['auditor_responsable']?.toString(), existing['auditor_responsable']),
          descripcionRiesgo: _localFirst(localData?['descripcion_riesgo']?.toString(), existing['descripcion_riesgo']),
          observationScopeId: _localFirst(localData?['observation_scope_id']?.toString(), existing['observation_scope_id']),
          alcanceObservacion: _localFirst(localData?['alcance_observacion']?.toString(), existing['alcance_observacion']),
          riskActualLevelId: _localFirst(localData?['risk_actual_level_id']?.toString(), existing['risk_actual_level_id']),
          riesgoActual: _localFirst(localData?['riesgo_actual']?.toString(), existing['riesgo_actual']),
          causaRaiz: _localFirst(localData?['causa_raiz']?.toString(), existing['causa_raiz']),
        );

        combinedControls.add(control);

        toUpdate.add({
          'id': existing['id'],
          'data': {
            'title': control.title,
            'description': control.description,
            'walkthrough_id': control.walkthroughId,
          },
        });
      } else {
        final control = Control(
          idControl: controlId,
          title: controlData['attributes']?['title']?.toString() ?? '',
          description:
              controlData['attributes']?['description']?.toString() ?? '',
          objectiveId: objectiveId,
          walkthroughId: walkthroughMap[controlId],
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

        toInsert.add({
          'id_control': control.idControl,
          'title': control.title,
          'description': control.description,
          'id_objective': control.objectiveId,
          'walkthrough_id': control.walkthroughId,
          'finding_status': null,
          'photos': null,
          'video': null,
          'archives': null,
          'status': control.status,
          'completed': control.completed,
          'created_at': control.createdAt,
          'updated_at': control.updatedAt,
        });
      }
    }

    final supabaseFuture = Future(() async {
      int updated = 0;
      int inserted = 0;

      for (int i = 0; i < toUpdate.length; i += 50) {
        final batch = toUpdate.skip(i).take(50);
        await Future.wait(batch.map((item) => supabase
            .from('Controls')
            .update(item['data'])
            .eq('id', item['id'])));
        updated += batch.length;
      }

      for (int i = 0; i < toInsert.length; i += 100) {
        final batch = toInsert.skip(i).take(100).toList();
        await supabase.from('Controls').insert(batch);
        inserted += batch.length;
      }

      return {'updated': updated, 'inserted': inserted};
    });

    final sqliteFuture =
        DBControles.insertControlesMasivos(combinedControls, objectiveId);

    final results = await Future.wait([supabaseFuture, sqliteFuture]);
    final supabaseResult = results[0] as Map<String, int>;
    final sqliteResult = results[1] as String;

    final duration = DateTime.now().difference(startTime).inMilliseconds;

    final message = '✅ Sincronización en ${duration}ms: '
        '${supabaseResult['updated']} actualizados, '
        '${supabaseResult['inserted']} insertados';


    return message;
  } catch (e, stackTrace) {
    final isRetriable = e.toString().contains('57014') ||
        e.toString().contains('statement timeout') ||
        e.toString().contains('canceling statement') ||
        e.toString().contains('Connection closed') ||
        e.toString().contains('ClientException') ||
        e.toString().contains('SocketException') ||
        e.toString().contains('Connection reset');
    if (isRetriable) rethrow;
    return 'Error: $e';
  }
}

String? _localFirst(String? localVal, dynamic supabaseVal) {
  if (localVal != null && localVal.isNotEmpty) return localVal;
  final s = supabaseVal?.toString();
  return (s != null && s.isNotEmpty) ? s : null;
}

Future<String?> _resolveAttachment(
  Future<List<String>> Function() loadLocal,
  String? supabaseValue,
) async {
  try {
    final localList = await loadLocal();
    if (localList.isNotEmpty) {
      return localList.join(Control.separator);
    }
  } catch (_) {}
  if (supabaseValue != null && supabaseValue.isNotEmpty) {
    return supabaseValue;
  }
  return null;
}
