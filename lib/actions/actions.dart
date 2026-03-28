import '/backend/api_requests/api_manager.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/DBSyncLogs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future sync(
  BuildContext context, {
  required bool? connect,
}) async {
  List<ProjectsRow>? queryONProjects;
  List<MatricesRow>? listONMatrices;
  String? formatjsonMatricesON;
  String? formatjsonON;
  List<UsersRow>? qONUsersList;
  String? returnInsertSQLite;
  List<UsersRow>? qUser;
  List<dynamic>? qOnProjects;
  List<dynamic>? qOnMatrices;
  List<dynamic>? qJSONROwsSupabase;
  bool? returnValidateSync;
  List<ControlsRow>? rowsSupabaseControlSync;
  List<dynamic>? jsonSQListControlSync;
  List<dynamic>? qoffProyectos;
  dynamic? returnLOginOFF;
  List<dynamic>? qoffMatrices;
  List<dynamic>? qSQLiteUsersOFF;

  // ========================================
  // 📝 CREAR SYNC LOG AL INICIO
  // ========================================
  final syncId = 'sync-${DateTime.now().millisecondsSinceEpoch}';
  final syncStart = DateTime.now();
  final userUid = FFAppState().currentUser.uidUsuario;
  final userEmail = FFAppState().currentUser.email;
  final userDisplayName = FFAppState().currentUser.displayName;

  // Insertar en SQLite
  await DBSyncLogs.insertSyncLog(
    syncId: syncId,
    userUid: userUid,
    userEmail: userEmail,
    userDisplayName: userDisplayName,
    syncStart: syncStart.toIso8601String(),
    syncType: 'manual',
    isOnline: connect ?? false,
  );

  // Insertar en Supabase (solo si hay conexión)
  if (connect == true) {
    try {
      await SyncLogsTable().insert({
        'user_uid': userUid,
        'user_email': userEmail,
        'user_display_name': userDisplayName,
        'sync_start': syncStart.toIso8601String(),
        'sync_type': 'manual',
        'sync_status': 'started',
        'total_controls_synced': 0,
        'controls_updated': [],
        'device_info': syncId,
      });
      print('✅ SyncLog insertado en Supabase: $syncId');
    } catch (e) {
      print('⚠️ Error insertando SyncLog en Supabase: $e');
    }
  }

  try {
    if (connect!) {
      // ⚡ Descargar Projects + Matrices + Users en paralelo (antes eran 3 llamadas secuenciales)
      final dlResults = await Future.wait([
        ProjectsTable().queryRows(queryFn: (q) => q),
        MatricesTable().queryRows(queryFn: (q) => q),
        UsersTable().queryRows(queryFn: (q) => q),
      ]);
      queryONProjects = dlResults[0] as List<ProjectsRow>;
      listONMatrices = dlResults[1] as List<MatricesRow>;
      qONUsersList = dlResults[2] as List<UsersRow>;

      // ⚡ Guardar en SQLite en paralelo (tablas distintas, sin conflicto)
      await Future.wait([
        actions.sqlLiteSaveMatricesMasivo(listONMatrices!.toList()),
        actions.sqlLiteSaveProyectosMasivo(queryONProjects!.toList()),
        actions.sqlLiteSaveUsersMasivo(qONUsersList!.toList()),
      ]);

      // ⚡ Leer desde SQLite + convertir usuarios en paralelo
      final localResults = await Future.wait([
        actions.sqlLiteListProyectos(),
        actions.sqlLiteListMatrices(),
        actions.convertRowsUsers(qONUsersList!.toList()),
      ]);
      qOnProjects = localResults[0] as List<dynamic>;
      qOnMatrices = localResults[1] as List<dynamic>;
      qJSONROwsSupabase = localResults[2] as List<dynamic>;
      FFAppState().jsonProyectos = qOnProjects!.toList().cast<dynamic>();
      FFAppState().jsonMatrices = qOnMatrices!.toList().cast<dynamic>();
      FFAppState().jsonUsers = qJSONROwsSupabase!.toList().cast<dynamic>();
      FFAppState().update(() {});
      returnValidateSync = await actions.verificarCambiosPendientesSync(
        FFAppState().currentUser.uidUsuario,
      );
      if (returnValidateSync!) {
        rowsSupabaseControlSync = await actions.obtenerControlesPorUsuario(
          FFAppState().currentUser.uidUsuario,
        );
        jsonSQListControlSync = await actions.obtenerControlesSQLitePorUsuario(
          FFAppState().currentUser.uidUsuario,
        );
        if ((rowsSupabaseControlSync!.length > 0) &&
            (jsonSQListControlSync!.length > 0)) {
          final syncResult = await actions.syncControlesToSupabase(
            jsonSQListControlSync!.toList(),
            rowsSupabaseControlSync!.toList(),
          );
          if (syncResult == 'exito_highbond_fallo') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sincronización completada, pero algunos archivos no se cargaron correctamente a HighBond. Por favor, intente nuevamente.',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                duration: Duration(milliseconds: 6000),
                backgroundColor: FlutterFlowTheme.of(context).warning,
              ),
            );
          } else if (syncResult != 'exito') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Fallo Sincronizacion',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                duration: Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }
      }

      // ========================================
      // ✅ ACTUALIZAR SYNC LOG - COMPLETADO (ONLINE)
      // ========================================
      final syncEnd = DateTime.now();
      await DBSyncLogs.updateSyncLog(
        syncId: syncId,
        syncStatus: 'completed',
        syncEnd: syncEnd.toIso8601String(),
      );

      // Actualizar en Supabase
      try {
        await SupaFlow.client
            .from('Sync_Logs')
            .update({
              'sync_status': 'completed',
              'sync_end': syncEnd.toIso8601String(),
            })
            .eq('device_info', syncId);
        print('✅ SyncLog actualizado en Supabase: completed');
      } catch (e) {
        print('⚠️ Error actualizando SyncLog en Supabase: $e');
      }

      // Actualizar última sincronización en AppState
      FFAppState().update(() {
        FFAppState().ultimaSincronizacion = syncEnd;
      });

      // Siempre recargar desde HighBond al sincronizar manualmente.
      // Garantiza que proyectos nuevos o con datos faltantes se actualicen,
      // incluso si no había cambios pendientes locales.
      print('🚀 Recargando datos con cache inteligente...');
      await actions.cargarDatosConCacheInteligente(
        FFAppState().currentUser!.id,
        forceFullSync: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Datos Sincronizados',
            style: TextStyle(),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } else {
      // ⚡ Leer SQLite en paralelo (offline)
      final offResults = await Future.wait([
        actions.sqlLiteListProyectos(),
        actions.sqlLiteListMatrices(),
        actions.sqLiteListUsers(),
      ]);
      qoffProyectos = offResults[0] as List<dynamic>;
      qoffMatrices = offResults[1] as List<dynamic>;
      qSQLiteUsersOFF = offResults[2] as List<dynamic>;
      FFAppState().jsonProyectos = qoffProyectos!.toList().cast<dynamic>();
      FFAppState().jsonMatrices =
          FFAppState().jsonMatrices.toList().cast<dynamic>();
      FFAppState().jsonUsers = qSQLiteUsersOFF!.toList().cast<dynamic>();
      FFAppState().update(() {});

      // ========================================
      // ✅ ACTUALIZAR SYNC LOG - COMPLETADO (OFFLINE)
      // ========================================
      final syncEnd = DateTime.now();
      await DBSyncLogs.updateSyncLog(
        syncId: syncId,
        syncStatus: 'completed',
        syncEnd: syncEnd.toIso8601String(),
      );

      // Actualizar última sincronización en AppState
      FFAppState().update(() {
        FFAppState().ultimaSincronizacion = syncEnd;
      });

      // 🚀 CARGAR TODOS LOS DATOS (Objetivos + Controles) - OFFLINE
      print('🚀 Cargando todos los datos después de sincronizar (OFFLINE)...');
      await actions.cargarTodosLosDatosUsuario(
        FFAppState().currentUser!.id,
      );
      print('✅ Carga completa finalizada');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Datos Sincronizados',
            style: TextStyle(),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    }
  } catch (e) {
    // ========================================
    // ❌ ACTUALIZAR SYNC LOG - ERROR
    // ========================================
    print('❌ Error en sync: $e');
    await DBSyncLogs.updateSyncLog(
      syncId: syncId,
      syncStatus: 'error',
      syncEnd: DateTime.now().toIso8601String(),
      errorMessage: e.toString(),
    );

    if (connect == true) {
      try {
        await SupaFlow.client
            .from('Sync_Logs')
            .update({
              'sync_status': 'error',
              'sync_end': DateTime.now().toIso8601String(),
              'error_message': e.toString(),
            })
            .eq('device_info', syncId);
      } catch (_) {}
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error en sincronización',
          style: TextStyle(),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: Colors.red,
      ),
    );
  }
}
