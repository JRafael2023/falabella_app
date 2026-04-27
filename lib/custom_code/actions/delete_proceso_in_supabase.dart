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

import 'package:tottus/custom_code/DBProceso.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> deleteProcesoInSupabase(String procesoId) async {
  try {
    await SupaFlow.client.from('Processes').update({
      'status': false,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('process_id', procesoId);

    await DBProceso.deleteProceso(procesoId);
    return true;
  } catch (e) {
    try {
      final db = await DBHelper.db;
      await db.update(
        'Procesos',
        {'pendienteEliminar': 1},
        where: 'idProceso = ?',
        whereArgs: [procesoId],
      );
      return true;
    } catch (e2) {
      return false;
    }
  }
}
