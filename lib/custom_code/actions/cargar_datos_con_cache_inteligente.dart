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

    // Detectar proyectos nuevos asignados después del último full sync
    // (objetivos vacíos en SQLite = proyecto que nunca fue sincronizado)
    bool hayProyectosNuevos = false;
    if (tieneDatos && !cacheExpirado && !forceFullSync) {
      try {
        final userUid = FFAppState().currentUser.uidUsuario ?? '';
        if (userUid.isNotEmpty && userUid != 'null') {
          final proyectosSupabase = await ProjectsTable().queryRows(
            queryFn: (q) => q!.eq('assign_user', userUid),
          );
          for (final proyecto in proyectosSupabase) {
            final idProyecto = proyecto.idProject ?? '';
            if (idProyecto.isEmpty) continue;
            final objetivosSQLite =
                await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
            if (objetivosSQLite.isEmpty) {
              hayProyectosNuevos = true;
              print('🆕 Proyecto nuevo detectado: $idProyecto → forzando full sync');
              break;
            }
          }
        }
      } catch (e) {
        print('⚠️ Error verificando proyectos nuevos: $e');
      }
    }

    final necesitaSyncCompleta = !tieneDatos || cacheExpirado || forceFullSync || hayProyectosNuevos;

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

/// Carga rápida desde SQLite + notifica UI.
/// Solo llega aquí si el usuario ya tiene TODOS sus proyectos en SQLite
/// (proyectos nuevos son detectados antes y disparan un full sync).
Future _cargarRapidoDesdeCache(String userId) async {
  try {
    // Actualizar AppState con los datos que ya están en SQLite/FFAppState
    FFAppState().update(() {});
    print('✅ Carga rápida: datos ya en FFAppState');
  } catch (e) {
    print('❌ Error en carga rápida: $e');
  }
}
