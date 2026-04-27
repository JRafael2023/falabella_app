import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/card_matriz/card_matriz_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'matrices_model.dart';
export 'matrices_model.dart';

class MatricesWidget extends StatefulWidget {
  const MatricesWidget({super.key});

  static String routeName = 'Matrices';
  static String routePath = '/matrices';

  @override
  State<MatricesWidget> createState() => _MatricesWidgetState();
}

class _MatricesWidgetState extends State<MatricesWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late MatricesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MatricesModel());

    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    _model.txtnombreTextController ??= TextEditingController();
    _model.txtnombreFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    disposeInternetCheck();
    _model.dispose();

    super.dispose();
  }

  Widget _buildFormMatriz(BuildContext context, String? errorMsg, void Function(String) mostrarError) {
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).containerColorPrimary,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).customColor4bbbbb,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 8.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Crear Matriz',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
                      padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: TextStyle(
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: TextFormField(
                                      controller: _model.txtnombreTextController,
                                      focusNode: _model.txtnombreFocusNode,
                                      autofocus: false,
                                      enabled: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        hintText: 'Escribe',
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).customColor4bbbbb,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).mouseregionTEXT,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: TextStyle(
                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                      maxLines: null,
                                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model.txtnombreTextControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 5.0)),
                              ),
                              if (errorMsg != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEB),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: const Color(0xFFE53935)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Color(0xFFE53935), size: 18.0),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if (_model.formKey.currentState == null ||
                                              !_model.formKey.currentState!.validate()) {
                                            return;
                                          }
                                          final nombreIngresado =
                                              _model.txtnombreTextController.text.trim();
                                          final existeDuplicado =
                                              FFAppState().jsonMatrices.any((m) =>
                                                  getJsonField(m, r'''$.name''')
                                                          .toString()
                                                          .trim()
                                                          .toLowerCase() ==
                                                      nombreIngresado.toLowerCase());
                                          if (existeDuplicado) {
                                            mostrarError(
                                                'La matriz "$nombreIngresado" ya existe');
                                            return;
                                          }
                                          if (_model.estaconectado ?? false) {
                                            final existenteSupabase = await MatricesTable().queryRows(
                                              queryFn: (q) => q.ilike('name', nombreIngresado),
                                            );
                                            if (existenteSupabase.isNotEmpty) {
                                              mostrarError('La matriz "$nombreIngresado" ya existe');
                                              return;
                                            }
                                          }
                                          if (_model.estaconectado!) {
                                            await MatricesTable().insert({
                                              'matrix_id': random_data.randomString(
                                                1,
                                                10,
                                                true,
                                                false,
                                                false,
                                              ),
                                              'name': _model.txtnombreTextController.text,
                                              'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                              'status': true,
                                            });
                                            await actions.insertMatrizSQLite(
                                              random_data.randomString(
                                                1,
                                                10,
                                                true,
                                                false,
                                                false,
                                              ),
                                              _model.txtnombreTextController.text,
                                            );
                                            _model.listONMatriz = await actions.sqlLiteListMatrices();
                                            FFAppState().jsonMatrices =
                                                _model.listONMatriz!.toList().cast<dynamic>();
                                            FFAppState().update(() {});
                                          } else {
                                            await actions.insertMatrizSQLite(
                                              random_data.randomString(
                                                1,
                                                10,
                                                true,
                                                false,
                                                false,
                                              ),
                                              _model.txtnombreTextController.text,
                                            );
                                            _model.listOFFMatriz = await actions.sqlLiteListMatrices();
                                            FFAppState().jsonMatrices =
                                                _model.listOFFMatriz!.toList().cast<dynamic>();
                                            FFAppState().update(() {});
                                          }

                                          safeSetState(() {
                                            _model.txtnombreTextController?.clear();
                                          });
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Matriz creada correctamente',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(context).accent4,
                                                ),
                                              ),
                                              duration: const Duration(milliseconds: 3000),
                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
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
                                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                font: TextStyle(
                                                  fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius: BorderRadius.circular(8.0),
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
            ],
          ),
        ),
      ),
    );
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
                    mainAxisAlignment: MainAxisAlignment.end,
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
                              conexion: _model.estaconectado!,
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
                    ].divide(SizedBox(width: 8.0)),
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listado de Matrices',
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
                                  child: _buildFormMatriz(ctx, _modalErrorMsg, mostrarError),
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
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (_model.estaconectado ?? false) {
                    return FutureBuilder<List<MatricesRow>>(
                      future: MatricesTable().queryRows(
                        queryFn: (q) => q,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: LoadingListTottusWidget(
                              texto: 'Lista de Proyectos Vacia',
                            ),
                          );
                        }
                        List<MatricesRow> containerMatricesRowList = snapshot.data!;

                        if (containerMatricesRowList.isEmpty) {
                          return Center(
                            child: LoadingListTottusWidget(
                              texto: 'Lista de Proyectos Vacia',
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: containerMatricesRowList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.0),
                          itemBuilder: (context, arrayMatrizONIndex) {
                            final arrayMatrizONItem = containerMatricesRowList[arrayMatrizONIndex];
                            return wrapWithModel(
                              model: _model.cardMatrizModels1.getModel(
                                arrayMatrizONIndex.toString(),
                                arrayMatrizONIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: CardMatrizWidget(
                                key: Key(
                                  'Keyawz_${arrayMatrizONIndex.toString()}',
                                ),
                                nombre: arrayMatrizONItem.name,
                                idMatriz: arrayMatrizONItem.id,
                                createdAt: arrayMatrizONItem.createdAt,
                                updateCardMatriz: (idMatriz) async {
                                  await MatricesTable().delete(
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      arrayMatrizONItem.id,
                                    ),
                                  );
                                  _model.eliminate = await actions.sqlLiteEliminarMatriz(
                                    idMatriz,
                                  );
                                  _model.returnMatrices = await actions.sqlLiteListMatrices();
                                  FFAppState().jsonMatrices =
                                      _model.returnMatrices!.toList().cast<dynamic>();
                                  FFAppState().update(() {});

                                  safeSetState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).containerColorPrimary,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).customColor4bbbbb,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
                            child: Builder(
                              builder: (context) {
                                final arrayMatricesSQLite = FFAppState().jsonMatrices.toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: arrayMatricesSQLite.length,
                                  separatorBuilder: (_, __) => SizedBox(height: 8.0),
                                  itemBuilder: (context, arrayMatricesSQLiteIndex) {
                                    final arrayMatricesSQLiteItem =
                                        arrayMatricesSQLite[arrayMatricesSQLiteIndex];
                                    return wrapWithModel(
                                      model: _model.cardMatrizModels2.getModel(
                                        arrayMatricesSQLiteIndex.toString(),
                                        arrayMatricesSQLiteIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardMatrizWidget(
                                        key: Key(
                                          'Keymdy_${arrayMatricesSQLiteIndex.toString()}',
                                        ),
                                        nombre: getJsonField(
                                          arrayMatricesSQLiteItem,
                                          r'''$.name''',
                                        ).toString(),
                                        idMatriz: getJsonField(
                                          arrayMatricesSQLiteItem,
                                          r'''$.matrix_id''',
                                        ).toString(),
                                        createdAt: functions.convertStringtoDate(
                                            getJsonField(
                                          arrayMatricesSQLiteItem,
                                          r'''$.created_at''',
                                        ).toString()),
                                        updateCardMatriz: (idMatriz) async {
                                          await actions.sqlLiteEliminarMatriz(
                                            idMatriz,
                                          );
                                          _model.returnListSqLite =
                                              await actions.sqlLiteListMatrices();
                                          FFAppState().jsonMatrices =
                                              _model.returnListSqLite!.toList().cast<dynamic>();
                                          FFAppState().update(() {});

                                          safeSetState(() {});
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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
}
