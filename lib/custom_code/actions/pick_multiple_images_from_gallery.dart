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

import 'package:image_picker/image_picker.dart';

Future<List<FFUploadedFile>> pickMultipleImagesFromGallery() async {
  try {
    final ImagePicker picker = ImagePicker();

    // Seleccionar múltiples imágenes de la galería
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 100,
    );

    if (images.isEmpty) {
      return [];
    }

    // Convertir XFile a FFUploadedFile
    List<FFUploadedFile> uploadedFiles = [];

    for (var image in images) {
      final bytes = await image.readAsBytes();

      uploadedFiles.add(FFUploadedFile(
        name: image.name,
        bytes: bytes,
      ));
    }

    return uploadedFiles;
  } catch (e) {
    print('❌ Error al seleccionar imágenes: $e');
    return [];
  }
}
