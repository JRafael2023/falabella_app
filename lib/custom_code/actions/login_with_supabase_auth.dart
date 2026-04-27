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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:async';

/// Inicia sesión con Supabase Auth usando email y contraseña
///
/// @param email: Correo electrónico del usuario
/// @param password: Contraseña del usuario
/// @return String: "OK" si el login es exitoso, o mensaje de error si falla
Future<String> loginWithSupabaseAuth(
  String email,
  String password,
) async {
  try {
    // Validar que los campos no estén vacíos
    if (email.trim().isEmpty) {
      return 'El correo electrónico es requerido';
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'El correo electrónico no tiene un formato válido';
    }

    if (password.trim().isEmpty) {
      return 'La contraseña es requerida';
    }

    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }


    // Intentar iniciar sesión con Supabase Auth
    final response = await SupaFlow.client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    if (response.user == null) {
      return 'Credenciales inválidas';
    }


    // Buscar el usuario en la tabla Users
    final userRows = await UsersTable().queryRows(
      queryFn: (q) => q.eqOrNull('email', email.trim()),
    );

    if (userRows.isEmpty) {
      return 'Usuario no encontrado en el sistema';
    }


    return 'OK';
  } on AuthException catch (e) {

    if (e.message.contains('Invalid login credentials')) {
      return 'El correo o la contraseña no son correctos. Verifica tus datos e intenta nuevamente';
    } else if (e.message.contains('Email not confirmed')) {
      return 'Por favor confirma tu correo electrónico';
    } else if (e.message.contains('Too many requests')) {
      return 'Demasiados intentos. Espera un momento';
    } else {
      return 'Error de autenticación: ${e.message}';
    }
  } on SocketException {
    return 'Sin conexión a internet. Verifica tu red e intenta nuevamente';
  } on TimeoutException {
    return 'La conexión tardó demasiado. Verifica tu red e intenta nuevamente';
  } catch (e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('socket') ||
        msg.contains('network') ||
        msg.contains('connection') ||
        msg.contains('timeout') ||
        msg.contains('host')) {
      return 'Sin conexión a internet. Verifica tu red e intenta nuevamente';
    }
    return 'Error al iniciar sesión. Intenta nuevamente';
  }
}
