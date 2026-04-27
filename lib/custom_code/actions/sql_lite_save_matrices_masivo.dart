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

Future<String> sqlLiteSaveMatricesMasivo(
    List<MatricesRow> rowsSupabaseMatriz) async {
  try {
    if (rowsSupabaseMatriz.isEmpty) {
      return 'No hay matrices disponibles';
    }

    final countLocal = await DBMatrices.countMatrices();


    if (rowsSupabaseMatriz.isNotEmpty) {
    }

    List<Matrices> matrices = rowsSupabaseMatriz.map<Matrices>((row) {
      return Matrices.fromMatricesRow(row);
    }).toList();

    if (matrices.isNotEmpty) {
    }

    if (countLocal == 0) {
      return await DBMatrices.insertMatricesMasivas(matrices);
    } else {
      return await DBMatrices.insertMatricesIncrementales(matrices);
    }
  } catch (e) {
    return "Error: $e";
  }
}
