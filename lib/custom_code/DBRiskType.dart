import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'RiskType.dart';

class DBRiskType {
  static Future<String> insertRiskType(RiskType item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('RiskTypes', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "RiskType agregado correctamente"
          : "Error: No se pudo agregar el RiskType";
    } catch (e) {
      print('Error al insertar RiskType: $e');
      return "Error al insertar RiskType: $e";
    }
  }

  static Future<String> updateRiskType(RiskType item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'RiskTypes', map,
        where: 'risk_type_id = ?',
        whereArgs: [item.riskTypeId],
      );

      return result > 0
          ? "RiskType actualizado correctamente"
          : "Error: No se pudo actualizar el RiskType";
    } catch (e) {
      print('Error al actualizar RiskType: $e');
      return "Error al actualizar RiskType: $e";
    }
  }

  static Future<String> deleteRiskType(String riskTypeId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'RiskTypes',
        where: 'risk_type_id = ?',
        whereArgs: [riskTypeId],
      );

      return result > 0
          ? "RiskType eliminado correctamente"
          : "Error: No se pudo eliminar el RiskType";
    } catch (e) {
      print('Error al eliminar RiskType: $e');
      return "Error al eliminar RiskType: $e";
    }
  }

  static Future<List<RiskType>> getAllRiskTypes() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('RiskTypes',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => RiskType.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener RiskTypes: $e');
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
        final item = RiskType.fromSupabase(json);
        final result = await insertRiskType(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} RiskTypes";
    } catch (e) {
      print('Error insertBatchFromSupabase RiskType: $e');
      return "Error: $e";
    }
  }
}
