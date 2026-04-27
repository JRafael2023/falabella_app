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

import 'dart:typed_data'; // Para el tipo Uint8List
import 'package:file_picker/file_picker.dart'; // Para FilePicker

Future<List<FFUploadedFile>?> openImageList() async {
  // Add your function code here!
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    allowMultiple: true, // Permitir seleccionar varios archivos
    withData: true,
  );

  if (result == null || result.files.isEmpty) {
    return []; // Retornar lista vacía en lugar de null
  }

  List<FFUploadedFile> uploadedFiles =
      []; // Lista para almacenar los archivos válidos
  List<String> invalidFiles =
      []; // Lista para almacenar los nombres de archivos no válidos

  // Iterar sobre los archivos seleccionados
  for (var file in result.files) {
    final String? extension =
        file.extension?.toLowerCase(); // ✅ Validar que sea imagen

    if (extension == null ||
        !['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      invalidFiles.add(file.name); // Agregar archivo no válido a la lista
      continue; // Saltar al siguiente archivo
    }


    final filePath = file.path;

    // Convertir a bytes si lo vas a subir
    final Uint8List bytes = file.bytes!;

    // Crear FFUploadedFile para cada archivo válido
    final ffFile = FFUploadedFile(
      name: file.name,
      bytes: bytes,

      originalFilename: file.name,

      height: null, // No disponible en videos
      width: null, // No disponible en videos
      blurHash: null, // No existe para videos
    );

    // Agregar el archivo a la lista de archivos subidos
    uploadedFiles.add(ffFile);
  }

  // Verificar si hay archivos no válidos
  if (invalidFiles.isNotEmpty) {
    invalidFiles.forEach((fileName) {
    });
  }

  // Verificar si se subieron archivos válidos
  if (uploadedFiles.isEmpty) {
    return []; // Si no hay archivos válidos, retornar lista vacía
  }


  return uploadedFiles; // Devolver la lista de archivos válidos
}
