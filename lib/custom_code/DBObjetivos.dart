import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Objetivo.dart';

class DBObjetivos {
  // ============================================
  // INSERTAR OBJETIVO
  // ============================================
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

  // ============================================
  // INSERTAR OBJETIVOS MASIVOS (SYNC TOTAL)
  // ============================================
  static Future<String> insertObjetivosMasivos(
    List<Objetivo> objetivos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        // Borrar solo los objetivos del proyecto específico (no toda la tabla)
        // Evita race condition cuando múltiples proyectos se sincronizan en paralelo
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

  // ============================================
  // LISTAR OBJETIVOS POR PROYECTO
  // ============================================
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

  // ============================================
  // LISTAR TODOS LOS OBJETIVOS
  // ============================================
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

  // ============================================
  // OBTENER OBJETIVO POR ID_OBJETIVO
  // ============================================
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

  // ============================================
  // ELIMINAR OBJETIVO POR ID_OBJETIVO
  // ============================================
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

  // ============================================
  // EXISTE OBJETIVO
  // ============================================
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

  // ============================================
  // CONTAR OBJETIVOS
  // ============================================
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

  // ============================================
  // ELIMINAR TODOS LOS OBJETIVOS
  // ============================================
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

  // ============================================
  // DROP TABLE (DEV ONLY)
  // ============================================
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
