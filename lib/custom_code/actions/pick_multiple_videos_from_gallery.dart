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

Future<List<FFUploadedFile>> pickMultipleVideosFromGallery() async {
  try {
    final ImagePicker picker = ImagePicker();

    final List<XFile> videos = await picker.pickMultipleMedia(
      imageQuality: 100,
    );

    if (videos.isEmpty) {
      return [];
    }

    List<FFUploadedFile> uploadedFiles = [];

    for (var video in videos) {
      if (video.path.toLowerCase().endsWith('.mp4') ||
          video.path.toLowerCase().endsWith('.mov') ||
          video.path.toLowerCase().endsWith('.avi') ||
          video.path.toLowerCase().endsWith('.mkv') ||
          video.path.toLowerCase().endsWith('.m4v')) {
        final bytes = await video.readAsBytes();

        uploadedFiles.add(FFUploadedFile(
          name: video.name,
          bytes: bytes,
        ));
      }
    }

    return uploadedFiles;
  } catch (e) {
    return [];
  }
}
