import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/components/advertencia_login/advertencia_login_widget.dart';
import 'dart:async';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  Local state fields for this page.

  bool stateError = false;
  String errorMessage = 'Correo electrónico o contraseña incorrecta. Por favor, vuelve a intentarlo nuevamente.';

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for AdvertenciaLogin component.
  late AdvertenciaLoginModel advertenciaLoginModel;
  // State field(s) for txtemail widget.
  FocusNode? txtemailFocusNode;
  TextEditingController? txtemailTextController;
  String? Function(BuildContext, String?)? txtemailTextControllerValidator;
  String? _txtemailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa tu Correo Electrónico ';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Ingrese Formato Correo Correcto';
    }
    return null;
  }

  // State field(s) for txtcontra widget.
  FocusNode? txtcontraFocusNode;
  TextEditingController? txtcontraTextController;
  late bool txtcontraVisibility;
  String? Function(BuildContext, String?)? txtcontraTextControllerValidator;
  String? _txtcontraTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa tu Contraseña';
    }

    return null;
  }

  // Stores action output result for [Custom Action - checkInternetConecction] action in btnlogin widget.
  bool? conectado;
  // Stores action output result for [Custom Action - loginWithSupabaseAuth] action in btnlogin widget.
  String? returnlogin;
  // Stores action output result for [Custom Action - getUsuarioByEmail] action in btnlogin widget.
  dynamic? correct;

  @override
  void initState(BuildContext context) {
    advertenciaLoginModel = createModel(context, () => AdvertenciaLoginModel());
    txtemailTextControllerValidator = _txtemailTextControllerValidator;
    txtcontraVisibility = false;
    txtcontraTextControllerValidator = _txtcontraTextControllerValidator;
  }

  @override
  void dispose() {
    advertenciaLoginModel.dispose();
    txtemailFocusNode?.dispose();
    txtemailTextController?.dispose();

    txtcontraFocusNode?.dispose();
    txtcontraTextController?.dispose();
  }
}
