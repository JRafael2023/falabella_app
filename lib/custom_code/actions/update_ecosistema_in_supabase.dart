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

import 'package:tottus/custom_code/DBEcosistema.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

Future<bool> updateEcosistemaInSupabase(EcosistemaStruct ecosistema) async {
  try {
    final Map<String, dynamic> data = {
      'name': ecosistema.nombre,
      'status': ecosistema.estado ?? true,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await SupaFlow.client
        .from('Ecosystems')
        .update(data)
        .eq('id', ecosistema.idEcosistema!);

    return true;
  } catch (e) {
    return false;
  }
}
