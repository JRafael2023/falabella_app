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

Future<String> sincronizarProcesosFromSupabase() async {
  try {
    final procesosSupabase = await getProcesosFromSupabase();

    if (procesosSupabase.isEmpty) {
      return 'No hay procesos en Supabase para sincronizar';
    }

    int sincronizados = 0;
    int errores = 0;

    for (var proceso in procesosSupabase) {
      try {
        await DBProceso.insertProceso(proceso, fromSupabase: true);
        sincronizados++;
      } catch (e) {
        errores++;
      }
    }

    final mensaje =
        '✅ Descarga completada: $sincronizados procesos descargados, $errores errores';
    return mensaje;
  } catch (e) {
    return 'Error al descargar: $e';
  }
}
