import 'sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tottus/custom_code/Usuario.dart';

class DBUsuarios {
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

  static Future<String> insertUsuariosMasivos(List<Usuario> usuarios) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return "Error: DB no disponible";

      await db.transaction((txn) async {
        for (final usuario in usuarios) {
          final existing = await txn.query(
            'Users',
            where: 'email = ?',
            whereArgs: [usuario.email],
            limit: 1,
          );

          final data = usuario.toMap();

          if (existing.isNotEmpty) {
            await txn.update(
              'Users',
              data,
              where: 'email = ?',
              whereArgs: [usuario.email],
            );
          } else {
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

  static Future<List<Usuario>> listarUsuarios() async {
    try {
      final db = await DBHelper.db;
      if (db == null) return [];

      final maps = await db.query(
        'Users',
        where: 'pendienteEliminar = 0 OR pendienteEliminar IS NULL',
      );
      return maps.map((e) => Usuario.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

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

  static Future<Usuario?> getUsuarioByEmail(String email) async {
    try {
      final db = await DBHelper.db;
      if (db == null) return null;

      final maps = await db.query(
        'Users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Usuario.fromMap(maps.first);
      }

      final mapsLower = await db.query(
        'Users',
        where: 'LOWER(email) = ?',
        whereArgs: [email.toLowerCase()],
        limit: 1,
      );

      if (mapsLower.isNotEmpty) {
        return Usuario.fromMap(mapsLower.first);
      }

      final allUsers = await db.query('Users');
      for (var u in allUsers) {
      }

      return null;
    } catch (e) {
      return null;
    }
  }

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
