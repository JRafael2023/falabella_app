import '/backend/api_requests/api_calls.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/list_audits/list_audits_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import '/totus/components/tasks/tasks_widget.dart';
import 'dart:ui';
import '/custom_code/Proyecto.dart';
import '/custom_code/DBProyectos.dart';
import '/custom_code/DBUsuarios.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'logs_model.dart';
export 'logs_model.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({super.key});

  static String routeName = 'logs';
  static String routePath = '/logs';

  @override
  State<LogsWidget> createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late LogsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogsModel());

    // ⚡ Inicializar timer de internet con soporte para pausar cuando se minimiza
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Logs es página de admin → cargar TODOS los proyectos sin filtrar por usuario
      final todosProyectos = await DBProyectos.listarProyectos();
      final usuarios = await actions.sqLiteListUsers();
      FFAppState().update(() {
        FFAppState().jsonProyectos =
            todosProyectos.map((p) => p.toJson()).toList().cast<dynamic>();
        FFAppState().jsonUsers = usuarios?.toList().cast<dynamic>() ?? [];
      });
      print('📊 Logs: ${todosProyectos.length} proyectos cargados para admin');
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    // ⚡ Limpiar timer de internet
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
            leading: InkWell(
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
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/download__7_-removebg-preview.png',
                    width: 157.89,
                    height: 33.4,
                    fit: BoxFit.cover,
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
                        child: Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: wrapWithModel(
                            model: _model.wifiComponentModel,
                            updateCallback: () => safeSetState(() {}),
                            child: WifiComponentWidget(
                              conexion: _model.estaconectado ?? true,
                            ),
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
              ].divide(SizedBox(width: 8.0)),
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .containerColorPrimary,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 16.0, 8.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Logs de Sincronización',
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
                              Text(
                                'Monitoreo de sincronizaciones con HighBond',
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
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Todos los auditores',
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
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .cboAuditoresValueController ??=
                                                FormFieldController<String>(
                                                    null),
                                            options: List<String>.from(
                                                functions.getAuditoresUserIds(
                                                    FFAppState()
                                                        .jsonUsers
                                                        .toList())),
                                            optionLabels: functions
                                                .getAuditoresDisplayNames(
                                                    FFAppState()
                                                        .jsonUsers
                                                        .toList()),
                                            onChanged: (val) => safeSetState(
                                                () => _model.cboAuditoresValue =
                                                    val),
                                            height: 50.0,
                                            maxHeight: 200.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                            hintText: 'Seleccione',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .customColor4bbbbb,
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 5.0)),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Todos los países',
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
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .cboPaisValueController ??=
                                                FormFieldController<String>(null),
                                            options:
                                                functions.getAllCountryListv(),
                                            onChanged: (val) => safeSetState(
                                                () =>
                                                    _model.cboPaisValue = val),
                                            height: 50.0,
                                            maxHeight: 200.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                            hintText: 'Seleccione',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .customColor4bbbbb,
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 5.0)),
                                    ),
                                  ),
                                ],
                              ),
                              // ── Botón limpiar filtros ─────────────────────
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: TextButton.icon(
                                  onPressed: () {
                                    safeSetState(() {
                                      _model.cboAuditoresValue = null;
                                      _model.cboAuditoresValueController
                                          ?.reset();
                                      _model.cboPaisValue = null;
                                      _model.cboPaisValueController?.reset();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.filter_alt_off_outlined,
                                    size: 18.0,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                  label: Text(
                                    'Limpiar filtros',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 32.0),
                                  child: Wrap(
                                    spacing: 16.0,
                                    runSpacing: 0.0,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .containerColorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor4bbbbb,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    functions
                                                        .countAuditoriasPendientes(
                                                            FFAppState()
                                                                .jsonProyectos
                                                                .toList(),
                                                            _model
                                                                .cboAuditoresValue,
                                                            _model.cboPaisValue,
                                                            FFAppState()
                                                                .jsonUsers
                                                                .toList())
                                                        .toString(),
                                                    '0',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
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
                                                Text(
                                                  'Auditorías pendientes',
                                                  textAlign: TextAlign.center,
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                              ].divide(SizedBox(height: 11.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Auditorías Pendientes',
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
                              Container(
                                decoration: BoxDecoration(),
                                child: Builder(
                                  builder: (context) {
                                    final arrayProyectosAuditores = functions
                                        .filterProyectos(
                                            FFAppState().jsonProyectos.toList(),
                                            _model.cboAuditoresValue,
                                            _model.cboPaisValue,
                                            FFAppState().jsonUsers.toList())
                                        .toList();
                                    if (arrayProyectosAuditores.isEmpty) {
                                      return LoadingListTottusWidget(
                                        texto: 'No hay Audtorias',
                                      );
                                    }

                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: arrayProyectosAuditores.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 12.0),
                                      itemBuilder: (context,
                                          arrayProyectosAuditoresIndex) {
                                        final arrayProyectosAuditoresItem =
                                            arrayProyectosAuditores[
                                                arrayProyectosAuditoresIndex];
                                        return wrapWithModel(
                                          model:
                                              _model.listAuditsModels.getModel(
                                            arrayProyectosAuditoresIndex
                                                .toString(),
                                            arrayProyectosAuditoresIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: ListAuditsWidget(
                                            key: Key(
                                              'Key3c8_${arrayProyectosAuditoresIndex.toString()}',
                                            ),
                                            idProject: getJsonField(
                                              arrayProyectosAuditoresItem,
                                              r'''$.id_project''',
                                            ).toString(),
                                            name: getJsonField(
                                              arrayProyectosAuditoresItem,
                                              r'''$.name''',
                                            ).toString(),
                                            assignUser: getJsonField(
                                              arrayProyectosAuditoresItem,
                                              r'''$.assign_user''',
                                            ).toString(),
                                            progress: getJsonField(
                                              arrayProyectosAuditoresItem,
                                              r'''$.progress''',
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ].divide(SizedBox(height: 11.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .containerColorPrimary,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 4.0, 8.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Historial de tareas enviadas a HighBond',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                    FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      showLoadingIndicator: true,
                                      icon: Icon(
                                        Icons.refresh_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20.0,
                                      ),
                                      onPressed: () async {
                                        safeSetState(() =>
                                            _model.apiRequestCompleter = null);
                                        await _model
                                            .waitForApiRequestCompleted(
                                                minWait: 1000);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder<ApiCallResponse>(
                                future: (_model.apiRequestCompleter ??=
                                        Completer<ApiCallResponse>()
                                          ..complete(SupabaseFunctionsGroup
                                              .getTaksHighbondCall
                                              .call()))
                                    .future,
                                builder: (context, snapshot) {
                                  // Show loading indicator
                                  if (!snapshot.hasData) {
                                    // ✅ Error de red / sin conexión
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(24.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.wifi_off_rounded,
                                                size: 48.0,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                              SizedBox(height: 12.0),
                                              Text(
                                                'Sin conexión',
                                                style: FlutterFlowTheme.of(context).titleSmall,
                                              ),
                                              SizedBox(height: 6.0),
                                              Text(
                                                'El historial de HighBond requiere conexión a internet.',
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(context).bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          width: 40.0,
                                          height: 40.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final containerTasksGetTaksHighbondResponse =
                                      snapshot.data!;
                                  // ✅ FIX: jsonBody puede ser null cuando no hay conexión
                                  final arrayTasks =
                                      (containerTasksGetTaksHighbondResponse
                                              .jsonBody?['data']?['tasks'] as List?) ??
                                          [];

                                  if (arrayTasks.isEmpty) {
                                    return LoadingListTottusWidget(
                                      texto: 'No hay Tasks disponibles',
                                    );
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      arrayTasks.length,
                                      (arrayTasksIndex) {
                                        final arrayTasksItem =
                                            arrayTasks[arrayTasksIndex];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: arrayTasksIndex <
                                                      arrayTasks.length - 1
                                                  ? 8.0
                                                  : 0.0),
                                          child: wrapWithModel(
                                            model:
                                                _model.tasksModels.getModel(
                                              arrayTasksIndex.toString(),
                                              arrayTasksIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: TasksWidget(
                                              key: Key(
                                                'Keyuwi_${arrayTasksIndex.toString()}',
                                              ),
                                              taskID: getJsonField(
                                                arrayTasksItem,
                                                r'''$.task_id''',
                                              ).toString(),
                                              status: getJsonField(
                                                arrayTasksItem,
                                                r'''$.status''',
                                              ).toString(),
                                              message: getJsonField(
                                                arrayTasksItem,
                                                r'''$.message''',
                                              ).toString(),
                                              createdat: getJsonField(
                                                arrayTasksItem,
                                                r'''$.created_at''',
                                              ).toString(),
                                              updatedat: getJsonField(
                                                arrayTasksItem,
                                                r'''$.updated_at''',
                                              ).toString(),
                                              clientip: getJsonField(
                                                arrayTasksItem,
                                                r'''$.client_ip''',
                                              ).toString(),
                                              item: functions.indexConvert(
                                                  arrayTasksIndex),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ].divide(SizedBox(height: 11.0)),
                          ),
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
