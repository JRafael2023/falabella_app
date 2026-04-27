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

import 'package:tottus/custom_code/DBGerencia.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

Future<String> insertGerenciaToSupabase(GerenciaStruct gerencia) async {
  try {
    final Map<String, dynamic> data = {
      'name': gerencia.nombre,
      'status': gerencia.estado ?? true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };


    final response =
        await SupaFlow.client.from('Managements').insert(data).select();

    if (response != null && response.isNotEmpty) {
      final insertedRow = response[0];
      final insertedId = insertedRow['id'] as String;
      final managementId = insertedRow['management_id'] as String? ?? '';

      // También insertar en SQLite con el management_id correcto
      if (managementId.isNotEmpty) {
        await DBGerencia.insertGerencia(
          GerenciaStruct(
            idGerencia: managementId,
            nombre: gerencia.nombre,
            estado: gerencia.estado ?? true,
          ),
          fromSupabase: true,
        );
      }

      return managementId.isNotEmpty ? managementId : insertedId;
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}
