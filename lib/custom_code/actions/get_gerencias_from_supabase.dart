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

import 'index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:tottus/custom_code/DBGerencia.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

Future<List<GerenciaStruct>> getGerenciasFromSupabase() async {
  try {
    final response = await SupaFlow.client
        .from('Managements')
        .select()
        .eq('status', true)
        .order('created_at', ascending: false);

    if (response == null) {
      return [];
    }


    final List<GerenciaStruct> gerencias = [];

    for (var item in (response as List)) {
      try {
        final gerencia = GerenciaStruct(
          id: item['id'] as String?,
          idGerencia: (item['management_id'] as String?) ?? (item['id'] as String?),
          nombre: item['name'] as String?,
          createdAt: item['created_at'] != null
              ? DateTime.parse(item['created_at'])
              : DateTime.now(),
          updateAt: item['updated_at'] != null
              ? DateTime.parse(item['updated_at'])
              : null,
          estado: item['status'] as bool? ?? true,
        );
        gerencias.add(gerencia);
      } catch (e) {
      }
    }

    return gerencias;
  } catch (e) {
    return [];
  }
}
