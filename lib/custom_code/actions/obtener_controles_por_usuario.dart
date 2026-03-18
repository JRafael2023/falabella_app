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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:tottus/custom_code/DBObjetivos.dart';
import 'package:tottus/custom_code/Objetivo.dart';

Future<List<ControlsRow>> obtenerControlesPorUsuario(String userId) async {
  try {
    print('🔍 Obteniendo controles para usuario: $userId');

    // 1. Obtener PROYECTOS del usuario desde SUPABASE
    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userId),
    );

    if (proyectosSupabase.isEmpty) {
      print('⚠️ No hay proyectos asignados a este usuario');
      return [];
    }

    print('📊 Proyectos encontrados: ${proyectosSupabase.length}');

    // 2. Extraer IDs de proyectosa
    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsProyectos.isEmpty) {
      print('⚠️ No hay IDs de proyectos válidos');
      return [];
    }

    // 3. Obtener OBJETIVOS de esos proyectos desde SQLITE
    // (porque Objectives NO existe en Supabase)
    List<Objetivo> objetivosSQLite = [];
    for (var idProyecto in idsProyectos) {
      final objetivos =
          await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
      objetivosSQLite.addAll(objetivos);
    }

    if (objetivosSQLite.isEmpty) {
      print('⚠️ No hay objetivos en SQLite para estos proyectos');
      return [];
    }

    print('📊 Objetivos encontrados: ${objetivosSQLite.length}');

    // 4. Extraer IDs de objetivos
    final idsObjetivos = objetivosSQLite
        .map((obj) => obj.idObjetivo)
        .where((id) => id.isNotEmpty)
        .toList();

    // 5. Obtener CONTROLES de esos objetivos desde SUPABASE
    final controlesSupabase = await ControlsTable().queryRows(
      queryFn: (q) {
        if (idsObjetivos.length == 1) {
          return q!.eq('id_objective', idsObjetivos[0]);
        } else {
          // Para múltiples IDs, usamos OR
          String orFilter =
              idsObjetivos.map((id) => 'id_objective.eq.$id').join(',');
          return q!.or(orFilter);
        }
      },
    );

    print('📊 Controles encontrados: ${controlesSupabase.length}');
    return controlesSupabase;
  } catch (e, stackTrace) {
    print('❌ Error obteniendo controles: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}
