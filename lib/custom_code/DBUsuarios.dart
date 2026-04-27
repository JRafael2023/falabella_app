import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tottus/custom_code/Usuario.dart';

class DBUsuarios {
  // ============================================
  // INSERTAR USUARIO
  // ============================================
  static Future<String> insertUsuario(Usuario usuario) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.insert(
        'Users',
        usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return "Usuario insertado correctamente";
    } catch (e) {
      return "Error insertUsuario: $e";
    }
  }

  // ============================================
  // INSERTAR USUARIOS MASIVOS
  // ============================================
  static Future<String> insertUsuariosMasivos(List<Usuario> usuarios) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        for (final usuario in usuarios) {
          // Buscar si ya existe por email (más confiable que user_uid que puede duplicarse)
          final existing = await txn.query(
            'Users',
            where: 'email = ?',
            whereArgs: [usuario.email],
            limit: 1,
          );

          final data = usuario.toMap();

          if (existing.isNotEmpty) {
            // Actualizar registro existente por email
            await txn.update(
              'Users',
              data,
              where: 'email = ?',
              whereArgs: [usuario.email],
            );
          } else {
            // Insertar nuevo, ignorar conflicto de user_uid duplicado
            await txn.insert(
              'Users',
              data,
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }
      });

      return "Usuarios insertados correctamente";
    } catch (e) {
      return "Error insertUsuariosMasivos: $e";
    }
  }

  // ============================================
  // LISTAR USUARIOS
  // ============================================
  static Future<List<Usuario>> listarUsuarios() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      // ✅ Excluir usuarios marcados como pendientes de eliminar
      final maps = await db.query(
        'Users',
        where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL',
      );
      return maps.map((e) => Usuario.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================
  // MARCAR USUARIO COMO PENDIENTE DE ELIMINAR (offline)
  // ============================================
  static Future<String> marcarPendienteEliminar(String userUid) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.update(
        'Users',
        {'pendienteEliminar': 1},
        where: 'user_uid = ?',
        whereArgs: [userUid],
      );

      return rows > 0 ? "Marcado para eliminar" : "Usuario no encontrado";
    } catch (e) {
      return "Error: $e";
    }
  }

  // ============================================
  // OBTENER USUARIO POR USER_UID
  // ============================================
  static Future<Usuario?> getUsuarioByUserUid(String userUid) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return null;

      final maps = await db.query(
        'Users',
        where: 'user_uid = ?',
        whereArgs: [userUid],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Usuario.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // OBTENER USUARIO POR EMAIL
  // ============================================
  static Future<Usuario?> getUsuarioByEmail(String email) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return null;

      // Buscar por email exacto
      final maps = await db.query(
        'Users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Usuario.fromMap(maps.first);
      }

      // Si no encontró por email, buscar ignorando mayúsculas/minúsculas
      final mapsLower = await db.query(
        'Users',
        where: 'LOWER(email) = ?',
        whereArgs: [email.toLowerCase()],
        limit: 1,
      );

      if (mapsLower.isNotEmpty) {
        return Usuario.fromMap(mapsLower.first);
      }

      // Listar todos para debug
      final allUsers = await db.query('Users');
      for (var u in allUsers) {
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // ACTUALIZAR USUARIO
  // ============================================
  static Future<String> updateUsuario(Usuario usuario) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.update(
        'Users',
        usuario.toMap(),
        where: 'user_uid = ?',
        whereArgs: [usuario.userUid],
      );

      return rows > 0 ? "Usuario actualizado" : "Usuario no encontrado";
    } catch (e) {
      return "Error updateUsuario: $e";
    }
  }

  // ============================================
  // ELIMINAR USUARIO POR USER_UID
  // ============================================
  static Future<String> deleteUsuarioByUserUid(String userUid) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      final rows = await db.delete(
        'Users',
        where: 'user_uid = ?',
        whereArgs: [userUid],
      );

      return rows > 0 ? "Usuario eliminado" : "Usuario no encontrado";
    } catch (e) {
      return "Error deleteUsuarioByUserUid: $e";
    }
  }

  // ============================================
  // EXISTE USUARIO
  // ============================================
  static Future<bool> existeUsuario(String userUid) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return false;

      final result = await db.query(
        'Users',
        where: 'user_uid = ?',
        whereArgs: [userUid],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ============================================
  // CONTAR USUARIOS
  // ============================================
  static Future<int> contarUsuarios() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return 0;

      final result = await db.rawQuery('SELECT COUNT(*) FROM Users');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ============================================
  // ELIMINAR TODOS LOS USUARIOS
  // ============================================
  static Future<String> deleteAllUsuarios() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.delete('Users');
      return "Usuarios eliminados";
    } catch (e) {
      return "Error deleteAllUsuarios: $e";
    }
  }
}
