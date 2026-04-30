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

Future<String?> openArchive(FFUploadedFile? archive) async {
  if (archive == null || archive.bytes == null) {
    return 'Archivo vacío o no disponible';
  }

  try {
    if (kIsWeb) {
      final mimeType = _getMimeType(archive.name ?? '');
      final base64Data = base64Encode(archive.bytes!);
      final dataUrl = 'data:$mimeType;base64,$base64Data';
      await launchURL(dataUrl);
      return null;
    }

    final dir = await getTemporaryDirectory();
    final fileName =
        archive.name ?? 'archivo_${DateTime.now().millisecondsSinceEpoch}';
    final filePath = '${dir.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(archive.bytes!);

    final result = await OpenFile.open(filePath);

    if (result.type == ResultType.done) {
      return null;
    } else {
      return 'No se encontró una app para abrir este tipo de archivo';
    }
  } catch (e) {
    return 'Error al abrir el archivo: $e';
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
