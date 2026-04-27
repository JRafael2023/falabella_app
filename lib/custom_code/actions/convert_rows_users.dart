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

Future<List<dynamic>> convertRowsUsers(List<UsersRow> rowsUsers) async {
  try {
    final List<Map<String, dynamic>> usuarios = rowsUsers.map((row) {
      return {
        'user_uid': row.userUid ?? '',
        'email': row.email ?? '',
        'display_name': row.displayName ?? '',
        'country': row.country ?? '',
        'role': row.role ?? '',
        'created_at': row.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': row.updatedAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': row.status ?? true,
      };
    }).toList();


    return usuarios;
  } catch (e) {
    return [];
  }
}
