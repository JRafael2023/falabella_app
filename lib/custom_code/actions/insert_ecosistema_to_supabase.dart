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

import 'package:tottus/custom_code/DBEcosistema.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

Future<String> insertEcosistemaToSupabase(EcosistemaStruct ecosistema) async {
  try {
    final Map<String, dynamic> data = {
      'name': ecosistema.nombre,
      'status': ecosistema.estado ?? true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    print('📤 Insertando ecosistema en Supabase: ${ecosistema.nombre}');

    final response =
        await SupaFlow.client.from('Ecosystems').insert(data).select();

    if (response != null && response.isNotEmpty) {
      final insertedRow = response[0];
      final insertedId = insertedRow['id'] as String;
      final ecosystemId = insertedRow['ecosystem_id'] as String? ?? '';
      print('✅ Ecosistema insertado en Supabase con ID: $insertedId, ecosystem_id: $ecosystemId');

      // También insertar en SQLite con el ecosystem_id correcto
      if (ecosystemId.isNotEmpty) {
        await DBEcosistema.insertEcosistema(
          EcosistemaStruct(
            idEcosistema: ecosystemId,
            nombre: ecosistema.nombre,
            estado: ecosistema.estado ?? true,
          ),
          fromSupabase: true,
        );
        print('✅ Ecosistema también insertado en SQLite: $ecosystemId');
      }

      return ecosystemId.isNotEmpty ? ecosystemId : insertedId;
    } else {
      print('❌ Error al insertar ecosistema en Supabase: response vacío');
      return '';
    }
  } catch (e) {
    print('❌ Error al insertar ecosistema en Supabase: $e');
    return '';
  }
}
