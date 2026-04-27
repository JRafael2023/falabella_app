import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Proyecto.dart';

class DBProyectos {
  static Future<String> insertProyecto(Proyecto proyecto) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.insert(
        'Proyectos',
        proyecto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return "Proyecto insertado correctamente";
    } catch (e) {
      return "Error insertProyecto: $e";
    }
  }

  static Future<String> insertProyectosMasivos(
    List<Proyecto> proyectos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        await txn.delete('Proyectos');

        for (final proyecto in proyectos) {
          await txn.insert(
            'Proyectos',
            proyecto.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return "Proyectos sincronizados correctamente";
    } catch (e) {
      return "Error insertProyectosMasivos: $e";
    }
  }

  static Future<List<Proyecto>> listarProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      final maps = await db.query('Proyectos');
      return maps.map((e) => Proyecto.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Proyecto?> getProyectoByIdProject(String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return null;

      final maps = await db.query(
        'Proyectos',
        where: 'idProyecto = ?',
        whereArgs: [idProject],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Proyecto.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String> deleteProyectoByIdProject(String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.delete(
        'Proyectos',
        where: 'idProyecto = ?',
        whereArgs: [idProject],
      );

      return rows > 0 ? "Proyecto eliminado" : "Proyecto no encontrado";
    } catch (e) {
      return "Error deleteProyectoByIdProject: $e";
    }
  }

  static Future<bool> existeProyecto(String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return false;

      final result = await db.query(
        'Proyectos',
        where: 'idProyecto = ?',
        whereArgs: [idProject],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<String> updateProyecto(Proyecto proyecto) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.update(
        'Proyectos',
        proyecto.toMap(),
        where: 'idProyecto = ?',
        whereArgs: [proyecto.idProject],
      );

      return rows > 0
          ? "Proyecto actualizado correctamente"
          : "Proyecto no encontrado";
    } catch (e) {
      return "Error updateProyecto: $e";
    }
  }

  static Future<int> contarProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return 0;

      final result = await db.rawQuery('SELECT COUNT(*) FROM Proyectos');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<String> deleteAllProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.delete('Proyectos');
      return "Proyectos eliminados";
    } catch (e) {
      return "Error deleteAllProyectos: $e";
    }
  }

  static Future<String> dropProyectosTable() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.execute('DROP TABLE IF EXISTS Proyectos');
      return "Tabla Proyectos eliminada";
    } catch (e) {
      return "Error dropProyectosTable: $e";
    }
  }

  static Future<String> insertProyectosIncrementales(
    List<Proyecto> proyectos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      int nuevos = 0;
      int actualizados = 0;

      for (final proyecto in proyectos) {
        final existe = await existeProyecto(proyecto.idProject);

        if (!existe) {
          await db.insert(
            'Proyectos',
            proyecto.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
          nuevos++;
        } else {
          await db.update(
            'Proyectos',
            {
              'progress': proyecto.progress,
              'state_proyecto': proyecto.projectState,
              'status_proyecto': proyecto.projectStatus,
            },
            where: 'idProyecto = ?',
            whereArgs: [proyecto.idProject],
          );
          actualizados++;
        }
      }

      return "✅ $nuevos nuevos | $actualizados actualizados";
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<double> calcularYActualizarProgressProyecto(
      String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) {
        return 0.0;
      }

      final objetivosResult = await db.query(
        'Objetivos',
        where: 'project_id = ?',
        whereArgs: [idProject],
      );

      if (objetivosResult.isEmpty) {
        return 0.0;
      }

      final idsObjetivos =
          objetivosResult.map((obj) => obj['id_objetivo'] as String).toList();


      int totalControles = 0;
      int controlesCompletados = 0;

      for (String idObjetivo in idsObjetivos) {
        final controlesResult = await db.query(
          'Controles',
          where: 'objective_id = ? AND status = 1',
          whereArgs: [idObjetivo],
        );

        totalControles += controlesResult.length;

        controlesCompletados += controlesResult
            .where((control) => control['completed'] == 1)
            .length;
      }


      double progress = 0.0;
      if (totalControles > 0) {
        progress = (controlesCompletados / totalControles) * 100.0;
      }


      await db.update(
        'Proyectos',
        {'progress': progress},
        where: 'idProyecto = ?',
        whereArgs: [idProject],
      );


      return progress;
    } catch (e) {
      return 0.0;
    }
  }
}
