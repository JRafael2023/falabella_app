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

import 'package:shared_preferences/shared_preferences.dart';
import '/backend/api_requests/api_calls.dart' as api_calls;

Future cargarDatosConCacheInteligente(
  String userId, {
  bool forceFullSync = false,
}) async {
  try {

    final estaConectado = await checkInternetConecction();
    if (!estaConectado) {
      return;
    }

    final userRole = FFAppState().currentUser.rol;
    if (userRole.isEmpty) {
      if (userId.isEmpty || userId == 'null') {
        return;
      }
      try {
        final usuarioData = await UsersTable().queryRows(
          queryFn: (q) => q!.eq('id', userId),
        );
        if (usuarioData.isEmpty) {
          return;
        }
      } catch (e) {
        return;
      }
    }

    final puedeUsarAPIs = userRole.toLowerCase() == 'usuario';

    if (!puedeUsarAPIs) {
      await _cargarRapidoDesdeCache(userId);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'last_full_sync_$userId';
    final lastSyncTimestamp = prefs.getInt(cacheKey) ?? 0;
    final ahora = DateTime.now().millisecondsSinceEpoch;

    final tieneControles = FFAppState().jsonControles.isNotEmpty;
    final tieneObjetivos = FFAppState().jsonObjetivos.isNotEmpty;
    final tieneDatos = tieneControles && tieneObjetivos;

    final horasDesdeUltimaSync = lastSyncTimestamp == 0
        ? double.infinity
        : (ahora - lastSyncTimestamp) / (1000 * 60 * 60);
    final cacheExpirado = horasDesdeUltimaSync >= 8;

    if (cacheExpirado) {
    }

    bool hayProyectosNuevos = false;
    if (tieneDatos && !cacheExpirado && !forceFullSync) {
      final idsConObjetivos = FFAppState()
          .jsonObjetivos
          .map((o) => o['id_project']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      for (final proyecto in FFAppState().jsonProyectos) {
        final idProyecto = proyecto['id_project']?.toString() ?? '';
        if (idProyecto.isEmpty) continue;
        if (!idsConObjetivos.contains(idProyecto)) {
          hayProyectosNuevos = true;
          break;
        }
      }
    }

    bool hayObjetivosSinControles = false;
    if (tieneDatos && !cacheExpirado && !forceFullSync && !hayProyectosNuevos) {
      final idsConControles = FFAppState()
          .jsonControles
          .map((c) => c['id_objective']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      for (final obj in FFAppState().jsonObjetivos) {
        final idObj = obj['id_objective']?.toString() ?? '';
        if (idObj.isEmpty) continue;
        if (!idsConControles.contains(idObj)) {
          hayObjetivosSinControles = true;
          break;
        }
      }
    }

    final necesitaSyncCompleta = !tieneDatos || cacheExpirado || forceFullSync || hayProyectosNuevos || hayObjetivosSinControles;

    if (necesitaSyncCompleta) {

      await cargarTodosLosDatosUsuario(userId);

      await prefs.setInt(cacheKey, ahora);

    } else {
      await _cargarRapidoDesdeCache(userId);
    }


  } catch (e) {
  }
}

Future _cargarRapidoDesdeCache(String userId) async {
  try {
    FFAppState().update(() {});
  } catch (e) {
  }
}
