import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/component_controllador/component_controllador_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import 'dart:convert';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'controles_model.dart';
export 'controles_model.dart';

class ControlesWidget extends StatefulWidget {
  const ControlesWidget({
    super.key,
    String? titleProject,
    String? categoriaObjetive,
    String? tipoMatriz,
  })  : this.titleProject = titleProject ?? '',
        this.categoriaObjetive = categoriaObjetive ?? '',
        this.tipoMatriz = tipoMatriz ?? '';

  final String titleProject;
  final String categoriaObjetive;
  final String tipoMatriz;

  static String routeName = 'Controles';
  static String routePath = '/controles';

  @override
  State<ControlesWidget> createState() => _ControlesWidgetState();
}

class _ControlesWidgetState extends State<ControlesWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late ControlesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ControlesModel());

    // Inicializar timer pausable de internet
    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Establecer ID del primer control (ya deberían estar cargados desde HOME)
      if (FFAppState().jsonControles.isNotEmpty) {
        _model.idControl = getJsonField(
          FFAppState().jsonControles.firstOrNull,
          r'''$.id_control''',
        ).toString();
      } else {
      }

      safeSetState(() {});
    });

    _model.txtidTextController ??= TextEditingController();
    _model.txtidFocusNode ??= FocusNode();

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
            toolbarHeight: 90.0,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                // 🔍 Verificar si hay cambios sin guardar
                if (_model.hayCambiosSinGuardar) {
                  final debeDescartar = await actions.mostrarDialogoCambiosSinGuardar(context);
                  if (debeDescartar == null || !debeDescartar) {
                    return; // Usuario canceló
                  }
                }
                context.goNamed(ObjetivesWidget.routeName);
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
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.titleProject.isNotEmpty
                                  ? widget.titleProject
                                  : FFAppState().projectName,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              'Tipo : ${widget.tipoMatriz.isEmpty ? 'Express' : widget.tipoMatriz}',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
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
                            conexion: _model.estaconectado ?? false,
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
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).bordeCompletada,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Proceso de la Auditoría',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).negroLinea,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: !_model.trueAutoincrement
                                        ? null
                                        : () async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Exito',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                  ),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            );
                                          },
                                    text: 'Finalizar auditoría',
                                    icon: FaIcon(
                                      FontAwesomeIcons.checkCircle,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 47.8,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .completada,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: TextStyle(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .completada,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      disabledColor:
                                          FlutterFlowTheme.of(context)
                                              .botonDisabled,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            LinearPercentIndicator(
                              percent: functions.progressBarFunction(
                                  FFAppState()
                                      .jsonControles
                                      .where((control) =>
                                          getJsonField(control, r'''$.objective_id''')
                                              ?.toString() ==
                                          FFAppState().idobejetivo)
                                      .toList()),
                              lineHeight: 12.0,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).completada,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).progresBarColor,
                              barRadius: Radius.circular(5.0),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              valueOrDefault<String>(
                                functions.textoContadorControl(
                                    FFAppState()
                                        .jsonControles
                                        .where((control) =>
                                            getJsonField(control, r'''$.objective_id''')
                                                ?.toString() ==
                                            FFAppState().idobejetivo)
                                        .toList()),
                                '0  de 20 completados',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(height: 11.0)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 8.0),
                        child: TextFormField(
                          controller: _model.txtidTextController,
                          focusNode: _model.txtidFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.txtidTextController',
                            Duration(milliseconds: 20),
                            () => safeSetState(() {}),
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
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                            hintText: 'Buscar por nombre',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: TextStyle(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
                            suffixIcon:
                                _model.txtidTextController!.text.isNotEmpty
                                    ? InkWell(
                                        onTap: () async {
                                          _model.txtidTextController?.clear();
                                          safeSetState(() {});
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          size: 22,
                                        ),
                                      )
                                    : null,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          enableInteractiveSelection: true,
                          validator: _model.txtidTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    if (FFAppState()
                        .jsonControles
                        .where((control) =>
                            getJsonField(control, r'''$.objective_id''')
                                ?.toString() ==
                            FFAppState().idobejetivo)
                        .isNotEmpty)
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Builder(
                            builder: (context) {
                              // Primero filtrar por objetivo, luego por búsqueda
                              final controlesPorObjetivo = FFAppState()
                                  .jsonControles
                                  .where((control) =>
                                      getJsonField(control, r'''$.objective_id''')
                                          ?.toString() ==
                                      FFAppState().idobejetivo)
                                  .toList();

                              final arrayControls = functions
                                  .getControlesSearchNombres(
                                      controlesPorObjetivo,
                                      _model.txtidTextController.text)
                                  .toList();
                              if (arrayControls.isEmpty) {
                                return LoadingListTottusWidget(
                                  texto: 'Lista Vacia de Controladores',
                                );
                              }

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                cacheExtent: 100, // MUY reducido - solo items cercanos
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: true,
                                addSemanticIndexes: false,
                                itemCount: arrayControls.length,
                                separatorBuilder: (_, __) => SizedBox(height: 12.0),
                                itemBuilder: (context, arrayControlsIndex) {
                                  final arrayControlsItem =
                                      arrayControls[arrayControlsIndex];
                                  return RepaintBoundary(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 4.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: wrapWithModel(
                                        model: _model
                                            .componentControlladorModels
                                            .getModel(
                                          arrayControlsIndex.toString(),
                                          arrayControlsIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: ComponentControlladorWidget(
                                          key: Key(
                                            'Keyea4_${arrayControlsIndex.toString()}',
                                          ),
                                          nameProyect: widget!.titleProject,
                                          nameControl: getJsonField(
                                            arrayControlsItem,
                                            r'''$.title''',
                                          ).toString(),
                                          estado: functions
                                              .convertStringtoBoolean(
                                                  getJsonField(
                                            arrayControlsItem,
                                            r'''$.completed''',
                                          ).toString()),
                                          controlestext: getJsonField(
                                            arrayControlsItem,
                                            r'''$.control_text''',
                                          ).toString(),
                                          idControl: getJsonField(
                                            arrayControlsItem,
                                            r'''$.id_control''',
                                          ).toString(),
                                          idObjetivo:
                                              FFAppState().idobejetivo,
                                          walkthroughId: getJsonField(
                                            arrayControlsItem,
                                            r'''$.walkthrough_id''',
                                          ).toString(),
                                          description: getJsonField(
                                            arrayControlsItem,
                                            r'''$.description''',
                                          ).toString(),
                                          categoria:
                                              widget!.categoriaObjetive,
                                          findingStatus: getJsonField(
                                            arrayControlsItem,
                                            r'''$.finding_status''',
                                          ),
                                          listImages: functions
                                              .convertBase64StringToUploadFiles(
                                                  getJsonField(arrayControlsItem, r'''$.photos''') != null
                                                      ? jsonEncode(getJsonField(arrayControlsItem, r'''$.photos'''))
                                                      : null,
                                                  'image'),
                                          listArchives: functions
                                              .convertBase64StringToUploadFiles(
                                                  getJsonField(arrayControlsItem, r'''$.archives''') != null
                                                      ? jsonEncode(getJsonField(arrayControlsItem, r'''$.archives'''))
                                                      : null,
                                                  'archives'),
                                          listVideos: functions
                                              .convertBase64StringToUploadFiles(
                                                  getJsonField(arrayControlsItem, r'''$.video''') != null
                                                      ? jsonEncode(getJsonField(arrayControlsItem, r'''$.video'''))
                                                      : null,
                                                  'video'),
                                          onUpdateDinamic: (state) async {
                                            if (state!) {
                                              // ⚡ OPTIMIZACIÓN: Actualizar SOLO el control modificado (mucho más rápido)
                                              // En lugar de recargar todos los 20+ controles desde SQLite,
                                              // solo actualizamos el control que cambió
                                              final controlId = getJsonField(
                                                arrayControlsItem,
                                                r'''$.id_control''',
                                              ).toString();

                                              await actions.actualizarControlEnAppState(
                                                controlId,
                                              );

                                              // Solo actualizar este widget específico con safeSetState
                                              safeSetState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Control Actualizado Exitosamente',
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
                                            }

                                            safeSetState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    if (!(FFAppState()
                        .jsonControles
                        .where((control) =>
                            getJsonField(control, r'''$.objective_id''')
                                ?.toString() ==
                            FFAppState().idobejetivo)
                        .isNotEmpty))
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: wrapWithModel(
                            model: _model.loadingListTottusModel,
                            updateCallback: () => safeSetState(() {}),
                            child: LoadingListTottusWidget(
                              texto: 'Lista Vacia de Controles',
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
