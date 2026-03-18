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

import 'index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:tottus/custom_code/DBEcosistema.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

/// Obtener todos los ecosistemas desde Supabase
Future<List<EcosistemaStruct>> getEcosistemasFromSupabase() async {
  try {
    print('📥 Consultando ecosistemas desde Supabase...');
    final response = await SupaFlow.client
        .from('Ecosystems')
        .select()
        .eq('status', true)
        .order('created_at', ascending: false);

    if (response == null) {
      print('⚠️ No hay ecosistemas en Supabase');
      return [];
    }

    print('📊 Respuesta de Supabase: ${response.length} registros');

    final List<EcosistemaStruct> ecosistemas = [];

    for (var item in (response as List)) {
      try {
        print('🔄 Procesando: ${item['name']} - ID: ${item['id']}');
        final ecosistema = EcosistemaStruct(
          id: item['id'] as String?,
          idEcosistema: (item['ecosystem_id'] as String?) ?? (item['id'] as String?),
          nombre: item['name'] as String?,
          createdAt: item['created_at'] != null
              ? DateTime.parse(item['created_at'])
              : DateTime.now(),
          updateAt: item['updated_at'] != null
              ? DateTime.parse(item['updated_at'])
              : null,
          estado: item['status'] as bool? ?? true,
        );
        ecosistemas.add(ecosistema);
      } catch (e) {
        print('❌ Error procesando item: ${item['name']} - Error: $e');
      }
    }

    print(
        '✅ ${ecosistemas.length} ecosistemas obtenidos exitosamente desde Supabase');
    return ecosistemas;
  } catch (e) {
    print('❌ Error al obtener ecosistemas desde Supabase: $e');
    return [];
  }
}
