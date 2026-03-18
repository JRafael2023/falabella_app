import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'noiniciada_model.dart';
export 'noiniciada_model.dart';

class NoiniciadaWidget extends StatefulWidget {
  const NoiniciadaWidget({
    super.key,
    String? tipomatriz,
    String? nemeProyect,
    String? codigo,
    int? quantityControls,
  })  : this.tipomatriz = tipomatriz ?? 'null',
        this.nemeProyect = nemeProyect ?? 'null',
        this.codigo = codigo ?? 'null',
        this.quantityControls = quantityControls ?? 0;

  final String tipomatriz;
  final String nemeProyect;
  final String codigo;
  final int quantityControls;

  @override
  State<NoiniciadaWidget> createState() => _NoiniciadaWidgetState();
}

class _NoiniciadaWidgetState extends State<NoiniciadaWidget> {
  late NoiniciadaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoiniciadaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).containerColorPrimary,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).customColor4bbbbb,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FFIcons.kitem1,
                    color: FlutterFlowTheme.of(context).nOIniciada,
                    size: 28.0,
                  ),
                  Builder(
                    builder: (context) {
                      if (widget!.tipomatriz == 'Express') {
                        return wrapWithModel(
                          model: _model.containerExpressModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ContainerExpressWidget(),
                        );
                      } else {
                        return wrapWithModel(
                          model: _model.containerCompletaModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ContainerCompletaWidget(),
                        );
                      }
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget!.nemeProyect,
                      'null',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget!.codigo,
                      'null',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(height: 5.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: Text(
                      '${valueOrDefault<String>(
                        widget!.quantityControls.toString(),
                        '0',
                      )} Controles',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Iniciar',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).nOIniciada,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Icon(
                        Icons.arrow_right_alt_sharp,
                        color: FlutterFlowTheme.of(context).nOIniciada,
                        size: 24.0,
                      ),
                    ],
                  ),
                ],
              ),
            ].divide(SizedBox(height: 17.0)),
          ),
        ),
      ),
    );
  }
}
