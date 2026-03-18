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

Future<List<dynamic>> convertDinamicProyectos(List<dynamic> json) async {
  // Add your function code here!
  //
  return json.map((item) {
    return {
      'idProyecto': item['id']?.toString() ?? '',
      'name': item['attributes']?['name'] ?? '',
      'description': item['attributes']?['description'] ?? '',
      'state_Proyecto': item['attributes']?['state'] ?? '',
      'status_Proyecto': item['attributes']?['status'] ?? '',
      'opinion': item['attributes']?['opinion'] ?? '',
      'progress': item['attributes']?['progress'] ?? 0,
    };
  }).toList();
}
