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

import 'package:tottus/custom_code/DBProceso.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

Future<String> insertProcesoToSupabase(ProcesoStruct proceso) async {
  try {
    final Map<String, dynamic> data = {
      'name': proceso.nombre,
      'status': proceso.estado ?? true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };


    final response =
        await SupaFlow.client.from('Processes').insert(data).select();

    if (response != null && response.isNotEmpty) {
      final insertedRow = response[0];
      final insertedId = insertedRow['id'] as String;
      final processId = insertedRow['process_id'] as String? ?? '';

      // También insertar en SQLite con el process_id correcto
      if (processId.isNotEmpty) {
        await DBProceso.insertProceso(
          ProcesoStruct(
            idProceso: processId,
            nombre: proceso.nombre,
            estado: proceso.estado ?? true,
          ),
          fromSupabase: true,
        );
      }

      return processId.isNotEmpty ? processId : insertedId;
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}
