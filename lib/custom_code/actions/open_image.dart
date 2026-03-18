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
import 'dart:io';
import 'package:image/image.dart' as img; // Usar el paquete image
import 'package:file_picker/file_picker.dart'; // Para FilePicker

Future<FFUploadedFile?> openImage() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    withData: true,
  );

  if (result == null) {
    print("❌ No se seleccionó ningún archivo");
    return null;
  }
  final file = result.files.first;
  final String? extension = file.extension?.toLowerCase();
  final filePath = file.path;
  print("✅ Ruta completa del archivo: $filePath");
  print("LOS BYESxxxxx SON ${file.bytes}");
  print(file?.bytes); //null

  print("Nombre del archivo: ${file.name}");
  print("Tamaño del archivo: ${file.size} bytes");
  print("IDENTIFIE: ${file.identifier} ");
  print("Extensión del archivo: ${file.extension}");
  print("Ruta del archivo: ${file.path}");
  print("Bytes del archivo: ${file.bytes?.length}");

  if (file.bytes == null) {
    print("⚠️ No se pudieron obtener los bytes del archivo.");
    return null;
  }

  // Declarar height y width como double?
  double? width, height;

  // Obtener las dimensiones de la imagen si es posible
  if (filePath != null) {
    try {
      final image = img.decodeImage(File(filePath).readAsBytesSync());
      if (image != null) {
        width = image.width.toDouble(); // Convertir a double
        height = image.height.toDouble(); // Convertir a double
      }
    } catch (e) {
      print("⚠️ Error al obtener las dimensiones de la imagen: $e");
    }
  }
  print("AJUASTADOOOOOOOOOOOOOOOOOOOO");
  print(file?.name);
  print(height); //null
  print(file?.name);
  print(width); //null
  print("AJUASTADOOOOOOOOOOOOOOOOOOOO");

  // Crear FFUploadedFile con double? para height y width
  final ffFile = FFUploadedFile(
    name: file.name,
    bytes: file.bytes,
    height: height, // Ahora es un double?
    width: width, // Ahora es un double?
    originalFilename: file.name, // Usar el nombre original si lo necesitas
  );
  print("Comparamos  ${ffFile.name}");
  print("Comparamos  ${file?.name}");
  return ffFile;
}
