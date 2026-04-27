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
import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/custom_code/DBControlAttachments.dart';
import 'dart:convert';

Future actualizarControlEnAppState(String idControl) async {
  try {
    final controlCompleto = await DBControles.obtenerControlCompleto(idControl);

    if (controlCompleto == null) {
      return;
    }

    final photosCount = await DBControlAttachments.contarPhotos(idControl);
    final archivesCount = await DBControlAttachments.contarArchives(idControl);
    final hasVideo = await DBControlAttachments.tieneVideo(idControl);

    final controlLigero = {
      'id_control': controlCompleto['id_control'],
      'title': controlCompleto['title'],
      'description': controlCompleto['description'],
      'finding_status': controlCompleto['finding_status'],
      'objective_id': controlCompleto['objective_id'],
      'id_objective': controlCompleto['objective_id'], // Alias
      'walkthrough_id': controlCompleto['walkthrough_id'],
      'created_at': controlCompleto['created_at'],
      'updated_at': controlCompleto['updated_at'],
      'status': controlCompleto['status'],
      'completed': controlCompleto['completed'],
      'titulo': controlCompleto['titulo'],
      'nivel_riesgo': controlCompleto['nivel_riesgo'],
      'photos': null,
      'video': null,
      'archives': null,
      'observacion': null,
      'gerencia': null,
      'ecosistema': null,
      'fecha': null,
      'descripcion_hallazgo': null,
      'recomendacion': null,
      'proceso_propuesto': null,
      'control_text': null,
      'photos_count': photosCount,
      'archives_count': archivesCount,
      'has_video': hasVideo ? 1 : 0,
    };


    final indice = FFAppState().jsonControles.indexWhere(
        (control) => getJsonField(control, r'''$.id_control''') == idControl);

    if (indice != -1) {
      FFAppState().jsonControles[indice] = controlLigero;
    } else {
      FFAppState().addToJsonControles(controlLigero);
    }

  } catch (e) {
  }
}
