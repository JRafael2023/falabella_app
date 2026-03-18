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

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class WidgetWritexText extends StatefulWidget {
  const WidgetWritexText({
    super.key,
    this.width,
    this.height,
    required this.action,
    required this.state,
    this.textValue,
  });

  final double? width;
  final double? height;
  final Future Function(String txtdota2) action;
  final bool state;
  final String? textValue;

  @override
  State<WidgetWritexText> createState() => _WidgetWritexTextState();
}

class _WidgetWritexTextState extends State<WidgetWritexText> {
  // === MODO ONLINE (speech_to_text) ===
  late stt.SpeechToText _speech;
  bool _speechInitialized = false;
  String? _localeId;
  bool _userStoppedManually = false;
  bool _isSavingText = false;

  // === MODO OFFLINE (grabar → transcribir) ===
  static Model? _voskModel;           // static: se comparte entre instancias
  static bool _voskModelLoading = false;
  AudioRecorder? _recorder;           // graba a archivo WAV
  bool _isTranscribing = false;       // muestra "Transcribiendo..."

  // === ESTADO COMPARTIDO ===
  bool _isListening = false;
  bool _isOnline = true;
  String _finalText = '';
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _recorder = AudioRecorder();
    if (widget.textValue != null && widget.textValue!.isNotEmpty) {
      _finalText = widget.textValue!;
    }
    _initializeSpeech();
  }

  // ─── INICIALIZACIÓN ONLINE ────────────────────────────────────────────────

  Future<void> _initializeSpeech() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status.isDenied || status.isPermanentlyDenied) return;

      _speechInitialized = await _speech.initialize(
        onStatus: (status) {
          if ((status == 'done' || status == 'notListening') &&
              _isListening &&
              _isOnline) {
            if (!_userStoppedManually) _restartListening();
          }
        },
        onError: (error) {
          if (mounted) setState(() => _isListening = false);
          _showError(error.errorMsg);
        },
      );

      if (_speechInitialized) {
        final locales = await _speech.locales();
        final spanish = locales.firstWhere(
          (l) => l.localeId.toLowerCase().startsWith('es'),
          orElse: () =>
              locales.isNotEmpty ? locales.first : stt.LocaleName('', ''),
        );
        _localeId = spanish.localeId.isNotEmpty ? spanish.localeId : null;
      }
    } catch (e) {
      _speechInitialized = false;
    }
  }

  // ─── BOTÓN PRINCIPAL ──────────────────────────────────────────────────────

  Future<void> _listen() async {
    if (_isTranscribing) return; // No interrumpir mientras transcribe

    if (!_isListening) {
      _isSavingText = false;
      _userStoppedManually = false;

      final tieneInternet = await checkInternetConecction();
      _isOnline = tieneInternet;

      if (tieneInternet) {
        await _listenOnline();
      } else {
        await _listenOffline();
      }
    } else {
      if (_isOnline) {
        await _stopOnline();
      } else {
        await _stopOffline();
      }
    }
  }

  // ─── MODO ONLINE ──────────────────────────────────────────────────────────

  Future<void> _listenOnline() async {
    if (!_speechInitialized) await _initializeSpeech();
    if (!_speechInitialized) {
      _showPermissionError();
      return;
    }

    bool available = await _speech.isAvailable;
    if (!available) {
      _showPermissionError();
      return;
    }

    setState(() {
      _isListening = true;
      _currentText = '';
    });

    await _startListeningOnline();
  }

  Future<void> _startListeningOnline() async {
    if (!_isListening || _userStoppedManually) return;
    try {
      await _speech.listen(
        onResult: (result) {
          if (mounted) setState(() => _currentText = result.recognizedWords);
        },
        listenFor: const Duration(hours: 1),
        pauseFor: const Duration(seconds: 30),
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
        localeId: _localeId,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isListening = false);
        _showError('Error al iniciar grabación: $e');
      }
    }
  }

  Future<void> _stopOnline() async {
    _userStoppedManually = true;
    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 500));
    _onStopListening();
  }

  Future<void> _restartListening() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_isListening && !_userStoppedManually && mounted) {
      if (_currentText.trim().isNotEmpty && widget.state) {
        _finalText = _finalText.isEmpty
            ? _currentText.trim()
            : '$_finalText ${_currentText.trim()}';
        _currentText = '';
      }
      await _startListeningOnline();
    }
  }

  void _onStopListening() {
    if (_isSavingText) return;
    if (!_isListening && _currentText.isEmpty) return;

    _isSavingText = true;
    setState(() {
      _isListening = false;
      if (widget.state) {
        if (_currentText.trim().isNotEmpty) {
          _finalText = _finalText.isEmpty
              ? _currentText.trim()
              : '$_finalText ${_currentText.trim()}';
        }
      } else {
        if (_currentText.trim().isNotEmpty) _finalText = _currentText.trim();
      }
      _currentText = '';
    });

    if (_finalText.isNotEmpty) widget.action(_finalText);
  }

  // ─── MODO OFFLINE: GRABAR ─────────────────────────────────────────────────

  Future<void> _listenOffline() async {
    // Permiso de micrófono
    PermissionStatus status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionError();
      return;
    }

    // Cargar modelo Vosk si no está listo (solo una vez)
    if (_voskModel == null) {
      if (_voskModelLoading) {
        // Otra instancia ya está cargando — esperar máx 15s
        int espera = 0;
        while (_voskModelLoading && espera < 150) {
          await Future.delayed(const Duration(milliseconds: 100));
          espera++;
        }
      }
      if (_voskModel == null && !_voskModelLoading) {
        _voskModelLoading = true;
        try {
          final vosk = VoskFlutterPlugin.instance();
          final modelPath = await ModelLoader().loadFromAssets(
              'assets/vosk_model/vosk-model-small-es-0.42.zip');
          _voskModel = await vosk.createModel(modelPath);
        } catch (e) {
          _voskModelLoading = false;
          _showError('Error cargando modelo offline: $e');
          return;
        } finally {
          _voskModelLoading = false;
        }
      }
      if (_voskModel == null) {
        _showError('No se pudo cargar el modelo de voz offline');
        return;
      }
    }

    // Preparar ruta del archivo temporal
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/vosk_recording.wav';

    // Grabar como WAV para poder leer el header y saber el formato real
    try {
      await _recorder!.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: path,
      );
      setState(() {
        _isListening = true;
        _currentText = '';
      });
    } catch (e) {
      _showError('Error al iniciar grabación: $e');
    }
  }

  // ─── MODO OFFLINE: PARAR Y TRANSCRIBIR ───────────────────────────────────

  Future<void> _stopOffline() async {
    final path = await _recorder?.stop();
    setState(() {
      _isListening = false;
      _isTranscribing = true;
    });

    if (path != null && _voskModel != null) {
      await _transcribeAudioFile(path);
    }

    if (mounted) setState(() => _isTranscribing = false);
  }

  Future<void> _transcribeAudioFile(String path) async {
    Recognizer? recognizer;
    try {
      debugPrint('[VOSK] Iniciando transcripción: $path');

      final wavBytes = await File(path).readAsBytes();
      debugPrint('[VOSK] Tamaño WAV total: ${wavBytes.length} bytes');

      // Leer header WAV para conocer el formato REAL grabado
      int actualSampleRate = 16000;
      int audioFormat = 1;
      int bitsPerSample = 16;
      int numChannels = 1;

      if (wavBytes.length >= 36) {
        audioFormat   = wavBytes[20] | (wavBytes[21] << 8);
        numChannels   = wavBytes[22] | (wavBytes[23] << 8);
        actualSampleRate = wavBytes[24] | (wavBytes[25] << 8) |
                           (wavBytes[26] << 16) | (wavBytes[27] << 24);
        bitsPerSample = wavBytes[34] | (wavBytes[35] << 8);
      }
      debugPrint('[VOSK] WAV header → format=$audioFormat (1=PCM,3=Float), '
          'channels=$numChannels, sampleRate=$actualSampleRate, bits=$bitsPerSample');

      // Extraer PCM (skip header)
      final pcmData = _extractPcmFromWav(wavBytes);
      debugPrint('[VOSK] PCM extraído: ${pcmData.length} bytes '
          '(~${(pcmData.length / (actualSampleRate * numChannels * (bitsPerSample ~/ 8))).toStringAsFixed(1)}s)');

      // Detectar si el audio es silencio y calcular amplitud RMS real
      if (pcmData.isNotEmpty) {
        final nonZero = pcmData.where((b) => b != 0).length;
        final silencePct = ((1 - nonZero / pcmData.length) * 100).toStringAsFixed(1);
        debugPrint('[VOSK] Silencio estimado: $silencePct%');

        // Calcular RMS de las muestras PCM 16-bit (little-endian)
        double sumSq = 0;
        int sampleCount = 0;
        for (int i = 0; i + 1 < pcmData.length; i += 2) {
          int sample = pcmData[i] | (pcmData[i + 1] << 8);
          if (sample > 32767) sample -= 65536; // convertir a signed
          sumSq += sample * sample;
          sampleCount++;
        }
        final rms = sampleCount > 0 ? (sumSq / sampleCount) : 0;
        final rmsVal = rms > 0 ? (rms as double) : 0.0;
        final rmsSqrt = rmsVal > 0 ? rmsVal : 0.0;
        debugPrint('[VOSK] RMS² promedio: ${rms.toStringAsFixed(0)} '
            '(>50000 = voz audible, <1000 = silencio/ruido)');
      }

      recognizer = await VoskFlutterPlugin.instance().createRecognizer(
        model: _voskModel!,
        sampleRate: actualSampleRate, // usar el rate REAL del archivo
      );
      debugPrint('[VOSK] Recognizer creado con sampleRate=$actualSampleRate');

      final pcmUint8 = Uint8List.fromList(pcmData);

      if (pcmUint8.isEmpty || pcmUint8.length < 100) {
        debugPrint('[VOSK] ERROR: PCM vacío o muy pequeño');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se capturó audio. ¿Tienes el micrófono habilitado?'),
            duration: Duration(seconds: 3),
          ));
        }
        return;
      }

      // Chunk dinámico según sample rate real
      final chunkSize = actualSampleRate ~/ 4 * (bitsPerSample ~/ 8);
      final List<String> parts = [];
      int chunkCount = 0;
      int chunksAceptados = 0;

      for (int i = 0; i < pcmUint8.length; i += chunkSize) {
        final end = (i + chunkSize).clamp(0, pcmUint8.length);
        final chunk = Uint8List.sublistView(pcmUint8, i, end);
        final accepted = await recognizer.acceptWaveformBytes(chunk);
        chunkCount++;
        if (accepted) {
          chunksAceptados++;
          final raw = await recognizer.getResult();
          debugPrint('[VOSK] chunk $chunkCount ACEPTADO → "$raw"');
          final text = _extractText(raw);
          if (text.isNotEmpty) parts.add(text);
        } else {
          // Cada 5 chunks mostrar resultado parcial para diagnóstico
          if (chunkCount % 5 == 0) {
            final partial = await recognizer.getPartialResult();
            debugPrint('[VOSK] chunk $chunkCount (parcial) → "$partial"');
          }
        }
      }

      debugPrint('[VOSK] Total chunks: $chunkCount, aceptados: $chunksAceptados');

      // Resultado final — captura lo que quedó en el buffer
      final finalRaw = await recognizer.getFinalResult();
      debugPrint('[VOSK] getFinalResult: $finalRaw');
      final finalText = _extractText(finalRaw);
      if (finalText.isNotEmpty) parts.add(finalText);

      final transcribed = parts.join(' ').trim();
      debugPrint('[VOSK] Texto transcrito final: "$transcribed"');

      if (transcribed.isNotEmpty && mounted) {
        setState(() {
          if (widget.state) {
            _finalText = _finalText.isEmpty ? transcribed : '$_finalText $transcribed';
          } else {
            _finalText = transcribed;
          }
        });
        widget.action(_finalText);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se reconoció voz. Habla más fuerte y cerca del micrófono.'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      debugPrint('[VOSK] EXCEPCIÓN: $e');
      _showError('Error al transcribir: $e');
    } finally {
      await recognizer?.dispose();
      try { await File(path).delete(); } catch (_) {}
    }
  }

  /// Extrae los bytes PCM del archivo WAV (busca el chunk "data")
  List<int> _extractPcmFromWav(Uint8List wavBytes) {
    try {
      // Buscar el marcador "data" (0x64 0x61 0x74 0x61) en el header
      for (int i = 12; i < wavBytes.length - 8; i++) {
        if (wavBytes[i]     == 0x64 && wavBytes[i + 1] == 0x61 &&
            wavBytes[i + 2] == 0x74 && wavBytes[i + 3] == 0x61) {
          final dataStart = i + 8; // 4 bytes "data" + 4 bytes tamaño
          if (dataStart < wavBytes.length) {
            return wavBytes.sublist(dataStart);
          }
        }
      }
      // Fallback: saltar los primeros 44 bytes del header estándar
      return wavBytes.length > 44 ? wavBytes.sublist(44) : [];
    } catch (_) {
      return wavBytes.length > 44 ? wavBytes.sublist(44) : [];
    }
  }

  /// Extrae el texto del JSON de Vosk
  String _extractText(String json) {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return (decoded['text'] as String? ?? '').trim();
    } catch (_) {
      return '';
    }
  }

  // ─── MENSAJES DE ERROR ────────────────────────────────────────────────────

  void _showPermissionError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Permiso de micrófono denegado. Ve a Configuración > Aplicaciones > Permisos.',
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Configuración',
          textColor: Colors.white,
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // ─── CICLO DE VIDA ────────────────────────────────────────────────────────

  @override
  void didUpdateWidget(WidgetWritexText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textValue != oldWidget.textValue &&
        widget.textValue != null &&
        widget.textValue!.isNotEmpty) {
      _finalText = widget.textValue!;
    }
  }

  @override
  void dispose() {
    _userStoppedManually = true;
    _speech.stop();
    _speech.cancel();
    _recorder?.dispose();
    super.dispose();
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 250,
      height: widget.height ?? 250,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Spinner mientras transcribe
          if (_isTranscribing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 6),
                  Text(
                    'Transcribiendo...',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            AvatarGlow(
              animate: _isListening,
              glowColor:
                  _isListening ? Colors.red : Theme.of(context).primaryColor,
              endRadius: 60.0,
              child: FloatingActionButton(
                heroTag: null, // evita conflicto cuando hay múltiples FABs
                mini: true,
                onPressed: _listen,
                backgroundColor: _isListening
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

          // Etiqueta de estado
          if (!_isTranscribing)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _isListening
                    ? (_isOnline ? 'Grabando...' : 'Grabando (offline)...')
                    : 'Toca el micrófono para hablar',
                style: TextStyle(
                  fontSize: 10,
                  color: _isListening ? Colors.red : Colors.grey,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
        ],
      ),
    );
  }
}
