import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'edit_project_widget.dart' show EditProjectWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProjectModel extends FlutterFlowModel<EditProjectWidget> {

  dynamic jsonSearchProyect;


  final formKey = GlobalKey<FormState>();
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese un ID Proyecto';
    }

    return null;
  }

  String? cbomatrixValue;
  FormFieldController<String>? cbomatrixValueController;
  String? cboUserAssignValue;
  FormFieldController<String>? cboUserAssignValueController;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese Nombre';
    }

    return null;
  }

  FocusNode? txtdescFocusNode;
  TextEditingController? txtdescTextController;
  String? Function(BuildContext, String?)? txtdescTextControllerValidator;
  FocusNode? txtopinionFocusNode;
  TextEditingController? txtopinionTextController;
  String? Function(BuildContext, String?)? txtopinionTextControllerValidator;
  bool? estadoconectado;
  List<ProjectsRow>? returnUpdateProjectOn;
  List<dynamic>? retunListSQLiteON;
  List<dynamic>? retunListSQLiteOFF;

  @override
  void initState(BuildContext context) {
    txtidTextControllerValidator = _txtidTextControllerValidator;
    txtnombreTextControllerValidator = _txtnombreTextControllerValidator;
  }

  @override
  void dispose() {
    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    txtdescFocusNode?.dispose();
    txtdescTextController?.dispose();

    txtopinionFocusNode?.dispose();
    txtopinionTextController?.dispose();
  }
}
