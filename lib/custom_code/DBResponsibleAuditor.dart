import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'ResponsibleAuditor.dart';

class DBResponsibleAuditor {
  static Future<String> insertResponsibleAuditor(ResponsibleAuditor item,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final map = item.toMap();
      map['sincronizadoNube'] = fromSupabase ? 1 : 0;
      map['sincronizadoLocal'] = 1;
      map['pendienteEliminar'] = 0;
      final result = await database.insert('ResponsibleAuditors', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return result > 0 ? "ResponsibleAuditor agregado correctamente" : "Error: No se pudo agregar";
    } catch (e) {
      print('Error al insertar ResponsibleAuditor: $e');
      return "Error al insertar ResponsibleAuditor: $e";
    }
  }

  static Future<String> updateResponsibleAuditor(ResponsibleAuditor item) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final map = item.toMap();
      map['sincronizadoNube'] = 0;
      map['sincronizadoLocal'] = 1;
      map['updated_at'] = DateTime.now().toIso8601String();
      final result = await database.update(
        'ResponsibleAuditors', map,
        where: 'responsible_auditor_id = ?',
        whereArgs: [item.responsibleAuditorId],
      );
      return result > 0 ? "ResponsibleAuditor actualizado correctamente" : "Error: No se pudo actualizar";
    } catch (e) {
      print('Error al actualizar ResponsibleAuditor: $e');
      return "Error al actualizar ResponsibleAuditor: $e";
    }
  }

  static Future<String> deleteResponsibleAuditor(String id) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      final result = await database.delete(
        'ResponsibleAuditors',
        where: 'responsible_auditor_id = ?',
        whereArgs: [id],
      );
      return result > 0 ? "ResponsibleAuditor eliminado correctamente" : "Error: No se pudo eliminar";
    } catch (e) {
      print('Error al eliminar ResponsibleAuditor: $e');
      return "Error al eliminar ResponsibleAuditor: $e";
    }
  }

  static Future<List<ResponsibleAuditor>> getAllResponsibleAuditors() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];
      final result = await database.query('ResponsibleAuditors',
          where: 'status = ? AND pendienteEliminar = ?',
          whereArgs: [1, 0],
          orderBy: 'name ASC');
      return result.map((row) => ResponsibleAuditor.fromMap(row)).toList();
    } catch (e) {
      print('Error al obtener ResponsibleAuditors: $e');
      return [];
    }
  }

  static Future<String> insertBatchFromSupabase(List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return "Error: No se pudo acceder a la base de datos";
      int count = 0;
      for (var json in supabaseData) {
        final item = ResponsibleAuditor.fromSupabase(json);
        final result = await insertResponsibleAuditor(item, fromSupabase: true);
        if (result.contains('correctamente')) count++;
      }
      return "Se insertaron $count de ${supabaseData.length} ResponsibleAuditors";
    } catch (e) {
      print('Error insertBatchFromSupabase ResponsibleAuditor: $e');
      return "Error: $e";
    }
  }
}
