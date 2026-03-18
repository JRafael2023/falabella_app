import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'Proyecto.dart';

class DBProyectos {
  // ============================================
  // INSERTAR PROYECTO
  // ============================================
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
      print('Error insertProyecto: $e');
      return "Error insertProyecto: $e";
    }
  }

  // ============================================
  // INSERTAR PROYECTOS MASIVOS (SYNC TOTAL)
  // ============================================
  static Future<String> insertProyectosMasivos(
    List<Proyecto> proyectos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        // 🔥 sync full
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
      print('Error insertProyectosMasivos: $e');
      return "Error insertProyectosMasivos: $e";
    }
  }

  // ============================================
  // LISTAR PROYECTOS
  // ============================================
  static Future<List<Proyecto>> listarProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      final maps = await db.query('Proyectos');
      return maps.map((e) => Proyecto.fromMap(e)).toList();
    } catch (e) {
      print('Error listarProyectos: $e');
      return [];
    }
  }

  // ============================================
  // OBTENER PROYECTO POR ID_PROJECT
  // ============================================
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
      print('Error getProyectoByIdProject: $e');
      return null;
    }
  }

  // ============================================
  // ELIMINAR PROYECTO POR ID_PROJECT
  // ============================================
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
      print('Error deleteProyectoByIdProject: $e');
      return "Error deleteProyectoByIdProject: $e";
    }
  }

  // ============================================
  // EXISTE PROYECTO
  // ============================================
  static Future<bool> existeProyecto(String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return false;

      final result = await db.query(
        'Proyectos',
        where: 'idProyecto = ?', // ⚠️ Sin guion bajo
        whereArgs: [idProject],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Error existeProyecto: $e');
      return false;
    }
  }

  // ============================================
  // ACTUALIZAR PROYECTO
  // ============================================
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
      print('Error updateProyecto: $e');
      return "Error updateProyecto: $e";
    }
  }

  // ============================================
  // CONTAR PROYECTOS
  // ============================================
  static Future<int> contarProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return 0;

      final result = await db.rawQuery('SELECT COUNT(*) FROM Proyectos');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error contarProyectos: $e');
      return 0;
    }
  }

  // ============================================
  // ELIMINAR TODOS LOS PROYECTOS
  // ============================================
  static Future<String> deleteAllProyectos() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.delete('Proyectos');
      return "Proyectos eliminados";
    } catch (e) {
      print('Error deleteAllProyectos: $e');
      return "Error deleteAllProyectos: $e";
    }
  }

  // ============================================
  // DROP TABLE (DEV ONLY)
  // ============================================
  static Future<String> dropProyectosTable() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.execute('DROP TABLE IF EXISTS Proyectos');
      return "Tabla Proyectos eliminada";
    } catch (e) {
      print('Error dropProyectosTable: $e');
      return "Error dropProyectosTable: $e";
    }
  }

  // ============================================
// INSERTAR PROYECTOS INCREMENTALES
// ============================================
  static Future<String> insertProyectosIncrementales(
    List<Proyecto> proyectos,
  ) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      int nuevos = 0;
      int ignorados = 0;

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
          ignorados++;
        }
      }

      return "✅ $nuevos nuevos | $ignorados ya existían";
    } catch (e) {
      print('Error insertProyectosIncrementales: $e');
      return "Error: $e";
    }
  }

  // ============================================
  // CALCULAR Y ACTUALIZAR PROGRESS DE PROYECTO
  // ============================================
  // Esta función calcula el progreso basándose en:
  // progress = (controles completados / total controles) * 100
  // Recorre: Proyecto -> Objetivos -> Controles
  static Future<double> calcularYActualizarProgressProyecto(
      String idProject) async {
    try {
      final db = await DBHelper.db;
      if (db == null) {
        print('❌ DB no disponible');
        return 0.0;
      }

      // PASO 1: Obtener todos los objetivos de este proyecto
      final objetivosResult = await db.query(
        'Objetivos',
        where: 'project_id = ?',
        whereArgs: [idProject],
      );

      if (objetivosResult.isEmpty) {
        print('⚠️ No hay objetivos para el proyecto $idProject');
        return 0.0;
      }

      // PASO 2: Extraer los IDs de los objetivos
      final idsObjetivos =
          objetivosResult.map((obj) => obj['id_objetivo'] as String).toList();

      print('📊 Proyecto $idProject tiene ${idsObjetivos.length} objetivos');

      // PASO 3: Contar TODOS los controles y los completados
      int totalControles = 0;
      int controlesCompletados = 0;

      for (String idObjetivo in idsObjetivos) {
        final controlesResult = await db.query(
          'Controles',
          where: 'objective_id = ? AND status = 1',
          whereArgs: [idObjetivo],
        );

        totalControles += controlesResult.length;

        // Contar los completados (completed = 1)
        controlesCompletados += controlesResult
            .where((control) => control['completed'] == 1)
            .length;
      }

      print('📊 Total controles: $totalControles');
      print('📊 Controles completados: $controlesCompletados');

      // PASO 4: Calcular el progreso
      double progress = 0.0;
      if (totalControles > 0) {
        progress = (controlesCompletados / totalControles) * 100.0;
      }

      print('📊 Progress calculado: $progress%');

      // PASO 5: Actualizar el campo progress en la tabla Proyectos
      await db.update(
        'Proyectos',
        {'progress': progress},
        where: 'idProyecto = ?',
        whereArgs: [idProject],
      );

      print('✅ Progress actualizado en DB: $progress%');

      return progress;
    } catch (e) {
      print('❌ Error al calcular progress: $e');
      return 0.0;
    }
  }
}
