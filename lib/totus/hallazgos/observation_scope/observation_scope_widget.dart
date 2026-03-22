import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_observation_scope/edit_observation_scope_widget.dart';
import 'dart:ui';
import '/custom_code/DBObservationScope.dart';
import '/custom_code/ObservationScope.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/custom_code/InternetCheckMixin.dart';
import 'observation_scope_model.dart';
export 'observation_scope_model.dart';

class ObservationScopeWidget extends StatefulWidget {
  const ObservationScopeWidget({super.key});
  static String routeName = 'ObservationScope';
  static String routePath = '/ObservationScope';
  @override
  State<ObservationScopeWidget> createState() => _ObservationScopeWidgetState();
}

class _ObservationScopeWidgetState extends State<ObservationScopeWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late ObservationScopeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ObservationScopeModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          initInternetCheck(context, onConnectionChanged: (isConnected) {
            _model.estaconectado = isConnected;
            if (mounted) safeSetState(() {});
          });
        }),
        Future(() async {
          _model.conexion = await actions.checkInternetConecction();
          if (_model.conexion!) {
            final data = await SupaFlow.client.from('ObservationScopes').select().eq('status', true).order('name');
            _model.listObservationScope = (data as List).map((e) => ObservationScope.fromSupabase(e as Map<String, dynamic>)).toList();
            safeSetState(() {});
          } else {
            _model.listObservationScope = await DBObservationScope.getAllObservationScopes();
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

  Future<bool?> _showDeleteDialog(BuildContext ctx, String name) => showDialog<bool>(
    context: ctx, barrierDismissible: false,
    builder: (dc) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)), child: Padding(padding: const EdgeInsets.all(24.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 64.0, height: 64.0, decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle), child: const Icon(Icons.delete_outline, color: Color(0xFFE53935), size: 32.0)),
      const SizedBox(height: 16.0), const Text('Eliminar alcance de observación', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0), Text('Eliminar "$name"?', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14.0)),
      const SizedBox(height: 24.0), Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(dc, false), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))), child: const Text('Cancelar'))),
        const SizedBox(width: 12.0),
        Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(dc, true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))), child: const Text('Eliminar'))),
      ]),
    ]))),
  );

  Widget _buildItem(ObservationScope item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: FlutterFlowTheme.of(context).containerColorPrimary, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: FlutterFlowTheme.of(context).alternate, width: 0.0)),
      child: Padding(padding: const EdgeInsets.all(20.0), child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(valueOrDefault<String>(item.name, 'name'), style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), fontSize: 16.0, letterSpacing: 0.0, fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle)),
        ].divide(const SizedBox(height: 4.0)))),
        Row(mainAxisSize: MainAxisSize.max, children: [
          Align(alignment: AlignmentDirectional(0.0, 0.0), child: Builder(builder: (context) => InkWell(splashColor: Colors.transparent, focusColor: Colors.transparent, hoverColor: Colors.transparent, highlightColor: Colors.transparent, onTap: () async {
            await showDialog(context: context, builder: (dc) => Dialog(elevation: 0, insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent, alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)), child: GestureDetector(onTap: () { FocusScope.of(dc).unfocus(); FocusManager.instance.primaryFocus?.unfocus(); }, child: EditObservationScopeWidget(conexion: _model.estaconectado!, idObservationScope: item.observationScopeId, nombre: item.name, update: (list) async { _model.listObservationScope = list; safeSetState(() {}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Alcance de Observacion Actualizado', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground)), duration: const Duration(milliseconds: 4000), backgroundColor: FlutterFlowTheme.of(context).secondary)); }))));
          }, child: Icon(Icons.edit_outlined, color: FlutterFlowTheme.of(context).secondaryText, size: 24.0)))),
          Align(alignment: AlignmentDirectional(0.0, 0.0), child: InkWell(splashColor: Colors.transparent, focusColor: Colors.transparent, hoverColor: Colors.transparent, highlightColor: Colors.transparent, onTap: () async {
            final confirmar = await _showDeleteDialog(context, item.name ?? '');
            if (confirmar != true) return;
            if (_model.estaconectado ?? false) {
              await SupaFlow.client.from('ObservationScopes').delete().eq('observation_scope_id', item.observationScopeId ?? '');
              final data = await SupaFlow.client.from('ObservationScopes').select().eq('status', true).order('name');
              _model.listObservationScope = (data as List).map((e) => ObservationScope.fromSupabase(e as Map<String, dynamic>)).toList();
            } else {
              await DBObservationScope.deleteObservationScope(item.observationScopeId ?? '');
              _model.listObservationScope = await DBObservationScope.getAllObservationScopes();
            }
            safeSetState(() {});
          }, child: FaIcon(FontAwesomeIcons.trashAlt, color: FlutterFlowTheme.of(context).rojoNoConforme, size: 24.0))),
        ].divide(const SizedBox(width: 8.0))),
      ].divide(const SizedBox(width: 10.0)))),
    );
  }

  Widget _buildCreateForm(BuildContext ctx, String? errorMsg, void Function(String) mostrarError) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: FlutterFlowTheme.of(ctx).colorFondoPrimary, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0), child: Container(
        decoration: BoxDecoration(color: FlutterFlowTheme.of(ctx).containerColorPrimary, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: FlutterFlowTheme.of(ctx).customColor4bbbbb)),
        child: Padding(padding: const EdgeInsets.all(16.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Crear Alcance de Observación', style: FlutterFlowTheme.of(ctx).bodyMedium.override(font: TextStyle(fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle), fontSize: 20.0, letterSpacing: 0.0, fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle)),
            IconButton(onPressed: () => Navigator.pop(ctx), icon: Icon(Icons.close, color: FlutterFlowTheme.of(ctx).primaryText, size: 24.0)),
          ])),
          Form(key: _model.formKey, autovalidateMode: AutovalidateMode.disabled, child: Padding(padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nombre', style: FlutterFlowTheme.of(ctx).bodyMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(ctx).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle), fontSize: 18.0, letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(ctx).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle)),
              TextFormField(controller: _model.txtnombreTextController, focusNode: _model.txtnombreFocusNode, autofocus: false, obscureText: false, decoration: InputDecoration(isDense: true, hintText: 'Escribe', hintStyle: FlutterFlowTheme.of(ctx).labelMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(ctx).labelMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).labelMedium.fontStyle), letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(ctx).labelMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).labelMedium.fontStyle), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(ctx).customColor4bbbbb, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(ctx).mouseregionTEXT, width: 2.0), borderRadius: BorderRadius.circular(8.0)), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(ctx).error, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(ctx).error, width: 2.0), borderRadius: BorderRadius.circular(8.0))), style: FlutterFlowTheme.of(ctx).bodyMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(ctx).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle), letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(ctx).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).bodyMedium.fontStyle), maxLines: null, cursorColor: FlutterFlowTheme.of(ctx).primaryText, enableInteractiveSelection: true, validator: _model.txtnombreTextControllerValidator.asValidator(ctx)),
            ].divide(const SizedBox(height: 5.0))),
            if (errorMsg != null) Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0), decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8.0), border: Border.all(color: const Color(0xFFE53935))), child: Row(children: [const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18.0), const SizedBox(width: 8.0), Expanded(child: Text(errorMsg, style: const TextStyle(color: Color(0xFFE53935), fontSize: 13.0)))])),
            Row(children: [Expanded(child: Padding(padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0), child: FFButtonWidget(
              onPressed: () async {
                final nombreIngresado = _model.txtnombreTextController.text.trim();
                if (nombreIngresado.isEmpty) { mostrarError('Ingresa el nombre del alcance de observación'); return; }
                if (_model.estaconectado ?? false) {
                  final nuevoId = random_data.randomString(1, 5, true, false, true);
                  await SupaFlow.client.from('ObservationScopes').insert({'observation_scope_id': nuevoId, 'name': nombreIngresado, 'status': true, 'created_at': DateTime.now().toIso8601String(), 'updated_at': DateTime.now().toIso8601String()});
                  await DBObservationScope.insertObservationScope(ObservationScope(observationScopeId: nuevoId, name: nombreIngresado, createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String(), status: true), fromSupabase: true);
                  final data = await SupaFlow.client.from('ObservationScopes').select().eq('status', true).order('name');
                  _model.listObservationScope = (data as List).map((e) => ObservationScope.fromSupabase(e as Map<String, dynamic>)).toList();
                } else {
                  await DBObservationScope.insertObservationScope(ObservationScope(observationScopeId: random_data.randomString(1, 5, true, false, true), name: nombreIngresado, createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String(), status: true));
                  _model.listObservationScope = await DBObservationScope.getAllObservationScopes();
                }
                safeSetState(() { _model.txtnombreTextController?.clear(); });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Alcance de Observación creado exitosamente', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground)), duration: const Duration(milliseconds: 3000), backgroundColor: FlutterFlowTheme.of(context).secondary));
              },
              text: 'Guardar', icon: FaIcon(FontAwesomeIcons.save, size: 15.0),
              options: FFButtonOptions(height: 40.0, padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0), iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0), color: FlutterFlowTheme.of(ctx).primaryText, textStyle: FlutterFlowTheme.of(ctx).titleSmall.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(ctx).titleSmall.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).titleSmall.fontStyle), color: Colors.white, letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(ctx).titleSmall.fontWeight, fontStyle: FlutterFlowTheme.of(ctx).titleSmall.fontStyle), elevation: 0.0, borderRadius: BorderRadius.circular(8.0)),
            )))]),
          ].divide(const SizedBox(height: 8.0))))),
        ])),
      ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return Builder(builder: (context) => GestureDetector(
      onTap: () { FocusScope.of(context).unfocus(); FocusManager.instance.primaryFocus?.unfocus(); },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).colorFondoPrimary,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondary, automaticallyImplyLeading: false,
          leading: InkWell(splashColor: Colors.transparent, focusColor: Colors.transparent, hoverColor: Colors.transparent, highlightColor: Colors.transparent, onTap: () async { context.pushNamed(HallazgosWidget.routeName); }, child: Icon(Icons.arrow_back, color: FlutterFlowTheme.of(context).primaryBackground, size: 24.0)),
          title: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset('assets/images/download__7_-removebg-preview.png', width: 157.89, height: 33.4, fit: BoxFit.cover)),
            Flexible(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40.0, height: 40.0, constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0, maxWidth: 40.0, maxHeight: 40.0), decoration: const BoxDecoration(), child: Align(alignment: AlignmentDirectional(1.0, 0.0), child: wrapWithModel(model: _model.wifiComponentModel, updateCallback: () => safeSetState(() {}), child: WifiComponentWidget(conexion: _model.estaconectado!)))),
              Container(width: 40.0, height: 40.0, constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0, maxWidth: 40.0, maxHeight: 40.0), decoration: const BoxDecoration(), child: wrapWithModel(model: _model.exitComponentModel, updateCallback: () => safeSetState(() {}), child: ExitComponentWidget())),
            ].divide(const SizedBox(width: 16.0)))),
          ].divide(const SizedBox(width: 8.0))),
          actions: const [], centerTitle: false, elevation: 2.0,
        ),
        body: SafeArea(top: true, child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(child: Text('Listado de Alcances de Observacion', maxLines: 2, softWrap: true, style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), fontSize: 18.0, letterSpacing: 0.0, fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle))),
              ElevatedButton.icon(onPressed: () { String? _modalErrorMsg; showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, useSafeArea: true, builder: (mc) => StatefulBuilder(builder: (ctx, setModalState) { void mostrarError(String msg) { setModalState(() => _modalErrorMsg = msg); Future.delayed(const Duration(seconds: 3), () { setModalState(() => _modalErrorMsg = null); }); } return Padding(padding: MediaQuery.viewInsetsOf(mc), child: _buildCreateForm(ctx, _modalErrorMsg, mostrarError)); })); }, icon: const Icon(Icons.add, size: 18.0), label: const Text('Crear'), style: ElevatedButton.styleFrom(backgroundColor: FlutterFlowTheme.of(context).primaryText, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
            ]),
            const SizedBox(height: 12.0),
            Expanded(child: Builder(builder: (context) {
              final list = _model.listObservationScope;
              return ListView.separated(padding: EdgeInsets.zero, scrollDirection: Axis.vertical, itemCount: list.length, separatorBuilder: (_, __) => const SizedBox(height: 16.0), itemBuilder: (context, index) => _buildItem(list[index]));
            })),
          ]),
        )),
      ),
    ));
  }
}
