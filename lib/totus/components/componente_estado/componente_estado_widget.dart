import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'componente_estado_model.dart';
export 'componente_estado_model.dart';

class ComponenteEstadoWidget extends StatefulWidget {
  const ComponenteEstadoWidget({
    super.key,
    String? tipomatriz,
    String? nemeProyect,
    String? codigo,
    int? quantityControls,
    bool? estadoAuditoria,
    double? progressbar,
  })  : this.tipomatriz = tipomatriz ?? 'null',
        this.nemeProyect = nemeProyect ?? 'null',
        this.codigo = codigo ?? 'null',
        this.quantityControls = quantityControls ?? 0,
        this.estadoAuditoria = estadoAuditoria ?? false,
        this.progressbar = progressbar ?? 0.0;

  final String tipomatriz;
  final String nemeProyect;
  final String codigo;
  final int quantityControls;
  final bool estadoAuditoria;
  final double progressbar;

  @override
  State<ComponenteEstadoWidget> createState() => _ComponenteEstadoWidgetState();
}

class _ComponenteEstadoWidgetState extends State<ComponenteEstadoWidget> {
  late ComponenteEstadoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponenteEstadoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.color = valueOrDefault<Color>(
        widget!.estadoAuditoria
            ? FlutterFlowTheme.of(context).completada
            : FlutterFlowTheme.of(context).enProgreso,
        FlutterFlowTheme.of(context).customColor1,
      );
      safeSetState(() {});
      safeSetState(() {});
    });

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
                    color: _model.color,
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
                        'Ver',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: _model.color,
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
                        color: _model.color,
                        size: 24.0,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Avance',
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    '${valueOrDefault<String>(
                      (valueOrDefault<double>(
                                widget!.progressbar,
                                0.0,
                              ) *
                              100)
                          .toString(),
                      '0',
                    )}%',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: _model.color,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ],
              ),
              LinearPercentIndicator(
                percent: valueOrDefault<double>(
                  widget!.progressbar,
                  0.5,
                ),
                lineHeight: 12.0,
                animation: true,
                animateFromLastPercent: true,
                progressColor: valueOrDefault<Color>(
                  _model.color,
                  FlutterFlowTheme.of(context).primaryText,
                ),
                backgroundColor: FlutterFlowTheme.of(context).progresBarColor,
                barRadius: Radius.circular(5.0),
                padding: EdgeInsets.zero,
              ),
            ].divide(SizedBox(height: 17.0)),
          ),
        ),
      ),
    );
  }
}
