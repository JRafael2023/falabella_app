import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'RiskTypology.dart';

class DBRiskTypology {
  static Future<String> insertRiskTypology(RiskTypology item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('RiskTypologies', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "RiskTypology agregado correctamente"
          : "Error: No se pudo agregar el RiskTypology";
    } catch (e) {
      print('Error al insertar RiskTypology: $e');
      return "Error al insertar RiskTypology: $e";
    }
  }

  static Future<String> updateRiskTypology(RiskTypology item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'RiskTypologies', map,
        where: 'risk_typology_id = ?',
        whereArgs: [item.riskTypologyId],
      );

      return result > 0
          ? "RiskTypology actualizado correctamente"
          : "Error: No se pudo actualizar el RiskTypology";
    } catch (e) {
      print('Error al actualizar RiskTypology: $e');
      return "Error al actualizar RiskTypology: $e";
    }
  }

  static Future<String> deleteRiskTypology(String riskTypologyId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'RiskTypologies',
        where: 'risk_typology_id = ?',
        whereArgs: [riskTypologyId],
      );

      return result > 0
          ? "RiskTypology eliminado correctamente"
          : "Error: No se pudo eliminar el RiskTypology";
    } catch (e) {
      print('Error al eliminar RiskTypology: $e');
      return "Error al eliminar RiskTypology: $e";
    }
  }

  static Future<List<RiskTypology>> getAllRiskTypologies() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('RiskTypologies',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => RiskTypology.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener RiskTypologies: $e');
      return [];
    }
  }

  static Future<List<RiskTypology>> getRiskTypologiesByType(
      String riskTypeId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('RiskTypologies',
          where: 'risk_type_id = ? AND status = ? AND pendienteEliminar = ?',
          whereArgs: [riskTypeId, 1, 0],
          orderBy: 'name ASC');
      return result.map((row) => RiskTypology.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener RiskTypologies por tipo: $e');
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
        final item = RiskTypology.fromSupabase(json);
        final result = await insertRiskTypology(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} RiskTypologies";
    } catch (e) {
      print('Error insertBatchFromSupabase RiskTypology: $e');
      return "Error: $e";
    }
  }
}
