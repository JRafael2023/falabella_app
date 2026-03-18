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
    // Obtener el usuario actual
    final userUid = FFAppState().currentUser?.uidUsuario ?? '';
    final userRole = FFAppState().currentUser?.rol ?? '';

    if (userUid.isEmpty) {
      print("⚠️ No hay usuario actual, retornando lista vacía");
      return [];
    }

    // Obtener la lista de proyectos desde SQLite
    final List<Proyecto> todosProyectos = await DBProyectos.listarProyectos();

    // Administrador ve TODOS los proyectos, usuario solo los suyos
    final bool esAdmin = userRole.toLowerCase() == 'administrador';
    final List<Proyecto> proyectosFiltrados = esAdmin
        ? todosProyectos
        : todosProyectos.where((p) => p.assignUser == userUid).toList();

    print("📊 Total proyectos en SQLite: ${todosProyectos.length}");
    print("✅ Proyectos para $userRole ($userUid): ${proyectosFiltrados.length}");

    // 🔥 CONVERTIR A MAPS para que getJsonField funcione
    final List<dynamic> proyectosMap =
        proyectosFiltrados.map((p) => p.toJson()).toList();

    // Debug: mostrar los primeros proyectos
    if (proyectosMap.isNotEmpty) {
      print("📋 Primer proyecto: ${proyectosMap.first['name']}");
      print("   Tipo: ${proyectosMap.first.runtimeType}");
    }

    return proyectosMap;
  } catch (e) {
    print("❌ Error en sqlLiteListProyectos: $e");
    return []; // Retornar lista vacía en caso de error
  }
}
