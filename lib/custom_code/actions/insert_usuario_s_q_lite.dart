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

Future<String> insertUsuarioSQLite(
  String email,
  String? displayName,
  String userUid,
  String? country,
  String? role, {
  // ✅ Contraseña temporal para sincronizar usuarios creados offline
  String? passwordTemp,
}) async {
  try {
    // ✅ Si se pasa passwordTemp → el usuario fue creado OFFLINE → sincronizadoNube = 0
    // Si no hay password → fue creado online con Auth exitoso → sincronizadoNube = 1
    final int sincronizado = (passwordTemp != null && passwordTemp.isNotEmpty) ? 0 : 1;

    final usuario = Usuario(
      userUid: userUid,
      email: email,
      displayName: displayName,
      country: country,
      role: role,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      status: true,
      sincronizadoNube: sincronizado,
      passwordTemp: passwordTemp,
    );

    final resultado = await DBUsuarios.insertUsuario(usuario);

    return resultado;
  } catch (e) {
    print('❌ Error insertUsuarioSQLite: $e');
    return "❌ Error al insertar usuario: $e";
  }
}
