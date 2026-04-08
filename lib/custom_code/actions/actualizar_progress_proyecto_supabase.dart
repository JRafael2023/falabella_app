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

import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBControles.dart';

Future<double> actualizarProgressProyectoSupabase(String idProject) async {
  try {
    print('🔄 Calculando progress del proyecto: $idProject');

    // PASO 1: Obtener objetivos desde SQLite (rápido, local)
    final objetivosResponse =
        await DBObjetivos.listarObjetivosPorProyecto(idProject);

    if (objetivosResponse.isEmpty) {
      print('⚠️ No hay objetivos para $idProject');
      return 0.0;
    }

    // PASO 2: Contar controles desde SQLite (sin tocar Supabase)
    int totalControles = 0;
    int controlesCompletados = 0;

    for (final obj in objetivosResponse) {
      final controles = await DBControles.listarControlesJson(obj.idObjetivo);
      totalControles += controles.length;
      controlesCompletados += controles
          .where((c) => c['completed'] == 1 || c['completed'] == true)
          .length;
    }

    if (totalControles == 0) {
      print('⚠️ No hay controles para $idProject');
      return 0.0;
    }

    print('📊 Total controles: $totalControles');
    print('📊 Controles completados: $controlesCompletados');

    // PASO 5: Calcular progress
    double progress = 0.0;
    if (totalControles > 0) {
      progress = (controlesCompletados / totalControles) * 100.0;
    }

    print('📊 Progress calculado: $progress%');

    // PASO 6: Actualizar en Supabase (tabla Projects)
    await ProjectsTable().update(
      data: {'progress': progress},
      matchingRows: (rows) => rows!.eq('id_project', idProject),
    );

    print('✅ Progress actualizado en Supabase: $progress%');

    return progress;
  } catch (e, stackTrace) {
    print('❌ Error al actualizar progress en Supabase: $e');
    print('Stack trace: $stackTrace');
    return 0.0;
  }
}
