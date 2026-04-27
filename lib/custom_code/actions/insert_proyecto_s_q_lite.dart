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
import '/custom_code/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

Future<String> insertProyectoSQLite(
  String idProject,
  String name,
  String description,
  String opinion,
  double progress,
  String? assignUser,
  String? matrixType,
) async {
  try {
    final db = await DBHelper.db;

    // Preparar los datos del proyecto
    final Map<String, dynamic> projectData = {
      'idProyecto': idProject,
      'name': name,
      'description': description,
      'state_proyecto': 'active',
      'status_proyecto': 'completed',
      'opinion': opinion,
      'progress': progress,
      'tipoMatriz': matrixType,
      'assign_usuario': assignUser,
      'sincronizadoNube': 0, // pendiente subir a Supabase cuando haya conexión
      'sincronizadoLocal': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'status': 1, // 1 = true, 0 = false
    };

    // Insertar el proyecto en la tabla Proyectos
    await db.insert(
      'Proyectos',
      projectData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return "✅ Proyecto insertado correctamente";
  } catch (e) {
    return "❌ Error al insertar proyecto: $e";
  }
}
