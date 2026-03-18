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
import 'dart:convert';

Future<List<dynamic>> recargarControlesDesdeSQL(String idObjetivo) async {
  try {
    final todosControles = await DBControles.listarControlesJson(idObjetivo);

    if (todosControles.isEmpty) {
      return [];
    }

    List<dynamic> jsonControles = todosControles.map((map) {
      Control control = Control.fromMap(map);

      return {
        'id_control': control.idControl,
        'title': control.title,
        'description': control.description,
        'photos': control.photos,
        'video': control.video,
        'archives': control.archives,
        'finding_status': control.findingStatus,
        'objective_id': control.objectiveId,
        'walkthrough_id': control.walkthroughId,
        'created_at': control.createdAt,
        'updated_at': control.updatedAt,
        'status': control.status,
        'completed': control.completed,
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
      };
    }).toList();

    return jsonControles;
  } catch (e) {
    return [];
  }
}
