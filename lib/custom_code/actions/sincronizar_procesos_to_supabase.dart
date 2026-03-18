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

Future<String> sincronizarProcesosToSupabase() async {
  try {
    final database = await DBHelper.db;

    // Obtener procesos no sincronizados
    final List<Map<String, dynamic>> result = await database.query(
      'Procesos',
      where: 'sincronizadoNube = ? AND sincronizadoLocal = ?',
      whereArgs: [0, 1],
    );

    if (result.isEmpty) {
      print('✅ No hay procesos pendientes por sincronizar');
      return 'No hay procesos pendientes por sincronizar';
    }

    int sincronizados = 0;
    int errores = 0;

    for (var map in result) {
      try {
        final proceso = await DBProceso.metodoconvertidor(map);

        // Insertar en Supabase
        final supabaseId = await insertProcesoToSupabase(proceso);

        if (supabaseId.isNotEmpty) {
          // Marcar como sincronizado en SQLite
          await database.update(
            'Procesos',
            {
              'sincronizadoNube': 1,
              'idProceso': supabaseId,
            },
            where: 'id = ?',
            whereArgs: [map['id']],
          );
          sincronizados++;
        } else {
          errores++;
        }
      } catch (e) {
        print('❌ Error al sincronizar proceso: $e');
        errores++;
      }
    }

    final mensaje =
        '✅ Sincronización completada: $sincronizados procesos sincronizados, $errores errores';
    print(mensaje);
    return mensaje;
  } catch (e) {
    print('❌ Error en sincronización de procesos: $e');
    return 'Error en sincronización: $e';
  }
}
