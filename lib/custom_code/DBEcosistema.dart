import '/backend/schema/structs/index.dart';
import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class DBEcosistema {
  // Insertar un nuevo Ecosistema
  /// [fromSupabase] = true cuando el registro viene bajando de Supabase
  /// (ya está en la nube → sincronizadoNube=1)
  /// [fromSupabase] = false (default) cuando es creación offline local
  /// (pendiente de subir → sincronizadoNube=0)
  static Future<String> insertEcosistema(EcosistemaStruct ecosistema,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> ecosistemaMap = {
        'idEcosistema': ecosistema.idEcosistema,
        'name': ecosistema.nombre,
        'sincronizadoNube': fromSupabase ? 1 : 0,
        'sincronizadoLocal': 1,
        'created_at': ecosistema.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': ecosistema.updateAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': ecosistema.estado == true ? 1 : 0,
      };

      final result = await database.insert('Ecosistemas', ecosistemaMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (result > 0) {
        return "Ecosistema agregado correctamente";
      } else {
        return "Error: No se pudo agregar el Ecosistema";
      }
    } catch (e) {
      print('Error al insertar ecosistema: $e');
      return "Error al insertar ecosistema: $e";
    }
  }

  // Actualizar un Ecosistema
  static Future<String> updateEcosistema(EcosistemaStruct ecosistema) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> ecosistemaMap = {
        'name': ecosistema.nombre,
        'sincronizadoNube': 0,
        'sincronizadoLocal': 1,
        'updated_at': DateTime.now().toIso8601String(),
        'status': ecosistema.estado == true ? 1 : 0,
      };

      final result = await database.update(
        'Ecosistemas',
        ecosistemaMap,
        where: 'idEcosistema = ?',
        whereArgs: [ecosistema.idEcosistema],
      );

      if (result > 0) {
        return "Ecosistema actualizado correctamente";
      } else {
        return "Error: No se pudo actualizar el Ecosistema";
      }
    } catch (e) {
      print('Error al actualizar ecosistema: $e');
      return "Error al actualizar ecosistema: $e";
    }
  }

  // Eliminar un Ecosistema
  static Future<String> deleteEcosistema(String idEcosistema) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.delete(
        'Ecosistemas',
        where: 'idEcosistema = ?',
        whereArgs: [idEcosistema],
      );

      if (result > 0) {
        return "Ecosistema eliminado correctamente";
      } else {
        return "Error: No se pudo eliminar el Ecosistema";
      }
    } catch (e) {
      print('Error al eliminar ecosistema: $e');
      return "Error al eliminar ecosistema: $e";
    }
  }

  // Obtener un Ecosistema por ID
  static Future<EcosistemaStruct?> getEcosistemaById(
      String idEcosistema) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return null;
      }

      final List<Map<String, dynamic>> result = await database.query(
        'Ecosistemas',
        where: 'idEcosistema = ?',
        whereArgs: [idEcosistema],
      );

      if (result.isNotEmpty) {
        return metodoconvertidorEcosistema(result.first);
      }

      return null;
    } catch (e) {
      print('Error al obtener ecosistema por ID: $e');
      return null;
    }
  }

  // Obtener todos los Ecosistemas
  static Future<List<EcosistemaStruct>> getAllEcosistemas() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      final result = await database.query('Ecosistemas');

      return result.map((row) => metodoconvertidorEcosistema(row)).toList();
    } catch (e) {
      print('Error al obtener todos los ecosistemas: $e');
      return [];
    }
  }

  // Método de conversión de Map a EcosistemaStruct
  // Convertir Map (SQLite) a EcosistemaStruct ✅ CORRECTO FLUTTERFLOW
  static EcosistemaStruct metodoconvertidorEcosistema(
      Map<String, dynamic> data) {
    return EcosistemaStruct.fromMap({
      'id': data['id']?.toString(),
      'idEcosistema': data['idEcosistema'],
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

  // MÉTODO PARA SUPABASE: Convertir JSON de Supabase a EcosistemaStruct
  // Convertir JSON de Supabase a EcosistemaStruct ✅ CORRECTO
  static List<EcosistemaStruct> convertFromSupabase(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return EcosistemaStruct.fromMap({
        'id': json['id']?.toString(),
        'idEcosistema': json['idEcosistema'],
        'nombre': json['nombre'],
        'created_at': json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        'update_at': json['update_at'] != null
            ? DateTime.tryParse(json['update_at'])
            : null,
        'estado': json['estado'] == true,
      });
    }).toList();
  }
}
