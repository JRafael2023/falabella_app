import '/backend/schema/structs/index.dart';
import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class DBProceso {
  /// [fromSupabase] = true cuando el registro viene bajando de Supabase
  /// (ya está en la nube → sincronizadoNube=1)
  /// [fromSupabase] = false (default) cuando es creación offline local
  /// (pendiente de subir → sincronizadoNube=0)
  static Future<String> insertProceso(ProcesoStruct proceso,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> procesoMap = {
        'idProceso': proceso.idProceso,
        'name': proceso.nombre,
        'sincronizadoNube': fromSupabase ? 1 : 0,
        'sincronizadoLocal': 1,
        'created_at': proceso.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': proceso.updateAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': proceso.estado == true ? 1 : 0,
      };

      final result = await database.insert('Procesos', procesoMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (result > 0) {
        return "Proceso agregado correctamente";
      } else {
        return "Error: No se pudo agregar al Proceso";
      }
    } catch (e) {
      return "Error al insertar proceso: $e";
    }
  }

  static Future<String> updateProceso(ProcesoStruct proceso) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> procesoMap = {
        'name': proceso.nombre,
        'sincronizadoNube': 0,
        'sincronizadoLocal': 1,
        'updated_at': DateTime.now().toIso8601String(),
        'status': proceso.estado == true ? 1 : 0,
      };

      final result = await database.update(
        'Procesos',
        procesoMap,
        where: 'idProceso = ?',
        whereArgs: [proceso.idProceso],
      );

      if (result > 0) {
        return "Proceso actualizado correctamente";
      } else {
        return "Error: No se pudo actualizar el Proceso";
      }
    } catch (e) {
      return "Error al actualizar proceso: $e";
    }
  }

  static Future<String> deleteProceso(String id) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.delete(
        'Procesos',
        where: 'idProceso = ?',
        whereArgs: [id],
      );

      if (result > 0) {
        return "Proceso eliminado correctamente";
      } else {
        return "Error: No se pudo eliminar el Proceso";
      }
    } catch (e) {
      return "Error al eliminar proceso: $e";
    }
  }

  static Future<ProcesoStruct?> getProcesoById(String id) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return null;
      }

      final List<Map<String, dynamic>> result = await database.query(
        'Procesos',
        where: 'idProceso = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return metodoconvertidor(result.first);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

// Convertir Map (SQLite) a ProcesoStruct ✅ CORRECTO FLUTTERFLOW
  static ProcesoStruct metodoconvertidor(Map<String, dynamic> data) {
    return ProcesoStruct.fromMap({
      'id': data['id']?.toString(),
      'idProceso': data['idProceso'],
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

  // Obtener todos los procesos de SQLite
  static Future<List<ProcesoStruct>> getAllProcesos() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      final List<Map<String, dynamic>> result =
          await database.query('Procesos');

      return result.map((row) => metodoconvertidor(row)).toList();
    } catch (e) {
      return [];
    }
  }

  // ✅ NUEVO: Convertir datos de Supabase "Processes" a ProcesoStruct
  static List<ProcesoStruct> convertFromSupabase(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return ProcesoStruct.fromMap({
        'id': json['id']?.toString(),
        'idProceso': json['process_id']?.toString(),
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

  // ✅ NUEVO: Insertar batch desde Supabase a SQLite
  static Future<String> insertBatchFromSupabase(
      List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      List<ProcesoStruct> procesos = convertFromSupabase(supabaseData);

      int insertedCount = 0;
      for (var proceso in procesos) {
        final result = await insertProceso(proceso, fromSupabase: true);
        if (result.contains('correctamente')) {
          insertedCount++;
        }
      }

      return "Se insertaron $insertedCount procesos de ${procesos.length} correctamente";
    } catch (e) {
      return "Error al insertar batch: $e";
    }
  }

  // ✅ NUEVO: Convertir ProcesoStruct a Map para Supabase
  static Map<String, dynamic> toSupabaseMap(ProcesoStruct proceso) {
    return {
      'id': proceso.id,
      'name': proceso.nombre,
      'created_at': proceso.createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'status': proceso.estado,
    };
  }
}
