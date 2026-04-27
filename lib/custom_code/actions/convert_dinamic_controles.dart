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

Future<List<dynamic>> convertDinamicControles(
  List<dynamic> json,
  String? idObjetive,
) async {
  final fecha = DateTime.now().toIso8601String();

  return json.map((item) {
    return {
      'idControl': item['id']?.toString() ?? '',
      'titulo': item['attributes']?['title'] ?? '',
      'description': item['attributes']?['description'] ?? '',
      'idWalkthrough':
          item['relationships']?['walkthrough']?['data']?['id']?.toString() ??
              '',
      'idObjetivo': idObjetive ?? '',
      'createdAt': fecha,
      'updatedAt': fecha,

      'estadoControl': '', // "efectivo" | "inefectivo" | ""
      'notasObservaciones': '', // Texto del textarea
      'completado': false, // true cuando se guarda exitosamente
      'listfotos': '', // Lista de URLs de fotos
      'video': '', // URL del video
    };
  }).toList();
}
