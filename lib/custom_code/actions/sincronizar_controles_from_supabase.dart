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

import '/custom_code/Control.dart';
import '/custom_code/DBControles.dart';
import '/flutter_flow/custom_functions.dart' as functions;

/// Sincronizar controles DESDE Supabase HACIA SQLite
/// Actualiza SQLite con los datos más recientes de Supabase
Future<String> sincronizarControlesFromSupabase(
  List<ControlsRow> controlesSupabase,
  String idObjetivo,
) async {
  try {
    if (controlesSupabase.isEmpty) {
      return 'No hay controles en Supabase';
    }

    print('🔄 Sincronizando ${controlesSupabase.length} controles desde Supabase a SQLite...');

    int actualizados = 0;
    int sinCambios = 0;

    // Obtener controles actuales de SQLite
    final controlesSQLite = await DBControles.listarControlesJson(idObjetivo);

    // Crear mapa para búsqueda rápida
    final Map<String, dynamic> mapaSQLite = {};
    for (var controlMap in controlesSQLite) {
      final idControl = controlMap['id_control'] ?? '';
      if (idControl.isNotEmpty) {
        mapaSQLite[idControl] = controlMap;
      }
    }

    // Actualizar cada control en SQLite con datos de Supabase
    for (var controlSupabase in controlesSupabase) {
      try {
        final idControl = controlSupabase.idControl ?? '';

        if (idControl.isEmpty) continue;

        // Verificar si existe en SQLite
        if (mapaSQLite.containsKey(idControl)) {
          final controlSQLite = mapaSQLite[idControl];

          // ⚡ Convertir formato JSON de Supabase → SQLite antes de comparar
          String? photosSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.photos);
          String? videoSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.video);
          String? archivesSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.archives);

          // Comparar si hay diferencias
          bool hayDiferencias =
              controlSQLite['completed'] != (controlSupabase.completed == true ? 1 : 0) ||
              controlSQLite['description'] != (controlSupabase.description ?? '') ||
              controlSQLite['finding_status'] != controlSupabase.findingStatus ||
              controlSQLite['photos'] != photosSupabaseConvertido ||
              controlSQLite['video'] != videoSupabaseConvertido ||
              controlSQLite['archives'] != archivesSupabaseConvertido ||
              controlSQLite['observacion'] != controlSupabase.observacion ||
              controlSQLite['gerencia'] != controlSupabase.gerencia ||
              controlSQLite['ecosistema'] != controlSupabase.ecosistema ||
              controlSQLite['fecha'] != controlSupabase.fecha ||
              controlSQLite['descripcion_hallazgo'] != controlSupabase.descripcionHallazgo ||
              controlSQLite['recomendacion'] != controlSupabase.recomendacion ||
              controlSQLite['proceso_propuesto'] != controlSupabase.procesoPropuesto ||
              controlSQLite['titulo'] != controlSupabase.titulo ||
              controlSQLite['nivel_riesgo'] != controlSupabase.nivelRiesgo ||
              controlSQLite['control_text'] != controlSupabase.controlText;

          if (hayDiferencias) {
            // Actualizar en SQLite
            final control = Control.fromMap(controlSQLite);

            // 🔥 Función auxiliar para limpiar "null" como texto
            String? limpiarNull(String? valor) {
              if (valor == null || valor == 'null' || valor.trim().isEmpty) {
                return null;
              }
              return valor;
            }

            // Actualizar campos desde Supabase (con conversión de formato)
            control.completed = controlSupabase.completed ?? false;
            control.description = controlSupabase.description ?? '';
            control.findingStatus = controlSupabase.findingStatus;
            control.photos = photosSupabaseConvertido; // ✅ Ya convertido a formato SQLite
            control.video = videoSupabaseConvertido; // ✅ Ya convertido a formato SQLite
            control.archives = archivesSupabaseConvertido; // ✅ Ya convertido a formato SQLite
            control.observacion = limpiarNull(controlSupabase.observacion);
            control.gerencia = limpiarNull(controlSupabase.gerencia);
            control.ecosistema = limpiarNull(controlSupabase.ecosistema);
            control.fecha = limpiarNull(controlSupabase.fecha);
            control.descripcionHallazgo = limpiarNull(controlSupabase.descripcionHallazgo);
            control.recomendacion = limpiarNull(controlSupabase.recomendacion);
            control.procesoPropuesto = limpiarNull(controlSupabase.procesoPropuesto);
            control.titulo = limpiarNull(controlSupabase.titulo);
            control.nivelRiesgo = limpiarNull(controlSupabase.nivelRiesgo);
            control.controlText = limpiarNull(controlSupabase.controlText);
            control.updatedAt = DateTime.now().toIso8601String();

            // Guardar en SQLite
            await DBControles.updateControl(control);
            actualizados++;
          } else {
            sinCambios++;
          }
        }
      } catch (e) {
        print('⚠️ Error actualizando control ${controlSupabase.idControl}: $e');
      }
    }

    print('✅ Sincronización completada: $actualizados actualizados, $sinCambios sin cambios');

    if (actualizados > 0) {
      return 'Actualizados: $actualizados controles';
    } else {
      return 'Sin cambios';
    }
  } catch (e) {
    print('❌ Error en sincronización: $e');
    return 'Error: $e';
  }
}
