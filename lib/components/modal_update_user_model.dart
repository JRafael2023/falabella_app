import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/Usuario.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'modal_update_user_widget.dart' show ModalUpdateUserWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalUpdateUserModel extends FlutterFlowModel<ModalUpdateUserWidget> {

  Usuario? usuario;


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  FocusNode? txtcorreoFocusNode;
  TextEditingController? txtcorreoTextController;
  String? Function(BuildContext, String?)? txtcorreoTextControllerValidator;
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  FocusNode? txtcontraFocusNode;
  TextEditingController? txtcontraTextController;
  late bool txtcontraVisibility;
  String? Function(BuildContext, String?)? txtcontraTextControllerValidator;
  String? cbopaisValue;
  FormFieldController<String>? cbopaisValueController;
  String? cborolValue;
  FormFieldController<String>? cborolValueController;
  List<UsersRow>? qONSUpabseRows;
  List<dynamic>? qUsersON;
  List<dynamic>? listSqUsers;
  List<dynamic>? qOFFUsers;

  @override
  void initState(BuildContext context) {
    txtcontraVisibility = false;
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
    txtcontraTextControllerValidator = (context, value) {
      if (value == null || value.trim().isEmpty) {
        return 'La contraseña es obligatoria';
      }
      return null;
    };
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    txtcorreoFocusNode?.dispose();
    txtcorreoTextController?.dispose();

    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    txtcontraFocusNode?.dispose();
    txtcontraTextController?.dispose();
  }
}
