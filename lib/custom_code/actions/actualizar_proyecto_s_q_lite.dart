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

Future<String> actualizarProyectoSQLite(
  String idProject,
  String name,
  String description,
  String opinion,
  String? assignUser,
  String? matrixType,
) async {
  try {
    final db = await DBHelper.db;

    // Preparar los datos del proyecto a actualizar
    final Map<String, dynamic> projectData = {
      'name': name,
      'description': description,
      'opinion': opinion,
      'tipoMatriz': matrixType,
      'assign_usuario': assignUser,
      'sincronizadoLocal':
          0, // Marcarlo como no sincronizado después de actualizar
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Actualizar el proyecto en la tabla Proyectos
    final rows = await db.update(
      'Proyectos',
      projectData,
      where: 'idProyecto = ?',
      whereArgs: [idProject],
    );

    if (rows > 0) {
      return "✅ Proyecto actualizado correctamente";
    } else {
      return "⚠️ Proyecto no encontrado";
    }
  } catch (e) {
    return "❌ Error al actualizar proyecto: $e";
  }
}
