import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_ecosistema/edit_ecosistema_widget.dart';
import 'dart:ui';
import '/custom_code/DBEcosistema.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/custom_code/InternetCheckMixin.dart';
import 'ecosistema_model.dart';
export 'ecosistema_model.dart';

class EcosistemaWidget extends StatefulWidget {
  const EcosistemaWidget({super.key});

  static String routeName = 'Ecosistema';
  static String routePath = '/Ecosistema';

  @override
  State<EcosistemaWidget> createState() => _EcosistemaWidgetState();
}

class _EcosistemaWidgetState extends State<EcosistemaWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late EcosistemaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EcosistemaModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          initInternetCheck(context, onConnectionChanged: (isConnected) {
            _model.estaconectado = isConnected;
            if (mounted) {
              safeSetState(() {});
            }
          });
        }),
        Future(() async {
          _model.qSupabaseEcosistema = await actions.getEcosistemasFromSupabase();
          _model.conexion = await actions.checkInternetConecction();
          if (_model.conexion!) {
            _model.listEcosistema =
                _model.qSupabaseEcosistema!.toList().cast<EcosistemaStruct>();
            safeSetState(() {});
          } else {
            _model.getEcosistemas = await actions.getEcosistemasFromSQLite();
            _model.listEcosistema =
                _model.getEcosistemas!.toList().cast<EcosistemaStruct>();
            safeSetState(() {});
          }
        }),
      ]);
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

  // ── Modal: formulario Crear Ecosistema ─────────────────────────────────────
  Widget _buildFormEcosistema(
    BuildContext context,
    String? errorMsg,
    void Function(String) mostrarError,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).colorFondoPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).containerColorPrimary,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).customColor4bbbbb,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Título del modal + botón X ────────────────────────────
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Crear Ecosistema',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                              ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Formulario ────────────────────────────────────────────
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Nombre ────────────────────────────────────────
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
                                decoration: const BoxDecoration(),
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
                            ].divide(const SizedBox(height: 5.0)),
                          ),
                          // ── Error inline ──────────────────────────────────
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
                                      errorMsg,
                                      style: const TextStyle(color: Color(0xFFE53935), fontSize: 13.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // ── Botón Guardar ─────────────────────────────────
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      // Validar nombre vacío
                                      final nombreIngresado = _model.txtnombreTextController.text.trim();
                                      if (nombreIngresado.isEmpty) {
                                        mostrarError('Ingresa el nombre del ecosistema');
                                        return;
                                      }

                                      // Validar duplicado local
                                      final duplicadoLocal = _model.listEcosistema.any(
                                        (e) => e.nombre.toLowerCase() == nombreIngresado.toLowerCase(),
                                      );
                                      if (duplicadoLocal) {
                                        mostrarError('El ecosistema "$nombreIngresado" ya existe');
                                        return;
                                      }

                                      // Validar duplicado contra Supabase si hay conexión
                                      if (_model.estaconectado ?? false) {
                                        final existenteSupabase = await EcosystemsTable().queryRows(
                                          queryFn: (q) => q.ilike('name', nombreIngresado),
                                        );
                                        if (existenteSupabase.isNotEmpty) {
                                          mostrarError('El ecosistema "$nombreIngresado" ya existe');
                                          return;
                                        }
                                      }

                                      if (_model.estaconectado!) {
                                        final nuevoEcosystemId = random_data.randomString(1, 5, true, false, true);
                                        await EcosystemsTable().insert({
                                          'ecosystem_id': nuevoEcosystemId,
                                          'name': nombreIngresado,
                                          'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                          'updated_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                          'status': true,
                                        });
                                        // También insertar en SQLite para que sincronización no lo detecte como nuevo
                                        await DBEcosistema.insertEcosistema(
                                          EcosistemaStruct(
                                            idEcosistema: nuevoEcosystemId,
                                            nombre: nombreIngresado,
                                            createdAt: getCurrentTimestamp,
                                            updateAt: getCurrentTimestamp,
                                            estado: true,
                                          ),
                                          fromSupabase: true,
                                        );
                                        _model.returnEcosistemas = await actions.getEcosistemasFromSupabase();
                                        _model.listEcosistema =
                                            _model.returnEcosistemas!.toList().cast<EcosistemaStruct>();
                                        safeSetState(() {});
                                      } else {
                                        await DBEcosistema.insertEcosistema(
                                          EcosistemaStruct(
                                            idEcosistema: random_data.randomString(1, 5, true, false, true),
                                            nombre: nombreIngresado,
                                            createdAt: getCurrentTimestamp,
                                            updateAt: getCurrentTimestamp,
                                            estado: true,
                                          ),
                                        );
                                        _model.ecosistemasoffline = await DBEcosistema.getAllEcosistemas();
                                        _model.listEcosistema =
                                            _model.ecosistemasoffline!.toList().cast<EcosistemaStruct>();
                                        safeSetState(() {});
                                      }

                                      safeSetState(() {
                                        _model.txtnombreTextController?.clear();
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Ecosistema creado exitosamente',
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                          ),
                                          duration: const Duration(milliseconds: 3000),
                                          backgroundColor: FlutterFlowTheme.of(context).secondary,
                                        ),
                                      );
                                    },
                                    text: 'Guardar',
                                    icon: FaIcon(FontAwesomeIcons.save, size: 15.0),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                        ].divide(const SizedBox(height: 8.0)),
                      ),
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
                context.pushNamed(HallazgosWidget.routeName);
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
            actions: const [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ── Título + botón Crear ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listado de Ecosistemas',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                              ),
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
                                  child: _buildFormEcosistema(ctx, _modalErrorMsg, mostrarError),
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18.0),
                        label: const Text('Crear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primaryText,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  // ── Lista ─────────────────────────────────────────────────
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (_model.estaconectado ?? false) {
                          return FutureBuilder<List<EcosystemsRow>>(
                            future: EcosystemsTable().queryRows(
                              queryFn: (q) => q.order('created_at'),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<EcosystemsRow> listViewEcosystemsRowList = snapshot.data!;

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: listViewEcosystemsRowList.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewEcosystemsRow = listViewEcosystemsRowList[listViewIndex];
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).containerColorPrimary,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 0.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(listViewEcosystemsRow.name, 'name'),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  dateTimeFormat(
                                                    "d/M/y",
                                                    listViewEcosystemsRow.createdAt,
                                                    locale: FFLocalizations.of(context).languageCode,
                                                  ),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: TextStyle(
                                                          fontWeight: FontWeight.w200,
                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w200,
                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(height: 4.0)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // Botón editar online
                                              Align(
                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                child: Builder(
                                                  builder: (context) => InkWell(
                                                    splashColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (dialogContext) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            insetPadding: EdgeInsets.zero,
                                                            backgroundColor: Colors.transparent,
                                                            alignment: AlignmentDirectional(0.0, 0.0)
                                                                .resolve(Directionality.of(context)),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(dialogContext).unfocus();
                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                              },
                                                              child: EditEcosistemaWidget(
                                                                conexion: _model.estaconectado!,
                                                                idEcosistema: listViewEcosystemsRow.ecosystemId,
                                                                nombre: listViewEcosystemsRow.name,
                                                                update: (listEcosistema) async {
                                                                  _model.listEcosistema =
                                                                      listEcosistema.toList().cast<EcosistemaStruct>();
                                                                  safeSetState(() {});
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                        'Ecosistema Actualizado Exitosamente',
                                                                        style: TextStyle(
                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                      ),
                                                                      duration: const Duration(milliseconds: 4000),
                                                                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Botón eliminar online
                                              Align(
                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () async {
                                                    final confirmar = await showDialog<bool>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (dialogContext) => Dialog(
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
                                                                  Icons.delete_outline,
                                                                  color: Color(0xFFE53935),
                                                                  size: 32.0,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16.0),
                                                              const Text(
                                                                'Eliminar ecosistema',
                                                                style: TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 8.0),
                                                              Text(
                                                                '¿Estás seguro de que deseas eliminar el ecosistema "${listViewEcosystemsRow.name ?? ''}"? Esta acción no se puede deshacer.',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 14.0,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 24.0),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: OutlinedButton(
                                                                      onPressed: () => Navigator.pop(dialogContext, false),
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      child: const Text('Cancelar'),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 12.0),
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      onPressed: () => Navigator.pop(dialogContext, true),
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: const Color(0xFFE53935),
                                                                        foregroundColor: Colors.white,
                                                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      child: const Text('Eliminar'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    if (confirmar != true) return;
                                                    await EcosystemsTable().delete(
                                                      matchingRows: (rows) => rows.eqOrNull(
                                                        'id',
                                                        listViewEcosystemsRow.id,
                                                      ),
                                                    );
                                                    await DBEcosistema.deleteEcosistema(listViewEcosystemsRow.ecosystemId ?? '');
                                                    _model.qSupabaseEcositemasOn =
                                                        await actions.getEcosistemasFromSupabase();
                                                    _model.listEcosistema =
                                                        _model.qSupabaseEcositemasOn!.toList().cast<EcosistemaStruct>();
                                                    safeSetState(() {});
                                                  },
                                                  child: FaIcon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color: FlutterFlowTheme.of(context).rojoNoConforme,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                            ].divide(const SizedBox(width: 8.0)),
                                          ),
                                        ].divide(const SizedBox(width: 10.0)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return Builder(
                            builder: (context) {
                              final arrayoffEcosistema = _model.listEcosistema.toList();

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: arrayoffEcosistema.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                                itemBuilder: (context, arrayoffEcosistemaIndex) {
                                  final arrayoffEcosistemaItem = arrayoffEcosistema[arrayoffEcosistemaIndex];
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).containerColorPrimary,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 0.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(arrayoffEcosistemaItem.nombre, 'nombre'),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  dateTimeFormat(
                                                    "d/M/y",
                                                    arrayoffEcosistemaItem.createdAt!,
                                                    locale: FFLocalizations.of(context).languageCode,
                                                  ),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: TextStyle(
                                                          fontWeight: FontWeight.w200,
                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w200,
                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(height: 4.0)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // Botón editar offline
                                              Align(
                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                child: Builder(
                                                  builder: (context) => InkWell(
                                                    splashColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (dialogContext) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            insetPadding: EdgeInsets.zero,
                                                            backgroundColor: Colors.transparent,
                                                            alignment: AlignmentDirectional(0.0, 0.0)
                                                                .resolve(Directionality.of(context)),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(dialogContext).unfocus();
                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                              },
                                                              child: EditEcosistemaWidget(
                                                                conexion: _model.estaconectado!,
                                                                idEcosistema: arrayoffEcosistemaItem.idEcosistema,
                                                                nombre: arrayoffEcosistemaItem.nombre,
                                                                update: (listEcosistema) async {
                                                                  _model.listEcosistema =
                                                                      listEcosistema.toList().cast<EcosistemaStruct>();
                                                                  safeSetState(() {});
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                        'Ecosistema Actualizado Exitosamente',
                                                                        style: TextStyle(
                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                      ),
                                                                      duration: const Duration(milliseconds: 4000),
                                                                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Botón eliminar offline
                                              Align(
                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () async {
                                                    final confirmar = await showDialog<bool>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (dialogContext) => Dialog(
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
                                                                  Icons.delete_outline,
                                                                  color: Color(0xFFE53935),
                                                                  size: 32.0,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16.0),
                                                              const Text(
                                                                'Eliminar ecosistema',
                                                                style: TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 8.0),
                                                              Text(
                                                                '¿Estás seguro de que deseas eliminar el ecosistema "${arrayoffEcosistemaItem.nombre ?? ''}"? Esta acción no se puede deshacer.',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 14.0,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 24.0),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: OutlinedButton(
                                                                      onPressed: () => Navigator.pop(dialogContext, false),
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      child: const Text('Cancelar'),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 12.0),
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      onPressed: () => Navigator.pop(dialogContext, true),
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: const Color(0xFFE53935),
                                                                        foregroundColor: Colors.white,
                                                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      child: const Text('Eliminar'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    if (confirmar != true) return;
                                                    await DBEcosistema.deleteEcosistema(arrayoffEcosistemaItem.idEcosistema);
                                                    _model.getEcosistemaoff = await actions.getEcosistemasFromSQLite();
                                                    _model.listEcosistema =
                                                        _model.getEcosistemaoff!.toList().cast<EcosistemaStruct>();
                                                    safeSetState(() {});
                                                  },
                                                  child: FaIcon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color: FlutterFlowTheme.of(context).rojoNoConforme,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                            ].divide(const SizedBox(width: 8.0)),
                                          ),
                                        ].divide(const SizedBox(width: 10.0)),
                                      ),
                                    ),
                                  );
                                },
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
}
