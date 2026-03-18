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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future openArchive(FFUploadedFile? archive) async {
  if (archive == null || archive.bytes == null) {
    print('❌ Archivo vacío o nulo');
    return;
  }

  try {
    // 🌐 WEB: Abrir directamente con data URL
    if (kIsWeb) {
      final mimeType = _getMimeType(archive.name ?? '');
      final base64Data = base64Encode(archive.bytes!);
      final dataUrl = 'data:$mimeType;base64,$base64Data';
      await launchURL(dataUrl);
      print('✅ Archivo abierto en WEB');
      return;
    }

    // 📱 MOBILE: Guardar el archivo temporalmente y abrirlo
    final dir = await getTemporaryDirectory();
    final fileName =
        archive.name ?? 'archivo_${DateTime.now().millisecondsSinceEpoch}';
    final filePath = '${dir.path}/$fileName';

    // Guardar bytes en archivo temporal
    final file = File(filePath);
    await file.writeAsBytes(archive.bytes!);
    print('📁 Archivo guardado en: $filePath');

    // Abrir el archivo con la app predeterminada
    final result = await OpenFile.open(filePath);

    if (result.type == ResultType.done) {
      print('✅ Archivo abierto correctamente');
    } else {
      print('⚠️ No se pudo abrir: ${result.message}');
    }
  } catch (e) {
    print('❌ Error al abrir archivo: $e');
  }
}

String _getMimeType(String name) {
  final extension = name.toLowerCase().split('.').last;

  switch (extension) {
    case 'pdf':
      return 'application/pdf';
    case 'txt':
      return 'text/plain';
    case 'doc':
    case 'docx':
      return 'application/msword';
    case 'xls':
    case 'xlsx':
      return 'application/vnd.ms-excel';
    default:
      return 'application/octet-stream';
  }
}
