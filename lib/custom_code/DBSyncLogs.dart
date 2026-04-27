import 'dart:convert';
import 'sqlite_helper.dart';

class DBSyncLogs {
  static Future<String> insertSyncLog({
    required String syncId,
    required String userUid,
    String? userEmail,
    String? userDisplayName,
    required String syncStart,
    String syncType = 'manual',
    bool isOnline = false,
  }) async {
    try {
      final database = await DBHelper.db;

      await database.insert('SyncLogs', {
        'sync_id': syncId,
        'user_uid': userUid,
        'user_email': userEmail ?? '',
        'user_display_name': userDisplayName ?? '',
        'sync_start': syncStart,
        'sync_type': syncType,
        'sync_status': 'started',
        'is_online': isOnline ? 1 : 0,
        'total_controls_synced': 0,
        'controls_updated': '[]',
        'sincronizadoNube': 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      return syncId;
    } catch (e) {
      return '';
    }
  }

  static Future<void> updateSyncLog({
    required String syncId,
    required String syncStatus,
    String? syncEnd,
    int totalControlsSynced = 0,
    List<Map<String, dynamic>>? controlsUpdated,
    String? errorMessage,
  }) async {
    try {
      final database = await DBHelper.db;

      await database.update(
        'SyncLogs',
        {
          'sync_status': syncStatus,
          'sync_end': syncEnd ?? DateTime.now().toIso8601String(),
          'total_controls_synced': totalControlsSynced,
          'controls_updated': jsonEncode(controlsUpdated ?? []),
          'error_message': errorMessage,
        },
        where: 'sync_id = ?',
        whereArgs: [syncId],
      );

    } catch (e) {
    }
  }

  static Future<List<Map<String, dynamic>>> listarSyncLogs({
    String? userUid,
    int limit = 50,
  }) async {
    try {
      final database = await DBHelper.db;

      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (userUid != null && userUid.isNotEmpty) {
        whereClause = 'user_uid = ?';
        whereArgs = [userUid];
      }

      final List<Map<String, dynamic>> maps = await database.query(
        'SyncLogs',
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'sync_start DESC',
        limit: limit,
      );

      return maps;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> listarLogsPendientesSubir() async {
    try {
      final database = await DBHelper.db;

      final List<Map<String, dynamic>> maps = await database.query(
        'SyncLogs',
        where: 'sincronizadoNube = 0 AND sync_status != ?',
        whereArgs: ['started'],
        orderBy: 'sync_start ASC',
      );

      return maps;
    } catch (e) {
      return [];
    }
  }

  static Future<void> marcarComoSubido(String syncId) async {
    try {
      final database = await DBHelper.db;

      await database.update(
        'SyncLogs',
        {'sincronizadoNube': 1},
        where: 'sync_id = ?',
        whereArgs: [syncId],
      );

    } catch (e) {
    }
  }

  static Future<Map<String, dynamic>?> getUltimoSync({
    String? userUid,
  }) async {
    try {
      final database = await DBHelper.db;

      String whereClause = 'sync_status = ?';
      List<dynamic> whereArgs = ['completed'];

      if (userUid != null && userUid.isNotEmpty) {
        whereClause += ' AND user_uid = ?';
        whereArgs.add(userUid);
      }

      final List<Map<String, dynamic>> maps = await database.query(
        'SyncLogs',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'sync_start DESC',
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return maps.first;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
