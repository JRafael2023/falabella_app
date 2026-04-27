import '/backend/supabase/supabase.dart';
import 'dart:math';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/card_user/card_user_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/Usuario.dart';
import '/custom_code/DBUsuarios.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/InternetCheckMixin.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'usuarios_model.dart';
export 'usuarios_model.dart';

class UsuariosWidget extends StatefulWidget {
  const UsuariosWidget({super.key});

  static String routeName = 'Usuarios';
  static String routePath = '/usuarios';

  @override
  State<UsuariosWidget> createState() => _UsuariosWidgetState();
}

class _UsuariosWidgetState extends State<UsuariosWidget> with WidgetsBindingObserver, InternetCheckMixin {
  late UsuariosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _errorMsg;

  String _generarIdUnico() {
    final rng = Random();
    final existentes = FFAppState().jsonUsers
        .map((u) => (u as Map)['user_uid']?.toString() ?? '')
        .toSet();
    String id;
    do {
      final digitos = 4 + rng.nextInt(3); // 4, 5 o 6 dígitos
      final min = _pow10(digitos - 1);
      final max = _pow10(digitos) - 1;
      id = (min + rng.nextInt(max - min + 1)).toString();
    } while (existentes.contains(id));
    return id;
  }

  int _pow10(int exp) {
    int result = 1;
    for (int i = 0; i < exp; i++) result *= 10;
    return result;
  }

  void _mostrarError(String msg, {VoidCallback? refresh}) {
    _errorMsg = msg;
    refresh?.call();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _errorMsg = null;
        refresh?.call();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UsuariosModel());

    initInternetCheck(context, onConnectionChanged: (isConnected) {
      _model.estaconectado = isConnected;
      if (mounted) {
        safeSetState(() {});
      }
    });

    _model.txtnombreTextController ??= TextEditingController();
    _model.txtnombreFocusNode ??= FocusNode();

    _model.txtcorreoTextController ??= TextEditingController();
    _model.txtcorreoFocusNode ??= FocusNode();

    _model.txtidTextController ??= TextEditingController();
    _model.txtidFocusNode ??= FocusNode();

    _model.txtcontraTextController ??= TextEditingController();
    _model.txtcontraFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    disposeInternetCheck();
    _model.dispose();

    super.dispose();
  }

  InputDecoration _inputDeco(BuildContext context) {
    return InputDecoration(
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
    );
  }

  TextStyle _fieldTextStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          font: TextStyle(
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
          letterSpacing: 0.0,
          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        );
  }

  TextStyle _labelTextStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          font: TextStyle(
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
          fontSize: 18.0,
          letterSpacing: 0.0,
          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
        );
  }

  Widget _buildFormUsuario(BuildContext context, BuildContext rootContext, {VoidCallback? refresh}) {
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
                        'Crear Usuario',
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
                              Text('Nombre', style: _labelTextStyle(context)),
                              Container(
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  controller: _model.txtnombreTextController,
                                  focusNode: _model.txtnombreFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  maxLength: 100,
                                  maxLines: 1,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                  decoration: _inputDeco(context),
                                  style: _fieldTextStyle(context),
                                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                                  enableInteractiveSelection: true,
                                  validator: _model.txtnombreTextControllerValidator.asValidator(context),
                                ),
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo', style: _labelTextStyle(context)),
                              Container(
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  controller: _model.txtcorreoTextController,
                                  focusNode: _model.txtcorreoFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  maxLength: 100,
                                  maxLines: 1,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                  decoration: _inputDeco(context),
                                  style: _fieldTextStyle(context),
                                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                                  enableInteractiveSelection: true,
                                  validator: _model.txtcorreoTextControllerValidator.asValidator(context),
                                ),
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Id Usuario', style: _labelTextStyle(context)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.txtidTextController,
                                      focusNode: _model.txtidFocusNode,
                                      autofocus: false,
                                      readOnly: true,
                                      obscureText: false,
                                      maxLines: 1,
                                      decoration: _inputDeco(context),
                                      style: _fieldTextStyle(context).copyWith(
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                      validator: _model.txtidTextControllerValidator.asValidator(context),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  IconButton(
                                    tooltip: 'Generar nuevo ID',
                                    onPressed: () {
                                      _model.txtidTextController?.text = _generarIdUnico();
                                      refresh?.call();
                                    },
                                    icon: Icon(Icons.refresh, color: FlutterFlowTheme.of(context).primary),
                                    style: IconButton.styleFrom(
                                      backgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contraseña', style: _labelTextStyle(context)),
                              Container(
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  controller: _model.txtcontraTextController,
                                  focusNode: _model.txtcontraFocusNode,
                                  autofocus: false,
                                  obscureText: !_model.txtcontraVisibility,
                                  maxLength: 100,
                                  maxLines: 1,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                  decoration: _inputDeco(context).copyWith(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _model.txtcontraVisibility =
                                            !_model.txtcontraVisibility;
                                        refresh?.call();
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.txtcontraVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  style: _fieldTextStyle(context),
                                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                                  enableInteractiveSelection: true,
                                  validator: _model.txtcontraTextControllerValidator.asValidator(context),
                                ),
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('País', style: _labelTextStyle(context)),
                              Container(
                                decoration: BoxDecoration(),
                                child: FlutterFlowDropDown<String>(
                                  controller: _model.cbopaisValueController ??=
                                      FormFieldController<String>(null),
                                  options: functions.getAllCountryListv(),
                                  onChanged: (val) {
                                    _model.cbopaisValue = val;
                                    refresh?.call();
                                  },
                                  maxHeight: 200.0,
                                  searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: TextStyle(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                  searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: TextStyle(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: TextStyle(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                  hintText: 'Seleccione',
                                  searchHintText: 'Buscar',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  elevation: 2.0,
                                  borderColor: Color(0xFFE1E0E0),
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isOverButton: false,
                                  isSearchable: true,
                                  isMultiSelect: false,
                                ),
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rol', style: _labelTextStyle(context)),
                              Container(
                                decoration: BoxDecoration(),
                                child: FlutterFlowDropDown<String>(
                                  controller: _model.cborolValueController ??=
                                      FormFieldController<String>(_model.cborolValue ??= ''),
                                  options: List<String>.from(['administrador', 'usuario']),
                                  optionLabels: ['Administrador', 'Usuario'],
                                  onChanged: (val) {
                                    _model.cborolValue = val;
                                    refresh?.call();
                                  },
                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: TextStyle(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                  hintText: 'Seleccione',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  elevation: 2.0,
                                  borderColor: Color(0xFFE1E0E0),
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isOverButton: false,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ),
                            ].divide(SizedBox(height: 5.0)),
                          ),
                          if (_errorMsg != null)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFEBEB),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Color(0xFFE53935)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18.0),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      _errorMsg!,
                                      style: TextStyle(
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

                                      if (_model.cborolValue == null || _model.cborolValue!.isEmpty) {
                                        _mostrarError('Selecciona un rol para el usuario', refresh: refresh);
                                        return;
                                      }

                                      final idIngresado = _model.txtidTextController.text.trim();
                                      final existeLocal = await DBUsuarios.existeUsuario(idIngresado);
                                      if (existeLocal) {
                                        _mostrarError('El ID "$idIngresado" ya está en uso. Ingresa uno diferente.', refresh: refresh);
                                        return;
                                      }

                                      if (_model.estaconectado!) {
                                        _model.validAuth = await actions.registerUserSupabaseAuth(
                                          _model.txtcorreoTextController.text,
                                          _model.txtcontraTextController.text,
                                        );
                                        if (_model.validAuth == 'OK') {
                                          await UsersTable().insert({
                                            'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                            'user_uid': idIngresado,
                                            'email': _model.txtcorreoTextController.text,
                                            'display_name': _model.txtnombreTextController.text,
                                            'country': _model.cbopaisValue,
                                            'role': _model.cborolValue,
                                            'updated_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                            'status': true,
                                          });
                                          await actions.insertUsuarioSQLite(
                                            _model.txtcorreoTextController.text,
                                            _model.txtnombreTextController.text,
                                            idIngresado,
                                            _model.cbopaisValue,
                                            _model.cborolValue,
                                          );
                                          _model.sqlLiteUsersListON = await actions.sqLiteListUsers();
                                          FFAppState().jsonUsers =
                                              _model.sqlLiteUsersListON!.toList().cast<dynamic>();
                                          FFAppState().update(() {});
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Usuario Creado Exitosamente',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(context).accent4,
                                                ),
                                              ),
                                              duration: Duration(milliseconds: 4000),
                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                            ),
                                          );
                                        } else {
                                          _mostrarError(
                                            _model.validAuth != null && _model.validAuth!.isNotEmpty
                                                ? _model.validAuth!
                                                : 'Error al crear el usuario. Verifica los datos e intenta de nuevo.',
                                            refresh: refresh,
                                          );
                                          return;
                                        }
                                      } else {
                                        await actions.insertUsuarioSQLite(
                                          _model.txtcorreoTextController.text,
                                          _model.txtnombreTextController.text,
                                          idIngresado,
                                          _model.cbopaisValue,
                                          _model.cborolValue,
                                          passwordTemp: _model.txtcontraTextController.text,
                                        );
                                        _model.sqlLiteUsersListOFF = await actions.sqLiteListUsers();
                                        FFAppState().jsonUsers =
                                            _model.sqlLiteUsersListOFF!.toList().cast<dynamic>();
                                        FFAppState().update(() {});
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Usuario guardado localmente. Sincroniza para subirlo a la nube.',
                                              style: TextStyle(
                                                color: FlutterFlowTheme.of(context).accent4,
                                              ),
                                            ),
                                            duration: Duration(milliseconds: 4500),
                                            backgroundColor: Color(0xFF856404),
                                          ),
                                        );
                                      }

                                      safeSetState(() {
                                        _model.txtnombreTextController?.clear();
                                        _model.txtcorreoTextController?.clear();
                                        _model.txtidTextController?.clear();
                                        _model.txtcontraTextController?.clear();
                                      });
                                      safeSetState(() {
                                        _model.cborolValueController?.reset();
                                        _model.cborolValue = null;
                                        _model.cbopaisValueController?.reset();
                                        _model.cbopaisValue = null;
                                      });

                                      safeSetState(() {});
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
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listado de Usuarios',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              font: TextStyle(fontWeight: FontWeight.bold),
                              letterSpacing: 0.0,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final rootContext = context;
                          _model.txtidTextController?.text = _generarIdUnico();
                          showModalBottomSheet(
                            context: rootContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            useSafeArea: true,
                            builder: (modalContext) => StatefulBuilder(
                              builder: (sbContext, setModalState) => Padding(
                                padding: MediaQuery.viewInsetsOf(sbContext),
                                child: _buildFormUsuario(
                                  sbContext,
                                  rootContext,
                                  refresh: () => setModalState(() {}),
                                ),
                              ),
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
                    return FutureBuilder<List<UsersRow>>(
                      future: UsersTable().queryRows(
                        queryFn: (q) => q,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LoadingListTottusWidget(
                            texto: 'Lista de Usuarios Vacio',
                          );
                        }
                        List<UsersRow> containerUsersRowList = snapshot.data!;

                        if (containerUsersRowList.isEmpty) {
                          return Center(
                            child: LoadingListTottusWidget(
                              texto: 'Lista de Usuarios Vacio',
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: containerUsersRowList.length,
                          itemBuilder: (context, arrayUsersONIndex) {
                            final arrayUsersONItem = containerUsersRowList[arrayUsersONIndex];
                            return wrapWithModel(
                              model: _model.cardUserModels1.getModel(
                                arrayUsersONIndex.toString(),
                                arrayUsersONIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: CardUserWidget(
                                key: Key(
                                  'Keyooe_${arrayUsersONIndex.toString()}',
                                ),
                                email: arrayUsersONItem.email,
                                rol: arrayUsersONItem.role,
                                uidFirebaseUser: arrayUsersONItem.userUid,
                                nombre: arrayUsersONItem.displayName,
                                fechaCreacion: arrayUsersONItem.createdAt,
                                uidUsuario: arrayUsersONItem.userUid,
                                pais: arrayUsersONItem.country,
                                contra: null,
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
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
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
                            child: Builder(
                              builder: (context) {
                                final arraySQLiteUsers = FFAppState().jsonUsers.toList();
                                if (arraySQLiteUsers.isEmpty) {
                                  return LoadingListTottusWidget(
                                    texto: 'Lista de Usuarios Vacio',
                                  );
                                }

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: arraySQLiteUsers.length,
                                  separatorBuilder: (_, __) => SizedBox(height: 8.0),
                                  itemBuilder: (context, arraySQLiteUsersIndex) {
                                    final arraySQLiteUsersItem = arraySQLiteUsers[arraySQLiteUsersIndex];
                                    return wrapWithModel(
                                      model: _model.cardUserModels2.getModel(
                                        arraySQLiteUsersIndex.toString(),
                                        arraySQLiteUsersIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardUserWidget(
                                        key: Key(
                                          'Keyytq_${arraySQLiteUsersIndex.toString()}',
                                        ),
                                        email: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.email''',
                                        ).toString(),
                                        rol: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.role''',
                                        ).toString(),
                                        uidFirebaseUser: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.uid''',
                                        ).toString(),
                                        nombre: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.display_name''',
                                        ).toString(),
                                        fechaCreacion: functions.convertStringtoDate(getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.created_at''',
                                        ).toString()),
                                        uidUsuario: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.user_uid''',
                                        ).toString(),
                                        pais: getJsonField(
                                          arraySQLiteUsersItem,
                                          r'''$.country''',
                                        ).toString(),
                                        contra: null,
                                        esPendienteSincronizar: (getJsonField(
                                              arraySQLiteUsersItem,
                                              r'''$.sincronizadoNube''',
                                            ) as int? ?? 1) == 0,
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
