import 'sqlite_helper.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class DBControlAttachments {
  /// Guardar un attachment (photo, video, archive)
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

    print('✅ Attachment guardado: $attachmentType[$attachmentIndex] para control $idControl');
  }

  /// Guardar múltiples photos (en paralelo)
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

  /// Guardar múltiples videos (en paralelo)
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

  /// Guardar múltiples archives (en paralelo)
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

  /// Obtener photos de un control
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

  /// Obtener videos de un control (lista, igual que obtenerPhotos)
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

  /// Obtener archives de un control
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

  /// Contar photos de un control
  static Future<int> contarPhotos(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'photo'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Contar archives de un control
  static Future<int> contarArchives(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'archive'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Verificar si tiene video
  static Future<bool> tieneVideo(String idControl) async {
    final db = await DBHelper.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ControlAttachments WHERE id_control = ? AND attachment_type = ?',
      [idControl, 'video'],
    );
    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }

  /// Obtener contadores de attachments para múltiples controles en UNA sola query
  /// Retorna: { idControl: { 'photos': int, 'archives': int, 'hasVideo': bool } }
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

  /// Eliminar attachments por tipo
  static Future<void> eliminarAttachmentsPorTipo(String idControl, String attachmentType) async {
    final db = await DBHelper.db;
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, attachmentType],
    );
  }

  /// Eliminar todos los attachments de un control
  static Future<void> eliminarTodosAttachments(String idControl) async {
    final db = await DBHelper.db;
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ?',
      whereArgs: [idControl],
    );
  }

  /// Obtener todos los attachments de un control (para sincronización, en paralelo)
  static Future<Map<String, dynamic>> obtenerTodosAttachments(String idControl) async {
    final results = await Future.wait([
      obtenerPhotos(idControl),
      obtenerVideos(idControl),
      obtenerArchives(idControl),
    ]);
    final photos = results[0];
    final videos = results[1];
    final archives = results[2];

    // 🔥 USAR FORMATO SIMPLE: base64|||base64|||base64
    // El formato JSON manual está causando problemas con strings muy largos
    return {
      'photos': photos.isEmpty ? '' : photos.join('|||'),
      'video': videos.isEmpty ? '' : videos.join('|||'),
      'archives': archives.isEmpty ? '' : archives.join('|||'),
    };
  }

  /// Obtener extensión según tipo de archivo
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
