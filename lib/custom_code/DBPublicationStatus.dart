import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'PublicationStatus.dart';

class DBPublicationStatus {
  static Future<String> insertPublicationStatus(PublicationStatus item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('PublicationStatuses', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "PublicationStatus agregado correctamente"
          : "Error: No se pudo agregar el PublicationStatus";
    } catch (e) {
      print('Error al insertar PublicationStatus: $e');
      return "Error al insertar PublicationStatus: $e";
    }
  }

  static Future<String> updatePublicationStatus(PublicationStatus item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'PublicationStatuses', map,
        where: 'publication_status_id = ?',
        whereArgs: [item.publicationStatusId],
      );

      return result > 0
          ? "PublicationStatus actualizado correctamente"
          : "Error: No se pudo actualizar el PublicationStatus";
    } catch (e) {
      print('Error al actualizar PublicationStatus: $e');
      return "Error al actualizar PublicationStatus: $e";
    }
  }

  static Future<String> deletePublicationStatus(
      String publicationStatusId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'PublicationStatuses',
        where: 'publication_status_id = ?',
        whereArgs: [publicationStatusId],
      );

      return result > 0
          ? "PublicationStatus eliminado correctamente"
          : "Error: No se pudo eliminar el PublicationStatus";
    } catch (e) {
      print('Error al eliminar PublicationStatus: $e');
      return "Error al eliminar PublicationStatus: $e";
    }
  }

  static Future<List<PublicationStatus>> getAllPublicationStatuses() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('PublicationStatuses',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => PublicationStatus.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener PublicationStatuses: $e');
      return [];
    }
  }

  static Future<String> insertBatchFromSupabase(
      List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      int count = 0;
      for (var json in supabaseData) {
        final item = PublicationStatus.fromSupabase(json);
        final result = await insertPublicationStatus(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} PublicationStatuses";
    } catch (e) {
      print('Error insertBatchFromSupabase PublicationStatus: $e');
      return "Error: $e";
    }
  }
}
