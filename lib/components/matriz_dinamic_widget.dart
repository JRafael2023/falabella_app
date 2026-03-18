import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'matriz_dinamic_model.dart';
export 'matriz_dinamic_model.dart';

class MatrizDinamicWidget extends StatefulWidget {
  const MatrizDinamicWidget({
    super.key,
    this.matriz,
    this.proyectos,
  });

  final List<dynamic>? matriz;
  final List<dynamic>? proyectos;

  @override
  State<MatrizDinamicWidget> createState() => _MatrizDinamicWidgetState();
}

class _MatrizDinamicWidgetState extends State<MatrizDinamicWidget> {
  late MatrizDinamicModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MatrizDinamicModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Builder(
      builder: (context) {
        final allMatrices =
            widget!.matriz?.map((e) => e).toList()?.toList() ?? [];
        final arrayMatrices = allMatrices.where((matrizItem) {
          return (widget!.proyectos ?? []).any((e) =>
              getJsonField(e, r'''$.matrix_type''') ==
              getJsonField(matrizItem, r'''$.name'''));
        }).toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: arrayMatrices.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.0),
          itemBuilder: (context, arrayMatricesIndex) {
            final arrayMatricesItem = arrayMatrices[arrayMatricesIndex];
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).containerExpress,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_tree_outlined,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 24.0,
                        ),
                        Flexible(
                          child: Text(
                            valueOrDefault<String>(
                              getJsonField(
                                arrayMatricesItem,
                                r'''$.name''',
                              )?.toString(),
                              'name',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ].divide(SizedBox(width: 10.0)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .containerColorPrimary,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .customColor4bbbbb,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .bordeNoIniciadas,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  Text(
                                    'No iniciadas',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .nOIniciada,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      functions
                                          .getProyectsNoiniciadas(
                                              widget!.proyectos!
                                                  .where((e) =>
                                                      getJsonField(
                                                        e,
                                                        r'''$.matrix_type''',
                                                      ) ==
                                                      getJsonField(
                                                        arrayMatricesItem,
                                                        r'''$.name''',
                                                      ))
                                                  .toList(),
                                              FFAppState()
                                                  .currentUser
                                                  .uidUsuario)
                                          .length
                                          .toString(),
                                      '0',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .warning,
                                          fontSize: 21.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w900,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .containerColorPrimary,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .customColor4bbbbb,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .bordeNoIniciadas,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  Text(
                                    'En progreso',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .enProgreso,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      functions
                                          .getProyectsProgress(
                                              widget!.proyectos!
                                                  .where((e) =>
                                                      getJsonField(
                                                        e,
                                                        r'''$.matrix_type''',
                                                      ) ==
                                                      getJsonField(
                                                        arrayMatricesItem,
                                                        r'''$.name''',
                                                      ))
                                                  .toList(),
                                              FFAppState()
                                                  .currentUser
                                                  .uidUsuario)
                                          .length
                                          .toString(),
                                      '0',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .enProgreso,
                                          fontSize: 21.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w900,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .containerColorPrimary,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .customColor4bbbbb,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .bordeNoIniciadas,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  Text(
                                    'Completadas',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .completada,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      functions
                                          .getProyectsComplete(
                                              widget!.proyectos!
                                                  .where((e) =>
                                                      getJsonField(
                                                        e,
                                                        r'''$.matrix_type''',
                                                      ) ==
                                                      getJsonField(
                                                        arrayMatricesItem,
                                                        r'''$.name''',
                                                      ))
                                                  .toList(),
                                              FFAppState()
                                                  .currentUser
                                                  .uidUsuario)
                                          .length
                                          .toString(),
                                      '0',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .completada,
                                          fontSize: 21.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w900,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                  ].divide(SizedBox(height: 17.0)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
