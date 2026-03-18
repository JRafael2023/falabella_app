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

Future<FFUploadedFile?> openVideoMp4() async {
  // Limite máximo de tamaño de archivo (en bytes) 100MB
  //
  print("Emrtpalmetod;");
  const maxSize = 100 * 1024 * 1024; // 100 MB en bytes

  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom, // Cambia el tipo a "custom"
    allowedExtensions: ['mp4'], // Solo permite archivos .mp4
    withData: true, // MUY IMPORTANTE para obtener los bytes
  );

  if (result == null) {
    print("❌ No se seleccionó ningún archivo");
    return null;
  }

  final file = result.files.first;
  final String? extension = file.extension?.toLowerCase();
  print("LOS BYES SON ${file.bytes}");
  // ✅ Validar que sea video .mp4
  if (extension == null || extension != 'mp4') {
    print("⚠️ Archivo no permitido: $extension");
    return null;
  }

  // Verificar el tamaño del archivo
  final int fileSize = file.bytes!.lengthInBytes; // Tamaño del archivo en bytes
  if (fileSize > maxSize) {
    print(
        "⚠️ El archivo es demasiado grande. Tamaño: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB");
    return null; // Retorna null si el archivo excede el límite de tamaño
  }

  print("✅ Archivo válido: ${file.name}");
  print("🎥 Extensión: $extension");
  print("📏 Tamaño: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB");

  // Convertir a bytes si lo vas a subir
  final Uint8List bytes = file.bytes!;

  print("✅ Ruta completa del archivo: ${file.path}");
  final ffFile = FFUploadedFile(
    name: file.name,
    originalFilename: file.name,
    bytes: bytes,
    height: null, // No disponible en videos
    width: null, // No disponible en videos
    blurHash: null, // No existe para videos
  );

  return ffFile; // Aquí puedes agregar tu lógica para subir el video a donde lo necesites
  // await subirVideoASupabase(bytes, file.name!); // Ejemplo de cómo podrías subirlo
}
