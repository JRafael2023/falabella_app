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

import 'package:tottus/custom_code/DBMatrices.dart';
import 'package:tottus/custom_code/Matrices.dart';

Future<String> updateMatrizSQLite(
  String idMatriz,
  String name,
  bool status,
) async {
  try {
    // Crear objeto Matrices con los datos actualizados
    final matriz = Matrices(
      idMatriz: idMatriz,
      name: name,
      createdAt: DateTime.now()
          .toIso8601String(), // O mantén el createdAt original si lo tienes
      status: status,
    );

    // ✅ Usar la función de DBMatrices
    final resultado = await DBMatrices.updateMatriz(matriz);

    return resultado;
  } catch (e) {
    return "❌ Error al actualizar matriz: $e";
  }
}
