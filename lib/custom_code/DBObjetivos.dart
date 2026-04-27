import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Objetivo.dart';

class DBObjetivos {
  static Future<String> insertObjetivo(Objetivo objetivo) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.insert(
        'Objetivos',
        objetivo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return "Objetivo insertado correctamente";
    } catch (e) {
      return "Error insertObjetivo: $e";
    }
  }

  static Future<String> insertObjetivosMasivos(
    List<Objetivo> objetivos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        if (objetivos.isNotEmpty) {
          await txn.delete(
            'Objetivos',
            where: 'project_id = ?',
            whereArgs: [objetivos.first.projectId],
          );
        }

        for (final objetivo in objetivos) {
          await txn.insert(
            'Objetivos',
            objetivo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return "Objetivos sincronizados correctamente";
    } catch (e) {
      return "Error insertObjetivosMasivos: $e";
    }
  }

  static Future<List<Objetivo>> listarObjetivosPorProyecto(
    String projectId,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      final maps = await db.query(
        'Objetivos',
        where: 'project_id = ?',
        whereArgs: [projectId],
      );

      return maps.map((e) => Objetivo.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Objetivo>> listarObjetivos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      final maps = await db.query('Objetivos');
      return maps.map((e) => Objetivo.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Objetivo?> getObjetivoByIdObjetivo(
    String idObjetivo,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return null;

      final maps = await db.query(
        'Objetivos',
        where: 'id_objetivo = ?',
        whereArgs: [idObjetivo],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Objetivo.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String> deleteObjetivoByIdObjetivo(
    String idObjetivo,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.delete(
        'Objetivos',
        where: 'id_objetivo = ?',
        whereArgs: [idObjetivo],
      );

      return rows > 0 ? "Objetivo eliminado" : "Objetivo no encontrado";
    } catch (e) {
      return "Error deleteObjetivoByIdObjetivo: $e";
    }
  }

  static Future<bool> existeObjetivo(String idObjetivo) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return false;

      final result = await db.query(
        'Objetivos',
        where: 'id_objetivo = ?',
        whereArgs: [idObjetivo],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<int> contarObjetivos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return 0;

      final result = await db.rawQuery('SELECT COUNT(*) FROM Objetivos');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<String> deleteAllObjetivos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.delete('Objetivos');
      return "Objetivos eliminados";
    } catch (e) {
      return "Error deleteAllObjetivos: $e";
    }
  }

  static Future<String> dropObjetivosTable() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.execute('DROP TABLE IF EXISTS Objetivos');
      return "Tabla Objetivos eliminada";
    } catch (e) {
      return "Error dropObjetivosTable: $e";
    }
  }
}
