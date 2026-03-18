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

import 'package:tottus/custom_code/DBTitulo.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

/// Insertar un título en Supabase
Future<String> insertTituloToSupabase(TituloStruct titulo) async {
  try {
    final Map<String, dynamic> data = {
      'name': titulo.nombre,
      'status': titulo.estado ?? true,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    print('📤 Insertando título en Supabase: ${titulo.nombre}');

    final response = await SupaFlow.client.from('Titles').insert(data).select();

    if (response != null && response.isNotEmpty) {
      final insertedRow = response[0];
      final insertedId = insertedRow['id'] as String;
      final titlesId = insertedRow['titles_id'] as String? ?? '';
      print('✅ Título insertado en Supabase con ID: $insertedId, titles_id: $titlesId');

      // También insertar en SQLite con el titles_id correcto
      if (titlesId.isNotEmpty) {
        await DBTitulo.insertTitulo(
          TituloStruct(
            idTitulo: titlesId,
            nombre: titulo.nombre,
            estado: titulo.estado ?? true,
          ),
          fromSupabase: true,
        );
        print('✅ Título también insertado en SQLite: $titlesId');
      }

      return titlesId.isNotEmpty ? titlesId : insertedId;
    } else {
      print('❌ Error al insertar título en Supabase: response vacío');
      return '';
    }
  } catch (e) {
    print('❌ Error al insertar título en Supabase: $e');
    return '';
  }
}
