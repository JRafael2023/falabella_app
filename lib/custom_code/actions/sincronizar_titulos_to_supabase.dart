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

Future<String> sincronizarTitulosToSupabase() async {
  try {
    final database = await DBHelper.db;

    // Obtener títulos no sincronizados
    final List<Map<String, dynamic>> result = await database.query(
      'Titulos',
      where: 'sincronizadoNube = ? AND sincronizadoLocal = ?',
      whereArgs: [0, 1],
    );

    if (result.isEmpty) {
      print('✅ No hay títulos pendientes por sincronizar');
      return 'No hay títulos pendientes por sincronizar';
    }

    int sincronizados = 0;
    int errores = 0;

    for (var map in result) {
      try {
        final titulo = DBTitulo.metodoConvertidor(map);

        // Insertar en Supabase
        final supabaseId = await insertTituloToSupabase(titulo);

        if (supabaseId.isNotEmpty) {
          // Marcar como sincronizado en SQLite
          await database.update(
            'Titulos',
            {
              'sincronizadoNube': 1,
              'idTitulo': supabaseId,
            },
            where: 'id = ?',
            whereArgs: [map['id']],
          );
          sincronizados++;
        } else {
          errores++;
        }
      } catch (e) {
        print('❌ Error al sincronizar título: $e');
        errores++;
      }
    }

    final mensaje =
        '✅ Sincronización completada: $sincronizados títulos sincronizados, $errores errores';
    print(mensaje);
    return mensaje;
  } catch (e) {
    print('❌ Error en sincronización de títulos: $e');
    return 'Error en sincronización: $e';
  }
}
