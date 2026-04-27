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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

DateTime? _ultimaVerificacion;
bool? _ultimoResultado;
const _duracionCache = Duration(seconds: 8);

void invalidarCacheInternet() {
  _ultimaVerificacion = null;
  _ultimoResultado = null;
}

Future<bool> checkInternetConecction() async {
  try {
    if (_ultimaVerificacion != null &&
        DateTime.now().difference(_ultimaVerificacion!) < _duracionCache) {
      return _ultimoResultado ?? true;
    }

    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _ultimaVerificacion = DateTime.now();
      _ultimoResultado = false;
      return false;
    }

    final result = await InternetAddress.lookup('google.com')
        .timeout(Duration(seconds: 5));

    final tieneConexion =
        result.isNotEmpty && result[0].rawAddress.isNotEmpty;

    _ultimaVerificacion = DateTime.now();
    _ultimoResultado = tieneConexion;

    return tieneConexion;
  } catch (e) {
    _ultimaVerificacion = DateTime.now();
    _ultimoResultado = false;
    return false;
  }
}
