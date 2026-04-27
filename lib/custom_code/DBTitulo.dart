import '/backend/schema/structs/index.dart';
import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class DBTitulo {
  static Future<String> insertTitulo(TituloStruct titulo,
      {bool fromSupabase = false}) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> tituloMap = {
        'idTitulo': titulo.idTitulo,
        'name': titulo.nombre,
        'sincronizadoNube': fromSupabase ? 1 : 0,
        'sincronizadoLocal': 1,
        'created_at': titulo.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': titulo.updateAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': titulo.estado == true ? 1 : 0,
      };

      final result = await database.insert('Titulos', tituloMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (result > 0) {
        return "Título agregado correctamente";
      } else {
        return "Error: No se pudo agregar el Título";
      }
    } catch (e) {
      return "Error al insertar título: $e";
    }
  }

  static Future<String> updateTitulo(TituloStruct titulo) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final Map<String, dynamic> tituloMap = {
        'name': titulo.nombre,
        'sincronizadoNube': 0,
        'sincronizadoLocal': 1,
        'updated_at': DateTime.now().toIso8601String(),
        'status': titulo.estado == true ? 1 : 0,
      };

      final result = await database.update(
        'Titulos',
        tituloMap,
        where: 'idTitulo = ?',
        whereArgs: [titulo.idTitulo],
      );

      if (result > 0) {
        return "Título actualizado correctamente";
      } else {
        return "Error: No se pudo actualizar el Título";
      }
    } catch (e) {
      return "Error al actualizar título: $e";
    }
  }

  static Future<String> deleteTitulo(String idTitulo) async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.delete(
        'Titulos',
        where: 'idTitulo = ?',
        whereArgs: [idTitulo],
      );

      if (result > 0) {
        return "Título eliminado correctamente";
      } else {
        return "Error: No se pudo eliminar el Título";
      }
    } catch (e) {
      return "Error al eliminar título: $e";
    }
  }

  static Future<TituloStruct?> getTituloById(String idTitulo) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return null;

      final List<Map<String, dynamic>> result = await database.query(
        'Titulos',
        where: 'idTitulo = ?',
        whereArgs: [idTitulo],
      );

      if (result.isNotEmpty) {
        return metodoConvertidor(result.first);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static TituloStruct metodoConvertidor(Map<String, dynamic> data) {
    return TituloStruct.fromMap({
      'id': data['id']?.toString(),
      'idTitulo': data['idTitulo'],
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

  static Future<List<TituloStruct>> getAllTitulos() async {
    try {
      final database = await DBHelper.db;

      if (database == null) {
        return [];
      }

      final List<Map<String, dynamic>> result = await database.query('Titulos');

      return result.map((row) => metodoConvertidor(row)).toList();
    } catch (e) {
      return [];
    }
  }

  static List<TituloStruct> convertFromSupabase(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return TituloStruct.fromMap({
        'id': json['id']?.toString(),
        'idTitulo': json['titles_id']?.toString(),
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

  static Future<String> insertBatchFromSupabase(
      List<dynamic> supabaseData) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      List<TituloStruct> titulos = convertFromSupabase(supabaseData);

      int insertedCount = 0;
      for (var titulo in titulos) {
        final result = await insertTitulo(titulo, fromSupabase: true);
        if (result.contains('correctamente')) {
          insertedCount++;
        }
      }

      return "Se insertaron $insertedCount títulos de ${titulos.length} correctamente";
    } catch (e) {
      return "Error al insertar batch: $e";
    }
  }

  static Map<String, dynamic> toSupabaseMap(TituloStruct titulo) {
    return {
      'id': titulo.id,
      'name': titulo.nombre,
      'created_at': titulo.createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'status': titulo.estado,
    };
  }

}
