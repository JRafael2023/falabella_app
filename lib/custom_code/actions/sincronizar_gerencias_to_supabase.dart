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

Future<String> sincronizarGerenciasToSupabase() async {
  try {
    final database = await DBHelper.db;

    // Obtener gerencias no sincronizadas
    final List<Map<String, dynamic>> result = await database.query(
      'Gerencias',
      where: 'sincronizadoNube = ? AND sincronizadoLocal = ?',
      whereArgs: [0, 1],
    );

    if (result.isEmpty) {
      print('✅ No hay gerencias pendientes por sincronizar');
      return 'No hay gerencias pendientes por sincronizar';
    }

    int sincronizados = 0;
    int errores = 0;

    for (var map in result) {
      try {
        final gerencia = await DBGerencia.metodoconvertidorGerencia(map);

        // Insertar en Supabase
        final supabaseId = await insertGerenciaToSupabase(gerencia);

        if (supabaseId.isNotEmpty) {
          // Marcar como sincronizado en SQLite
          await database.update(
            'Gerencias',
            {
              'sincronizadoNube': 1,
              'idGerencia': supabaseId,
            },
            where: 'id = ?',
            whereArgs: [map['id']],
          );
          sincronizados++;
        } else {
          errores++;
        }
      } catch (e) {
        print('❌ Error al sincronizar gerencia: $e');
        errores++;
      }
    }

    final mensaje =
        '✅ Sincronización completada: $sincronizados gerencias sincronizadas, $errores errores';
    print(mensaje);
    return mensaje;
  } catch (e) {
    print('❌ Error en sincronización de gerencias: $e');
    return 'Error en sincronización: $e';
  }
}
