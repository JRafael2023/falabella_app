import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/container_admin/container_admin_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/custom_code/InternetCheckMixin.dart';
import 'hallazgos_model.dart';
export 'hallazgos_model.dart';

class HallazgosWidget extends StatefulWidget {
  const HallazgosWidget({super.key});

  static String routeName = 'Hallazgos';
  static String routePath = '/Hallazgos';

  @override
  State<HallazgosWidget> createState() => _HallazgosWidgetState();
}

class _HallazgosWidgetState extends State<HallazgosWidget> with TickerProviderStateMixin, WidgetsBindingObserver, InternetCheckMixin {
  late HallazgosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HallazgosModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });
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
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(HomePageAdminWidget.routeName);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 24.0,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
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
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            minHeight: 40.0,
                            maxWidth: 40.0,
                            maxHeight: 40.0,
                          ),
                          decoration: BoxDecoration(),
                          child: wrapWithModel(
                            model: _model.wifiComponentModel,
                            updateCallback: () => safeSetState(() {}),
                            child: WifiComponentWidget(
                              conexion: _model.estaconectado!,
                            ),
                          ),
                        ),
                        Container(
                          width: 40.0,
                          height: 40.0,
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            minHeight: 40.0,
                            maxWidth: 40.0,
                            maxHeight: 40.0,
                          ),
                          decoration: BoxDecoration(),
                          child: wrapWithModel(
                            model: _model.exitComponentModel,
                            updateCallback: () => safeSetState(() {}),
                            child: ExitComponentWidget(),
                          ),
                        ),
                      ].divide(SizedBox(width: 16.0)),
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
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (false)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 8.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).bordeCompletada,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 15.0, 15.0, 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
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
                                    onPressed: () async {
                                      FFAppState().jsonProyectos = [];
                                      FFAppState().jsonUsers = [];
                                      safeSetState(() {});
                                      _model.masivodb =
                                          await actions.sqlLiteListProyectos();
                                      _model.usersMasivo =
                                          await actions.sqLiteListUsers();
                                      FFAppState().jsonProyectos = _model
                                          .masivodb!
                                          .toList()
                                          .cast<dynamic>();
                                      FFAppState().jsonUsers = _model
                                          .usersMasivo!
                                          .toList()
                                          .cast<dynamic>();
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                      'iconButtonOnPageLoadAnimation']!),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'Detalles Observación',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(TituloWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '📝',
                                  name: 'Título',
                                  description: 'Crear Títulos',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  GerenciaWidget.routeName,
                                  extra: <String, dynamic>{
                                    '__transition_info__': TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '👔',
                                  name: 'Gerencia',
                                  description: 'Crear Gerencias',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(EcosistemaWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '🌐',
                                  name: 'Ecosistema',
                                  description: 'Crear Ecosistemas',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(RiskLevelWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '⚠️',
                                  name: 'Nivel de Riesgo',
                                  description: 'Crear Niveles de Riesgo',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(PublicationStatusWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel6,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '📋',
                                  name: 'Estado de Publicación',
                                  description: 'Crear Estados de Publicación',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(ImpactTypeWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel7,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '💥',
                                  name: 'Tipo de Impacto',
                                  description: 'Crear Tipos de Impacto',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(EcosystemSupportWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel8,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '🌿',
                                  name: 'Soporte Ecosistema',
                                  description: 'Crear Soportes de Ecosistema',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(RiskTypeWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel9,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '🔰',
                                  name: 'Tipo de Riesgo',
                                  description: 'Crear Tipos de Riesgo',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(RiskTypologyWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel10,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '🗂️',
                                  name: 'Tipología de Riesgo',
                                  description: 'Crear Tipologías de Riesgo',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(ObservationScopeWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel11,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '🔍',
                                  name: 'Alcance de Observación',
                                  description: 'Crear Alcances de Observación',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(ResponsibleAuditorsWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel12,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '👤',
                                  name: 'Auditor Responsable',
                                  description: 'Crear Auditores Responsables',
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(ResponsibleManagersWidget.routeName);
                              },
                              child: wrapWithModel(
                                model: _model.containerAdminModel13,
                                updateCallback: () => safeSetState(() {}),
                                child: ContainerAdminWidget(
                                  icontext: '👔',
                                  name: 'Gerente Responsable',
                                  description: 'Crear Gerentes Responsables',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
