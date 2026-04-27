import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import 'dart:ui';
import '/custom_code/Usuario.dart';
import '/index.dart';
import 'create_account_widget.dart' show CreateAccountWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountModel extends FlutterFlowModel<CreateAccountWidget> {

  Usuario? usuario;


  final formKey = GlobalKey<FormState>();
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa un id valido';
    }

    return null;
  }

  FocusNode? txtemailFocusNode;
  TextEditingController? txtemailTextController;
  String? Function(BuildContext, String?)? txtemailTextControllerValidator;
  String? _txtemailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa un correo';
    }

    return null;
  }

  FocusNode? txtnameFocusNode;
  TextEditingController? txtnameTextController;
  String? Function(BuildContext, String?)? txtnameTextControllerValidator;
  FocusNode? txtlastnameFocusNode1;
  TextEditingController? txtlastnameTextController1;
  String? Function(BuildContext, String?)? txtlastnameTextController1Validator;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  FocusNode? txtlastnameFocusNode2;
  TextEditingController? txtlastnameTextController2;
  String? Function(BuildContext, String?)? txtlastnameTextController2Validator;
  FocusNode? txtcarnetFocusNode;
  TextEditingController? txtcarnetTextController;
  String? Function(BuildContext, String?)? txtcarnetTextControllerValidator;
  FocusNode? passwordCreateFocusNode;
  TextEditingController? passwordCreateTextController;
  late bool passwordCreateVisibility;
  String? Function(BuildContext, String?)?
      passwordCreateTextControllerValidator;
  String? _passwordCreateTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  bool? checkboxValue1;
  bool? checkboxValue2;

  @override
  void initState(BuildContext context) {
    txtidTextControllerValidator = _txtidTextControllerValidator;
    txtemailTextControllerValidator = _txtemailTextControllerValidator;
    passwordCreateVisibility = false;
    passwordCreateTextControllerValidator =
        _passwordCreateTextControllerValidator;
  }

  @override
  void dispose() {
    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    txtemailFocusNode?.dispose();
    txtemailTextController?.dispose();

    txtnameFocusNode?.dispose();
    txtnameTextController?.dispose();

    txtlastnameFocusNode1?.dispose();
    txtlastnameTextController1?.dispose();

    txtlastnameFocusNode2?.dispose();
    txtlastnameTextController2?.dispose();

    txtcarnetFocusNode?.dispose();
    txtcarnetTextController?.dispose();

    passwordCreateFocusNode?.dispose();
    passwordCreateTextController?.dispose();
  }
}
