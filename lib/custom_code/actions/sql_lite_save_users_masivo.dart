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
import '/flutter_flow/custom_functions.dart';
import 'package:tottus/custom_code/DBUsuarios.dart';
import 'package:tottus/custom_code/Usuario.dart';

Future<String> sqlLiteSaveUsersMasivo(List<UsersRow> rowsSupabase) async {
  try {
    if (rowsSupabase.isEmpty) {
      print('⚠️ No hay usuarios disponibles para guardar');
      return 'No hay usuarios disponibles';
    }

    final countLocal = await DBUsuarios.contarUsuarios();

    print('📊 Users SQLite: $countLocal | Supabase: ${rowsSupabase.length}');

    // Convertir UsersRow a Usuario usando el factory fromUsersRow
    List<Usuario> usuarios = rowsSupabase.map<Usuario>((row) {
      return Usuario.fromUsersRow(row);
    }).toList();

    print('🔄 Guardando ${usuarios.length} usuarios en SQLite...');

    // Insertar usuarios masivamente (usa ConflictAlgorithm.replace)
    final resultado = await DBUsuarios.insertUsuariosMasivos(usuarios);

    print('✅ $resultado');
    return resultado;
  } catch (e) {
    print('❌ Error en sqlLiteSaveUsersMasivo: $e');
    return "Error: $e";
  }
}
