import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'loading_list_tottus_model.dart';
export 'loading_list_tottus_model.dart';

class LoadingListTottusWidget extends StatefulWidget {
  const LoadingListTottusWidget({
    super.key,
    this.texto,
  });

  final String? texto;

  @override
  State<LoadingListTottusWidget> createState() =>
      _LoadingListTottusWidgetState();
}

class _LoadingListTottusWidgetState extends State<LoadingListTottusWidget> {
  late LoadingListTottusModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingListTottusModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.85,
        height: MediaQuery.sizeOf(context).width * 0.60,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.85,
          maxHeight: MediaQuery.sizeOf(context).width * 0.60,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).colorFondoPrimary,
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.folderOpen,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 60.0,
            ),
            Text(
              valueOrDefault<String>(
                widget!.texto,
                'No hay elementos',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
