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
import '/custom_code/Objetivo.dart';
import '/backend/api_requests/api_calls.dart' as api_calls;

/// Carga TODOS los datos del usuario de una sola vez:
/// 1. Obtiene user_uid desde tabla Users por userId (UUID)
/// 2. Obtiene proyectos desde Supabase por assign_user = user_uid
/// 3. Para cada proyecto → objetivos desde SQLite
/// 4. Para cada objetivo → controles desde SQLite
Future cargarTodosLosDatosUsuario(String userId) async {
  try {
    print('🚀 ===== CARGA COMPLETA DE DATOS =====');
    print('👤 Usuario UUID: $userId');

    // ============================================
    // 1️⃣ OBTENER USER_UID DEL USUARIO
    // ============================================
    print('\n👤 Paso 1: Obteniendo user_uid...');

    // Usar uidUsuario de FFAppState directamente (evita query con userId nulo)
    String userUid = FFAppState().currentUser.uidUsuario ?? '';

    if (userUid.isEmpty || userUid == 'null') {
      // Fallback: consultar Supabase solo si userId es un UUID válido
      if (userId.isNotEmpty && userId != 'null') {
        try {
          final usuarioSupabase = await UsersTable().queryRows(
            queryFn: (q) => q!.eq('id', userId),
          );
          if (usuarioSupabase.isNotEmpty) {
            userUid = usuarioSupabase.first.userUid ?? '';
          }
        } catch (e) {
          print('⚠️ Error obteniendo user_uid desde Supabase: $e');
        }
      }
    }

    if (userUid.isEmpty || userUid == 'null') {
      print('⚠️ No se pudo obtener user_uid válido');
      FFAppState().jsonObjetivos = [];
      FFAppState().jsonControles = [];
      return;
    }

    print('✅ user_uid: $userUid');

    // ============================================
    // 2️⃣ OBTENER PROYECTOS DEL USUARIO DESDE SUPABASE
    // ============================================
    print('\n📦 Paso 2: Obteniendo proyectos por assign_user = $userUid...');
    final proyectosSupabase = await ProjectsTable().queryRows(
      queryFn: (q) => q!.eq('assign_user', userUid),
    );

    if (proyectosSupabase.isEmpty) {
      print('⚠️ No hay proyectos asignados a user_uid: $userUid');
      FFAppState().jsonObjetivos = [];
      FFAppState().jsonControles = [];
      return;
    }

    print('✅ Proyectos encontrados: ${proyectosSupabase.length}');

    // Extraer IDs de proyectos
    final idsProyectos = proyectosSupabase
        .map((p) => p.idProject ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    print('📋 IDs de proyectos: $idsProyectos');

    // ============================================
    // 3️⃣ CARGAR OBJETIVOS - VALIDAR CON API PRIMERO
    // ============================================
    print('\n🎯 Paso 3: Cargando objetivos de ${idsProyectos.length} proyectos...');

    List<dynamic> todosObjetivosJSON = [];
    List<String> proyectosConObjetivos = [];
    int totalObjetivos = 0;

    // ⚡ Cache de controles por objetivo: evita doble consulta SQLite en paso 4
    final Map<String, List<Map<String, dynamic>>> controlesCache = {};

    // ⚡ OPTIMIZACIÓN: Procesar proyectos en PARALELO (máximo 5 a la vez)
    final batchSize = 5;
    for (var i = 0; i < idsProyectos.length; i += batchSize) {
      final batch = idsProyectos.skip(i).take(batchSize).toList();

      await Future.wait(batch.map((idProyecto) async {
        try {
          print('  🔍 Validando proyecto $idProyecto con API...');

          // Llamar API de objetivos
          final apiObjetivos = await api_calls.SupabaseFunctionsGroup
              .getObjetivesHighbondCall
              .call(idProject: idProyecto);

          if (apiObjetivos?.succeeded ?? false) {
            print('  ✅ API respondió OK - Guardando en SQLite...');

            // Guardar objetivos en SQLite
            await sqLiteSaveObjetivosMasivo(
              getJsonField(apiObjetivos?.jsonBody ?? '', r'''$.data.data'''),
            );

            // Leer objetivos desde SQLite
            final objetivosSQLite =
                await DBObjetivos.listarObjetivosPorProyecto(idProyecto);

            if (objetivosSQLite.isNotEmpty) {
              proyectosConObjetivos.add(idProyecto);

              // Convertir a JSON y calcular progress real desde SQLite
              final objetivosJSON = await Future.wait(objetivosSQLite.map((obj) async {
                // Calcular progress desde controles en SQLite
                final controles = await DBControles.listarControlesJson(obj.idObjetivo);
                // ⚡ Guardar en cache para reusar en paso 4 (evita segunda consulta)
                controlesCache[obj.idObjetivo] = controles;
                final totalControles = controles.length;
                final completados = controles.where((c) => c['completed'] == 1 || c['completed'] == true).length;
                final progressReal = totalControles > 0 ? (completados / totalControles) : 0.0;

                print('📊 Objetivo ${obj.title}: $completados/$totalControles completados = ${(progressReal * 100).toStringAsFixed(0)}%');

                return {
                  'id_objective': obj.idObjetivo,
                  'id_project': obj.projectId,
                  'title': obj.title,
                  'category': obj.divisionDepartment,
                  'description': obj.description,
                  'progress': progressReal,
                  'completed': obj.status,
                };
              })).then((list) => list.toList());

              todosObjetivosJSON.addAll(objetivosJSON);
              totalObjetivos += objetivosJSON.length;
              print(
                  '  ✓ Proyecto $idProyecto: ${objetivosJSON.length} objetivos');
            }
          } else {
            // ⚡ API falló (offline o error) → cargar desde SQLite directamente
            print('  ⚠️ API falló para $idProyecto - usando SQLite como fallback');
            final objetivosSQLite =
                await DBObjetivos.listarObjetivosPorProyecto(idProyecto);
            if (objetivosSQLite.isNotEmpty) {
              proyectosConObjetivos.add(idProyecto);
              final objetivosJSON = await Future.wait(objetivosSQLite.map((obj) async {
                final controles = await DBControles.listarControlesJson(obj.idObjetivo);
                controlesCache[obj.idObjetivo] = controles;
                final totalControles = controles.length;
                final completados = controles.where((c) => c['completed'] == 1 || c['completed'] == true).length;
                final progressReal = totalControles > 0 ? (completados / totalControles) : 0.0;
                return {
                  'id_objective': obj.idObjetivo,
                  'id_project': obj.projectId,
                  'title': obj.title,
                  'category': obj.divisionDepartment,
                  'description': obj.description,
                  'progress': progressReal,
                  'completed': obj.status,
                };
              })).then((list) => list.toList());
              todosObjetivosJSON.addAll(objetivosJSON);
              totalObjetivos += objetivosJSON.length;
              print('  ✓ Proyecto $idProyecto (SQLite): ${objetivosJSON.length} objetivos');
            }
          }
        } catch (e) {
          print('  ❌ Error en proyecto $idProyecto: $e');
        }
      }));
    }

    print('✅ Total objetivos cargados: $totalObjetivos');
    print(
        '📋 Proyectos con objetivos: ${proyectosConObjetivos.length} de ${idsProyectos.length}');

    // Guardar en FFAppState
    FFAppState().jsonObjetivos = todosObjetivosJSON;

    // ============================================
    // 4️⃣ CARGAR CONTROLES - REUSAR CACHE DEL PASO 3
    // ============================================
    print('\n🎮 Paso 4: Cargando controles de $totalObjetivos objetivos...');

    List<dynamic> todosControlesJSON = [];
    int totalControles = 0;

    // Extraer IDs de objetivos
    final idsObjetivos = todosObjetivosJSON
        .map((obj) => obj['id_objective']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsObjetivos.isEmpty) {
      print('⚠️ No hay objetivos para cargar controles');
      FFAppState().jsonControles = [];
      return;
    }

    // Procesar controles en lotes de 2 para evitar timeout de Supabase
    // (corrían 10 en paralelo → 4 queries simultáneas → statement timeout en Supabase)
    // Con batch=2 se reduce la carga y se agrega retry automático en timeout.
    final batchSizeControles = 2;
    for (var i = 0; i < idsObjetivos.length; i += batchSizeControles) {
      final batch = idsObjetivos.skip(i).take(batchSizeControles).toList();

      final resultados = await Future.wait(batch.map((idObjetivo) async {
        // Helper interno con retry (máx 2 intentos)
        Future<List<dynamic>> cargarControlesConRetry(int intento) async {
          try {
            // ⚡ Usar cache del paso 3 si está disponible (evita segunda consulta SQLite)
            final controlesCached = controlesCache[idObjetivo];
            if (controlesCached != null && controlesCached.isNotEmpty) {
              return controlesCached;
            }

            // 1️⃣ Verificar si ya existen controles en SQLite
            final controlesSQLite =
                await DBControles.listarControlesJson(idObjetivo);

            if (controlesSQLite.isNotEmpty) {
              // ✅ YA HAY DATOS EN SQLITE - Usarlos directamente (NO llamar API)
              return controlesSQLite;
            } else {
              // ⚠️ SQLite VACÍO - Primera vez, llamar API
              final results = await Future.wait([
                api_calls.SupabaseFunctionsGroup.getControlsDescriptionHighbondCall
                    .call(idObjective: idObjetivo),
                api_calls.SupabaseFunctionsGroup.getControlsWalkthroughHighbondCall
                    .call(idObjective: idObjetivo),
              ]);

              final apiControls = results[0];
              final apiControlWalk = results[1];

              if (apiControls?.succeeded ?? false) {
                // Combinar y sincronizar controles (primera vez)
                await combineAndSyncControls(
                  getJsonField(apiControls?.jsonBody ?? '', r'''$.data.data''', true)!,
                  getJsonField(
                      apiControlWalk?.jsonBody ?? '', r'''$.data.data''', true)!,
                  idObjetivo,
                );

                // Leer controles guardados desde SQLite
                final controlesNuevos =
                    await DBControles.listarControlesJson(idObjetivo);

                return controlesNuevos;
              }
            }
          } catch (e) {
            final esRetriable = e.toString().contains('57014') ||
                e.toString().contains('statement timeout') ||
                e.toString().contains('canceling statement') ||
                e.toString().contains('Connection closed') ||
                e.toString().contains('ClientException') ||
                e.toString().contains('SocketException') ||
                e.toString().contains('Connection reset');
            if (esRetriable && intento < 2) {
              print('  ⏱️ Error de red en $idObjetivo (intento $intento) → reintentando en 2s...');
              await Future.delayed(const Duration(seconds: 2));
              return cargarControlesConRetry(intento + 1);
            }
            print('  ❌ Error en $idObjetivo (intento $intento): $e');
          }
          return <dynamic>[];
        }

        return cargarControlesConRetry(1);
      }));

      // Agregar todos los resultados del batch
      for (var controles in resultados) {
        todosControlesJSON.addAll(controles);
        totalControles += controles.length;
      }
    }

    print('✅ Total controles cargados: $totalControles');

    // Guardar en FFAppState
    FFAppState().jsonControles = todosControlesJSON;
    FFAppState().update(() {});

    // ============================================
    // RESUMEN FINAL
    // ============================================
    print('\n📊 ===== RESUMEN DE CARGA =====');
    print('✅ user_uid: $userUid');
    print('✅ Proyectos: ${idsProyectos.length}');
    print('✅ Objetivos: $totalObjetivos (de ${proyectosConObjetivos.length} proyectos)');
    print('✅ Controles: $totalControles');
    print('================================\n');
  } catch (e, stackTrace) {
    print('❌ ERROR EN CARGA COMPLETA: $e');
    print('Stack trace: $stackTrace');
    FFAppState().jsonObjetivos = [];
    FFAppState().jsonControles = [];
  }
}
