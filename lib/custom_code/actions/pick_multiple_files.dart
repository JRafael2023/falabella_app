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

import 'package:file_picker/file_picker.dart';

Future<List<FFUploadedFile>> pickMultipleFiles() async {
  try {
    // Seleccionar múltiples archivos
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) {
      return [];
    }

    // Convertir a FFUploadedFile
    List<FFUploadedFile> uploadedFiles = [];

    for (var file in result.files) {
      if (file.bytes != null) {
        uploadedFiles.add(FFUploadedFile(
          name: file.name,
          bytes: file.bytes!,
        ));
      }
    }

    return uploadedFiles;
  } catch (e) {
    print('❌ Error al seleccionar archivos: $e');
    return [];
  }
}
