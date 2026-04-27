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

import 'dart:io';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';

class GetvideoCustomWidget extends StatefulWidget {
  const GetvideoCustomWidget({
    super.key,
    this.width,
    this.height,
    required this.ffupload,
  });

  final double? width;
  final double? height;
  final FFUploadedFile? ffupload;

  @override
  State<GetvideoCustomWidget> createState() => _GetvideoCustomWidgetState();
}

class _GetvideoCustomWidgetState extends State<GetvideoCustomWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _currentPosition = 0.0;
  double _videoDuration = 1.0;
  File? _tempVideoFile; // Guardar referencia al archivo temporal para limpiarlo

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Observamos cambios en el ciclo de vida
    if (widget.ffupload?.bytes != null) {
      _loadVideoFromMemory(widget.ffupload!.bytes!);
    }
  }

  // Función para cargar el video desde los bytes
  Future<void> _loadVideoFromMemory(Uint8List bytes) async {
    try {
      // Generar nombre único para evitar conflictos entre múltiples videos
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ruta = '${Directory.systemTemp.path}/temp_video_$timestamp.mp4';
      final videoFile = File(ruta);

      await videoFile
          .writeAsBytes(bytes); // Guardamos el video en la memoria local
      _tempVideoFile = videoFile; // Guardar referencia para limpieza posterior
      _controller = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {
            _loading = false;
            _controller!.setLooping(true); // Looping activado

            // --- INICIO DE CAMBIO: HACER QUE EL VIDEO INICIE EN PAUSA ---
            // Este cambio asegura que el video se inicie en pausa en lugar de reproducirse automáticamente
            _controller!.pause(); // Inicia en pausa
            // --- FIN DE CAMBIO ---

            // --- INICIO DE CAMBIO: COMENTARIOS SOBRE AVANZAR 10 SEGUNDOS ---
            // Acciones de avanzar 10 segundos
            // _seekForward(); // Comentado por defecto. Puedes descomentar esta línea para probarlo.

            // --- FIN DE CAMBIO ---
          });
        });

      // Listener para actualizar la posición y duración del video
      // Optimizado: solo actualizar cada 500ms para reducir rebuilds
      _controller!.addListener(() {
        if (!mounted) return; // Evitar actualizar si el widget ya no existe

        final position = _controller!.value.position.inMilliseconds.toDouble();
        final duration = _controller!.value.duration.inMilliseconds.toDouble();

        // Solo actualizar si cambió significativamente (reducir rebuilds innecesarios)
        if ((position - _currentPosition).abs() > 500 || duration != _videoDuration) {
          if (mounted) {
            setState(() {
              _currentPosition = position;
              _videoDuration = duration;
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  // Función para pausar/reproducir el video
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

  // Función para avanzar el video (10 segundos)
  void _seekForward() {
    final currentPosition = _controller!.value.position.inMilliseconds;
    final duration = _controller!.value.duration.inMilliseconds;
    final newPosition =
        (currentPosition + 10000).clamp(0, duration); // Avanza 10 segundos
    _controller!.seekTo(Duration(milliseconds: newPosition));
  }

  // Función para retroceder el video (10 segundos)
  void _seekBackward() {
    final currentPosition = _controller!.value.position.inMilliseconds;
    final newPosition = (currentPosition - 10000)
        .clamp(0, _videoDuration.toInt()); // Retrocede 10 segundos
    _controller!.seekTo(Duration(milliseconds: newPosition));
  }

  // Función para cambiar el volumen
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

  // Detectamos cuando la aplicación cambia de estado
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

    // Limpiar archivo temporal
    _tempVideoFile?.delete().catchError((e) {
    });

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
                    // Video player
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                    // Controles de video
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
        // Barra de progreso
        Slider(
          value: currentPosition,
          min: 0,
          max: videoDuration,
          onChanged: (value) {
            // Buscamos a la nueva posición
            final newPosition = value.toInt();
            controller.seekTo(Duration(milliseconds: newPosition));
          },
        ),
        // Botones de control (Reproducir/Pausar, Adelantar, Retroceder, Silenciar)
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
