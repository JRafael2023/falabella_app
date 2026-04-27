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

import 'package:tottus/custom_code/DBGerencia.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> deleteGerenciaInSupabase(String gerenciaId) async {
  try {
    // Intentar soft delete en Supabase
    await SupaFlow.client.from('Managements').update({
      'status': false,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('management_id', gerenciaId);

    // Online: eliminó en Supabase → eliminar también de SQLite
    await DBGerencia.deleteGerencia(gerenciaId);
    return true;
  } catch (e) {
    // Offline: marcar como pendiente de eliminar en SQLite
    try {
      final db = await DBHelper.db;
      await db.update(
        'Gerencias',
        {'pendienteEliminar': 1},
        where: 'idGerencia = ?',
        whereArgs: [gerenciaId],
      );
      return true;
    } catch (e2) {
      return false;
    }
  }
}
