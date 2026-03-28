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
import '/custom_code/DBObjetivos.dart';
import '/custom_code/DBControles.dart';
import '/backend/api_requests/api_calls.dart' as api_calls;

/// Carga inteligente de datos con caché:
/// 1. Si es primera vez o caché expirado (8 horas) → Sincronización COMPLETA (APIs + Supabase)
/// 2. Si tiene datos → Cargar SQLite + Sincronizar SOLO con Supabase (rápido)
///
/// forceFullSync: true para forzar sincronización completa (botón manual)
Future cargarDatosConCacheInteligente(
  String userId, {
  bool forceFullSync = false,
}) async {
  try {
    print('🚀 Carga inteligente iniciada');

    // ============================================
    // VERIFICAR CONECTIVIDAD ANTES DE LLAMAR SUPABASE
    // ============================================
    final estaConectado = await checkInternetConecction();
    if (!estaConectado) {
      print('📴 Sin conexión - saltando carga inteligente (modo offline)');
      return;
    }

    // ============================================
    // VERIFICAR ROL DEL USUARIO
    // ============================================
    // Usar el rol ya disponible en FFAppState (evita query con userId nulo)
    final userRole = FFAppState().currentUser.rol;
    if (userRole.isEmpty) {
      // Fallback: intentar obtener de Supabase solo si userId es válido
      if (userId.isEmpty || userId == 'null') {
        print('❌ userId inválido y sin rol en FFAppState - abortando');
        return;
      }
      try {
        final usuarioData = await UsersTable().queryRows(
          queryFn: (q) => q!.eq('id', userId),
        );
        if (usuarioData.isEmpty) {
          print('❌ Usuario no encontrado');
          return;
        }
      } catch (e) {
        print('❌ Error obteniendo usuario: $e');
        return;
      }
    }

    // SOLO usuarios con role = 'usuario' pueden hacer sync completa con APIs
    final puedeUsarAPIs = userRole.toLowerCase() == 'usuario';

    if (!puedeUsarAPIs) {
      // Cargar solo desde cache/Supabase
      await _cargarRapidoDesdeCache(userId);
      print('✅ Carga rápida completada');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'last_full_sync_$userId';
    final lastSyncTimestamp = prefs.getInt(cacheKey) ?? 0;
    final ahora = DateTime.now().millisecondsSinceEpoch;

    // ============================================
    // VERIFICAR SI TIENE DATOS EN SQLITE
    // ============================================
    final tieneControles = FFAppState().jsonControles.isNotEmpty;
    final tieneObjetivos = FFAppState().jsonObjetivos.isNotEmpty;
    final tieneDatos = tieneControles && tieneObjetivos;

    // ============================================
    // DECIDIR QUÉ TIPO DE SINCRONIZACIÓN HACER
    // ============================================
    // Sync completa si:
    // 1. Es primera vez (no tiene datos)
    // 2. El caché expiró (más de 8 horas desde la última sync completa)
    // 3. Usuario presiona botón "Sincronizar" (forceFullSync = true)
    final horasDesdeUltimaSync = lastSyncTimestamp == 0
        ? double.infinity
        : (ahora - lastSyncTimestamp) / (1000 * 60 * 60);
    final cacheExpirado = horasDesdeUltimaSync >= 8;

    if (cacheExpirado) {
      print('⏰ Caché expirado (${horasDesdeUltimaSync.toStringAsFixed(1)}h) → sync completa');
    }

    final necesitaSyncCompleta = !tieneDatos || cacheExpirado || forceFullSync;

    if (necesitaSyncCompleta) {
      print('🔄 Sincronización completa iniciada');

      // Llamar a la función completa existente
      await cargarTodosLosDatosUsuario(userId);

      // Guardar timestamp de sync completa
      await prefs.setInt(cacheKey, ahora);
      print('✅ Sincronización completa finalizada');

    } else {
      await _cargarRapidoDesdeCache(userId);
    }

    print('✅ Carga inteligente completada');

  } catch (e) {
    print('❌ Error en carga inteligente: $e');
    // No relanzar el error para no bloquear el flujo offline
  }
}

/// Carga rápida desde SQLite + validación con Supabase
Future _cargarRapidoDesdeCache(String userId) async {
  try {
    // Obtener user_uid desde FFAppState (evita query con userId potencialmente nulo)
    String userUid = FFAppState().currentUser.uidUsuario ?? '';
    if (userUid.isEmpty || userUid == 'null') {
      if (userId.isNotEmpty && userId != 'null') {
        try {
          final usuarioSupabase = await UsersTable().queryRows(
            queryFn: (q) => q!.eq('id', userId),
          );
          if (usuarioSupabase.isNotEmpty) {
            userUid = usuarioSupabase.first.userUid ?? '';
          }
        } catch (e) {
          print('⚠️ Error obteniendo user_uid en carga rápida: $e');
        }
      }
    }

    if (userUid.isEmpty || userUid == 'null') {
      return;
    }

    // Obtener proyectos
    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userUid),
    );

    if (proyectosSupabase.isEmpty) {
      return;
    }

    // Extraer IDs de proyectos
    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    // Para cada proyecto, sincronizar solo con Supabase (SOLO SI HAY CAMBIOS)
    print('🔄 Sincronizando ${idsProyectos.length} proyectos...');

    for (var idProyecto in idsProyectos) {
      try {
        // Obtener objetivos del proyecto desde SQLite
        final objetivosSQLite = await DBObjetivos.listarObjetivosPorProyecto(idProyecto);

        for (var objetivo in objetivosSQLite) {
          final idObjetivo = objetivo.idObjetivo;

          // 2️⃣ SOLO SQLite → Supabase (subir cambios locales si hay)
          // No descargar de Supabase porque ya está actualizado
          await combineAndSyncControls(
            [], // apiResponseDescription - vacío porque no llamamos API
            [], // apiResponseWalkthrough - vacío porque no llamamos API
            idObjetivo, // objectiveId
          );
        }
      } catch (e) {
        print('❌ Error sincronizando proyecto $idProyecto: $e');
      }
    }

    // ⚠️ NO RECARGAR controles aquí - ya están actualizados en FFAppState
    // Si recargamos desde SQLite, sobrescribimos los cambios recientes
    // Los controles se cargan UNA VEZ en cargarTodosLosDatosUsuario (primera vez)
    // Y se actualizan individualmente en actualizar_control_sq_lite
    print('✅ Controles ya cargados en FFAppState - no recargando');

    // Actualizar AppState con datos frescos
    FFAppState().update(() {});

  } catch (e) {
    print('❌ Error en carga rápida: $e');
  }
}
