import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'ResponsibleManager.dart';

class DBResponsibleManager {
  static Future<String> insertResponsibleManager(ResponsibleManager item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;
      final result = await database.insert('ResponsibleManagers', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return result > 0 ? "ResponsibleManager agregado correctamente" : "Error: No se pudo agregar";
    } catch (e) {
      return "Error al insertar ResponsibleManager: $e";
    }
  }

  static Future<String> updateResponsibleManager(ResponsibleManager item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();
      final result = await database.update(
        'ResponsibleManagers', map,
        where: 'responsible_manager_id = ?',
        whereArgs: [item.responsibleManagerId],
      );
      return result > 0 ? "ResponsibleManager actualizado correctamente" : "Error: No se pudo actualizar";
    } catch (e) {
      return "Error al actualizar ResponsibleManager: $e";
    }
  }

  static Future<String> deleteResponsibleManager(String id) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final result = await database.delete(
        'ResponsibleManagers',
        where: 'responsible_manager_id = ?',
        whereArgs: [id],
      );
      return result > 0 ? "ResponsibleManager eliminado correctamente" : "Error: No se pudo eliminar";
    } catch (e) {
      return "Error al eliminar ResponsibleManager: $e";
    }
  }

  static Future<List<ResponsibleManager>> getAllResponsibleManagers() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('ResponsibleManagers',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => ResponsibleManager.fromMap(row)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<String> insertBatchFromSupabase(List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      int count = 0;
      for (var json in supabaseData) {
        final item = ResponsibleManager.fromSupabase(json);
        final result = await insertResponsibleManager(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} ResponsibleManagers";
    } catch (e) {
      return "Error: $e";
    }
  }
}
