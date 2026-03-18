import '/backend/api_requests/api_calls.dart';
import '/components/exit_component_widget.dart';
import '/components/matriz_dinamic_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/DBGerencia.dart';
import '/custom_code/DBSyncLogs.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'home_proyects_model.dart';
export 'home_proyects_model.dart';

class HomeProyectsWidget extends StatefulWidget {
  const HomeProyectsWidget({
    super.key,
    this.title,
  });

  final String? title;

  static String routeName = 'HomeProyects';
  static String routePath = '/homeProyects';

  @override
  State<HomeProyectsWidget> createState() => _HomeProyectsWidgetState();
}

class _HomeProyectsWidgetState extends State<HomeProyectsWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver, InternetCheckMixin {
  late HomeProyectsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  Future<void> _loadUltimaSync() async {
    final userUid = FFAppState().currentUser.uidUsuario;
    final ultimoSync = await DBSyncLogs.getUltimoSync(userUid: userUid);
    if (ultimoSync != null && ultimoSync['sync_end'] != null) {
      final fecha = DateTime.tryParse(ultimoSync['sync_end'].toString())?.toLocal();
      if (fecha != null) {
        final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(fecha);
        _model.ultimaSyncText = formattedDate;
        print('🕒 Última sincronización actualizada: $formattedDate');
      } else {
        _model.ultimaSyncText = 'No hay sincronizaciones';
      }
    } else {
      _model.ultimaSyncText = 'No hay sincronizaciones';
    }
  }


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeProyectsModel());

    // Inicializar timer pausable de internet
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    // Cargar última sincronización
    _loadUltimaSync();

    _model.txtidTextController ??= TextEditingController();
    _model.txtidFocusNode ??= FocusNode();

    animationsMap.addAll({
      'iconButtonOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeIn,
            delay: 500.0.ms,
            duration: 1220.0.ms,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
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
                          updateOnChange: true,
                          child: WifiComponentWidget(
                            conexion: _model.estaconectado ?? true,
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
              ],
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: Stack(
            children: [
              SafeArea(
                top: true,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 4.0, 8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).bordeCompletada,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 15.0, 15.0, 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .completada,
                                      size: 24.0,
                                    ),
                                    SizedBox(width: 12.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Estado de sincronización',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: TextStyle(
                                                    fontWeight: FontWeight.w600,
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
                                                      FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 14.0,
                                              ),
                                              SizedBox(width: 4.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Última sincronización:',
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodySmall
                                                          .override(
                                                            font: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontStyle: FlutterFlowTheme.of(context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FlutterFlowTheme.of(context)
                                                                .bodySmall
                                                                .fontStyle,
                                                          ),
                                                    ),
                                                    Text(
                                                      _model.ultimaSyncText,
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodySmall
                                                          .override(
                                                            font: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontStyle: FlutterFlowTheme.of(context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FlutterFlowTheme.of(context)
                                                                .bodySmall
                                                                .fontStyle,
                                                          ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  await action_blocks.sync(
                                    context,
                                    connect: _model.estaconectado,
                                  );
                                  await _loadUltimaSync();
                                  safeSetState(() {});
                                },
                              ).animateOnPageLoad(animationsMap[
                                  'iconButtonOnPageLoadAnimation']!),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF7B501),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 4.0, 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 34.0,
                                        ),
                                        Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: (_model.apiRequestCompleter3 ??=
                                                        Completer<ApiCallResponse>()
                                                          ..complete(SupabaseGroup
                                                              .getProjectsCall
                                                              .call(
                                                            filters:
                                                                '?progress=eq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                            offset: 0,
                                                            limit: 2500,
                                                          )))
                                                    .future,
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final textGetProjectsResponse =
                                                      snapshot.data!;

                                                  return Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getJsonListLength(
                                                              textGetProjectsResponse
                                                                  .jsonBody)
                                                          .toString(),
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              );
                                            } else {
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getProyectsNoiniciadas(
                                                              functions.getProyectosSearchCodigoNombre(
                                                                  FFAppState().jsonProyectos ?? [],
                                                                  _model.txtidTextController.text,
                                                                  FFAppState().currentUser.uidUsuario) ?? [],
                                                              FFAppState()
                                                                  .currentUser
                                                                  .uidUsuario)
                                                          .length
                                                          .toString(),
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          'No iniciadas',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).enProgreso,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 4.0, 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cached_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 34.0,
                                        ),
                                        Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: (_model.apiRequestCompleter1 ??=
                                                        Completer<ApiCallResponse>()
                                                          ..complete(SupabaseGroup
                                                              .getProjectsCall
                                                              .call(
                                                            filters:
                                                                '?progress=neq.100&progress=neq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                            offset: 0,
                                                            limit: 2500,
                                                          )))
                                                    .future,
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final textGetProjectsResponse =
                                                      snapshot.data!;

                                                  return Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getJsonListLength(
                                                              textGetProjectsResponse
                                                                  .jsonBody)
                                                          .toString(),
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              );
                                            } else {
                                              return Text(
                                                valueOrDefault<String>(
                                                  functions
                                                      .getProyectsProgressCount(
                                                          functions.getProyectosSearchCodigoNombre(
                                                              FFAppState().jsonProyectos ?? [],
                                                              _model.txtidTextController.text,
                                                              FFAppState().currentUser.uidUsuario) ?? [],
                                                          assignUser: FFAppState().currentUser.uidUsuario)
                                                      .toString(),
                                                  '0',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          'En progreso',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 8.0, 4.0, 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 34.0,
                                        ),
                                        Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: (_model.apiRequestCompleter2 ??=
                                                        Completer<ApiCallResponse>()
                                                          ..complete(SupabaseGroup
                                                              .getProjectsCall
                                                              .call(
                                                            filters:
                                                                '?progress=eq.100&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                            offset: 0,
                                                            limit: 2500,
                                                          )))
                                                    .future,
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final textGetProjectsResponse =
                                                      snapshot.data!;

                                                  return Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getJsonListLength(
                                                              textGetProjectsResponse
                                                                  .jsonBody)
                                                          .toString(),
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              );
                                            } else {
                                              return Text(
                                                valueOrDefault<String>(
                                                  functions
                                                      .getProyectsCompleteCount(
                                                          functions.getProyectosSearchCodigoNombre(
                                                              FFAppState().jsonProyectos ?? [],
                                                              _model.txtidTextController.text,
                                                              FFAppState().currentUser.uidUsuario) ?? [],
                                                          assignUser: FFAppState().currentUser.uidUsuario)
                                                      .toString(),
                                                  '0',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
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
                                                              .primaryBackground,
                                                          fontSize: 21.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          'Completas',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 24.0, 4.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .containerColorPrimary,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 16.0, 8.0, 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.fileAlt,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Estatus por Auditoría',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  if (_model.estaconectado ?? false) {
                                    return FutureBuilder<ApiCallResponse>(
                                      future:
                                          SupabaseGroup.getMatricesCall.call(),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final containerGetMatricesResponse =
                                            snapshot.data!;

                                        return Container(
                                          height: 300.0,
                                          decoration: BoxDecoration(),
                                          child: FutureBuilder<ApiCallResponse>(
                                            future: SupabaseGroup
                                                .getProjectsCall
                                                .call(
                                              filters:
                                                  '?assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                              offset: 0,
                                              limit: 2500,
                                            ),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final containerGetProjectsResponse =
                                                  snapshot.data!;

                                              return Container(
                                                decoration: BoxDecoration(),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .matrizDinamicOnModel,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: MatrizDinamicWidget(
                                                    matriz:
                                                        containerGetMatricesResponse
                                                            .jsonBody,
                                                    proyectos:
                                                        containerGetProjectsResponse
                                                            .jsonBody,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Container(
                                      height: 300.0,
                                      decoration: BoxDecoration(),
                                      child: wrapWithModel(
                                        model: _model.matrizDinamicOffModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: MatrizDinamicWidget(
                                          matriz: FFAppState().jsonMatrices,
                                          proyectos: FFAppState()
                                              .jsonProyectos
                                              .where((e) =>
                                                  getJsonField(
                                                    e,
                                                    r'''$.assign_user''',
                                                  )?.toString() ==
                                                  FFAppState()
                                                      .currentUser
                                                      .uidUsuario)
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ].divide(SizedBox(height: 17.0)),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              width: 200.0,
                              child: TextFormField(
                                controller: _model.txtidTextController,
                                focusNode: _model.txtidFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.txtidTextController',
                                  Duration(milliseconds: 20),
                                  () async {
                                    if (_model.estaconectado!) {
                                      safeSetState(() =>
                                          _model.apiRequestCompleter3 = null);
                                      await _model
                                          .waitForApiRequestCompleted3();
                                      safeSetState(() =>
                                          _model.apiRequestCompleter3 = null);
                                      await _model
                                          .waitForApiRequestCompleted3();
                                    }
                                  },
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: TextStyle(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  hintText: 'Buscar por código o nombre',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: TextStyle(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .customColor4bbbbb,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .mouseregionTEXT,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.search,
                                  ),
                                  suffixIcon: _model
                                          .txtidTextController!.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.txtidTextController?.clear();
                                            if (_model.estaconectado!) {
                                              safeSetState(() => _model
                                                  .apiRequestCompleter3 = null);
                                              await _model
                                                  .waitForApiRequestCompleted3();
                                              safeSetState(() => _model
                                                  .apiRequestCompleter3 = null);
                                              await _model
                                                  .waitForApiRequestCompleted3();
                                            }
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 22,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: TextStyle(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                enableInteractiveSelection: true,
                                validator: _model.txtidTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Wrap(
                        spacing: 32.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        runAlignment: WrapAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        clipBehavior: Clip.none,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              _model.autioriaType = 'todas';
                              safeSetState(() {});
                            },
                            text: 'Todas',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).hintText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.autioriaType = 'no_iniciadas';
                              safeSetState(() {});
                            },
                            text: 'No iniciadas',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF7B501),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.autioriaType = 'en_progreso';
                              safeSetState(() {});
                            },
                            text: 'En progreso',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF0DA3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.autioriaType = 'completadas';
                              safeSetState(() {});
                            },
                            text: 'Completadas',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF1B9848),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if ((_model.autioriaType == 'todas') ||
                            (_model.autioriaType == 'no_iniciadas'))
                          Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 4.0, 8.0, 4.0),
                                        child: Icon(
                                          Icons.circle_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .nOIniciada,
                                          size: 30.0,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: SupabaseGroup
                                                    .getProjectsCall
                                                    .call(
                                                  filters:
                                                      '?progress=eq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                  offset: 0,
                                                  limit: 2500,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final richTextGetProjectsResponse =
                                                      snapshot.data!;

                                                  return RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'No iniciadas',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize:
                                                                    24.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: ' ',
                                                          style: TextStyle(),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '(${valueOrDefault<String>(
                                                            functions
                                                                .getProyectsNoiniciadas(
                                                                    functions
                                                                        .getProyectosSearchCodigoNombre(
                                                                            FFAppState().jsonProyectos ?? [],
                                                                            _model.txtidTextController.text,
                                                                            FFAppState().currentUser.uidUsuario),
                                                                    FFAppState().currentUser.uidUsuario)
                                                                .length
                                                                .toString(),
                                                            '0',
                                                          )})',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 25.0,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    );
                                                },
                                              );
                                            } else {
                                              return RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'No iniciadas',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle: FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                            ),
                                                            fontSize: 24.0,
                                                            letterSpacing:
                                                                0.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: ' ',
                                                      style: TextStyle(),
                                                    ),
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        functions
                                                            .getProyectsNoiniciadas(
                                                                functions.getProyectosSearchCodigoNombre(
                                                                    FFAppState().jsonProyectos ?? [],
                                                                    _model.txtidTextController.text,
                                                                    FFAppState().currentUser.uidUsuario),
                                                                FFAppState()
                                                                    .currentUser
                                                                    .uidUsuario)
                                                            .length
                                                            .toString(),
                                                        '0',
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            TextStyle(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (_model.estaconectado ?? false) {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: FutureBuilder<ApiCallResponse>(
                                            future: (_model
                                                        .apiRequestCompleter3 ??=
                                                    Completer<ApiCallResponse>()
                                                      ..complete(SupabaseGroup
                                                          .getProjectsCall
                                                          .call(
                                                        filters:
                                                            '?progress=eq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}&or=(name.${'ilike.%${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? '%${_model.txtidTextController.text}%' : '%%'}%'},id_project.${'eq.${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? _model.txtidTextController.text : '*'}'})',
                                                        offset: 0,
                                                        limit: 2500,
                                                      )))
                                                .future,
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return LoadingListTottusWidget(
                                                  texto:
                                                      'Lista Vacias de Proyectos No iniciadas',
                                                );
                                              }
                                              final listViewNoIniciadasGetProjectsResponse =
                                                  snapshot.data!;

                                              return Builder(
                                                builder: (context) {
                                                  final arrayNoIniciadas =
                                                      listViewNoIniciadasGetProjectsResponse
                                                              .jsonBody ??
                                                          [];
                                                  if (arrayNoIniciadas
                                                      .isEmpty) {
                                                    return LoadingListTottusWidget(
                                                      texto:
                                                          'No hay auditorías iniciadas.',
                                                    );
                                                  }

                                                  return RefreshIndicator(
                                                    key: Key(
                                                        'RefreshIndicator_at33ngp3'),
                                                    onRefresh: () async {
                                                      safeSetState(() => _model
                                                              .apiRequestCompleter3 =
                                                          null);
                                                      await _model
                                                          .waitForApiRequestCompleted3();
                                                    },
                                                    child: ListView.separated(
                                                      padding: EdgeInsets.zero,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          arrayNoIniciadas
                                                              .length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              height: 15.0),
                                                      itemBuilder: (context,
                                                          arrayNoIniciadasIndex) {
                                                        final arrayNoIniciadasItem =
                                                            arrayNoIniciadas[
                                                                arrayNoIniciadasIndex];
                                                        return InkWell(
                                                          splashColor: Colors.transparent,
                                                          focusColor: Colors.transparent,
                                                          hoverColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          onTap: () async {
                                                            await _model.objetives(
                                                              context,
                                                              idProyecto: getJsonField(
                                                                arrayNoIniciadasItem,
                                                                r'''$.id_project''',
                                                              ).toString(),
                                                              title: getJsonField(
                                                                arrayNoIniciadasItem,
                                                                r'''$.name''',
                                                              ).toString(),
                                                              tipoMatriz: getJsonField(
                                                                arrayNoIniciadasItem,
                                                                r'''$.matrix_type''',
                                                              )?.toString(),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .unselectedColorTabbar,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.name''',
                                                                          )?.toString(),
                                                                          'name',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    wrapWithModel(
                                                                      model: _model
                                                                          .containerExpressModels1
                                                                          .getModel(
                                                                        arrayNoIniciadasIndex
                                                                            .toString(),
                                                                        arrayNoIniciadasIndex,
                                                                      ),
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          ContainerExpressWidget(
                                                                        key:
                                                                            Key(
                                                                          'Keyk58_${arrayNoIniciadasIndex.toString()}',
                                                                        ),
                                                                        tipoMatriz:
                                                                            valueOrDefault<String>(
                                                                          getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                          'matriz',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          5.0)),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arrayNoIniciadasItem,
                                                                          r'''$.id_project''',
                                                                        )?.toString(),
                                                                        'id_project',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w300,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          5.0)),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await actions
                                                                            .generarPDFReporteProyecto(
                                                                          getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.id_project''',
                                                                          ).toString(),
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Reporte',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            35.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        iconAlignment:
                                                                            IconAlignment.start,
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Color(
                                                                            0x005CA828),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).warning,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await _model
                                                                            .objetives(
                                                                          context,
                                                                          idProyecto:
                                                                              getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.id_project''',
                                                                          ).toString(),
                                                                          title:
                                                                              getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.name''',
                                                                          ).toString(),
                                                                          tipoMatriz:
                                                                              getJsonField(
                                                                            arrayNoIniciadasItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Iniciar',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_right_alt,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            35.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        iconAlignment:
                                                                            IconAlignment.end,
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        iconColor:
                                                                            FlutterFlowTheme.of(context).warning,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .transpararente,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).warning,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height:
                                                                      17.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final arrayNoIniciadasOff = functions
                                                  .getProyectsNoiniciadas(
                                                      functions
                                                          .getProyectosSearchCodigoNombre(
                                                              FFAppState()
                                                                      .jsonProyectos ??
                                                                  [],
                                                              _model
                                                                  .txtidTextController
                                                                  .text,
                                                              FFAppState()
                                                                  .currentUser
                                                                  .uidUsuario),
                                                      FFAppState()
                                                          .currentUser
                                                          .uidUsuario);
                                              if (arrayNoIniciadasOff.isEmpty) {
                                                return LoadingListTottusWidget(
                                                  texto:
                                                      'No hay auditorías iniciadas.',
                                                );
                                              }

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    arrayNoIniciadasOff.length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 15.0),
                                                itemBuilder: (context,
                                                    arrayNoIniciadasOffIndex) {
                                                  final arrayNoIniciadasOffItem =
                                                      arrayNoIniciadasOff[
                                                          arrayNoIniciadasOffIndex];
                                                  return InkWell(
                                                    splashColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () async {
                                                      await _model.objetives(
                                                        context,
                                                        idProyecto: getJsonField(
                                                          arrayNoIniciadasOffItem,
                                                          r'''$.id_project''',
                                                        ).toString(),
                                                        title: getJsonField(
                                                          arrayNoIniciadasOffItem,
                                                          r'''$.name''',
                                                        ).toString(),
                                                        tipoMatriz: getJsonField(
                                                          arrayNoIniciadasOffItem,
                                                          r'''$.matrix_type''',
                                                        )?.toString(),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .unselectedColorTabbar,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    getJsonField(
                                                                      arrayNoIniciadasOffItem,
                                                                      r'''$.name''',
                                                                    )?.toString(),
                                                                    'name',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              wrapWithModel(
                                                                model: _model
                                                                    .containerExpressModels2
                                                                    .getModel(
                                                                  arrayNoIniciadasOffIndex
                                                                      .toString(),
                                                                  arrayNoIniciadasOffIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    ContainerExpressWidget(
                                                                  key: Key(
                                                                    'Keys2m_${arrayNoIniciadasOffIndex.toString()}',
                                                                  ),
                                                                  tipoMatriz:
                                                                      valueOrDefault<
                                                                          String>(
                                                                    getJsonField(
                                                                      arrayNoIniciadasOffItem,
                                                                      r'''$.matrix_type''',
                                                                    )?.toString(),
                                                                    'matriz',
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 5.0)),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    arrayNoIniciadasOffItem,
                                                                    r'''$.id_project''',
                                                                  )?.toString(),
                                                                  'id_project',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 5.0)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        8.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .generarPDFReporteProyecto(
                                                                      getJsonField(
                                                                        arrayNoIniciadasOffItem,
                                                                        r'''$.id_project''',
                                                                      ).toString(),
                                                                    );
                                                                  },
                                                                  text:
                                                                      'Reporte',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        35.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                    iconAlignment:
                                                                        IconAlignment
                                                                            .start,
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0x005CA828),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).warning,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await _model
                                                                        .objetives(
                                                                      context,
                                                                      idProyecto:
                                                                          getJsonField(
                                                                        arrayNoIniciadasOffItem,
                                                                        r'''$.id_project''',
                                                                      ).toString(),
                                                                      title: valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arrayNoIniciadasOffItem,
                                                                          r'''$.name''',
                                                                        )?.toString(),
                                                                        'name',
                                                                      ),
                                                                      tipoMatriz:
                                                                          getJsonField(
                                                                        arrayNoIniciadasOffItem,
                                                                        r'''$.matrix_type''',
                                                                      )?.toString(),
                                                                    );
                                                                  },
                                                                  text:
                                                                      'Iniciar',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_right_alt,
                                                                    size: 20.0,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        35.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    iconAlignment:
                                                                        IconAlignment
                                                                            .end,
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    iconColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .warning,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .transpararente,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).warning,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 17.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if ((_model.autioriaType == 'todas') ||
                            (_model.autioriaType == 'en_progreso'))
                          Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 45.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.cached_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .enProgreso,
                                          size: 25.0,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: SupabaseGroup
                                                    .getProjectsCall
                                                    .call(
                                                  filters:
                                                      '?progress=neq.100&progress=neq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                  offset: 0,
                                                  limit: 2500,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final richTextGetProjectsResponse =
                                                      snapshot.data!;

                                                  return RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'En progreso',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 25.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: ' ',
                                                          style: TextStyle(),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '(${valueOrDefault<String>(
                                                            functions
                                                                .getProyectsProgress(
                                                                    functions
                                                                        .getProyectosSearchCodigoNombre(
                                                                            FFAppState().jsonProyectos ?? [],
                                                                            _model.txtidTextController.text,
                                                                            FFAppState().currentUser.uidUsuario),
                                                                    FFAppState().currentUser.uidUsuario)
                                                                .length
                                                                .toString(),
                                                            '0',
                                                          )})',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 25.0,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'En progreso',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 25.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: ' ',
                                                      style: TextStyle(),
                                                    ),
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        functions
                                                            .getProyectsProgressCount(
                                                                functions.getProyectosSearchCodigoNombre(
                                                                    FFAppState().jsonProyectos ?? [],
                                                                    _model.txtidTextController.text,
                                                                    FFAppState().currentUser.uidUsuario),
                                                                assignUser: FFAppState().currentUser.uidUsuario)
                                                            .toString(),
                                                        '0',
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: TextStyle(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (_model.estaconectado ?? false) {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: FutureBuilder<ApiCallResponse>(
                                            future: (_model
                                                        .apiRequestCompleter1 ??=
                                                    Completer<ApiCallResponse>()
                                                      ..complete(SupabaseGroup
                                                          .getProjectsCall
                                                          .call(
                                                        filters:
                                                            '?progress=neq.100&progress=neq.0&assign_user=eq.${FFAppState().currentUser.uidUsuario}&or=(name.${'ilike.%${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? '%${_model.txtidTextController.text}%' : '%%'}%'},id_project.${'eq.${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? _model.txtidTextController.text : '*'}'})',
                                                        offset: 0,
                                                        limit: 2500,
                                                      )))
                                                .future,
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final listViewProgresoGetProjectsResponse =
                                                  snapshot.data!;

                                              return Builder(
                                                builder: (context) {
                                                  final arrayEnProgreso =
                                                      listViewProgresoGetProjectsResponse
                                                              .jsonBody ??
                                                          [];
                                                  if (arrayEnProgreso.isEmpty) {
                                                    return LoadingListTottusWidget(
                                                      texto:
                                                          'No hay auditorías en progreso.',
                                                    );
                                                  }

                                                  return RefreshIndicator(
                                                    key: Key(
                                                        'RefreshIndicator_gx59c2v8'),
                                                    onRefresh: () async {
                                                      safeSetState(() => _model
                                                              .apiRequestCompleter1 =
                                                          null);
                                                      await _model
                                                          .waitForApiRequestCompleted1();
                                                    },
                                                    child: ListView.separated(
                                                      padding: EdgeInsets.zero,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: arrayEnProgreso
                                                          .length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              height: 15.0),
                                                      itemBuilder: (context,
                                                          arrayEnProgresoIndex) {
                                                        final arrayEnProgresoItem =
                                                            arrayEnProgreso[
                                                                arrayEnProgresoIndex];
                                                        return InkWell(
                                                          splashColor: Colors.transparent,
                                                          focusColor: Colors.transparent,
                                                          hoverColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          onTap: () async {
                                                            await _model.objetives(
                                                              context,
                                                              idProyecto: getJsonField(
                                                                arrayEnProgresoItem,
                                                                r'''$.id_project''',
                                                              ).toString(),
                                                              title: getJsonField(
                                                                arrayEnProgresoItem,
                                                                r'''$.name''',
                                                              ).toString(),
                                                              tipoMatriz: getJsonField(
                                                                arrayEnProgresoItem,
                                                                r'''$.matrix_type''',
                                                              )?.toString(),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .linealogin,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.name''',
                                                                          )?.toString(),
                                                                          'name',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    wrapWithModel(
                                                                      model: _model
                                                                          .containerExpressModels3
                                                                          .getModel(
                                                                        arrayEnProgresoIndex
                                                                            .toString(),
                                                                        arrayEnProgresoIndex,
                                                                      ),
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          ContainerExpressWidget(
                                                                        key:
                                                                            Key(
                                                                          'Keyz9v_${arrayEnProgresoIndex.toString()}',
                                                                        ),
                                                                        tipoMatriz:
                                                                            valueOrDefault<String>(
                                                                          getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                          'matriz',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          5.0)),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arrayEnProgresoItem,
                                                                          r'''$.id_project''',
                                                                        )?.toString(),
                                                                        'id_project',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w300,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          5.0)),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Opacity(
                                                                      opacity:
                                                                          0.0,
                                                                      child:
                                                                          Text(
                                                                        '${valueOrDefault<String>(
                                                                          getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.aaaa''',
                                                                          )?.toString(),
                                                                          '1',
                                                                        )} Controles',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await _model
                                                                            .objetives(
                                                                          context,
                                                                          idProyecto:
                                                                              getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.id_project''',
                                                                          ).toString(),
                                                                          title:
                                                                              getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.name''',
                                                                          ).toString(),
                                                                          tipoMatriz:
                                                                              getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Ver',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_right_alt,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            35.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        iconAlignment:
                                                                            IconAlignment.end,
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Colors
                                                                            .transparent,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).enProgreso,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Avance',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arrayEnProgresoItem,
                                                                          r'''$.progress''',
                                                                        )?.toString(),
                                                                        '0',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).enProgreso,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                LinearPercentIndicator(
                                                                  percent:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    (valueOrDefault<
                                                                            double>(
                                                                          getJsonField(
                                                                            arrayEnProgresoItem,
                                                                            r'''$.progress''',
                                                                          ),
                                                                          0.0,
                                                                        ) /
                                                                        100),
                                                                    0.2,
                                                                  ),
                                                                  lineHeight:
                                                                      12.0,
                                                                  animation:
                                                                      true,
                                                                  animateFromLastPercent:
                                                                      true,
                                                                  progressColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .enProgreso,
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .progresBarColor,
                                                                  barRadius: Radius
                                                                      .circular(
                                                                          5.0),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .generarPDFReporteProyecto(
                                                                      getJsonField(
                                                                        arrayEnProgresoItem,
                                                                        r'''$.id_project''',
                                                                      ).toString(),
                                                                    );
                                                                  },
                                                                  text:
                                                                      'Reporte',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        35.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                    iconAlignment:
                                                                        IconAlignment
                                                                            .start,
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0x005CA828),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).enProgreso,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height:
                                                                      17.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final arrayEnProgresoOff = functions
                                                  .getProyectsProgress(
                                                      functions
                                                          .getProyectosSearchCodigoNombre(
                                                              FFAppState()
                                                                      .jsonProyectos ??
                                                                  [],
                                                              _model
                                                                  .txtidTextController
                                                                  .text,
                                                              FFAppState()
                                                                  .currentUser
                                                                  .uidUsuario),
                                                      FFAppState()
                                                          .currentUser
                                                          .uidUsuario);
                                              if (arrayEnProgresoOff.isEmpty) {
                                                return LoadingListTottusWidget(
                                                  texto:
                                                      'No hay auditorías en progreso.',
                                                );
                                              }

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    arrayEnProgresoOff.length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 15.0),
                                                itemBuilder: (context,
                                                    arrayEnProgresoOffIndex) {
                                                  final arrayEnProgresoOffItem =
                                                      arrayEnProgresoOff[
                                                          arrayEnProgresoOffIndex];
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .linealogin,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.name''',
                                                                    )?.toString(),
                                                                    'name',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              wrapWithModel(
                                                                model: _model
                                                                    .containerExpressModels4
                                                                    .getModel(
                                                                  arrayEnProgresoOffIndex
                                                                      .toString(),
                                                                  arrayEnProgresoOffIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    ContainerExpressWidget(
                                                                  key: Key(
                                                                    'Keyjwd_${arrayEnProgresoOffIndex.toString()}',
                                                                  ),
                                                                  tipoMatriz:
                                                                      valueOrDefault<
                                                                          String>(
                                                                    getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.matrix_type''',
                                                                    )?.toString(),
                                                                    'matriz',
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 5.0)),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    arrayEnProgresoOffItem,
                                                                    r'''$.id_project''',
                                                                  )?.toString(),
                                                                  'id_project',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 5.0)),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Opacity(
                                                                opacity: 0.0,
                                                                child: Text(
                                                                  '${valueOrDefault<String>(
                                                                    getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.aaaa''',
                                                                    )?.toString(),
                                                                    '1',
                                                                  )} Controles',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Avance',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    arrayEnProgresoOffItem,
                                                                    r'''$.progress''',
                                                                  )?.toString(),
                                                                  '0',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .enProgreso,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await _model
                                                                      .objetives(
                                                                    context,
                                                                    idProyecto:
                                                                        getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.id_project''',
                                                                    ).toString(),
                                                                    title:
                                                                        getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.name''',
                                                                    ).toString(),
                                                                    tipoMatriz:
                                                                        getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.matrix_type''',
                                                                    )?.toString(),
                                                                  );
                                                                },
                                                                text: 'Ver',
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_right_alt,
                                                                  size: 20.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 35.0,
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                  iconAlignment:
                                                                      IconAlignment
                                                                          .end,
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Colors
                                                                      .transparent,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .enProgreso,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          LinearPercentIndicator(
                                                            percent:
                                                                valueOrDefault<
                                                                    double>(
                                                              (valueOrDefault<
                                                                      double>(
                                                                    getJsonField(
                                                                      arrayEnProgresoOffItem,
                                                                      r'''$.progress''',
                                                                    ),
                                                                    0.0,
                                                                  ) /
                                                                  100),
                                                              0.2,
                                                            ),
                                                            lineHeight: 12.0,
                                                            animation: true,
                                                            animateFromLastPercent:
                                                                true,
                                                            progressColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .enProgreso,
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .progresBarColor,
                                                            barRadius:
                                                                Radius.circular(
                                                                    5.0),
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              await actions
                                                                  .generarPDFReporteProyecto(
                                                                getJsonField(
                                                                  arrayEnProgresoOffItem,
                                                                  r'''$.id_project''',
                                                                ).toString(),
                                                              );
                                                            },
                                                            text: 'Reporte',
                                                            options:
                                                                FFButtonOptions(
                                                              height: 35.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                              iconAlignment:
                                                                  IconAlignment
                                                                      .start,
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: Color(
                                                                  0x005CA828),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .enProgreso,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                              elevation: 0.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 17.0)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if ((_model.autioriaType == 'todas') ||
                            (_model.autioriaType == 'completadas'))
                          Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 45.0, 0.0, 45.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .completada,
                                          size: 30.0,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            if (_model.estaconectado ?? false) {
                                              return FutureBuilder<
                                                  ApiCallResponse>(
                                                future: SupabaseGroup
                                                    .getProjectsCall
                                                    .call(
                                                  filters:
                                                      '?progress=eq.100&assign_user=eq.${FFAppState().currentUser.uidUsuario}',
                                                  offset: 0,
                                                  limit: 2500,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final richTextGetProjectsResponse =
                                                      snapshot.data!;

                                                  return RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Completadas',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 25.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: ' ',
                                                          style: TextStyle(),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '(${valueOrDefault<String>(
                                                            functions
                                                                .getProyectsComplete(
                                                                    functions
                                                                        .getProyectosSearchCodigoNombre(
                                                                            FFAppState().jsonProyectos ?? [],
                                                                            _model.txtidTextController.text,
                                                                            FFAppState().currentUser.uidUsuario),
                                                                    FFAppState().currentUser.uidUsuario)
                                                                .length
                                                                .toString(),
                                                            '0',
                                                          )})',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 25.0,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Completadas',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 25.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: ' ',
                                                      style: TextStyle(),
                                                    ),
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        functions
                                                            .getProyectsCompleteCount(
                                                                functions.getProyectosSearchCodigoNombre(
                                                                    FFAppState().jsonProyectos ?? [],
                                                                    _model.txtidTextController.text,
                                                                    FFAppState().currentUser.uidUsuario),
                                                                assignUser: FFAppState().currentUser.uidUsuario)
                                                            .toString(),
                                                        '0',
                                                      ),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: TextStyle(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (_model.estaconectado ?? false) {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: FutureBuilder<ApiCallResponse>(
                                            future: (_model
                                                        .apiRequestCompleter2 ??=
                                                    Completer<ApiCallResponse>()
                                                      ..complete(SupabaseGroup
                                                          .getProjectsCall
                                                          .call(
                                                        filters:
                                                            '?progress=eq.100&assign_user=eq.${FFAppState().currentUser.uidUsuario}&or=(name.${'ilike.%${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? '%${_model.txtidTextController.text}%' : '%%'}%'},id_project.${'eq.${_model.txtidTextController.text != null && _model.txtidTextController.text != '' ? _model.txtidTextController.text : '*'}'})',
                                                        offset: 0,
                                                        limit: 2500,
                                                      )))
                                                .future,
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final listViewCompletasGetProjectsResponse =
                                                  snapshot.data!;

                                              return Builder(
                                                builder: (context) {
                                                  final arregloCompletas = functions
                                                      .getProyectosSearchCodigoNombre(
                                                          _model.completasJson ??
                                                              [],
                                                          _model
                                                              .txtidTextController
                                                              .text,
                                                          FFAppState()
                                                              .currentUser
                                                              .uidUsuario);
                                                  if (arregloCompletas
                                                      .isEmpty) {
                                                    return LoadingListTottusWidget(
                                                      texto:
                                                          'No hay auditorías completas.',
                                                    );
                                                  }

                                                  return RefreshIndicator(
                                                    key: Key(
                                                        'RefreshIndicator_3953tgy1'),
                                                    onRefresh: () async {
                                                      safeSetState(() => _model
                                                              .apiRequestCompleter2 =
                                                          null);
                                                      await _model
                                                          .waitForApiRequestCompleted2();
                                                    },
                                                    child: ListView.separated(
                                                      padding: EdgeInsets.zero,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          arregloCompletas
                                                              .length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              height: 15.0),
                                                      itemBuilder: (context,
                                                          arregloCompletasIndex) {
                                                        final arregloCompletasItem =
                                                            arregloCompletas[
                                                                arregloCompletasIndex];
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFF0F1F1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.name''',
                                                                          )?.toString(),
                                                                          'name',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    wrapWithModel(
                                                                      model: _model
                                                                          .containerCompletaModels1
                                                                          .getModel(
                                                                        arregloCompletasIndex
                                                                            .toString(),
                                                                        arregloCompletasIndex,
                                                                      ),
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          ContainerCompletaWidget(
                                                                        key:
                                                                            Key(
                                                                          'Keypg0_${arregloCompletasIndex.toString()}',
                                                                        ),
                                                                        tipoMatriz:
                                                                            valueOrDefault<String>(
                                                                          getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                          'matriz',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          5.0)),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arregloCompletasItem,
                                                                          r'''$.id_project''',
                                                                        )?.toString(),
                                                                        'id_project',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w300,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          5.0)),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Opacity(
                                                                      opacity:
                                                                          0.0,
                                                                      child:
                                                                          Text(
                                                                        '${valueOrDefault<String>(
                                                                          getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.aaaa''',
                                                                          )?.toString(),
                                                                          '1',
                                                                        )} Controles',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await _model
                                                                            .objetives(
                                                                          context,
                                                                          idProyecto:
                                                                              getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.id_project''',
                                                                          ).toString(),
                                                                          title:
                                                                              getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.name''',
                                                                          ).toString(),
                                                                          tipoMatriz:
                                                                              getJsonField(
                                                                            arregloCompletasItem,
                                                                            r'''$.matrix_type''',
                                                                          )?.toString(),
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Ver',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_right_alt,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            35.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        iconAlignment:
                                                                            IconAlignment.end,
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Colors
                                                                            .transparent,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: TextStyle(
                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).completada,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Avance',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        getJsonField(
                                                                          arregloCompletasItem,
                                                                          r'''$.progress''',
                                                                        )?.toString(),
                                                                        '0',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).completada,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                LinearPercentIndicator(
                                                                  percent:
                                                                      valueOrDefault<
                                                                          double>(
                                                                    double.parse((valueOrDefault<
                                                                                double>(
                                                                              getJsonField(
                                                                                arregloCompletasItem,
                                                                                r'''$.progress''',
                                                                              ),
                                                                              0.0,
                                                                            ) /
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            0)),
                                                                    0.0,
                                                                  ),
                                                                  lineHeight:
                                                                      12.0,
                                                                  animation:
                                                                      true,
                                                                  animateFromLastPercent:
                                                                      true,
                                                                  progressColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .completada,
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .progresBarColor,
                                                                  barRadius: Radius
                                                                      .circular(
                                                                          5.0),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .generarPDFReporteProyecto(
                                                                      getJsonField(
                                                                        arregloCompletasItem,
                                                                        r'''$.id_project''',
                                                                      ).toString(),
                                                                    );
                                                                  },
                                                                  text:
                                                                      'Reporte',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        35.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                    iconAlignment:
                                                                        IconAlignment
                                                                            .start,
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: Color(
                                                                        0x005CA828),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height:
                                                                      17.0)),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final arregloCompletasOff =
                                                  functions
                                                      .getProyectsComplete(
                                                          FFAppState().jsonProyectos ?? [],
                                                          FFAppState()
                                                              .currentUser
                                                              .uidUsuario)
                                                      .toList();
                                              if (arregloCompletasOff.isEmpty) {
                                                return LoadingListTottusWidget(
                                                  texto:
                                                      'No hay auditorías completas.',
                                                );
                                              }

                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    arregloCompletasOff.length,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 15.0),
                                                itemBuilder: (context,
                                                    arregloCompletasOffIndex) {
                                                  final arregloCompletasOffItem =
                                                      arregloCompletasOff[
                                                          arregloCompletasOffIndex];
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F1F1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.name''',
                                                                    )?.toString(),
                                                                    'name',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              wrapWithModel(
                                                                model: _model
                                                                    .containerCompletaModels2
                                                                    .getModel(
                                                                  arregloCompletasOffIndex
                                                                      .toString(),
                                                                  arregloCompletasOffIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    ContainerCompletaWidget(
                                                                  key: Key(
                                                                    'Key0y2_${arregloCompletasOffIndex.toString()}',
                                                                  ),
                                                                  tipoMatriz:
                                                                      valueOrDefault<
                                                                          String>(
                                                                    getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.matrix_type''',
                                                                    )?.toString(),
                                                                    'matriz',
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 5.0)),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    arregloCompletasOffItem,
                                                                    r'''$.id_project''',
                                                                  )?.toString(),
                                                                  'id_project',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 5.0)),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Opacity(
                                                                opacity: 0.0,
                                                                child: Text(
                                                                  '${valueOrDefault<String>(
                                                                    getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.aaaa''',
                                                                    )?.toString(),
                                                                    '1',
                                                                  )} Controles',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await _model
                                                                      .objetives(
                                                                    context,
                                                                    idProyecto:
                                                                        getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.id_project''',
                                                                    ).toString(),
                                                                    title:
                                                                        getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.name''',
                                                                    ).toString(),
                                                                    tipoMatriz:
                                                                        getJsonField(
                                                                      arregloCompletasOffItem,
                                                                      r'''$.matrix_type''',
                                                                    )?.toString(),
                                                                  );
                                                                },
                                                                text: 'Ver',
                                                                icon: Icon(
                                                                  Icons
                                                                      .arrow_right_alt,
                                                                  size: 20.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 35.0,
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                  iconAlignment:
                                                                      IconAlignment
                                                                          .end,
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Colors
                                                                      .transparent,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .completada,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Avance',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    arregloCompletasOffItem,
                                                                    r'''$.progress''',
                                                                  )?.toString(),
                                                                  '0',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .completada,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          LinearPercentIndicator(
                                                            percent:
                                                                valueOrDefault<
                                                                    double>(
                                                              double.parse(
                                                                  (valueOrDefault<
                                                                              double>(
                                                                            getJsonField(
                                                                              arregloCompletasOffItem,
                                                                              r'''$.progress''',
                                                                            ),
                                                                            0.0,
                                                                          ) /
                                                                          100)
                                                                      .toStringAsFixed(
                                                                          0)),
                                                              0.0,
                                                            ),
                                                            lineHeight: 12.0,
                                                            animation: true,
                                                            animateFromLastPercent:
                                                                true,
                                                            progressColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .completada,
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .progresBarColor,
                                                            barRadius:
                                                                Radius.circular(
                                                                    5.0),
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              await actions
                                                                  .generarPDFReporteProyecto(
                                                                getJsonField(
                                                                  arregloCompletasOffItem,
                                                                  r'''$.id_project''',
                                                                ).toString(),
                                                              );
                                                            },
                                                            text: 'Reporte',
                                                            options:
                                                                FFButtonOptions(
                                                              height: 35.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                              iconAlignment:
                                                                  IconAlignment
                                                                      .start,
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: Color(
                                                                  0x005CA828),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                              elevation: 0.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 17.0)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    ].divide(SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
