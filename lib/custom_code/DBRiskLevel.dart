import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'RiskLevel.dart';

class DBRiskLevel {
  static Future<String> insertRiskLevel(RiskLevel item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('RiskLevels', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "RiskLevel agregado correctamente"
          : "Error: No se pudo agregar el RiskLevel";
    } catch (e) {
      print('Error al insertar RiskLevel: $e');
      return "Error al insertar RiskLevel: $e";
    }
  }

  static Future<String> updateRiskLevel(RiskLevel item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'RiskLevels', map,
        where: 'risk_level_id = ?',
        whereArgs: [item.riskLevelId],
      );

      return result > 0
          ? "RiskLevel actualizado correctamente"
          : "Error: No se pudo actualizar el RiskLevel";
    } catch (e) {
      print('Error al actualizar RiskLevel: $e');
      return "Error al actualizar RiskLevel: $e";
    }
  }

  static Future<String> deleteRiskLevel(String riskLevelId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'RiskLevels',
        where: 'risk_level_id = ?',
        whereArgs: [riskLevelId],
      );

      return result > 0
          ? "RiskLevel eliminado correctamente"
          : "Error: No se pudo eliminar el RiskLevel";
    } catch (e) {
      print('Error al eliminar RiskLevel: $e');
      return "Error al eliminar RiskLevel: $e";
    }
  }

  static Future<List<RiskLevel>> getAllRiskLevels() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('RiskLevels',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => RiskLevel.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener RiskLevels: $e');
      return [];
    }
  }

  static Future<RiskLevel?> getRiskLevelById(String riskLevelId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return null;
      final result = await database.query('RiskLevels',
          where: 'risk_level_id = ?', whereArgs: [riskLevelId]);
      return result.isNotEmpty ? RiskLevel.fromMap(result.first) : null;
    } catch (e) {
      print('Error al obtener RiskLevel por ID: $e');
      return null;
    }
  }

  static Future<String> insertBatchFromSupabase(
      List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      int count = 0;
      for (var json in supabaseData) {
        final item = RiskLevel.fromSupabase(json);
        final result = await insertRiskLevel(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} RiskLevels";
    } catch (e) {
      print('Error insertBatchFromSupabase RiskLevel: $e');
      return "Error: $e";
    }
  }
}
