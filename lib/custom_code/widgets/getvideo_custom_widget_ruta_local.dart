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
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:video_player/video_player.dart';

class GetvideoCustomWidgetRutaLocal extends StatefulWidget {
  const GetvideoCustomWidgetRutaLocal({
    super.key,
    this.width,
    this.height,
    required this.videoPath, // Nueva propiedad para aceptar la ruta del video
  });

  final double? width;
  final double? height;
  final String videoPath; // Ruta del video como string

  @override
  State<GetvideoCustomWidgetRutaLocal> createState() =>
      _GetvideoCustomWidgetRutaLocalState();
}

class _GetvideoCustomWidgetRutaLocalState
    extends State<GetvideoCustomWidgetRutaLocal> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _currentPosition = 0.0;
  double _videoDuration = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Observamos cambios en el ciclo de vida
    _loadVideoFromFile(
        widget.videoPath); // Cargar el video desde la ruta proporcionada
  }

  Future<void> _loadVideoFromFile(String path) async {
    try {
      _controller = VideoPlayerController.file(File(path))
        ..initialize().then((_) {
          setState(() {
            _loading = false;
            _controller!.setLooping(true); // Looping activado

            _controller!.pause(); // Inicia en pausa, no automáticamente en play



          });
        });

      _controller!.addListener(() {
        final position = _controller!.value.position.inMilliseconds.toDouble();
        final duration = _controller!.value.duration.inMilliseconds.toDouble();
        setState(() {
          _currentPosition = position;
          _videoDuration = duration;
        });
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _seekForward() {
    final currentPosition = _controller!.value.position.inMilliseconds;
    final duration = _controller!.value.duration.inMilliseconds;
    final newPosition =
        (currentPosition + 10000).clamp(0, duration); // Avanza 10 segundos
    _controller!.seekTo(Duration(milliseconds: newPosition));
  }

  void _seekBackward() {
    final currentPosition = _controller!.value.position.inMilliseconds;
    final newPosition = (currentPosition - 10000)
        .clamp(0, _videoDuration.toInt()); // Retrocede 10 segundos
    _controller!.seekTo(Duration(milliseconds: newPosition));
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _controller!.setVolume(1.0); // Restauramos el volumen
        _isMuted = false;
      } else {
        _controller!.setVolume(0.0); // Silenciamos el video
        _isMuted = true;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause(); // Pausamos el video si la app pasa a segundo plano
    }
  }

  @override
  void dispose() {
    _controller?.pause(); // Aseguramos que el video se pause
    _controller
        ?.dispose(); // Liberamos el controlador para evitar fugas de memoria
    WidgetsBinding.instance
        .removeObserver(this); // Eliminamos el observador del ciclo de vida
    super.dispose(); // Llamamos al dispose() de la clase base
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 300,
      height: widget.height ?? 300,
      color: Colors.black,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _controller != null && _controller!.value.isInitialized
              ? Column(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                    VideoControls(
                      controller: _controller!,
                      isPlaying: _isPlaying,
                      isMuted: _isMuted,
                      onPlayPause: _togglePlayPause,
                      onSeekForward: _seekForward,
                      onSeekBackward: _seekBackward,
                      onMute: _toggleMute,
                      currentPosition: _currentPosition,
                      videoDuration: _videoDuration,
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No se pudo cargar el video",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
    );
  }
}

class VideoControls extends StatelessWidget {
  const VideoControls({
    super.key,
    required this.controller,
    required this.isPlaying,
    required this.isMuted,
    required this.onPlayPause,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onMute,
    required this.currentPosition,
    required this.videoDuration,
  });

  final VideoPlayerController controller;
  final bool isPlaying;
  final bool isMuted;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final VoidCallback onMute;
  final double currentPosition;
  final double videoDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: currentPosition,
          min: 0,
          max: videoDuration,
          onChanged: (value) {
            final newPosition = value.toInt();
            controller.seekTo(Duration(milliseconds: newPosition));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: onPlayPause,
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.replay_10, color: Colors.white),
              onPressed: onSeekBackward,
            ),
            IconButton(
              icon: const Icon(Icons.forward_10, color: Colors.white),
              onPressed: onSeekForward,
            ),
            IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: onMute,
            ),
          ],
        ),
      ],
    );
  }
}
