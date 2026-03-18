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
import 'package:file_picker/file_picker.dart'; // Para FilePicker
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String?> openimagenCopyStorageExternal() async {
  // Abre el FilePicker para seleccionar un archivo de imagen
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'mp4'],
    withData: true, // Asegúrate de tener acceso a los bytes del archivo
  );

  if (result == null) {
    print("❌ No se seleccionó ningún archivo");
    return null;
  }

  final file = result.files.first;
  final String? extension = file.extension?.toLowerCase();
  final filePath = file.path;
  print("✅ Ruta completa del archivo: $filePath");
  print("FF UPLOAD");

  print("Nombre del archivo: ${file.name}");
  print("Tamaño del archivo: ${file.size} bytes");
  print("IDENTIFIE: ${file.identifier} ");
  print("Extensión del archivo: ${file.extension}");
  if (file.bytes == null) {
    print("⚠️ No se pudieron obtener los bytes del archivo.");
    return null;
  }
  String rutafinal = file.name.split(".")[0];
  print("lA RUTA FINALES  : ${rutafinal}");
  // Copiar la imagen a la carpeta externa
  final String? copiedPath =
      await copyImageToExternalFolder(file.bytes!, extension, rutafinal);

  if (copiedPath == null) {
    print("⚠️ No se pudo copiar la imagen.");
    return null;
  }

  print("Imagen copiada a: $copiedPath");

  return copiedPath;
}

Future<String?> copyImageToExternalFolder(
    Uint8List fileBytes, String? extension, String? rutafinal) async {
  // Obtener carpeta externa del sistema (esto es para el almacenamiento externo)
  final directoryExtern = await getExternalStorageDirectory();

  // Crear el directorio /fotos si no existe
  final fotosDir = Directory('${directoryExtern?.path}/fotos');
  if (!fotosDir.existsSync()) {
    fotosDir.createSync(
        recursive: true); // Crear el directorio /fotos si no existe
  }

  // Crear un nombre único para el archivo copiado
  final newFilePath =
      '${fotosDir.path}/${DateTime.now().millisecondsSinceEpoch}-${rutafinal}.$extension';

  try {
    // Escribir los bytes en el nuevo archivo
    final newImage = await File(newFilePath).writeAsBytes(fileBytes);

    return newImage.path; // Devolver la nueva ruta de la imagen copiada
  } catch (e) {
    print("Error al copiar la imagen: $e");
    return null;
  }
}
