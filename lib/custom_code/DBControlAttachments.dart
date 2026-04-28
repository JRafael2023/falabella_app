import 'sqlite_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBControlAttachments {
  // ── File helpers ──────────────────────────────────────────────────────────

  static Future<String> _filePath(
      String idControl, String type, int index) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder =
        Directory('${dir.path}/attachments/$idControl/$type');
    await folder.create(recursive: true);
    return '${folder.path}/$index.dat';
  }

  static bool _isFilePath(String value) =>
      value.startsWith('/') || value.contains('/attachments/');

  // ── Core storage ──────────────────────────────────────────────────────────

  static Future<void> guardarAttachment({
    required String idControl,
    required String attachmentType,
    required String attachmentData,
    required int attachmentIndex,
  }) async {
    final path = await _filePath(idControl, attachmentType, attachmentIndex);
    await File(path).writeAsString(attachmentData);

    final db = await DBHelper.db;
    await db.insert(
      'ControlAttachments',
      {
        'id_control': idControl,
        'attachment_type': attachmentType,
        'attachment_data': path, // solo la ruta, no los datos
        'attachment_index': attachmentIndex,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<String>> _leerAttachments(
      String idControl, String type) async {
    final db = await DBHelper.db;
    List<Map<String, dynamic>> results;
    try {
      results = await db.query(
        'ControlAttachments',
        columns: ['attachment_data'],
        where: 'id_control = ? AND attachment_type = ?',
        whereArgs: [idControl, type],
        orderBy: 'attachment_index ASC',
      );
    } catch (_) {
      // CursorWindow overflow — datos legacy ilegibles, limpiar y re-sincronizar
      try {
        await db.delete('ControlAttachments',
            where: 'id_control = ? AND attachment_type = ?',
            whereArgs: [idControl, type]);
      } catch (_) {}
      return [];
    }

    final List<String> data = [];
    for (final row in results) {
      final value = row['attachment_data'] as String? ?? '';
      if (value.isEmpty) continue;
      if (_isFilePath(value)) {
        try {
          final content = await File(value).readAsString();
          if (content.isNotEmpty) data.add(content);
        } catch (_) {}
      } else {
        // dato legacy guardado directo en SQLite — migrar al leerlo
        data.add(value);
        _migrarLegacyAArchivo(idControl, type, results.indexOf(row), value);
      }
    }
    return data;
  }

  // migra silenciosamente un dato legacy a archivo en disco
  static Future<void> _migrarLegacyAArchivo(
      String idControl, String type, int index, String data) async {
    try {
      final path = await _filePath(idControl, type, index);
      await File(path).writeAsString(data);
      final db = await DBHelper.db;
      await db.update(
        'ControlAttachments',
        {'attachment_data': path},
        where:
            'id_control = ? AND attachment_type = ? AND attachment_index = ?',
        whereArgs: [idControl, type, index],
      );
    } catch (_) {}
  }

  // ── Guardar por tipo ──────────────────────────────────────────────────────

  static Future<void> guardarPhotos(
      String idControl, List<String> photos) async {
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

  static Future<void> guardarVideos(
      String idControl, List<String> videos) async {
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

  static Future<void> guardarArchives(
      String idControl, List<String> archives) async {
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

  // ── Leer por tipo ─────────────────────────────────────────────────────────

  static Future<List<String>> obtenerPhotos(String idControl) =>
      _leerAttachments(idControl, 'photo');

  static Future<List<String>> obtenerVideos(String idControl) =>
      _leerAttachments(idControl, 'video');

  static Future<List<String>> obtenerArchives(String idControl) =>
      _leerAttachments(idControl, 'archive');

  // ── Conteos ───────────────────────────────────────────────────────────────

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
      counts.putIfAbsent(
          idControl, () => {'photos': 0, 'archives': 0, 'hasVideo': false});
      if (type == 'photo') counts[idControl]!['photos'] = count;
      else if (type == 'archive') counts[idControl]!['archives'] = count;
      else if (type == 'video') counts[idControl]!['hasVideo'] = count > 0;
    }
    return counts;
  }

  // ── Eliminar ──────────────────────────────────────────────────────────────

  static Future<void> eliminarAttachmentsPorTipo(
      String idControl, String attachmentType) async {
    final db = await DBHelper.db;
    final rows = await db.query(
      'ControlAttachments',
      columns: ['attachment_data'],
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, attachmentType],
    );
    for (final row in rows) {
      final value = row['attachment_data'] as String? ?? '';
      if (_isFilePath(value)) {
        try { await File(value).delete(); } catch (_) {}
      }
    }
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ? AND attachment_type = ?',
      whereArgs: [idControl, attachmentType],
    );
  }

  static Future<void> eliminarTodosAttachments(String idControl) async {
    final db = await DBHelper.db;
    final rows = await db.query(
      'ControlAttachments',
      columns: ['attachment_data'],
      where: 'id_control = ?',
      whereArgs: [idControl],
    );
    for (final row in rows) {
      final value = row['attachment_data'] as String? ?? '';
      if (_isFilePath(value)) {
        try { await File(value).delete(); } catch (_) {}
      }
    }
    await db.delete(
      'ControlAttachments',
      where: 'id_control = ?',
      whereArgs: [idControl],
    );
    // Limpiar carpeta de archivos del control
    try {
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/attachments/$idControl');
      if (await folder.exists()) await folder.delete(recursive: true);
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> obtenerTodosAttachments(
      String idControl) async {
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
}
