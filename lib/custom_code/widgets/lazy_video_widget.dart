// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:visibility_detector/visibility_detector.dart';
import 'getvideo_custom_widget.dart';

/// Widget optimizado que solo carga el video cuando es visible en pantalla
/// Esto reduce el uso de memoria al no cargar todos los videos simultáneamente
class LazyVideoWidget extends StatefulWidget {
  const LazyVideoWidget({
    super.key,
    this.width,
    this.height,
    required this.ffupload,
    required this.videoIndex,
  });

  final double? width;
  final double? height;
  final FFUploadedFile? ffupload;
  final int videoIndex; // Índice único para cada video

  @override
  State<LazyVideoWidget> createState() => _LazyVideoWidgetState();
}

class _LazyVideoWidgetState extends State<LazyVideoWidget> {
  bool _isVisible = false;
  bool _hasBeenLoaded = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.videoIndex}'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;

        // Solo cargar el video si es visible al menos en un 30%
        if (visiblePercentage > 30 && !_hasBeenLoaded) {
          setState(() {
            _isVisible = true;
            _hasBeenLoaded = true; // Una vez cargado, no volver a cargar
          });
        }
      },
      child: Container(
        width: widget.width ?? 300,
        height: widget.height ?? 300,
        color: Colors.black,
        child: _isVisible
            ? GetvideoCustomWidget(
                width: widget.width,
                height: widget.height,
                ffupload: widget.ffupload,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 80,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Desplázate para cargar el video',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
