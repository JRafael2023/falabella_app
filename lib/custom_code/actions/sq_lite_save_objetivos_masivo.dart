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

import '/custom_code/Objetivo.dart';
import '/custom_code/sqlite_helper.dart';

Future<String> sqLiteSaveObjetivosMasivo(dynamic jsonObjetivos) async {
  try {
    if (jsonObjetivos == null) {
      return 'Error: No se recibieron datos';
    }

    // Extraer array de objetivos
    List<dynamic> objetivosData;

    if (jsonObjetivos is Map<String, dynamic>) {
      if (jsonObjetivos.containsKey('data') &&
          jsonObjetivos['data'] is Map &&
          jsonObjetivos['data']['data'] is List) {
        objetivosData = jsonObjetivos['data']['data'];
      } else if (jsonObjetivos.containsKey('data') &&
          jsonObjetivos['data'] is List) {
        objetivosData = jsonObjetivos['data'];
      } else {
        return 'Error: Estructura JSON no válida';
      }
    } else if (jsonObjetivos is List) {
      objetivosData = jsonObjetivos;
    } else {
      return 'Error: Tipo de datos no soportado';
    }

    // Convertir a objetos Objetivo
    List<Objetivo> objetivos = objetivosData.map((item) {
      return Objetivo.fromHighBondJson(item);
    }).toList();

    final db = await DBHelper.db;

    int insertados = 0;
    int actualizados = 0;

    for (var objetivo in objetivos) {
      // ✅ VALIDAR SI EXISTE (evita duplicados)
      final existente = await db.query(
        'objetivos',
        where: 'id_objetivo = ?',
        whereArgs: [objetivo.idObjetivo],
      );

      if (existente.isEmpty) {
        // ✅ INSERTAR NUEVO (con sincronizadoNube = 1)
        await db.insert('objetivos', {
          ...objetivo.toMap(),
          'sincronizadoNube': 1, // Viene de la nube
          'sincronizadoLocal': 0, // No tiene cambios locales
        });
        insertados++;
      } else {
        // ✅ ACTUALIZAR SOLO SI NO TIENE CAMBIOS LOCALES
        final sincronizadoLocal = existente[0]['sincronizadoLocal'] as int;

        if (sincronizadoLocal == 0) {
          // No tiene cambios locales pendientes, actualizar
          await db.update(
            'objetivos',
            {
              ...objetivo.toMap(),
              'sincronizadoNube': 1,
              'sincronizadoLocal': 0,
            },
            where: 'id_objetivo = ?',
            whereArgs: [objetivo.idObjetivo],
          );
          actualizados++;
        } else {
          // Tiene cambios locales, NO sobrescribir
        }
      }
    }

    return 'Guardados: $insertados nuevos, $actualizados actualizados';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}
