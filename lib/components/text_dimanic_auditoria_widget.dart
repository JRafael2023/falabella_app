import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'text_dimanic_auditoria_model.dart';
export 'text_dimanic_auditoria_model.dart';

class TextDimanicAuditoriaWidget extends StatefulWidget {
  const TextDimanicAuditoriaWidget({
    super.key,
    this.filterJSON,
    this.color,
  });

  final List<dynamic>? filterJSON;
  final Color? color;

  @override
  State<TextDimanicAuditoriaWidget> createState() =>
      _TextDimanicAuditoriaWidgetState();
}

class _TextDimanicAuditoriaWidgetState
    extends State<TextDimanicAuditoriaWidget> {
  late TextDimanicAuditoriaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TextDimanicAuditoriaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      valueOrDefault<String>(
        widget!.filterJSON?.length.toString(),
        '0',
      ),
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: TextStyle(
              fontWeight: FontWeight.w900,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: widget!.color,
            fontSize: 21.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w900,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
    );
  }
}
