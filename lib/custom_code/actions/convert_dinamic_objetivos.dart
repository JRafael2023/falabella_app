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

Future<List<dynamic>> convertDinamicObjetivos(List<dynamic> json) async {
  final fecha = DateTime.now().toIso8601String();

  return json.map((item) {
    return {
      'idObjetivo': item['id']?.toString() ?? '',
      'title': item['attributes']?['title'] ?? '',
      'description': item['attributes']?['description'] ?? '',
      'reference': item['attributes']?['reference'] ?? '',
      'division_department': item['attributes']?['division_department'] ?? '',
      'owner': item['attributes']?['owner'] ?? '',
      'executive_owner': item['attributes']?['executive_owner'] ?? '',
      'position': item['attributes']?['position'] ?? '',
      'custom_attributes': item['attributes']?['custom_attributes'] ?? '',
      'idProyecto':
          item['relationships']?['project']?['data']?['id']?.toString() ?? '',
      'assignedUser':
          item['relationships']?['assigned_user']?['data']?['id']?.toString() ??
              '',
      'ownerUser':
          item['relationships']?['owner_user']?['data']?['id']?.toString() ??
              '',
      'executiveOwnerUser': item['relationships']?['executive_owner_user']
                  ?['data']?['id']
              ?.toString() ??
          '',
      'createdAt': fecha,
      'updatedAt': fecha,
    };
  }).toList();
}
