import 'sqlite_helper.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class DBControlAttachments {
  static Future<void> guardarAttachment({
    required String idControl,
    required String attachmentType, // 'photo', 'video', 'archive'
    required String attachmentData,
    required int attachmentIndex,
  }) async {
    final db = await DBHelper.db;
    final createdAt = DateTime.now().toIso8601String();

    await db.insert(
      'ControlAttachments',
      {
        'id_control': idControl,
        'attachment_type': attachmentType,
        'attachment_data': attachmentData,
        'attachment_index': attachmentIndex,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  static Future<void> guardarPhotos(String idControl, List<String> photos) async {
    await eliminarAttachmentsPorTipo(idControl, 'photo');
    await Future.wait([
      for (int i = 0; i < photos.length; i++)
        if (photos[i].isNotEmpty)
          guardarAttachment(
            idControl: idControl,
            attachmentType: 'photo',
            attachmentData: photos[i],
            attachmentIndex: i,
          ),
    ]);
  }

  static Future<void> guardarVideos(String idControl, List<String> videos) async {
    await eliminarAttachmentsPorTipo(idControl, 'video');
    await Future.wait([
      for (int i = 0; i < videos.length; i++)
        if (videos[i].isNotEmpty)
          guardarAttachment(
            idControl: idControl,
            attachmentType: 'video',
            attachmentData: videos[i],
            attachmentIndex: i,
          ),
    ]);
  }

  static Future<void> guardarArchives(String idControl, List<String> archives) async {
    await eliminarAttachmentsPorTipo(idControl, 'archive');
    await Future.wait([
      for (int i = 0; i < archives.length; i++)
        if (archives[i].isNotEmpty)
          guardarAttachment(
            idControl: idControl,
            attachmentType: 'archive',
            attachmentData: archives[i],
            attachmentIndex: i,
          ),
    ]);
  }

  static Future<List<String>> obtenerPhotos(String idControl) async {
    final db = await DBHelper.db;
    final results = await db.query(
      'ControlAttachments',
      columns: ['attachment_data'],
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, 'photo'],
      orderBy: 'attachment_index ASC',
    );

    return results.map((row) => row['attachment_data'] as String).toList();
  }

  static Future<List<String>> obtenerVideos(String idControl) async {
    final db = await DBHelper.db;
    final results = await db.query(
      'ControlAttachments',
      columns: ['attachment_data'],
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, 'video'],
      orderBy: 'attachment_index ASC',
    );

    return results.map((row) => row['attachment_data'] as String).toList();
  }

  static Future<List<String>> obtenerArchives(String idControl) async {
    final db = await DBHelper.db;
    final results = await db.query(
      'ControlAttachments',
      columns: ['attachment_data'],
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, 'archive'],
      orderBy: 'attachment_index ASC',
    );

    return results.map((row) => row['attachment_data'] as String).toList();
  }

  static Future<int> contarPhotos(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'photo'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> contarArchives(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'archive'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<bool> tieneVideo(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'video'],
    );
    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }

  static Future<Map<String, Map<String, dynamic>>> contarAttachmentsPorLote(
      List<String> idControles) async {
    if (idControles.isEmpty) return {};
    final db = await DBHelper.db;
    final placeholders = idControles.map((_) => '?').join(', ');
    final result = await db.rawQuery(
      'SELECT id_control, attachment_type, COUNT(*) as count '
      'FROM ControlAttachments '
      'WHERE id_control IN ($placeholders) '
      'GROUP BY id_control, attachment_type',
      idControles,
    );
    final Map<String, Map<String, dynamic>> counts = {};
    for (var row in result) {
      final idControl = row['id_control'] as String;
      final type = row['attachment_type'] as String;
      final count = (row['count'] as int?) ?? 0;
      counts.putIfAbsent(idControl, () => {'photos': 0, 'archives': 0, 'hasVideo': false});
      if (type == 'photo') counts[idControl]!['photos'] = count;
      else if (type == 'archive') counts[idControl]!['archives'] = count;
      else if (type == 'video') counts[idControl]!['hasVideo'] = count > 0;
    }
    return counts;
  }

  static Future<void> eliminarAttachmentsPorTipo(String idControl, String attachmentType) async {
    final db = await DBHelper.db;
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, attachmentType],
    );
  }

  static Future<void> eliminarTodosAttachments(String idControl) async {
    final db = await DBHelper.db;
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ?',
      whereArgs: [idControl],
    );
  }

  static Future<Map<String, dynamic>> obtenerTodosAttachments(String idControl) async {
    final results = await Future.wait([
      obtenerPhotos(idControl),
      obtenerVideos(idControl),
      obtenerArchives(idControl),
    ]);
    final photos = results[0];
    final videos = results[1];
    final archives = results[2];

    return {
      'photos': photos.isEmpty ? '' : photos.join('|||'),
      'video': videos.isEmpty ? '' : videos.join('|||'),
      'archives': archives.isEmpty ? '' : archives.join('|||'),
    };
  }

  static String _getExtension(String tipo) {
    switch (tipo) {
      case 'image':
        return 'jpg';
      case 'video':
        return 'mp4';
      case 'archive':
        return 'pdf';
      default:
        return 'file';
    }
  }
}
