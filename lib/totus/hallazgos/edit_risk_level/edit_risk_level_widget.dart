import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBRiskLevel.dart';
import '/custom_code/RiskLevel.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_risk_level_model.dart';
export 'edit_risk_level_model.dart';

class EditRiskLevelWidget extends StatefulWidget {
  const EditRiskLevelWidget({
    super.key,
    bool? conexion,
    this.idRiskLevel,
    this.nombre,
    this.update,
  }) : this.conexion = conexion ?? false;

  final bool conexion;
  final String? idRiskLevel;
  final String? nombre;
  final Future Function(List<RiskLevel> listRiskLevel)? update;

  @override
  State<EditRiskLevelWidget> createState() => _EditRiskLevelWidgetState();
}

class _EditRiskLevelWidgetState extends State<EditRiskLevelWidget> {
  late EditRiskLevelModel _model;

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
    _model = createModel(context, () => EditRiskLevelModel());

    _model.txtnombreTextController ??=
        TextEditingController(text: widget.nombre);
    _model.txtnombreFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                'Editar Nivel de Riesgo',
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
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
                      if (_errorMsg != null)
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
                                  _errorMsg!,
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
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  final nombreNuevo = _model.txtnombreTextController.text.trim();
                                  if (nombreNuevo.isEmpty) {
                                    _mostrarError('Ingresa el nombre del nivel de riesgo');
                                    return;
                                  }

                                  _model.estaconectado = await actions.checkInternetConecction();
                                  if (_model.estaconectado!) {
                                    await SupaFlow.client.from('RiskLevels').update({
                                      'name': nombreNuevo,
                                      'updated_at': DateTime.now().toIso8601String(),
                                    }).eq('risk_level_id', widget.idRiskLevel ?? '');
                                    final data = await SupaFlow.client
                                        .from('RiskLevels')
                                        .select()
                                        .eq('status', true)
                                        .order('name');
                                    _model.listRiskLevel = (data as List)
                                        .map((e) => RiskLevel.fromSupabase(e as Map<String, dynamic>))
                                        .toList();
                                    safeSetState(() {});
                                  } else {
                                    await DBRiskLevel.updateRiskLevel(
                                      RiskLevel(
                                        riskLevelId: widget.idRiskLevel,
                                        name: nombreNuevo,
                                        createdAt: DateTime.now().toIso8601String(),
                                        updatedAt: DateTime.now().toIso8601String(),
                                        status: true,
                                      ),
                                    );
                                    _model.listRiskLevel = await DBRiskLevel.getAllRiskLevels();
                                    safeSetState(() {});
                                  }

                                  Navigator.pop(context);
                                  await widget.update?.call(_model.listRiskLevel);
                                  safeSetState(() {});
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
            ),
          ],
        ),
      ),
    );
  }
}
