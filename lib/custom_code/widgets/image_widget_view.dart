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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:io';

class ImageWidgetView extends StatefulWidget {
  const ImageWidgetView({
    super.key,
    this.width,
    this.height,
    this.rutalocal,
  });

  final double? width;
  final double? height;
  final String? rutalocal;

  @override
  State<ImageWidgetView> createState() => _ImageWidgetViewState();
}

class _ImageWidgetViewState extends State<ImageWidgetView> {
  static const String placeholderPath = 'assets/images/hacker.jpg';
  late Future<ImageProvider> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  /// Carga segura del archivo local. Si no existe, usa placeholder.
  Future<ImageProvider> _loadImage() async {
    final path = widget.rutalocal;

    if (path == null || path.isEmpty) {
      return const AssetImage(placeholderPath);
    }

    final file = File(path);

    if (await file.exists()) {
      return FileImage(file);
    } else {
      return const AssetImage(placeholderPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: _imageFuture,
      builder: (context, snapshot) {
        final imageProvider = snapshot.data;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: imageProvider != null
                ? DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : null,
        );
      },
    );
  }
}
