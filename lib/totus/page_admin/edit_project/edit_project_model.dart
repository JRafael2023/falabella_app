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
  ///  Local state fields for this component.

  dynamic jsonSearchProyect;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for txtid widget.
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese un ID Proyecto';
    }

    return null;
  }

  // State field(s) for cbomatrix widget.
  String? cbomatrixValue;
  FormFieldController<String>? cbomatrixValueController;
  // State field(s) for cboUserAssign widget.
  String? cboUserAssignValue;
  FormFieldController<String>? cboUserAssignValueController;
  // State field(s) for txtnombre widget.
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese Nombre';
    }

    return null;
  }

  // State field(s) for txtdesc widget.
  FocusNode? txtdescFocusNode;
  TextEditingController? txtdescTextController;
  String? Function(BuildContext, String?)? txtdescTextControllerValidator;
  // State field(s) for txtopinion widget.
  FocusNode? txtopinionFocusNode;
  TextEditingController? txtopinionTextController;
  String? Function(BuildContext, String?)? txtopinionTextControllerValidator;
  // Stores action output result for [Custom Action - checkInternetConecction] action in Button widget.
  bool? estadoconectado;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ProjectsRow>? returnUpdateProjectOn;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Button widget.
  List<dynamic>? retunListSQLiteON;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Button widget.
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
