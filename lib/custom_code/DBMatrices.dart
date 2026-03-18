import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Matrices.dart';

class DBMatrices {
  // Insertar una nueva matriz
  static Future<String> insertMatriz(Matrices matriz) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.insert(
        'Matrices',
        matriz.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return result > 0
          ? "Matriz agregada correctamente"
          : "Error: No se pudo agregar la Matriz";
    } catch (e) {
      print('Error al insertar matriz: $e');
      return "Error al insertar matriz: $e";
    }
  }

  // Listar todas las matrices (JSON)
  static Future<List<Map<String, dynamic>>> listarMatricesJson() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      return await database.query(
        'Matrices',
        where: 'status = ?',
        whereArgs: [1],
        orderBy: 'id ASC',
      );
    } catch (e) {
      print("Error al listar matrices: $e");
      return [];
    }
  }

  // Obtener todas las matrices como objetos
  static Future<List<Matrices>> getAllMatrices() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      final maps = await database.query(
        'Matrices',
        where: 'status = ?',
        whereArgs: [1],
        orderBy: 'id ASC',
      );

      return maps.map((e) => Matrices.fromMap(e)).toList();
    } catch (e) {
      print('Error al obtener matrices: $e');
      return [];
    }
  }

  // Obtener matriz por ID local
  static Future<Matrices?> getMatrizById(int id) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return null;

      final maps = await database.query(
        'Matrices',
        where: 'id = ? AND status = ?',
        whereArgs: [id, 1],
      );

      return maps.isNotEmpty ? Matrices.fromMap(maps.first) : null;
    } catch (e) {
      print('Error al obtener matriz por ID: $e');
      return null;
    }
  }

  // Obtener matriz por id_matriz (ID lógico / remoto)
  static Future<Matrices?> getMatrizByIdMatriz(String idMatriz) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return null;

      final maps = await database.query(
        'Matrices',
        where: 'id_matriz = ? AND status = ?',
        whereArgs: [idMatriz, 1],
      );

      return maps.isNotEmpty ? Matrices.fromMap(maps.first) : null;
    } catch (e) {
      print('Error al obtener matriz por idMatriz: $e');
      return null;
    }
  }

  // Actualizar una matriz (por id_matriz)
  static Future<String> updateMatriz(Matrices matriz) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.update(
        'Matrices',
        matriz.toMap(),
        where: 'id_matriz = ?',
        whereArgs: [matriz.idMatriz],
      );

      return result > 0
          ? "Matriz actualizada correctamente"
          : "Error: No se pudo actualizar la Matriz";
    } catch (e) {
      print('Error al actualizar matriz: $e');
      return "Error al actualizar matriz: $e";
    }
  }

  // Soft delete (status = 0)
  static Future<String> deleteMatriz(String idMatriz) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result = await database.update(
        'Matrices',
        {'status': 0},
        where: 'id_matriz = ?',
        whereArgs: [idMatriz],
      );

      return result > 0
          ? "Matriz eliminada correctamente"
          : "Error: No se pudo eliminar la Matriz";
    } catch (e) {
      print('Error al eliminar matriz: $e');
      return "Error al eliminar matriz: $e";
    }
  }

  // Eliminar permanentemente
  static Future<String> deleteMatrizPermanently(int id) async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      final result =
          await database.delete('Matrices', where: 'id = ?', whereArgs: [id]);

      return result > 0
          ? "Matriz eliminada permanentemente"
          : "Error: No se pudo eliminar la Matriz";
    } catch (e) {
      print('Error al eliminar permanentemente matriz: $e');
      return "Error al eliminar permanentemente matriz: $e";
    }
  }

  // Buscar matrices por nombre
  static Future<List<Matrices>> searchMatricesByName(String searchTerm) async {
    try {
      final database = await DBHelper.db;
      if (database == null) return [];

      final maps = await database.query(
        'Matrices',
        where: 'name LIKE ? AND status = ?',
        whereArgs: ['%$searchTerm%', 1],
        orderBy: 'name ASC',
      );

      return maps.map((e) => Matrices.fromMap(e)).toList();
    } catch (e) {
      print('Error al buscar matrices: $e');
      return [];
    }
  }

  // Contar matrices activas
  static Future<int> countMatrices() async {
    try {
      final database = await DBHelper.db;
      if (database == null) return 0;

      final result = await database.rawQuery(
        'SELECT COUNT(*) FROM Matrices WHERE status = 1',
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error al contar matrices: $e');
      return 0;
    }
  }

  // Eliminar la tabla Matrices
  static Future<String> dropMatricesTable() async {
    try {
      final database = await DBHelper.db;
      if (database == null) {
        return "Error: No se pudo acceder a la base de datos";
      }

      await database.execute('DROP TABLE IF EXISTS Matrices');
      return "Tabla 'Matrices' eliminada correctamente";
    } catch (e) {
      print('Error al eliminar la tabla Matrices: $e');
      return "Error al eliminar la tabla Matrices: $e";
    }
  }

  // ============================================
// INSERTAR MATRICES MASIVAS (SYNC TOTAL)
// ============================================
  static Future<String> insertMatricesMasivas(
    List<Matrices> matrices,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        // 🔥 sync full
        await txn.delete('Matrices');

        for (final matriz in matrices) {
          await txn.insert(
            'Matrices',
            matriz.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return "Matrices sincronizadas correctamente";
    } catch (e) {
      print('Error insertMatricesMasivas: $e');
      return "Error insertMatricesMasivas: $e";
    }
  }

// ============================================
// INSERTAR MATRICES INCREMENTALES
// ============================================
  static Future<String> insertMatricesIncrementales(
    List<Matrices> matrices,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      int nuevos = 0;
      int ignorados = 0;

      for (final matriz in matrices) {
        final existe = await getMatrizByIdMatriz(matriz.idMatriz);

        if (existe == null) {
          await db.insert(
            'Matrices',
            matriz.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
          nuevos++;
        } else {
          ignorados++;
        }
      }

      return "✅ $nuevos nuevas | $ignorados ya existían";
    } catch (e) {
      print('Error insertMatricesIncrementales: $e');
      return "Error: $e";
    }
  }
}
