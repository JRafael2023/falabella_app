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

import 'package:tottus/custom_code/DBGerencia.dart';
import 'package:tottus/custom_code/sqlite_helper.dart';

/// Obtener todas las gerencias desde Supabase
Future<List<GerenciaStruct>> getGerenciasFromSupabase() async {
  try {
    print('📥 Consultando gerencias desde Supabase...');
    final response = await SupaFlow.client
        .from('Managements')
        .select()
        .eq('status', true)
        .order('created_at', ascending: false);

    if (response == null) {
      print('⚠️ No hay gerencias en Supabase');
      return [];
    }

    print('📊 Respuesta de Supabase: ${response.length} registros');

    final List<GerenciaStruct> gerencias = [];

    for (var item in (response as List)) {
      try {
        print('🔄 Procesando: ${item['name']} - ID: ${item['id']}');
        final gerencia = GerenciaStruct(
          id: item['id'] as String?,
          idGerencia: (item['management_id'] as String?) ?? (item['id'] as String?),
          nombre: item['name'] as String?,
          createdAt: item['created_at'] != null
              ? DateTime.parse(item['created_at'])
              : DateTime.now(),
          updateAt: item['updated_at'] != null
              ? DateTime.parse(item['updated_at'])
              : null,
          estado: item['status'] as bool? ?? true,
        );
        gerencias.add(gerencia);
      } catch (e) {
        print('❌ Error procesando item: ${item['name']} - Error: $e');
      }
    }

    print(
        '✅ ${gerencias.length} gerencias obtenidas exitosamente desde Supabase');
    return gerencias;
  } catch (e) {
    print('❌ Error al obtener gerencias desde Supabase: $e');
    return [];
  }
}
