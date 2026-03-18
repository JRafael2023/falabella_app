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
    // 1️⃣ OBTENER USER_UID DEL USUARIO DESDE TABLA USERS
    // ============================================
    print('\n👤 Paso 1: Obteniendo user_uid desde tabla Users...');
    final usuarioSupabase = await UsersTable().queryRows(
      queryFn: (q) => q!.eq('id', userId),
    );

    if (usuarioSupabase.isEmpty) {
      print('⚠️ No se encontró usuario con UUID: $userId');
      FFAppState().jsonObjetivos = [];
      FFAppState().jsonControles = [];
      return;
    }

    final userUid = usuarioSupabase.first.userUid ?? '';
    print('✅ user_uid encontrado: $userUid');

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

    // ⚡ OPTIMIZACIÓN: Procesar proyectos en PARALELO (máximo 5 a la vez)
    final batchSize = 5; // Aumentado de 3 a 5
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
            print('  ⚠️ API falló para $idProyecto');
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
    // 4️⃣ CARGAR CONTROLES - VALIDAR CON API PRIMERO
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

    // ⚡⚡⚡ SUPER OPTIMIZACIÓN: Procesar controles en PARALELO (lotes de 10)
    // Si hay datos locales, usarlos DIRECTAMENTE sin llamar API
    // Solo llamar API si es primera vez (SQLite vacío)
    final batchSizeControles = 10; // Procesar 10 objetivos a la vez (aumentado de 5)
    for (var i = 0; i < idsObjetivos.length; i += batchSizeControles) {
      final batch = idsObjetivos.skip(i).take(batchSizeControles).toList();

      final resultados = await Future.wait(batch.map((idObjetivo) async {
        try {
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
          print('  ❌ Error en $idObjetivo: $e');
        }
        return <dynamic>[];
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
