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

Future<List<dynamic>> sqlLiteListProyectos() async {
  try {
    final userUid = FFAppState().currentUser?.uidUsuario ?? '';
    final userRole = FFAppState().currentUser?.rol ?? '';

    if (userUid.isEmpty) {
      return [];
    }

    final List<Proyecto> todosProyectos = await DBProyectos.listarProyectos();

    final bool esAdmin = userRole.toLowerCase() == 'administrador';
    final List<Proyecto> proyectosFiltrados = esAdmin
        ? todosProyectos
        : todosProyectos.where((p) => p.assignUser == userUid).toList();


    final List<dynamic> proyectosMap =
        proyectosFiltrados.map((p) => p.toJson()).toList();

    if (proyectosMap.isNotEmpty) {
    }

    return proyectosMap;
  } catch (e) {
    return []; // Retornar lista vacía en caso de error
  }
}
