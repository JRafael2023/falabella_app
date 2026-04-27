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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:intl/intl.dart';
import 'package:tottus/custom_code/DBProyectos.dart';
import 'package:tottus/custom_code/DBUsuarios.dart';

Future<bool> sincronizarDatos(bool conectado) async {
  try {


    int totalMatrices = 0;
    int totalUsuarios = 0;

    try {
      List<dynamic> proyectosJson = await DBProyectos.listarProyectos();
      totalMatrices = proyectosJson.length;
    } catch (e) {
      totalMatrices = 0;
    }

    try {
      totalUsuarios = await DBUsuarios.contarUsuarios();
    } catch (e) {
      totalUsuarios = 0;
    }


    try {
      FFAppState().update(() {
        FFAppState().ultimaSincronizacion = DateTime.now();
        FFAppState().matricesCargadas = totalMatrices;
        FFAppState().usuariosRegistrados = totalUsuarios;
      });
    } catch (e) {
    }


    String estadoConexion = conectado ? '🌐 Activa' : '📴 Inactiva';
    String mensaje = '✅ Sincronización completada:\n'
        'Estado: $estadoConexion\n'
        '📊 Matrices: $totalMatrices\n'
        '👥 Usuarios: $totalUsuarios\n'
        '🕐 ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}';


    return conectado;
  } catch (e, stackTrace) {

    try {
      FFAppState().update(() {
        FFAppState().matricesCargadas = 0;
        FFAppState().usuariosRegistrados = 0;
      });
    } catch (e2) {
    }

    return false;
  }
}
