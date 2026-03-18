import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBRiskTypology.dart';
import '/custom_code/RiskTypology.dart';
import '/custom_code/DBRiskType.dart';
import '/custom_code/RiskType.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_risk_typology_model.dart';
export 'edit_risk_typology_model.dart';

class EditRiskTypologyWidget extends StatefulWidget {
  const EditRiskTypologyWidget({
    super.key,
    bool? conexion,
    this.idRiskTypology,
    this.nombre,
    this.riskTypeId,
    this.update,
  }) : this.conexion = conexion ?? false;

  final bool conexion;
  final String? idRiskTypology;
  final String? nombre;
  final String? riskTypeId;
  final Future Function(List<RiskTypology> listRiskTypology)? update;

  @override
  State<EditRiskTypologyWidget> createState() => _EditRiskTypologyWidgetState();
}

class _EditRiskTypologyWidgetState extends State<EditRiskTypologyWidget> {
  late EditRiskTypologyModel _model;
  String? _errorMsg;

  void _mostrarError(String msg) {
    setState(() => _errorMsg = msg);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _errorMsg = null);
    });
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditRiskTypologyModel());
    _model.txtnombreTextController ??= TextEditingController(text: widget.nombre);
    _model.txtnombreFocusNode ??= FocusNode();
    _model.selectedRiskTypeId = widget.riskTypeId;
    _loadRiskTypes();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadRiskTypes() async {
    final isConnected = await actions.checkInternetConecction();
    if (isConnected) {
      final data = await SupaFlow.client.from('RiskTypes').select().eq('status', true).order('name');
      _model.listRiskTypes = (data as List).map((e) => RiskType.fromSupabase(e as Map<String, dynamic>)).toList();
    } else {
      _model.listRiskTypes = await DBRiskType.getAllRiskTypes();
    }
    if (mounted) safeSetState(() {});
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 15.0, 8.0, 15.0),
      child: Container(
        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).containerColorPrimary, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: FlutterFlowTheme.of(context).customColor4bbbbb, width: 2.0)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
            child: Text('Editar Tipologia de Riesgo', style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), fontSize: 24.0, letterSpacing: 0.0, fontWeight: FontWeight.bold, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle))),
          Padding(padding: const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
            child: Form(key: _model.formKey, autovalidateMode: AutovalidateMode.disabled,
              child: Padding(padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Nombre', style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), fontSize: 18.0, letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle)),
                    TextFormField(controller: _model.txtnombreTextController, focusNode: _model.txtnombreFocusNode, autofocus: false, obscureText: false, decoration: InputDecoration(isDense: true, hintText: 'Escribe', hintStyle: FlutterFlowTheme.of(context).labelMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle), letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).customColor4bbbbb, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).mouseregionTEXT, width: 2.0), borderRadius: BorderRadius.circular(8.0)), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2.0), borderRadius: BorderRadius.circular(8.0))), style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), maxLines: null, cursorColor: FlutterFlowTheme.of(context).primaryText, enableInteractiveSelection: true, validator: _model.txtnombreTextControllerValidator.asValidator(context)),
                  ].divide(const SizedBox(height: 5.0))),
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Tipo de Riesgo', style: FlutterFlowTheme.of(context).bodyMedium.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle), fontSize: 18.0, letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight, fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle)),
                    DropdownButtonFormField<String>(
                      value: _model.selectedRiskTypeId,
                      decoration: InputDecoration(isDense: true, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).customColor4bbbbb, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).mouseregionTEXT, width: 2.0), borderRadius: BorderRadius.circular(8.0)), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2.0), borderRadius: BorderRadius.circular(8.0)), focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2.0), borderRadius: BorderRadius.circular(8.0))),
                      hint: const Text('Seleccionar tipo de riesgo'),
                      items: _model.listRiskTypes.map((rt) => DropdownMenuItem<String>(value: rt.riskTypeId, child: Text(rt.name ?? ''))).toList(),
                      onChanged: (val) => safeSetState(() => _model.selectedRiskTypeId = val),
                    ),
                  ].divide(const SizedBox(height: 5.0))),
                  if (_errorMsg != null) Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0), decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8.0), border: Border.all(color: const Color(0xFFE53935))), child: Row(children: [const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18.0), const SizedBox(width: 8.0), Expanded(child: Text(_errorMsg!, style: const TextStyle(color: Color(0xFFE53935), fontSize: 13.0, fontWeight: FontWeight.w500)))])),
                  Row(children: [Expanded(child: Padding(padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        final nombreNuevo = _model.txtnombreTextController.text.trim();
                        if (nombreNuevo.isEmpty) { _mostrarError('Ingresa el nombre de la tipologia de riesgo'); return; }
                        _model.estaconectado = await actions.checkInternetConecction();
                        if (_model.estaconectado!) {
                          await SupaFlow.client.from('RiskTypologies').update({'name': nombreNuevo, 'risk_type_id': _model.selectedRiskTypeId, 'updated_at': DateTime.now().toIso8601String()}).eq('risk_typology_id', widget.idRiskTypology ?? '');
                          final data = await SupaFlow.client.from('RiskTypologies').select().eq('status', true).order('name');
                          _model.listRiskTypology = (data as List).map((e) => RiskTypology.fromSupabase(e as Map<String, dynamic>)).toList();
                          safeSetState(() {});
                        } else {
                          await DBRiskTypology.updateRiskTypology(RiskTypology(riskTypologyId: widget.idRiskTypology, name: nombreNuevo, riskTypeId: _model.selectedRiskTypeId, createdAt: DateTime.now().toIso8601String(), updatedAt: DateTime.now().toIso8601String(), status: true));
                          _model.listRiskTypology = await DBRiskTypology.getAllRiskTypologies();
                          safeSetState(() {});
                        }
                        Navigator.pop(context);
                        await widget.update?.call(_model.listRiskTypology);
                        safeSetState(() {});
                      },
                      text: 'Guardar',
                      icon: FaIcon(FontAwesomeIcons.save, size: 15.0),
                      options: FFButtonOptions(height: 40.0, padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0), iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0), color: FlutterFlowTheme.of(context).primaryText, textStyle: FlutterFlowTheme.of(context).titleSmall.override(font: TextStyle(fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight, fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle), color: Colors.white, letterSpacing: 0.0, fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight, fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle), elevation: 0.0, borderRadius: BorderRadius.circular(8.0)),
                    )))]),
                ].divide(const SizedBox(height: 8.0))),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
