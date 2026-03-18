import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
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
import '/totus/card_projects/card_projects_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/Proyecto.dart';
import '/custom_code/Usuario.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/custom_code/InternetCheckMixin.dart';
import 'create_proyectos_model.dart';
export 'create_proyectos_model.dart';

class CreateProyectosWidget extends StatefulWidget {
  const CreateProyectosWidget({super.key});

  static String routeName = 'CreateProyectos';
  static String routePath = '/createProyectos';

  @override
  State<CreateProyectosWidget> createState() => _CreateProyectosWidgetState();
}

class _CreateProyectosWidgetState extends State<CreateProyectosWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late CreateProyectosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateProyectosModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Inicializar timer pausable de internet
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });
    });

    _model.txtidTextController ??= TextEditingController();
    _model.txtidFocusNode ??= FocusNode();

    _model.txtnombreTextController ??= TextEditingController();
    _model.txtnombreFocusNode ??= FocusNode();

    _model.txtdescTextController ??= TextEditingController();
    _model.txtdescFocusNode ??= FocusNode();

    _model.txtopinionTextController ??= TextEditingController();
    _model.txtopinionFocusNode ??= FocusNode();

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
                    width: 157.9,
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
                        constraints: const BoxConstraints(
                          minWidth: 40.0,
                          minHeight: 40.0,
                          maxWidth: 40.0,
                          maxHeight: 40.0,
                        ),
                        decoration: const BoxDecoration(),
                        child: Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: wrapWithModel(
                            model: _model.wifiComponentModel,
                            updateCallback: () => safeSetState(() {}),
                            child: WifiComponentWidget(
                              conexion: _model.estaconectado!,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        constraints: const BoxConstraints(
                          minWidth: 40.0,
                          minHeight: 40.0,
                          maxWidth: 40.0,
                          maxHeight: 40.0,
                        ),
                        decoration: const BoxDecoration(),
                        child: wrapWithModel(
                          model: _model.exitComponentModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ExitComponentWidget(),
                        ),
                      ),
                    ].divide(const SizedBox(width: 16.0)),
                  ),
                ),
              ].divide(const SizedBox(width: 8.0)),
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ── Fila título + botón Crear ──────────────────────────
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listado de Proyectos',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              font: TextStyle(fontWeight: FontWeight.bold),
                              letterSpacing: 0.0,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          String? _modalErrorMsg;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            useSafeArea: true,
                            builder: (modalContext) => StatefulBuilder(
                              builder: (ctx, setModalState) {
                                void mostrarError(String msg) {
                                  setModalState(() => _modalErrorMsg = msg);
                                  Future.delayed(const Duration(seconds: 3), () {
                                    setModalState(() => _modalErrorMsg = null);
                                  });
                                }
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(modalContext),
                                  child: _buildFormProyecto(ctx, _modalErrorMsg, mostrarError, setModalState),
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18.0),
                        label: const Text('Crear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          textStyle: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  // ── Lista de proyectos ─────────────────────────────────
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (_model.estaconectado ?? false) {
                          return FutureBuilder<List<ProjectsRow>>(
                            future: ProjectsTable().queryRows(
                              queryFn: (q) => q.order('created_at', ascending: true),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: LoadingListTottusWidget(
                                    texto: 'Lista de Proyectos Vacia',
                                  ),
                                );
                              }
                              List<ProjectsRow> containerProjectsRowList = snapshot.data!;

                              if (containerProjectsRowList.isEmpty) {
                                return Center(
                                  child: LoadingListTottusWidget(
                                    texto: 'Lista de Proyectos Vacia',
                                  ),
                                );
                              }

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: containerProjectsRowList.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                                itemBuilder: (context, arrayProjectONIndex) {
                                  final arrayProjectONItem =
                                      containerProjectsRowList[arrayProjectONIndex];
                                  return wrapWithModel(
                                    model: _model.cardProjectsModels1.getModel(
                                      arrayProjectONIndex.toString(),
                                      arrayProjectONIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: CardProjectsWidget(
                                      key: Key('Key94q_${arrayProjectONIndex.toString()}'),
                                      nombre: arrayProjectONItem.name,
                                      descripcion: arrayProjectONItem.description,
                                      estado: arrayProjectONItem.projectState,
                                      estatus: arrayProjectONItem.projectStatus,
                                      idProyecto: arrayProjectONItem.idProject,
                                      tipoMatriz: arrayProjectONItem.matrixType,
                                      userId: arrayProjectONItem.assignUser,
                                      opinion: arrayProjectONItem.opinion,
                                      updateCardProject: (idProyecto) async {
                                        await ProjectsTable().delete(
                                          matchingRows: (rows) => rows.eqOrNull('id_project', idProyecto),
                                        );
                                        _model.data = await actions.sqlLiteEliminarProyectos(idProyecto!);
                                        _model.returnsqllistSIBNBD = await actions.sqlLiteListProyectos();
                                        FFAppState().jsonProyectos =
                                            _model.returnsqllistSIBNBD!.toList().cast<dynamic>();
                                        FFAppState().update(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Proyecto Eliminado',
                                              style: TextStyle(color: FlutterFlowTheme.of(context).info),
                                            ),
                                            duration: const Duration(milliseconds: 4000),
                                            backgroundColor: FlutterFlowTheme.of(context).error,
                                          ),
                                        );
                                        safeSetState(() {});
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          // ── Modo offline ───────────────────────────────
                          final arrayOFFProjects = FFAppState().jsonProyectos.toList();
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: arrayOFFProjects.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                            itemBuilder: (context, arrayOFFProjectsIndex) {
                              final arrayOFFProjectsItem = arrayOFFProjects[arrayOFFProjectsIndex];
                              return wrapWithModel(
                                model: _model.cardProjectsModels2.getModel(
                                  arrayOFFProjectsIndex.toString(),
                                  arrayOFFProjectsIndex,
                                ),
                                updateCallback: () => safeSetState(() {}),
                                child: CardProjectsWidget(
                                  key: Key('Keyyno_${arrayOFFProjectsIndex.toString()}'),
                                  nombre: getJsonField(arrayOFFProjectsItem, r'''$.name''').toString(),
                                  descripcion: getJsonField(arrayOFFProjectsItem, r'''$.description''').toString(),
                                  estado: getJsonField(arrayOFFProjectsItem, r'''$.project_state''').toString(),
                                  estatus: getJsonField(arrayOFFProjectsItem, r'''$.project_status''').toString(),
                                  idProyecto: getJsonField(arrayOFFProjectsItem, r'''$.id_project''').toString(),
                                  tipoMatriz: getJsonField(arrayOFFProjectsItem, r'''$.matrix_type''').toString(),
                                  userId: getJsonField(arrayOFFProjectsItem, r'''$.assign_user''').toString(),
                                  opinion: getJsonField(arrayOFFProjectsItem, r'''$.opinion''').toString(),
                                  updateCardProject: (idProyecto) async {
                                    _model.dataSQLLite = await actions.sqlLiteEliminarProyectos(idProyecto!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Proyecto Eliminado',
                                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                                        ),
                                        duration: const Duration(milliseconds: 4000),
                                        backgroundColor: FlutterFlowTheme.of(context).error,
                                      ),
                                    );
                                    _model.returnsqllistSQlLite = await actions.sqlLiteListProyectos();
                                    FFAppState().jsonProyectos =
                                        _model.returnsqllistSQlLite!.toList().cast<dynamic>();
                                    safeSetState(() {});
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormProyecto(BuildContext context, String? errorMsg, void Function(String) mostrarError, StateSetter setModalState) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).colorFondoPrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
        child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .containerColorPrimary,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color:
                                FlutterFlowTheme.of(context).customColor4bbbbb,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 8.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Crear Proyecto',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FlutterFlowTheme.of(context)
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
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  4.0, 4.0, 4.0, 4.0),
                              child: Form(
                                key: _model.formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 8.0, 8.0, 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ID Proyecto',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
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
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .txtidTextController,
                                                    focusNode:
                                                        _model.txtidFocusNode,
                                                    autofocus: false,
                                                    enabled: true,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                      hintText: 'Escribe',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor4bbbbb,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .mouseregionTEXT,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
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
                                                    maxLines: null,
                                                    cursorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    enableInteractiveSelection:
                                                        true,
                                                    validator: _model
                                                        .txtidTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 5.0)),
                                            ),
                                          ),
                                          if (_model.estaconectado ?? true)
                                            FlutterFlowIconButton(
                                              borderRadius: 8.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              icon: Icon(
                                                Icons.search,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 24.0,
                                              ),
                                              showLoadingIndicator: true,
                                              onPressed: () async {
                                                _model.apiProyects =
                                                    await SupabaseFunctionsGroup
                                                        .getProjectsHighbondCall
                                                        .call();

                                                if ((_model.apiProyects
                                                        ?.succeeded ??
                                                    true)) {
                                                  // Pasar el jsonBody completo — filterAPI navega la estructura internamente
                                                  _model.jsonSearchProyect =
                                                      functions.filterAPI(
                                                          _model
                                                              .txtidTextController
                                                              .text
                                                              .trim(),
                                                          (_model.apiProyects
                                                                  ?.jsonBody ??
                                                              ''));
                                                  setModalState(() {});
                                                  if (_model
                                                          .jsonSearchProyect !=
                                                      null) {
                                                    // Acceso directo al Map para evitar problemas de getJsonField
                                                    final resultMap = _model.jsonSearchProyect as Map<String, dynamic>;
                                                    setModalState(() {
                                                      _model
                                                          .txtnombreTextController
                                                          ?.text = (resultMap['name'] ?? '').toString();
                                                    });
                                                  } else {
                                                    mostrarError('Proyecto no encontrado');
                                                  }
                                                } else {
                                                  mostrarError('Error de conexión con Highbond');
                                                  return;
                                                }
                                              },
                                            ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tipo de Matriz',
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
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .cbomatrixValueController ??=
                                                  FormFieldController<String>(
                                                _model.cbomatrixValue,
                                              ),
                                              options: FFAppState()
                                                  .jsonMatrices
                                                  .map((e) => getJsonField(
                                                        e,
                                                        r'''$.name''',
                                                      ))
                                                  .toList()
                                                  .unique((e) => e)
                                                  .map((e) => e.toString())
                                                  .toList(),
                                              onChanged: (val) {
                                                // ✅ setModalState para que el modal muestre el valor seleccionado
                                                setModalState(() {
                                                  _model.cbomatrixValue = val;
                                                  _model.cbomatrixValueController?.value = val;
                                                });
                                              },
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
                                                Icons
                                                    .keyboard_arrow_down_rounded,
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
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 5.0)),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Usuario a Asignar',
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
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .cboUserAssignValueController ??=
                                                  FormFieldController<String>(
                                                _model.cboUserAssignValue,
                                              ),
                                              options: List<String>.from(
                                                  FFAppState()
                                                      .jsonUsers
                                                      .where((e) {
                                                        final uid = getJsonField(e, r'''$.user_uid''');
                                                        return uid != null && uid.toString() != 'null' && uid.toString().isNotEmpty;
                                                      })
                                                      .map((e) => getJsonField(e, r'''$.user_uid''').toString())
                                                      .toList()),
                                              optionLabels: FFAppState()
                                                  .jsonUsers
                                                  .where((e) {
                                                    final uid = getJsonField(e, r'''$.user_uid''');
                                                    return uid != null && uid.toString() != 'null' && uid.toString().isNotEmpty;
                                                  })
                                                  .map((e) {
                                                    final name = getJsonField(e, r'''$.display_name''');
                                                    return (name != null && name.toString() != 'null') ? name.toString() : getJsonField(e, r'''$.email''').toString();
                                                  })
                                                  .toList(),
                                              onChanged: (val) {
                                                // ✅ setModalState para que el modal muestre el valor seleccionado
                                                setModalState(() {
                                                  _model.cboUserAssignValue = val;
                                                  _model.cboUserAssignValueController?.value = val;
                                                });
                                              },
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
                                                Icons
                                                    .keyboard_arrow_down_rounded,
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
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 5.0)),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nombre',
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
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: TextFormField(
                                              controller: _model
                                                  .txtnombreTextController,
                                              focusNode:
                                                  _model.txtnombreFocusNode,
                                              autofocus: false,
                                              enabled: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                hintText: 'Escribe',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              TextStyle(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor4bbbbb,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .mouseregionTEXT,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              style:
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
                                              maxLines: null,
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              enableInteractiveSelection: true,
                                              validator: _model
                                                  .txtnombreTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 5.0)),
                                      ),
                                      // ── Mensaje de error inline ─────────────────────────
                                      if (errorMsg != null)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEBEB),
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(color: const Color(0xFFE53935)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18.0),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  errorMsg!,
                                                  style: const TextStyle(
                                                    color: Color(0xFFE53935),
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 10.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  if (_model.formKey
                                                              .currentState ==
                                                          null ||
                                                      !_model
                                                          .formKey.currentState!
                                                          .validate()) {
                                                    return;
                                                  }
                                                  if (_model.cbomatrixValue == null ||
                                                      _model.cbomatrixValue!.isEmpty) {
                                                    mostrarError('Selecciona el tipo de matriz');
                                                    return;
                                                  }
                                                  if (_model.cboUserAssignValue == null ||
                                                      _model.cboUserAssignValue!.isEmpty) {
                                                    mostrarError('Selecciona un usuario a asignar');
                                                    return;
                                                  }
                                                  // Verificar duplicado de ID en proyectos existentes (local SQLite/cache)
                                                  final idIngresado = _model.txtidTextController.text.trim();
                                                  final existeLocal = FFAppState().jsonProyectos.any((p) =>
                                                    getJsonField(p, r'''$.id_project''').toString().trim().toLowerCase() ==
                                                    idIngresado.toLowerCase());
                                                  if (existeLocal) {
                                                    mostrarError('El ID de proyecto "$idIngresado" ya existe');
                                                    return;
                                                  }
                                                  // Si está conectado, verificar también contra Supabase
                                                  if (_model.estaconectado ?? false) {
                                                    final existenteSupabase = await ProjectsTable().queryRows(
                                                      queryFn: (q) => q.eqOrNull('id_project', idIngresado),
                                                    );
                                                    if (existenteSupabase.isNotEmpty) {
                                                      mostrarError('El ID de proyecto "$idIngresado" ya existe');
                                                      return;
                                                    }
                                                  }
                                                  if (_model.estaconectado ?? false) {
                                                    try {
                                                    _model.apiProyectsCREATE =
                                                        await SupabaseFunctionsGroup
                                                            .getProjectsHighbondCall
                                                            .call();

                                                    _model.jsonSearchProyect =
                                                        functions.filterAPI(
                                                            _model
                                                                .txtidTextController
                                                                .text,
                                                            getJsonField(
                                                              (_model.apiProyectsCREATE
                                                                      ?.jsonBody ??
                                                                  ''),
                                                              r'''$.data.data''',
                                                            ));
                                                    safeSetState(() {});
                                                    if (!(_model
                                                            .jsonSearchProyect !=
                                                        null)) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Advertencia: este proyecto no tiene objetivos asignados todavía.',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .colorFondoPrimary,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .nOIniciada,
                                                        ),
                                                      );
                                                    }
                                                    _model.returnCreateProject =
                                                        await ProjectsTable()
                                                            .insert({
                                                      'created_at': supaSerialize<
                                                              DateTime>(
                                                          getCurrentTimestamp),
                                                      'name': _model
                                                          .txtnombreTextController
                                                          .text,
                                                      'description': _model
                                                          .txtdescTextController
                                                          .text,
                                                      'project_state': 'active',
                                                      'project_status':
                                                          'incompleto',
                                                      'opinion': _model
                                                          .txtopinionTextController
                                                          .text,
                                                      'progress': 0.0,
                                                      'matrix_type':
                                                          _model.cbomatrixValue,
                                                      'assign_user': _model
                                                          .cboUserAssignValue,
                                                      'updated_at': supaSerialize<
                                                              DateTime>(
                                                          getCurrentTimestamp),
                                                      'status': true,
                                                      'id_project': _model
                                                          .txtidTextController
                                                          .text,
                                                    });
                                                    await actions
                                                        .insertProyectoSQLite(
                                                      _model.txtidTextController
                                                          .text,
                                                      _model
                                                          .txtnombreTextController
                                                          .text,
                                                      _model
                                                          .txtdescTextController
                                                          .text,
                                                      _model
                                                          .txtopinionTextController
                                                          .text,
                                                      0.0,
                                                      _model.cboUserAssignValue,
                                                      _model.cbomatrixValue,
                                                    );
                                                    _model.retunListSQLiteON =
                                                        await actions
                                                            .sqlLiteListProyectos();
                                                    FFAppState().jsonProyectos =
                                                        (_model.retunListSQLiteON ?? [])
                                                            .cast<dynamic>();
                                                    FFAppState().update(() {});
                                                    } catch (e) {
                                                      print('❌ Error guardando proyecto online: $e');
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Error al guardar: $e'),
                                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                                          duration: Duration(milliseconds: 4000),
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                  } else {
                                                    try {
                                                      await actions
                                                          .insertProyectoSQLite(
                                                        _model.txtidTextController
                                                            .text,
                                                        _model
                                                            .txtnombreTextController
                                                            .text,
                                                        _model
                                                            .txtdescTextController
                                                            .text,
                                                        _model
                                                            .txtopinionTextController
                                                            .text,
                                                        0.0,
                                                        _model.cboUserAssignValue,
                                                        _model.cbomatrixValue,
                                                      );
                                                      _model.retunListSQLiteOFF =
                                                          await actions
                                                              .sqlLiteListProyectos();
                                                      FFAppState().jsonProyectos =
                                                          (_model.retunListSQLiteOFF ?? [])
                                                              .cast<dynamic>();
                                                      FFAppState().update(() {});
                                                    } catch (e) {
                                                      print('❌ Error guardando proyecto offline: $e');
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Error al guardar: $e'),
                                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                                          duration: Duration(milliseconds: 4000),
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                  }

                                                  safeSetState(() {
                                                    _model.txtidTextController
                                                        ?.clear();
                                                    _model
                                                        .txtnombreTextController
                                                        ?.clear();
                                                    _model
                                                        .txtopinionTextController
                                                        ?.clear();
                                                    _model.txtdescTextController
                                                        ?.clear();
                                                  });
                                                  safeSetState(() {
                                                    _model
                                                        .cbomatrixValueController
                                                        ?.reset();
                                                    _model.cbomatrixValue =
                                                        null;
                                                    _model
                                                        .cboUserAssignValueController
                                                        ?.reset();
                                                    _model.cboUserAssignValue =
                                                        null;
                                                  });
                                                  // Cerrar el formulario primero
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Proyecto Creado Exitosamente',
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );

                                                  safeSetState(() {});
                                                },
                                                text: 'Guardar',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.save,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
      ),
    );
  }
}
