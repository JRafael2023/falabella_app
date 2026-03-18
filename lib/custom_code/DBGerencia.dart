import '/backend/schema/structs/index.dart';
import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class DBGerencia {
  /// [fromSupabase] = true cuando el registro viene bajando de Supabase
  /// (ya está en la nube → sincronizadoNube=1)
  /// [fromSupabase] = false (default) cuando es creación offline local
  /// (pendiente de subir → sincronizadoNube=0)
  static Future<String> insertGerencia(GerenciaStruct gerencia,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> gerenciaMap = {
        'idGerencia': gerencia.idGerencia,
        'name': gerencia.nombre,
        'sincronizadoNube': fromSupabase ? 1 : 0,
        'sincronizadoLocal': 1,
        'created_at': gerencia.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': gerencia.updateAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': gerencia.estado == true ? 1 : 0,
      };

      final result = await database.insert('Gerencias', gerenciaMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (result > 0) {
        return "Gerencia agregada correctamente";
      } else {
        return "Error: No se pudo agregar la Gerencia";
      }
    } catch (e) {
      print('Error al insertar gerencia: $e');
      return "Error al insertar gerencia: $e";
    }
  }

  // Actualizar una Gerencia
  static Future<String> updateGerencia(GerenciaStruct gerencia) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> gerenciaMap = {
        'name': gerencia.nombre,
        'sincronizadoNube': 0,
        'sincronizadoLocal': 1,
        'updated_at': DateTime.now().toIso8601String(),
        'status': gerencia.estado == true ? 1 : 0,
      };

      final result = await database.update(
        'Gerencias',
        gerenciaMap,
        where: 'idGerencia = ?',
        whereArgs: [gerencia.idGerencia],
      );

      if (result > 0) {
        return "Gerencia actualizada correctamente";
      } else {
        return "Error: No se pudo actualizar la Gerencia";
      }
    } catch (e) {
      print('Error al actualizar gerencia: $e');
      return "Error al actualizar gerencia: $e";
    }
  }

  // Eliminar una Gerencia
  static Future<String> deleteGerencia(String idGerencia) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.delete(
        'Gerencias',
        where: 'idGerencia = ?',
        whereArgs: [idGerencia],
      );

      if (result > 0) {
        return "Gerencia eliminada correctamente";
      } else {
        return "Error: No se pudo eliminar la Gerencia";
      }
    } catch (e) {
      print('Error al eliminar gerencia: $e');
      return "Error al eliminar gerencia: $e";
    }
  }

  // Obtener una Gerencia por ID
  static Future<GerenciaStruct?> getGerenciaById(String idGerencia) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return null;
      }

      final List<Map<String, dynamic>> result = await database.query(
        'Gerencias',
        where: 'idGerencia = ?',
        whereArgs: [idGerencia],
      );

      if (result.isNotEmpty) {
        return metodoconvertidorGerencia(result.first);
      }

      return null;
    } catch (e) {
      print('Error al obtener gerencia por ID: $e');
      return null;
    }
  }

  // Obtener todas las Gerencias
// Obtener todas las Gerencias
  static Future<List<GerenciaStruct>> getAllGerencias() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      final result = await database.query('Gerencias');

      return result.map((row) => metodoconvertidorGerencia(row)).toList();
    } catch (e) {
      print('Error al obtener todas las gerencias: $e');
      return [];
    }
  }

// Convertir Map (SQLite) a GerenciaStruct ✅ CORRECTO FLUTTERFLOW
  static GerenciaStruct metodoconvertidorGerencia(Map<String, dynamic> data) {
    return GerenciaStruct.fromMap({
      'id': data['id']?.toString(),
      'idGerencia': data['idGerencia'],
      'nombre': data['name'],
      'created_at': data['created_at'] != null
          ? DateTime.tryParse(data['created_at'])
          : null,
      'update_at': data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'])
          : null,
      'estado': data['status'] == 1,
    });
  }

  // ✅ NUEVO: Convertir datos de Supabase "Managements" a GerenciaStruct
  static List<GerenciaStruct> convertFromSupabase(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return GerenciaStruct.fromMap({
        'id': json['id']?.toString(),
        'idGerencia': json['management_id'],
        'nombre': json['name'],
        'created_at': json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        'update_at': json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
        'estado': json['status'] == true,
      });
    }).toList();
  }

  // ✅ NUEVO: Insertar lista completa desde Supabase a SQLite
  static Future<String> insertBatchFromSupabase(
      List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      // Convertir datos de Supabase a GerenciaStruct
      List<GerenciaStruct> gerencias = convertFromSupabase(supabaseData);

      // Insertar cada gerencia en SQLite
      int insertedCount = 0;
      for (var gerencia in gerencias) {
        final result = await insertGerencia(gerencia, fromSupabase: true);
        if (result.contains('correctamente')) {
          insertedCount++;
        }
      }

      return "Se insertaron $insertedCount gerencias de ${gerencias.length} correctamente";
    } catch (e) {
      print('Error al insertar batch desde Supabase: $e');
      return "Error al insertar batch: $e";
    }
  }

  // ✅ NUEVO: Sincronizar de SQLite a Supabase
  static Map<String, dynamic> toSupabaseMap(GerenciaStruct gerencia) {
    return {
      'id': gerencia.id,
      'management_id': gerencia.idGerencia, // ← management_id
      'name': gerencia.nombre, // ← name
      'created_at': gerencia.createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'status': gerencia.estado, // ← boolean directo
    };
  }
}
