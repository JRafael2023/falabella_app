import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'objetives_model.dart';
export 'objetives_model.dart';

class ObjetivesWidget extends StatefulWidget {
  const ObjetivesWidget({
    super.key,
    this.jsonControles,
    this.titleProject,
    this.tipoMatriz,
  });

  final List<dynamic>? jsonControles;
  final String? titleProject;
  final String? tipoMatriz;

  static String routeName = 'Objetives';
  static String routePath = '/objetives';

  @override
  State<ObjetivesWidget> createState() => _ObjetivesWidgetState();
}

class _ObjetivesWidgetState extends State<ObjetivesWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver, InternetCheckMixin {
  late ObjetivesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ObjetivesModel());

    // Inicializar timer pausable de internet
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    animationsMap.addAll({
      'iconButtonOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeIn,
            delay: 500.0.ms,
            duration: 800.0.ms,
            color: Color(0x8529A828),
            angle: 0.524,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    disposeInternetCheck();
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).colorFondoPrimary,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(HomeProyectsWidget.routeName);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 24.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/download__7_-removebg-preview.png',
                      width: 135.5,
                      height: 46.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(),
                            child: wrapWithModel(
                              model: _model.wifiComponentModel,
                              updateCallback: () => safeSetState(() {}),
                              child: WifiComponentWidget(
                                conexion: _model.estaconectado ?? true,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(),
                            child: wrapWithModel(
                              model: _model.exitComponentModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ExitComponentWidget(),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ],
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (true != true)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 15.0, 0.0, 15.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).bordeCompletada,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 15.0, 15.0, 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.cloud_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .completada,
                                          size: 24.0,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Estado de Sincronización',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ].divide(SizedBox(height: 2.0)),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    hoverColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    icon: Icon(
                                      Icons.cached_sharp,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                      'iconButtonOnPageLoadAnimation']!),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Builder(
                      builder: (context) {
                        if (FFAppState().jsonObjetivos.isNotEmpty) {
                          return Builder(
                            builder: (context) {
                              // Filtrar objetivos del proyecto actual
                              final arreglo = FFAppState()
                                  .jsonObjetivos
                                  .where((obj) =>
                                      getJsonField(obj, r'''$.id_project''')
                                          ?.toString() ==
                                      FFAppState().idproyect)
                                  .toList();

                              if (arreglo.isEmpty) {
                                return LoadingListTottusWidget(
                                  texto: 'Este proyecto no tiene objetivos asignados.',
                                );
                              }

                              return ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  8.0,
                                  0,
                                  0,
                                ),
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: arreglo.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 16.0),
                                itemBuilder: (context, arregloIndex) {
                                  final arregloItem = arreglo[arregloIndex];
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0F1F1),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    arregloItem,
                                                    r'''$.title''',
                                                  )?.toString(),
                                                  'title',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: Text(
                                                  'Avance',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .negroLinea,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  '${valueOrDefault<String>(
                                                    functions
                                                        .calcularPorcentajePorObjetivo(
                                                            FFAppState()
                                                                    .jsonControles ??
                                                                [],
                                                            getJsonField(
                                                              arregloItem,
                                                              r'''$.id_objective''',
                                                            ).toString())
                                                        .toString(),
                                                    '0',
                                                  )}%',
                                                  '0',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 24.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ].divide(SizedBox(height: 5.0)),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Opacity(
                                                opacity: 0.0,
                                                child: Text(
                                                  'a',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  // Guardar ID del objetivo actual
                                                  FFAppState().idobejetivo =
                                                      getJsonField(
                                                    arregloItem,
                                                    r'''$.id_objective''',
                                                  ).toString();
                                                  safeSetState(() {});

                                                  // NO HACER LLAMADAS API - Los datos ya están precargados
                                                  // La página de controles los filtrará automáticamente

                                                  context.goNamed(
                                                    ControlesWidget.routeName,
                                                    queryParameters: {
                                                      'titleProject':
                                                          serializeParam(
                                                        widget!.titleProject,
                                                        ParamType.String,
                                                      ),
                                                      'categoriaObjetive':
                                                          serializeParam(
                                                        getJsonField(
                                                          arregloItem,
                                                          r'''$.title''',
                                                        ).toString(),
                                                        ParamType.String,
                                                      ),
                                                      'tipoMatriz':
                                                          serializeParam(
                                                        widget!.tipoMatriz,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  safeSetState(() {});
                                                },
                                                text: 'Iniciar',
                                                icon: Icon(
                                                  Icons.arrow_right_alt,
                                                  size: 20.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 35.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 0.0, 8.0, 0.0),
                                                  iconAlignment:
                                                      IconAlignment.end,
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  iconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .warning,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transpararente,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .warning,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 17.0)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return wrapWithModel(
                            model: _model.loadingListTottusModel,
                            updateCallback: () => safeSetState(() {}),
                            child: LoadingListTottusWidget(
                              texto:
                                  'Este proyecto no tiene objetivos asignados.',
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
