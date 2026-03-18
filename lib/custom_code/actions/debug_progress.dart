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

import '/custom_code/sqlite_helper.dart';

/// Debug: Muestra el estado de los controles en la base de datos
Future<String> debugProgress(String idObjetivo) async {
  try {
    final db = await DBHelper.db;
    if (db == null) return '❌ DB no disponible';

    // Obtener todos los controles del objetivo
    final controles = await db.query(
      'Controles',
      where: 'objective_id = ?',
      whereArgs: [idObjetivo],
    );

    if (controles.isEmpty) {
      return '⚠️ No hay controles para el objetivo $idObjetivo';
    }

    StringBuffer resultado = StringBuffer();
    resultado.writeln('📊 Total de controles: ${controles.length}');
    resultado.writeln('');

    int conStatus1 = 0;
    int completados = 0;

    for (var control in controles) {
      final status = control['status'];
      final completed = control['completed'];
      final title = control['title'];

      if (status == 1) conStatus1++;
      if (completed == 1) completados++;

      resultado.writeln(
          '• $title: status=$status, completed=$completed');
    }

    resultado.writeln('');
    resultado.writeln('🔍 Resumen:');
    resultado.writeln('  - Controles con status=1: $conStatus1');
    resultado.writeln('  - Controles completados: $completados');
    resultado.writeln(
        '  - Progreso calculado: ${conStatus1 > 0 ? (completados / conStatus1 * 100).toStringAsFixed(1) : 0}%');

    return resultado.toString();
  } catch (e) {
    return '❌ Error: $e';
  }
}
