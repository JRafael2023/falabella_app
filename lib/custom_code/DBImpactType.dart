import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'ImpactType.dart';

class DBImpactType {
  static Future<String> insertImpactType(ImpactType item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('ImpactTypes', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "ImpactType agregado correctamente"
          : "Error: No se pudo agregar el ImpactType";
    } catch (e) {
      print('Error al insertar ImpactType: $e');
      return "Error al insertar ImpactType: $e";
    }
  }

  static Future<String> updateImpactType(ImpactType item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'ImpactTypes', map,
        where: 'impact_type_id = ?',
        whereArgs: [item.impactTypeId],
      );

      return result > 0
          ? "ImpactType actualizado correctamente"
          : "Error: No se pudo actualizar el ImpactType";
    } catch (e) {
      print('Error al actualizar ImpactType: $e');
      return "Error al actualizar ImpactType: $e";
    }
  }

  static Future<String> deleteImpactType(String impactTypeId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'ImpactTypes',
        where: 'impact_type_id = ?',
        whereArgs: [impactTypeId],
      );

      return result > 0
          ? "ImpactType eliminado correctamente"
          : "Error: No se pudo eliminar el ImpactType";
    } catch (e) {
      print('Error al eliminar ImpactType: $e');
      return "Error al eliminar ImpactType: $e";
    }
  }

  static Future<List<ImpactType>> getAllImpactTypes() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('ImpactTypes',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => ImpactType.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener ImpactTypes: $e');
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
        final item = ImpactType.fromSupabase(json);
        final result = await insertImpactType(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} ImpactTypes";
    } catch (e) {
      print('Error insertBatchFromSupabase ImpactType: $e');
      return "Error: $e";
    }
  }
}
