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

import '/custom_code/DBControles.dart';
import '/custom_code/DBControlAttachments.dart';

Future<dynamic> obtenerControlCompleto(String idControl) async {
  final resultado = await DBControles.obtenerControlCompleto(idControl);
  if (resultado == null) return null;

  // Si no hay fotos locales, buscar en Supabase y guardar en SQLite
  final photosVacias = (resultado['photos'] as String?)?.isEmpty ?? true;
  final videoVacio = (resultado['video'] as String?)?.isEmpty ?? true;
  final archivesVacios = (resultado['archives'] as String?)?.isEmpty ?? true;

  if (photosVacias || videoVacio || archivesVacios) {
    try {
      final supabase = SupaFlow.client;
      final rows = await supabase
          .from('Controls')
          .select('photos, video, archives')
          .eq('id_control', idControl)
          .limit(1);

      if (rows.isNotEmpty) {
        final row = rows.first;
        String photos = resultado['photos'] as String? ?? '';
        String video = resultado['video'] as String? ?? '';
        String archives = resultado['archives'] as String? ?? '';

        if (photosVacias && row['photos'] != null) {
          final gzip = convertirJSONaFormatoSQLite(row['photos']);
          if (gzip != null && gzip.isNotEmpty) {
            await DBControlAttachments.guardarPhotos(idControl, gzip.split('|||'));
            photos = gzip;
          }
        }
        if (videoVacio && row['video'] != null) {
          final gzip = convertirJSONaFormatoSQLite(row['video']);
          if (gzip != null && gzip.isNotEmpty) {
            await DBControlAttachments.guardarVideos(idControl, gzip.split('|||'));
            video = gzip;
          }
        }
        if (archivesVacios && row['archives'] != null) {
          final gzip = convertirJSONaFormatoSQLite(row['archives']);
          if (gzip != null && gzip.isNotEmpty) {
            await DBControlAttachments.guardarArchives(idControl, gzip.split('|||'));
            archives = gzip;
          }
        }

        return {
          ...resultado,
          'photos': photos,
          'video': video,
          'archives': archives,
        };
      }
    } catch (_) {}
  }

  return resultado;
}
