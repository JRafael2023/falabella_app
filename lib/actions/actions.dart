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
  // ⏱️ CRONÓMETRO DE SINCRONIZACIÓN
  // ========================================
  final _stopwatch = Stopwatch()..start();

  void _logTiempo(String etapa) {
    final ms = _stopwatch.elapsedMilliseconds;
    final seg = (ms / 1000).toStringAsFixed(1);
  }

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
    } catch (e) {
    }
  }

  try {
    if (connect!) {
      _logTiempo('INICIO sync online');

      // ⚡ Descargar Projects + Matrices + Users en paralelo (antes eran 3 llamadas secuenciales)
      final dlResults = await Future.wait([
        ProjectsTable().queryRows(queryFn: (q) => q),
        MatricesTable().queryRows(queryFn: (q) => q),
        UsersTable().queryRows(queryFn: (q) => q),
      ]);
      queryONProjects = dlResults[0] as List<ProjectsRow>;
      listONMatrices = dlResults[1] as List<MatricesRow>;
      qONUsersList = dlResults[2] as List<UsersRow>;
      _logTiempo('Descarga Projects/Matrices/Users OK');

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
      _logTiempo('Guardado SQLite OK');

      // ⚡ NUEVO: Solo leer SQLite local (pendiente_sync=1) — sin descarga masiva de Supabase.
      // El flag pendiente_sync se activa solo cuando el usuario modifica un control.
      jsonSQListControlSync = await actions.obtenerControlesSQLitePorUsuario(
        FFAppState().currentUser.uidUsuario,
      );
      _logTiempo('Controles pendientes SQLite (${jsonSQListControlSync?.length ?? 0})');

      if (jsonSQListControlSync != null && jsonSQListControlSync!.isNotEmpty) {
        // ⚡ Descargar SOLO los controles pendientes de Supabase (3-6 ids, no los 50)
        final _idsPendientes = jsonSQListControlSync!
            .map((c) => (c as Map<String, dynamic>)['id_control'] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
        rowsSupabaseControlSync = await ControlsTable().queryRows(
          queryFn: (q) => q!.inFilter('id_control', _idsPendientes),
        );
        _logTiempo('Descarga Supabase solo pendientes OK (${rowsSupabaseControlSync?.length ?? 0})');

        final syncResult = await actions.syncControlesToSupabase(
          jsonSQListControlSync!.toList(),
          rowsSupabaseControlSync!.toList(),
        );
        _logTiempo('syncControlesToSupabase OK (resultado=$syncResult)');
        if (syncResult == 'exito_highbond_fallo') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sincronización completada, pero algunos datos no se enviaron correctamente a HighBond. Por favor, intente nuevamente.',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
              ),
              duration: Duration(milliseconds: 6000),
              backgroundColor: FlutterFlowTheme.of(context).warning,
            ),
          );
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
      } catch (e) {
      }

      // Actualizar última sincronización en AppState
      FFAppState().update(() {
        FFAppState().ultimaSincronizacion = syncEnd;
      });

      // Recargar desde cache/SQLite (sin forzar HighBond).
      // forceFullSync: false → si el cache es reciente usa SQLite (rápido).
      // Solo llama HighBond si el cache expiró (> 8 horas), no en cada sync.
      await actions.cargarDatosConCacheInteligente(
        FFAppState().currentUser!.id,
        forceFullSync: false,
      );
      _logTiempo('Recarga cache inteligente OK');

      _stopwatch.stop();
      final _totalSeg = (_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);

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
      await actions.cargarTodosLosDatosUsuario(
        FFAppState().currentUser!.id,
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
    }
  } catch (e) {
    // ========================================
    // ❌ ACTUALIZAR SYNC LOG - ERROR
    // ========================================
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
