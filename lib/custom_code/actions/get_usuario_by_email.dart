// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'package:tottus/custom_code/DBUsuarios.dart';
import 'package:tottus/custom_code/Usuario.dart';

Future<dynamic> getUsuarioByEmail(String email) async {
  try {
    if (email.isEmpty) {
      return null;
    }

    print('🔍 Buscando usuario: $email');

    // 1️⃣ Primero buscar en jsonUsers del AppState (funciona offline sin BD)
    final jsonUsers = FFAppState().jsonUsers;
    if (jsonUsers.isNotEmpty) {
      final emailLower = email.toLowerCase();
      final found = jsonUsers.firstWhere(
        (u) {
          final uEmail = (u['email'] ?? u['Email'] ?? '').toString().toLowerCase();
          return uEmail == emailLower;
        },
        orElse: () => null,
      );
      if (found != null) {
        print('✅ Usuario encontrado en AppState: ${found['display_name'] ?? found['email']}');
        return found;
      }
    }

    // 2️⃣ Fallback: buscar en SQLite
    final usuario = await DBUsuarios.getUsuarioByEmail(email);

    if (usuario != null) {
      print('✅ Usuario encontrado en SQLite: ${usuario.displayName ?? usuario.email}');
      return usuario.toMap();
    } else {
      print('❌ Usuario no encontrado en AppState ni SQLite');
      return null;
    }
  } catch (e) {
    print('❌ Error: $e');
    return null;
  }
}
