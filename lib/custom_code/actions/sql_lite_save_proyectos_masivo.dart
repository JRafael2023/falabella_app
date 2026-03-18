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

import 'index.dart'; // Imports other custom actions

import 'package:tottus/custom_code/DBProyectos.dart';
import 'package:tottus/custom_code/Proyecto.dart';
import 'dart:convert';

Future<String> sqlLiteSaveProyectosMasivo(
    List<ProjectsRow> rowsSupabase) async {
  try {
    if (rowsSupabase.isEmpty) {
      return 'No hay proyectos disponibles';
    }

    final countLocal = await DBProyectos.contarProyectos();

    print('📊 SQLite: $countLocal | Supabase: ${rowsSupabase.length}');

    // Convertir ProjectsRow directamente a Proyecto usando fromProjectsRow

    List<Proyecto> proyectos = rowsSupabase.map<Proyecto>((row) {
      return Proyecto.fromProjectsRow(row);
    }).toList();

    if (countLocal == 0) {
      print('🔥 Sync completo');
      return await DBProyectos.insertProyectosMasivos(proyectos);
    } else {
      print('🔄 Sync incremental');
      return await DBProyectos.insertProyectosIncrementales(proyectos);
    }
  } catch (e) {
    print('❌ Error: $e');
    return "Error: $e";
  }
}
