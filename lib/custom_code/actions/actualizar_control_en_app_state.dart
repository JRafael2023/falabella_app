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

/// ⚡ Función optimizada que actualiza SOLO un control en FFAppState
/// En lugar de recargar todos los controles desde SQLite (lento),
/// esta función solo actualiza el control modificado (rápido)
Future actualizarControlEnAppState(String idControl) async {
  try {
    // 1️⃣ Obtener el control COMPLETO desde SQLite
    final controlCompleto = await DBControles.obtenerControlCompleto(idControl);

    if (controlCompleto == null) {
      return;
    }

    // 2️⃣ Contar attachments desde la tabla separada (para mostrar contadores)
    final photosCount = await DBControlAttachments.contarPhotos(idControl);
    final archivesCount = await DBControlAttachments.contarArchives(idControl);
    final hasVideo = await DBControlAttachments.tieneVideo(idControl);

    // 3️⃣ Crear versión LIGERA del control para FFAppState (SIN archivos grandes)
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
      // ⚡ NO incluir archivos grandes (se cargan bajo demanda)
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
      // ⚡ Contadores para UI
      'photos_count': photosCount,
      'archives_count': archivesCount,
      'has_video': hasVideo ? 1 : 0,
    };


    // 4️⃣ Actualizar el control en FFAppState (reemplazar el existente)
    final indice = FFAppState().jsonControles.indexWhere(
        (control) => getJsonField(control, r'''$.id_control''') == idControl);

    if (indice != -1) {
      FFAppState().jsonControles[indice] = controlLigero;
    } else {
      // Si no existe, agregarlo
      FFAppState().addToJsonControles(controlLigero);
    }

  } catch (e) {
  }
}
