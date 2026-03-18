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

/// Registra un nuevo usuario en Supabase Auth
///
/// @param email: Correo electrónico del usuario
/// @param password: Contraseña del usuario
/// @return String: "OK" si el registro es exitoso, o mensaje de error si falla
Future<String> registerUserSupabaseAuth(
  String email,
  String password,
) async {
  try {
    // Validar que los campos no estén vacíos
    if (email.trim().isEmpty) {
      return 'El correo electrónico es requerido';
    }

    if (password.trim().isEmpty) {
      return 'La contraseña es requerida';
    }

    // Validar longitud mínima de contraseña (Supabase requiere mínimo 6 caracteres)
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    print('Intentando registrar usuario con email: $email');

    // Registrar usuario en Supabase Auth
    final response = await SupaFlow.client.auth.signUp(
      email: email.trim(),
      password: password,
    );

    if (response.user == null) {
      return 'Error al crear el usuario';
    }

    print(
        'Usuario registrado exitosamente en Supabase Auth. UID: ${response.user!.id}');

    return 'OK';
  } on AuthException catch (e) {
    print('Error de autenticación al registrar: ${e.message}');

    if (e.message.contains('User already registered')) {
      return 'El correo ya está registrado';
    } else if (e.message.contains('Invalid email')) {
      return 'Correo electrónico inválido';
    } else if (e.message.contains('Password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    } else {
      return 'Error de registro: ${e.message}';
    }
  } catch (e) {
    print('Error inesperado al registrar: $e');
    return 'Error al registrar usuario: $e';
  }
}
