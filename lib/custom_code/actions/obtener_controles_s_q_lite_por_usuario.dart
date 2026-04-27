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
import 'package:tottus/custom_code/DBControles.dart';
import 'package:tottus/custom_code/DBObjetivos.dart';
import 'package:tottus/custom_code/DBProyectos.dart';

Future<List<dynamic>> obtenerControlesSQLitePorUsuario(
  String userId, {
  List<ControlsRow>? controlesSupabasePreCargados,
}) async {
  try {

    // 1. Obtener proyectos del usuario desde SQLite
    final todosProyectos = await DBProyectos.listarProyectos();
    final proyectosUsuario = todosProyectos
        .where((p) => p.assignUser == userId)
        .toList();

    if (proyectosUsuario.isEmpty) {
      return [];
    }

    // 2. Obtener objetivos de esos proyectos (en paralelo)
    final objetivosListas = await Future.wait(
      proyectosUsuario.map((p) =>
          DBObjetivos.listarObjetivosPorProyecto(p.idProject)),
    );
    final objetivosUsuario = objetivosListas.expand((l) => l).toList();

    if (objetivosUsuario.isEmpty) {
      return [];
    }

    // 3. Obtener controles con pendiente_sync = 1 (en paralelo)
    final pendientesListas = await Future.wait(
      objetivosUsuario.map((obj) =>
          DBControles.listarControlesPendientesSync(obj.idObjetivo)),
    );
    final idsPendientes = pendientesListas
        .expand((l) => l)
        .map((c) => c['id_control'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsPendientes.isEmpty) {
      return [];
    }


    // 4. Cargar datos completos en paralelo
    final completosLista = await Future.wait(
      idsPendientes.map((id) async {
        try {
          return await DBControles.obtenerControlCompleto(id);
        } catch (e) {
          return null;
        }
      }),
    );

    final controlesPendientes = completosLista
        .where((c) => c != null)
        .cast<dynamic>()
        .toList();

    return controlesPendientes;
  } catch (e, stackTrace) {
    return [];
  }
}
