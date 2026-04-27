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
import '/totus/components/card_user/card_user_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/Usuario.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'usuarios_widget.dart' show UsuariosWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsuariosModel extends FlutterFlowModel<UsuariosWidget> {

  Usuario? usuario;


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  FocusNode? txtcorreoFocusNode;
  TextEditingController? txtcorreoTextController;
  String? Function(BuildContext, String?)? txtcorreoTextControllerValidator;
  String? _txtcorreoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa el id';
    }

    return null;
  }

  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe is required';
    }

    return null;
  }

  FocusNode? txtcontraFocusNode;
  TextEditingController? txtcontraTextController;
  late bool txtcontraVisibility;
  String? Function(BuildContext, String?)? txtcontraTextControllerValidator;
  String? _txtcontraTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe is required';
    }

    return null;
  }

  String? cbopaisValue;
  FormFieldController<String>? cbopaisValueController;
  String? cborolValue;
  FormFieldController<String>? cborolValueController;
  String? validAuth;
  List<dynamic>? sqlLiteUsersListON;
  List<dynamic>? sqlLiteUsersListOFF;
  late FlutterFlowDynamicModels<CardUserModel> cardUserModels1;
  late FlutterFlowDynamicModels<CardUserModel> cardUserModels2;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    txtnombreTextControllerValidator = (context, value) {
      if (value == null || value.trim().isEmpty) {
        return 'El nombre es obligatorio';
      }
      return null;
    };
    txtcorreoTextControllerValidator = (context, value) {
      if (value == null || value.trim().isEmpty) {
        return 'El correo es obligatorio';
      }
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Ingresa un correo válido';
      }
      return null;
    };
    txtidTextControllerValidator = (context, value) {
      if (value == null || value.trim().isEmpty) {
        return 'El ID de usuario es obligatorio';
      }
      return null;
    };
    txtcontraVisibility = false;
    txtcontraTextControllerValidator = (context, value) {
      if (value == null || value.trim().isEmpty) {
        return 'La contraseña es obligatoria';
      }
      return null;
    };
    cardUserModels1 = FlutterFlowDynamicModels(() => CardUserModel());
    cardUserModels2 = FlutterFlowDynamicModels(() => CardUserModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    txtcorreoFocusNode?.dispose();
    txtcorreoTextController?.dispose();

    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    txtcontraFocusNode?.dispose();
    txtcontraTextController?.dispose();

    cardUserModels1.dispose();
    cardUserModels2.dispose();
  }
}
