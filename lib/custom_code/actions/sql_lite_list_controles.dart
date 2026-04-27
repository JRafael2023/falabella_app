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
import 'package:tottus/custom_code/DBControles.dart';
import 'package:tottus/custom_code/Control.dart';
import '../sqlite_helper.dart';

Future<List<dynamic>> sqlLiteListControles(String idObjetivo) async {
  final result = await DBControles.listarControlesJson(idObjetivo);

  return result;
}
