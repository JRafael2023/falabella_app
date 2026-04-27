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
import 'package:sqflite/sqflite.dart';

Future<bool> deleteTituloInSupabase(String tituloId) async {
  try {
    await SupaFlow.client.from('Titles').update({
      'status': false,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('titles_id', tituloId);

    await DBTitulo.deleteTitulo(tituloId);
    return true;
  } catch (e) {
    try {
      final db = await DBHelper.db;
      await db.update(
        'Titulos',
        {'pendienteEliminar': 1},
        where: 'idTitulo = ?',
        whereArgs: [tituloId],
      );
      return true;
    } catch (e2) {
      return false;
    }
  }
}
