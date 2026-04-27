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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import '/custom_code/sqlite_helper.dart';

Future<String> limpiarDescripcionesTitulos() async {
  try {

    final database = await DBHelper.db;
    if (database == null) {
      return '❌ Error: No se pudo acceder a la base de datos';
    }

    final result = await database.update(
      'Titulos',
      {'description': ''},
    );

    return '✅ Se limpiaron $result descripciones de títulos';
  } catch (e) {
    return '❌ Error: $e';
  }
}
