import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'EcosystemSupport.dart';

class DBEcosystemSupport {
  static Future<String> insertEcosystemSupport(EcosystemSupport item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;

      final result = await database.insert('EcosystemSupports', map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0
          ? "EcosystemSupport agregado correctamente"
          : "Error: No se pudo agregar el EcosystemSupport";
    } catch (e) {
      print('Error al insertar EcosystemSupport: $e');
      return "Error al insertar EcosystemSupport: $e";
    }
  }

  static Future<String> updateEcosystemSupport(EcosystemSupport item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();

      final result = await database.update(
        'EcosystemSupports', map,
        where: 'ecosystem_support_id = ?',
        whereArgs: [item.ecosystemSupportId],
      );

      return result > 0
          ? "EcosystemSupport actualizado correctamente"
          : "Error: No se pudo actualizar el EcosystemSupport";
    } catch (e) {
      print('Error al actualizar EcosystemSupport: $e');
      return "Error al actualizar EcosystemSupport: $e";
    }
  }

  static Future<String> deleteEcosystemSupport(
      String ecosystemSupportId) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";

      final result = await database.delete(
        'EcosystemSupports',
        where: 'ecosystem_support_id = ?',
        whereArgs: [ecosystemSupportId],
      );

      return result > 0
          ? "EcosystemSupport eliminado correctamente"
          : "Error: No se pudo eliminar el EcosystemSupport";
    } catch (e) {
      print('Error al eliminar EcosystemSupport: $e');
      return "Error al eliminar EcosystemSupport: $e";
    }
  }

  static Future<List<EcosystemSupport>> getAllEcosystemSupports() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('EcosystemSupports',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => EcosystemSupport.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener EcosystemSupports: $e');
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
        final item = EcosystemSupport.fromSupabase(json);
        final result = await insertEcosystemSupport(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} EcosystemSupports";
    } catch (e) {
      print('Error insertBatchFromSupabase EcosystemSupport: $e');
      return "Error: $e";
    }
  }
}
