import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'wifi_component_model.dart';
export 'wifi_component_model.dart';

class WifiComponentWidget extends StatefulWidget {
  const WifiComponentWidget({
    super.key,
    bool? conexion,
  }) : this.conexion = conexion ?? false;

  final bool conexion;

  @override
  State<WifiComponentWidget> createState() => _WifiComponentWidgetState();
}

class _WifiComponentWidgetState extends State<WifiComponentWidget> {
  late WifiComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WifiComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      constraints: BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
        maxWidth: 40.0,
        maxHeight: 40.0,
      ),
      decoration: BoxDecoration(),
      child: Builder(
        builder: (context) {
          if (widget!.conexion) {
            return AlignedTooltip(
              content: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Con Conexion a Internet',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: TextStyle(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
              ),
              offset: 4.0,
              preferredDirection: AxisDirection.down,
              borderRadius: BorderRadius.circular(8.0),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 4.0,
              tailBaseWidth: 24.0,
              tailLength: 12.0,
              waitDuration: Duration(milliseconds: 100),
              showDuration: Duration(milliseconds: 1500),
              triggerMode: TooltipTriggerMode.tap,
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                icon: Icon(
                  Icons.wifi_rounded,
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 24.0,
                ),
                onPressed: (random_data.randomInteger(1, 1) == 1)
                    ? null
                    : () {
                      },
              ),
            );
          } else {
            return AlignedTooltip(
              content: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Sin Conexion a Internet',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: TextStyle(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
              ),
              offset: 4.0,
              preferredDirection: AxisDirection.down,
              borderRadius: BorderRadius.circular(8.0),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 4.0,
              tailBaseWidth: 24.0,
              tailLength: 12.0,
              waitDuration: Duration(milliseconds: 100),
              showDuration: Duration(milliseconds: 1500),
              triggerMode: TooltipTriggerMode.tap,
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                icon: Icon(
                  Icons.wifi_off_sharp,
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 24.0,
                ),
                onPressed: (random_data.randomInteger(1, 1) == 1)
                    ? null
                    : () {
                      },
              ),
            );
          }
        },
      ),
    );
  }
}
