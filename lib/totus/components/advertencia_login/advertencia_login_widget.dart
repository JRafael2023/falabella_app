import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'advertencia_login_model.dart';
export 'advertencia_login_model.dart';

class AdvertenciaLoginWidget extends StatefulWidget {
  const AdvertenciaLoginWidget({
    super.key,
    this.mensaje,
  });

  final String? mensaje;

  @override
  State<AdvertenciaLoginWidget> createState() => _AdvertenciaLoginWidgetState();
}

class _AdvertenciaLoginWidgetState extends State<AdvertenciaLoginWidget> {
  late AdvertenciaLoginModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdvertenciaLoginModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
      child: Container(
        width: double.infinity,
        height: 77.7,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).customColor3,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.warning_amber_sharp,
                color: FlutterFlowTheme.of(context).nOIniciada,
                size: 24.0,
              ),
              Flexible(
                child: Text(
                  widget.mensaje ?? 'Correo electrónico o contraseña incorrecta. Por favor, vuelve a intentarlo nuevamente.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
        ),
      ),
    );
  }
}
