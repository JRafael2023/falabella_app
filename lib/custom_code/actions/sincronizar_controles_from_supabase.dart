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

Future<String> sincronizarControlesFromSupabase(
  List<ControlsRow> controlesSupabase,
  String idObjetivo,
) async {
  try {
    if (controlesSupabase.isEmpty) {
      return 'No hay controles en Supabase';
    }


    int actualizados = 0;
    int sinCambios = 0;

    final controlesSQLite = await DBControles.listarControlesJson(idObjetivo);

    final Map<String, dynamic> mapaSQLite = {};
    for (var controlMap in controlesSQLite) {
      final idControl = controlMap['id_control'] ?? '';
      if (idControl.isNotEmpty) {
        mapaSQLite[idControl] = controlMap;
      }
    }

    for (var controlSupabase in controlesSupabase) {
      try {
        final idControl = controlSupabase.idControl ?? '';

        if (idControl.isEmpty) continue;

        if (mapaSQLite.containsKey(idControl)) {
          final controlSQLite = mapaSQLite[idControl];

          String? photosSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.photos);
          String? videoSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.video);
          String? archivesSupabaseConvertido = functions.convertirJSONaFormatoSQLite(controlSupabase.archives);

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
            final control = Control.fromMap(controlSQLite);

            String? limpiarNull(String? valor) {
              if (valor == null || valor == 'null' || valor.trim().isEmpty) {
                return null;
              }
              return valor;
            }

            bool localCompletado = control.completed == true;
            bool supabaseCompletado = controlSupabase.completed ?? false;

            if (supabaseCompletado || !localCompletado) {
              control.completed = supabaseCompletado;
            }

            final supabaseDescription = controlSupabase.description ?? '';
            if (supabaseDescription.isNotEmpty) {
              control.description = supabaseDescription;
            }

            if (supabaseCompletado && controlSupabase.findingStatus != null) {
              control.findingStatus = controlSupabase.findingStatus;
            } else if (!localCompletado) {
              control.findingStatus = controlSupabase.findingStatus;
            }
            if (photosSupabaseConvertido != null && photosSupabaseConvertido.isNotEmpty) {
              control.photos = photosSupabaseConvertido;
            } else if (control.photos == null || control.photos!.isEmpty) {
              control.photos = photosSupabaseConvertido; // null o vacío desde Supabase cuando local también vacío
            }
            if (videoSupabaseConvertido != null && videoSupabaseConvertido.isNotEmpty) {
              control.video = videoSupabaseConvertido;
            } else if (control.video == null || control.video!.isEmpty) {
              control.video = videoSupabaseConvertido;
            }
            if (archivesSupabaseConvertido != null && archivesSupabaseConvertido.isNotEmpty) {
              control.archives = archivesSupabaseConvertido;
            } else if (control.archives == null || control.archives!.isEmpty) {
              control.archives = archivesSupabaseConvertido;
            }
            void _actualizarSiTieneValor(String? supabaseValor, void Function(String?) setter, String? valorLocal) {
              final valorLimpio = limpiarNull(supabaseValor);
              if (valorLimpio != null && valorLimpio.isNotEmpty) {
                setter(valorLimpio);
              } else if (valorLocal == null || valorLocal.isEmpty) {
                setter(null);
              }
            }

            _actualizarSiTieneValor(controlSupabase.observacion, (v) => control.observacion = v, control.observacion);
            _actualizarSiTieneValor(controlSupabase.gerencia, (v) => control.gerencia = v, control.gerencia);
            _actualizarSiTieneValor(controlSupabase.ecosistema, (v) => control.ecosistema = v, control.ecosistema);
            _actualizarSiTieneValor(controlSupabase.fecha, (v) => control.fecha = v, control.fecha);
            _actualizarSiTieneValor(controlSupabase.descripcionHallazgo, (v) => control.descripcionHallazgo = v, control.descripcionHallazgo);
            _actualizarSiTieneValor(controlSupabase.recomendacion, (v) => control.recomendacion = v, control.recomendacion);
            _actualizarSiTieneValor(controlSupabase.procesoPropuesto, (v) => control.procesoPropuesto = v, control.procesoPropuesto);
            _actualizarSiTieneValor(controlSupabase.titulo, (v) => control.titulo = v, control.titulo);
            _actualizarSiTieneValor(controlSupabase.nivelRiesgo, (v) => control.nivelRiesgo = v, control.nivelRiesgo);
            _actualizarSiTieneValor(controlSupabase.controlText, (v) => control.controlText = v, control.controlText);
            control.updatedAt = DateTime.now().toIso8601String();

            await DBControles.updateControl(control);
            actualizados++;
          } else {
            sinCambios++;
          }
        }
      } catch (e) {
      }
    }


    if (actualizados > 0) {
      return 'Actualizados: $actualizados controles';
    } else {
      return 'Sin cambios';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
