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

import 'package:tottus/custom_code/DBTitulo.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

/// Obtener todos los títulos desde Supabase
Future<List<TituloStruct>> getTitulosFromSupabase() async {
  try {
    final response = await SupaFlow.client
        .from('Titles')
        .select()
        .eq('status', true)
        .order('created_at', ascending: false);

    if (response == null) {
      print('⚠️ No hay títulos en Supabase');
      return [];
    }

    final List<TituloStruct> titulos = (response as List).map((item) {
      return TituloStruct(
        id: item['id'] as String?,
        idTitulo: (item['titles_id'] as String?) ?? (item['id'] as String?),
        nombre: item['name'] as String?,
        createdAt: item['created_at'] != null
            ? DateTime.parse(item['created_at'])
            : DateTime.now(),
        updateAt: item['updated_at'] != null
            ? DateTime.parse(item['updated_at'])
            : null,
        estado: item['status'] as bool? ?? true,
      );
    }).toList();

    print('✅ ${titulos.length} títulos obtenidos desde Supabase');
    return titulos;
  } catch (e) {
    print('❌ Error al obtener títulos desde Supabase: $e');
    return [];
  }
}
