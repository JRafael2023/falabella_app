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

Future<String> sincronizarGerenciasFromSupabase() async {
  try {
    final gerenciasSupabase = await getGerenciasFromSupabase();

    if (gerenciasSupabase.isEmpty) {
      return 'No hay gerencias en Supabase para sincronizar';
    }

    int sincronizados = 0;
    int errores = 0;

    for (var gerencia in gerenciasSupabase) {
      try {
        await DBGerencia.insertGerencia(gerencia, fromSupabase: true);
        sincronizados++;
      } catch (e) {
        print('❌ Error al sincronizar gerencia a SQLite: $e');
        errores++;
      }
    }

    final mensaje =
        '✅ Descarga completada: $sincronizados gerencias descargadas, $errores errores';
    print(mensaje);
    return mensaje;
  } catch (e) {
    print('❌ Error al descargar gerencias desde Supabase: $e');
    return 'Error al descargar: $e';
  }
}
