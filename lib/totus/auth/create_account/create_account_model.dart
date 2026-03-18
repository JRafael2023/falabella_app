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
  ///  Local state fields for this page.

  Usuario? usuario;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for txtid widget.
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa un id valido';
    }

    return null;
  }

  // State field(s) for txtemail widget.
  FocusNode? txtemailFocusNode;
  TextEditingController? txtemailTextController;
  String? Function(BuildContext, String?)? txtemailTextControllerValidator;
  String? _txtemailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa un correo';
    }

    return null;
  }

  // State field(s) for txtname widget.
  FocusNode? txtnameFocusNode;
  TextEditingController? txtnameTextController;
  String? Function(BuildContext, String?)? txtnameTextControllerValidator;
  // State field(s) for txtlastname widget.
  FocusNode? txtlastnameFocusNode1;
  TextEditingController? txtlastnameTextController1;
  String? Function(BuildContext, String?)? txtlastnameTextController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for txtlastname widget.
  FocusNode? txtlastnameFocusNode2;
  TextEditingController? txtlastnameTextController2;
  String? Function(BuildContext, String?)? txtlastnameTextController2Validator;
  // State field(s) for txtcarnet widget.
  FocusNode? txtcarnetFocusNode;
  TextEditingController? txtcarnetTextController;
  String? Function(BuildContext, String?)? txtcarnetTextControllerValidator;
  // State field(s) for password_Create widget.
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

  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
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
