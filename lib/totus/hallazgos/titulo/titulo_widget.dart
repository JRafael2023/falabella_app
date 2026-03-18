import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_titulo/edit_titulo_widget.dart';
import 'dart:ui';
import '/custom_code/DBProceso.dart';
import '/custom_code/DBTitulo.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'titulo_model.dart';
export 'titulo_model.dart';

class TituloWidget extends StatefulWidget {
  const TituloWidget({super.key});

  static String routeName = 'Titulo';
  static String routePath = '/Titulo';

  @override
  State<TituloWidget> createState() => _TituloWidgetState();
}

class _TituloWidgetState extends State<TituloWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late TituloModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TituloModel());

    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.qSupabaseProceso = await actions.getProcesosFromSupabase();
      _model.qSupabaseTitulos = await actions.getTitulosFromSupabase();
      _model.conexion = await actions.checkInternetConecction();
      if (_model.conexion!) {
        _model.listProcesosPageState =
            _model.qSupabaseProceso!.toList().cast<ProcesoStruct>();
        safeSetState(() {});
        _model.listTitulos =
            _model.qSupabaseTitulos!.toList().cast<TituloStruct>();
        safeSetState(() {});
      } else {
        _model.getprocesos = await actions.getProcesosFromSQLite();
        _model.getTitulos = await actions.getTitulosFromSQLite();
        _model.listProcesosPageState =
            _model.getprocesos!.toList().cast<ProcesoStruct>();
        safeSetState(() {});
        _model.listTitulos =
            _model.getTitulos!.toList().cast<TituloStruct>();
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

  Widget _buildFormTitulo(BuildContext context, String? errorMsg, void Function(String) mostrarError, void Function(VoidCallback) setModalState) {
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
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).containerColorPrimary,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).customColor4bbbbb,
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
                        'Crear Título',
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
                          // ── Nombre ────────────────────────────────────
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
                          // ── Error inline ──────────────────────────────
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
                          // ── Botón Guardar ─────────────────────────────
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
                                      final nombreIngresado = _model.txtnombreTextController.text.trim();
                                      if (nombreIngresado.isEmpty) {
                                        mostrarError('Ingresa el nombre del título');
                                        return;
                                      }
                                      // Validar nombre duplicado local
                                      final existeNombreDuplicado = _model.listTitulos.any((t) =>
                                          t.nombre.trim().toLowerCase() == nombreIngresado.toLowerCase());
                                      if (existeNombreDuplicado) {
                                        mostrarError('El título "$nombreIngresado" ya existe');
                                        return;
                                      }
                                      // Si está conectado, verificar también contra Supabase
                                      if (_model.estaconectado ?? false) {
                                        final existenteSupabase = await TitlesTable().queryRows(
                                          queryFn: (q) => q.ilike('name', nombreIngresado),
                                        );
                                        if (existenteSupabase.isNotEmpty) {
                                          mostrarError('El título "$nombreIngresado" ya existe');
                                          return;
                                        }
                                      }
                                      if (_model.estaconectado!) {
                                        await TitlesTable().insert({
                                          'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                          'name': nombreIngresado,
                                          'updated_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                          'status': true,
                                          'titles_id': random_data.randomString(
                                            1,
                                            5,
                                            true,
                                            false,
                                            true,
                                          ),
                                        });
                                        _model.sincronizado =
                                            await actions.sincronizarTitulosFromSupabase();
                                        _model.returnTituls =
                                            await actions.getTitulosFromSupabase();
                                        _model.listTitulos = _model.returnTituls!
                                            .toList()
                                            .cast<TituloStruct>();
                                        safeSetState(() {});
                                      } else {
                                        await DBTitulo.insertTitulo(
                                          TituloStruct(
                                            nombre: nombreIngresado,
                                            createdAt: getCurrentTimestamp,
                                            updateAt: getCurrentTimestamp,
                                            estado: true,
                                            idTitulo: random_data.randomString(
                                              1,
                                              5,
                                              true,
                                              false,
                                              true,
                                            ),
                                          ),
                                        );
                                        _model.titulosoffline =
                                            await DBTitulo.getAllTitulos();
                                        _model.listTitulos = _model.titulosoffline!
                                            .toList()
                                            .cast<TituloStruct>();
                                        safeSetState(() {});
                                      }

                                      _model.txtnombreTextController?.clear();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Título creado correctamente',
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
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listado de Títulos',
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
                                  child: _buildFormTitulo(ctx, _modalErrorMsg, mostrarError, setModalState),
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
                    return FutureBuilder<List<TitlesRow>>(
                      future: TitlesTable().queryRows(
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
                        List<TitlesRow> listViewTitlesRowList = snapshot.data!;

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewTitlesRowList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16.0),
                          itemBuilder: (context, listViewIndex) {
                            final listViewTitlesRow = listViewTitlesRowList[listViewIndex];
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
                                padding: EdgeInsets.all(20.0),
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
                                            valueOrDefault<String>(listViewTitlesRow.name, 'name'),
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
                                              listViewTitlesRow.createdAt,
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
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
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
                                                        child: EditTituloWidget(
                                                          conexion: _model.estaconectado!,
                                                          idProceso: listViewTitlesRow.processId,
                                                          nombre: listViewTitlesRow.name,
                                                          idTitulo: listViewTitlesRow.titlesId,
                                                          listProcesosPageState: _model.listProcesosPageState,
                                                          update: (listTitulos) async {
                                                            _model.listTitulos = listTitulos
                                                                .toList()
                                                                .cast<TituloStruct>();
                                                            safeSetState(() {});
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Titulo Actualizado Exitosamente',
                                                                  style: TextStyle(
                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  ),
                                                                ),
                                                                duration: Duration(milliseconds: 4000),
                                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );

                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                        ),
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
                                                builder: (dialogContext) {
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
                                                            width: 56.0,
                                                            height: 56.0,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme.of(context).error.withOpacity(0.12),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.delete_outline_rounded,
                                                              color: FlutterFlowTheme.of(context).error,
                                                              size: 28.0,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16.0),
                                                          Text(
                                                            '¿Eliminar título?',
                                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                  font: TextStyle(fontWeight: FontWeight.bold),
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 8.0),
                                                          Text(
                                                            'Esta acción eliminará el título "${listViewTitlesRow.name ?? ''}" de forma permanente y no se puede deshacer.',
                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                  font: TextStyle(),
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 24.0),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: OutlinedButton(
                                                                  onPressed: () => Navigator.pop(dialogContext, false),
                                                                  child: const Text('Cancelar'),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 12.0),
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  onPressed: () => Navigator.pop(dialogContext, true),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                                                  ),
                                                                  child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              if (confirmar != true) return;
                                              await TitlesTable().delete(
                                                matchingRows: (rows) => rows.eqOrNull(
                                                  'titles_id',
                                                  listViewTitlesRow.titlesId,
                                                ),
                                              );
                                              await DBTitulo.deleteTitulo(
                                                listViewTitlesRow.titlesId!,
                                              );
                                              _model.qSupabaseTitulosOn =
                                                  await actions.getTitulosFromSupabase();
                                              _model.listTitulos = _model.qSupabaseTitulosOn!
                                                  .toList()
                                                  .cast<TituloStruct>();
                                              safeSetState(() {});
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.trashAlt,
                                              color: FlutterFlowTheme.of(context).rojoNoConforme,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
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
                        final arrayoffTitulos = _model.listTitulos.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: arrayoffTitulos.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16.0),
                          itemBuilder: (context, arrayoffTitulosIndex) {
                            final arrayoffTitulosItem = arrayoffTitulos[arrayoffTitulosIndex];
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
                                padding: EdgeInsets.all(20.0),
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
                                            valueOrDefault<String>(arrayoffTitulosItem.nombre, 'nombre'),
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
                                              arrayoffTitulosItem.createdAt!,
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
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
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
                                                        child: EditTituloWidget(
                                                          conexion: _model.estaconectado!,
                                                          idProceso: arrayoffTitulosItem.idProceso,
                                                          nombre: arrayoffTitulosItem.nombre,
                                                          idTitulo: arrayoffTitulosItem.idTitulo,
                                                          listProcesosPageState: _model.listProcesosPageState,
                                                          update: (listTitulos) async {
                                                            _model.listTitulos = listTitulos
                                                                .toList()
                                                                .cast<TituloStruct>();
                                                            safeSetState(() {});
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Titulo Actualizado Exitosamente',
                                                                  style: TextStyle(
                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  ),
                                                                ),
                                                                duration: Duration(milliseconds: 4000),
                                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );

                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                        ),
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
                                                builder: (dialogContext) {
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
                                                            width: 56.0,
                                                            height: 56.0,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme.of(context).error.withOpacity(0.12),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.delete_outline_rounded,
                                                              color: FlutterFlowTheme.of(context).error,
                                                              size: 28.0,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16.0),
                                                          Text(
                                                            '¿Eliminar título?',
                                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                  font: TextStyle(fontWeight: FontWeight.bold),
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 8.0),
                                                          Text(
                                                            'Esta acción eliminará el título "${arrayoffTitulosItem.nombre ?? ''}" de forma permanente y no se puede deshacer.',
                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                  font: TextStyle(),
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 24.0),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: OutlinedButton(
                                                                  onPressed: () => Navigator.pop(dialogContext, false),
                                                                  child: const Text('Cancelar'),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 12.0),
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  onPressed: () => Navigator.pop(dialogContext, true),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                                                  ),
                                                                  child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              if (confirmar != true) return;
                                              await DBTitulo.deleteTitulo(
                                                arrayoffTitulosItem.idTitulo,
                                              );
                                              _model.getTitulosoff =
                                                  await actions.getTitulosFromSQLite();
                                              _model.listTitulos = _model.getTitulosoff!
                                                  .toList()
                                                  .cast<TituloStruct>();
                                              safeSetState(() {});
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.trashAlt,
                                              color: FlutterFlowTheme.of(context).rojoNoConforme,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
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
