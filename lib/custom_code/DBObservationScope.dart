import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'ObservationScope.dart';

class DBObservationScope {
  static Future<String> insertObservationScope(ObservationScope item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('ObservationScopes', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "ObservationScope agregado correctamente"
          : "Error: No se pudo agregar el ObservationScope";
    } catch (e) {
      print('Error al insertar ObservationScope: $e');
      return "Error al insertar ObservationScope: $e";
    }
  }

  static Future<String> updateObservationScope(ObservationScope item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'ObservationScopes', map,
        where: 'observation_scope_id = ?',
        whereArgs: [item.observationScopeId],
      );

      return result > 0
          ? "ObservationScope actualizado correctamente"
          : "Error: No se pudo actualizar el ObservationScope";
    } catch (e) {
      print('Error al actualizar ObservationScope: $e');
      return "Error al actualizar ObservationScope: $e";
    }
  }

  static Future<String> deleteObservationScope(
      String observationScopeId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'ObservationScopes',
        where: 'observation_scope_id = ?',
        whereArgs: [observationScopeId],
      );

      return result > 0
          ? "ObservationScope eliminado correctamente"
          : "Error: No se pudo eliminar el ObservationScope";
    } catch (e) {
      print('Error al eliminar ObservationScope: $e');
      return "Error al eliminar ObservationScope: $e";
    }
  }

  static Future<List<ObservationScope>> getAllObservationScopes() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('ObservationScopes',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => ObservationScope.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener ObservationScopes: $e');
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
        final item = ObservationScope.fromSupabase(json);
        final result = await insertObservationScope(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} ObservationScopes";
    } catch (e) {
      print('Error insertBatchFromSupabase ObservationScope: $e');
      return "Error: $e";
    }
  }
}
