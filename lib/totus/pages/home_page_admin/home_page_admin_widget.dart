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
import '/totus/components/container_admin/container_admin_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/actions/index.dart' show ImportResult, SyncAdminResult;
import '/custom_code/DBSyncLogs.dart';
import '/custom_code/InternetCheckMixin.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_admin_model.dart';
export 'home_page_admin_model.dart';

class HomePageAdminWidget extends StatefulWidget {
  const HomePageAdminWidget({super.key});

  static String routeName = 'HomePageAdmin';
  static String routePath = '/homePageAdmin';

  @override
  State<HomePageAdminWidget> createState() => _HomePageAdminWidgetState();
}

class _HomePageAdminWidgetState extends State<HomePageAdminWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver, InternetCheckMixin {
  late HomePageAdminModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageAdminModel());

    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // 🌐 Cargar proyectos Highbond en paralelo (solo si hay internet)
      _cargarProyectosHighbondEnParalelo();

      // Cargar última sincronización desde SQLite
      try {
        final ultimoSync = await DBSyncLogs.getUltimoSync();
        if (ultimoSync != null && ultimoSync['sync_end'] != null) {
          String syncEndStr = ultimoSync['sync_end'].toString();

          // Parsear como UTC y convertir a local
          DateTime? fecha;
          if (syncEndStr.endsWith('Z') || syncEndStr.contains('+')) {
            fecha = DateTime.tryParse(syncEndStr)?.toLocal();
          } else {
            // Si no tiene zona horaria, asumimos que es hora LOCAL (guardada con DateTime.now())
            fecha = DateTime.tryParse(syncEndStr);
          }

          if (fecha != null) {
            FFAppState().ultimaSincronizacion = fecha;
            safeSetState(() {});
          }
        }
      } catch (e) {
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

  /// Lee los proyectos desde la tabla cache de Supabase con paginación.
  /// El sync con Highbond lo hace el cron job en background cada 2 horas.
  void _cargarProyectosHighbondEnParalelo() {
    _fetchAllHighbondProjects().then((projects) {
      if (!mounted) return;
      if (projects.isNotEmpty) {
        FFAppState().jsonHighbondProjects = projects.cast<dynamic>();
      }
    }).catchError((e) {
    });
  }

  Future<List<Map<String, String>>> _fetchAllHighbondProjects() async {
    const pageSize = 1000;
    const batchSize = 5; // 5 requests en paralelo a la vez
    const maxPages = 25; // soporta hasta 25.000 proyectos

    final List<Map<String, String>> all = [];
    for (int batch = 0; batch < maxPages; batch += batchSize) {
      final end = (batch + batchSize).clamp(0, maxPages);
      final futures = List.generate(end - batch, (i) => SupaFlow.client
          .from('highbond_projects_cache')
          .select('id_highbond, name')
          .range((batch + i) * pageSize, (batch + i + 1) * pageSize - 1));

      final results = await Future.wait(futures);
      bool anyResults = false;
      for (final rows in results) {
        for (final r in (rows as List)) {
          final id = r['id_highbond']?.toString() ?? '';
          if (id.isNotEmpty) {
            all.add({'id': id, 'name': r['name']?.toString() ?? ''});
            anyResults = true;
          }
        }
      }
      // Si ningún resultado en este batch, terminamos
      if (!anyResults) break;
    }
    return all;
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/download__7_-removebg-preview.png',
                    width: 135.5,
                    height: 46.3,
                    fit: BoxFit.contain,
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
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: Container(
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
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  if (!(_model.estaconectado ?? false)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Sin conexión. Los cambios se sincronizarán cuando vuelvas a conectarte.',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                        ),
                                        duration: const Duration(milliseconds: 3000),
                                        backgroundColor: Colors.orange[700],
                                      ),
                                    );
                                    return;
                                  }

                                  final syncResult = await actions.sincronizarAdmin();

                                  _model.masivodb = await actions.sqlLiteListProyectos();
                                  _model.usersMasivo = await actions.sqLiteListUsers();
                                  FFAppState().jsonProyectos =
                                      _model.masivodb!.toList().cast<dynamic>();
                                  FFAppState().jsonUsers =
                                      _model.usersMasivo!.toList().cast<dynamic>();
                                  safeSetState(() {});

                                  if (context.mounted) {
                                    // El mensaje ya viene con ✅ o sin prefijo desde sincronizarAdmin
                                    final bool sinCambios = syncResult.exito && !syncResult.huboCambiosPendientes && syncResult.usuariosSincronizados == 0;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          syncResult.exito
                                              ? syncResult.mensaje
                                              : '⚠️ ${syncResult.mensaje}',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                        ),
                                        duration: const Duration(milliseconds: 4000),
                                        backgroundColor: !syncResult.exito
                                            ? Colors.orange[700]
                                            : sinCambios
                                                ? Colors.grey[700]
                                                : FlutterFlowTheme.of(context).secondary,
                                      ),
                                    );
                                  }
                                },
                              ).animateOnPageLoad(animationsMap[
                                  'iconButtonOnPageLoadAnimation']!),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: Container(
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
                              16.0, 8.0, 16.0, 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  '💠 Estado del sistema',
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
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Integración HighBond:',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                          Text(
                                            'Activa',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Matrices cargadas:',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                          Text(
                                            valueOrDefault<String>(
                                              FFAppState()
                                                  .jsonMatrices
                                                  .length
                                                  .toString(),
                                              '0',
                                            ),
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Usuarios registrados:',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                          Text(
                                            valueOrDefault<String>(
                                              FFAppState()
                                                  .jsonUsers
                                                  .length
                                                  .toString(),
                                              '0',
                                            ),
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Última sincronización:',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                          Text(
                                            dateTimeFormat(
                                              "dd/MM/yyyy HH:mm",
                                              FFAppState().ultimaSincronizacion,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.push_pin,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Funciones Principales',
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
                              _model.usersMasivo1 =
                                  await actions.sqLiteListUsers();
                              FFAppState().jsonUsers =
                                  _model.usersMasivo1!.toList().cast<dynamic>();
                              safeSetState(() {});
                              await _model.cargarMatrices(context);

                              context.goNamed(CreateProyectosWidget.routeName);

                              safeSetState(() {});
                            },
                            child: wrapWithModel(
                              model: _model.containerAdminModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '📄',
                                name: 'Proyectos',
                                description: 'Crear Proyectos',
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await _model.cargarMatrices(context);

                              context.goNamed(MatricesWidget.routeName);
                            },
                            child: wrapWithModel(
                              model: _model.containerAdminModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '🧮',
                                name: 'Matrices',
                                description: 'Crear Matrices',
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(UsuariosWidget.routeName);
                            },
                            child: wrapWithModel(
                              model: _model.containerAdminModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '👥',
                                name: 'Usuarios',
                                description:
                                    'Crear, activar, desactivar usuarios',
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await _model.cargarMatrices(context);

                              context.pushNamed(
                                HallazgosWidget.routeName,
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
                              model: _model.containerAdminModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '🔍',
                                name: 'Observaciones',
                                description: 'Gestión de observaciones',
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(LogsWidget.routeName);
                            },
                            child: wrapWithModel(
                              model: _model.containerAdminModel5,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '🔁',
                                name: 'Logs de sincronización',
                                description:
                                    'Errores, historial, registro por auditor',
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              void Function(String paso, int actual, int total)? actualizarProgreso;

                              // Estado del diálogo de progreso
                              String progresoPaso = 'Iniciando importación...';
                              int progresoActual = 0;
                              int progresoTotal = 0;

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) {
                                  return StatefulBuilder(
                                    builder: (ctx, setDialogState) {
                                      actualizarProgreso = (paso, actual, total) {
                                        if (ctx.mounted) {
                                          setDialogState(() {
                                            progresoPaso = paso;
                                            progresoActual = actual;
                                            progresoTotal = total;
                                          });
                                        }
                                      };

                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 64.0,
                                                height: 64.0,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE8F5E9),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.upload_file_outlined,
                                                  color: Color(0xFF43A047),
                                                  size: 32.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              const Text(
                                                'Importando hallazgos',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                progresoPaso,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: LinearProgressIndicator(
                                                  value: progresoTotal > 0
                                                      ? (progresoActual / progresoTotal).clamp(0.0, 1.0)
                                                      : null,
                                                  minHeight: 8.0,
                                                  backgroundColor: Colors.grey[200],
                                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF43A047),
                                                  ),
                                                ),
                                              ),
                                              if (progresoTotal > 0) ...[
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  '$progresoActual / $progresoTotal',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(height: 12.0),
                                              Text(
                                                'Por favor espera, no cierres la app...',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );

                              final ImportResult importResult = await actions.importarHallazgos(
                                onProgress: (paso, actual, total) {
                                  actualizarProgreso?.call(paso, actual, total);
                                },
                              );

                              if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
                              actualizarProgreso = null;

                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (resultContext) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 64.0,
                                              height: 64.0,
                                              decoration: BoxDecoration(
                                                color: importResult.success
                                                    ? const Color(0xFFE8F5E9)
                                                    : const Color(0xFFFFEBEB),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                importResult.success
                                                    ? Icons.check_circle_outline
                                                    : Icons.error_outline,
                                                color: importResult.success
                                                    ? const Color(0xFF43A047)
                                                    : const Color(0xFFE53935),
                                                size: 32.0,
                                              ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text(
                                              importResult.success
                                                  ? '✅ Importación completada'
                                                  : '❌ Error en la importación',
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12.0),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                importResult.message,
                                                style: const TextStyle(fontSize: 13.0),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Column(
                                              children: [
                                                // Botón ACEPTAR (siempre visible)
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () => Navigator.pop(resultContext),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: importResult.success
                                                          ? const Color(0xFF43A047)
                                                          : Colors.grey[700],
                                                      foregroundColor: Colors.white,
                                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                    ),
                                                    child: const Text('Aceptar'),
                                                  ),
                                                ),
                                                // Botón DESHACER (solo si hay datos insertados)
                                                if (importResult.success && importResult.tieneRollback) ...[
                                                  const SizedBox(height: 10.0),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: OutlinedButton.icon(
                                                      onPressed: () async {
                                                        Navigator.pop(resultContext);

                                                        void Function(String, int, int)? actualizarRollback;
                                                        String rollbackPaso = 'Deshaciendo cambios...';
                                                        int rollbackActual = 0;
                                                        int rollbackTotal = 0;

                                                        if (context.mounted) {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (rbCtx) {
                                                              return StatefulBuilder(
                                                                builder: (rbCtx2, setRbState) {
                                                                  actualizarRollback = (paso, actual, total) {
                                                                    if (rbCtx2.mounted) {
                                                                      setRbState(() {
                                                                        rollbackPaso = paso;
                                                                        rollbackActual = actual;
                                                                        rollbackTotal = total;
                                                                      });
                                                                    }
                                                                  };
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(16.0),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(24.0),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            width: 64.0,
                                                                            height: 64.0,
                                                                            decoration: const BoxDecoration(
                                                                              color: Color(0xFFFFEBEB),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.undo_rounded,
                                                                              color: Color(0xFFE53935),
                                                                              size: 32.0,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 16.0),
                                                                          const Text(
                                                                            'Deshaciendo importación',
                                                                            style: TextStyle(
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 8.0),
                                                                          Text(
                                                                            rollbackPaso,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: Colors.grey[600],
                                                                              fontSize: 13.0,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 16.0),
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                            child: LinearProgressIndicator(
                                                                              value: rollbackTotal > 0
                                                                                  ? (rollbackActual / rollbackTotal).clamp(0.0, 1.0)
                                                                                  : null,
                                                                              minHeight: 8.0,
                                                                              backgroundColor: Colors.grey[200],
                                                                              valueColor: const AlwaysStoppedAnimation<Color>(
                                                                                Color(0xFFE53935),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (rollbackTotal > 0) ...[
                                                                            const SizedBox(height: 4.0),
                                                                            Text(
                                                                              '$rollbackActual / $rollbackTotal',
                                                                              style: TextStyle(
                                                                                color: Colors.grey[500],
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          const SizedBox(height: 12.0),
                                                                          Text(
                                                                            'Por favor espera...',
                                                                            style: TextStyle(
                                                                              color: Colors.grey[500],
                                                                              fontSize: 12.0,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        }

                                                        await actions.deshacerImportacion(
                                                          result: importResult,
                                                          onProgress: (paso, actual, total) {
                                                            actualizarRollback?.call(paso, actual, total);
                                                          },
                                                        );

                                                        if (context.mounted) {
                                                          Navigator.of(context, rootNavigator: true).pop();
                                                        }
                                                        actualizarRollback = null;

                                                        if (context.mounted) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (doneCtx) => Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16.0),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(24.0),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Container(
                                                                      width: 64.0,
                                                                      height: 64.0,
                                                                      decoration: const BoxDecoration(
                                                                        color: Color(0xFFE8F5E9),
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: const Icon(
                                                                        Icons.check_circle_outline,
                                                                        color: Color(0xFF43A047),
                                                                        size: 32.0,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 16.0),
                                                                    const Text(
                                                                      'Importación deshecha',
                                                                      style: TextStyle(
                                                                        fontSize: 18.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 8.0),
                                                                    Text(
                                                                      'Todos los datos importados han sido eliminados correctamente.',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.grey[600],
                                                                        fontSize: 13.0,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 20.0),
                                                                    SizedBox(
                                                                      width: double.infinity,
                                                                      child: ElevatedButton(
                                                                        onPressed: () => Navigator.pop(doneCtx),
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: const Color(0xFF43A047),
                                                                          foregroundColor: Colors.white,
                                                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                        child: const Text('Entendido'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.undo_rounded,
                                                        color: Color(0xFFE53935),
                                                      ),
                                                      label: const Text(
                                                        'Deshacer importación',
                                                        style: TextStyle(color: Color(0xFFE53935)),
                                                      ),
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(color: Color(0xFFE53935)),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              safeSetState(() {});
                            },
                            child: wrapWithModel(
                              model: _model.containerAdminModel6,
                              updateCallback: () => safeSetState(() {}),
                              child: ContainerAdminWidget(
                                icontext: '📥',
                                name: 'Importar Hallazgos',
                                description: 'Importar desde Excel',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ].divide(SizedBox(height: 12.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
