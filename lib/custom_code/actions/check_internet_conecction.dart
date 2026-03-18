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

// check the  internet connection
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

// 📦 Caché del último resultado de conexión
DateTime? _ultimaVerificacion;
bool? _ultimoResultado;
const _duracionCache = Duration(seconds: 8); // ⚡ Caché reducido a 8s para detección más rápida

/// Invalida el caché de internet (usado por InternetCheckMixin al detectar cambio de red)
void invalidarCacheInternet() {
  _ultimaVerificacion = null;
  _ultimoResultado = null;
}

Future<bool> checkInternetConecction() async {
  try {
    // ⚡ OPTIMIZACIÓN 1: Usar caché si verificamos recientemente (8s)
    if (_ultimaVerificacion != null &&
        DateTime.now().difference(_ultimaVerificacion!) < _duracionCache) {
      return _ultimoResultado ?? true;
    }

    // ⚡ OPTIMIZACIÓN 2: Verificar conectividad básica primero (MUY rápido - 0.1s)
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Sin conexión WiFi o móvil - DEFINITIVAMENTE sin internet
      _ultimaVerificacion = DateTime.now();
      _ultimoResultado = false;
      return false;
    }

    // ⚡ WiFi/Datos activos → hacer DNS lookup para verificar acceso real a internet
    // (eliminado el bypass de 60s que ocultaba pérdida de internet con WiFi activo)
    final result = await InternetAddress.lookup('google.com')
        .timeout(Duration(seconds: 5));

    final tieneConexion =
        result.isNotEmpty && result[0].rawAddress.isNotEmpty;

    // Guardar en caché
    _ultimaVerificacion = DateTime.now();
    _ultimoResultado = tieneConexion;

    return tieneConexion;
  } catch (e) {
    // DNS falló → sin acceso real a internet (aunque WiFi esté conectado)
    _ultimaVerificacion = DateTime.now();
    _ultimoResultado = false;
    return false;
  }
}
