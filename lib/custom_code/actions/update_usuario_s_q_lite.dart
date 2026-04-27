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

Future<String> updateUsuarioSQLite(
  String userUid,
  String email,
  String displayName,
  String? photoUrl,
  String? phoneNumber,
  String? country,
  String? role,
  bool status,
) async {
  try {
    // Crear objeto Usuario con los datos actualizados
    final usuario = Usuario(
      userUid: userUid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      country: country,
      role: role,
      updatedAt: DateTime.now().toIso8601String(),
      status: status,
    );

    // ✅ Usar la función de DBUsuarios
    final resultado = await DBUsuarios.updateUsuario(usuario);

    return resultado;
  } catch (e) {
    return "❌ Error al actualizar usuario: $e";
  }
}
