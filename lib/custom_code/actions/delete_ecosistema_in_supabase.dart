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

import 'package:tottus/custom_code/DBEcosistema.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> deleteEcosistemaInSupabase(String ecosistemaId) async {
  try {
    // Intentar soft delete en Supabase
    await SupaFlow.client.from('Ecosystems').update({
      'status': false,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('ecosystem_id', ecosistemaId);

    // Online: eliminó en Supabase → eliminar también de SQLite
    await DBEcosistema.deleteEcosistema(ecosistemaId);
    print('✅ Ecosistema eliminado en Supabase y SQLite: $ecosistemaId');
    return true;
  } catch (e) {
    // Offline: marcar como pendiente de eliminar en SQLite
    try {
      final db = await DBHelper.db;
      await db.update(
        'Ecosistemas',
        {'pendienteEliminar': 1},
        where: 'idEcosistema = ?',
        whereArgs: [ecosistemaId],
      );
      print('📌 Ecosistema marcado como pendienteEliminar (offline): $ecosistemaId');
      return true;
    } catch (e2) {
      print('❌ Error al marcar ecosistema como pendienteEliminar: $e2');
      return false;
    }
  }
}
