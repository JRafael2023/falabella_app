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

Future<double> actualizarProgressProyectoSupabase(String idProject) async {
  try {
    print('🔄 Calculando progress del proyecto en Supabase: $idProject');

    // PASO 1: Obtener todos los objetivos de este proyecto desde SQLite
    final objetivosResponse =
        await DBObjetivos.listarObjetivosPorProyecto(idProject);

    if (objetivosResponse.isEmpty) {
      print('⚠️ No hay objetivos para el proyecto $idProject en SQLite');
      return 0.0;
    }

    print('📊 Proyecto tiene ${objetivosResponse.length} objetivos (SQLite)');

    // PASO 2: Extraer IDs de objetivos
    final idsObjetivos =
        objetivosResponse.map((obj) => obj.idObjetivo).toList();

    if (idsObjetivos.isEmpty) {
      print('⚠️ No hay IDs de objetivos válidos');
      return 0.0;
    }

    // PASO 3: Obtener todos los controles de esos objetivos desde Supabase
    final controlesResponse = await ControlsTable().queryRows(
      queryFn: (q) {
        // Construir filtro OR para múltiples objetivos
        if (idsObjetivos.length == 1) {
          return q!.eq('id_objective', idsObjetivos[0]);
        } else {
          String orFilter =
              idsObjetivos.map((id) => 'id_objective.eq.$id').join(',');
          return q!.or(orFilter);
        }
      },
    );

    if (controlesResponse.isEmpty) {
      print('⚠️ No hay controles en el proyecto (Supabase)');
      return 0.0;
    }

    // PASO 4: Contar total y completados
    final totalControles = controlesResponse.length;
    final controlesCompletados =
        controlesResponse.where((control) => control.completed == true).length;

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
