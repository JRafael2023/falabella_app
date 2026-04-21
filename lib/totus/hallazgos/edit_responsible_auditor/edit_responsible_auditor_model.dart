import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBResponsibleAuditor.dart';
import '/custom_code/ResponsibleAuditor.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_responsible_auditor_widget.dart' show EditResponsibleAuditorWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditResponsibleAuditorModel
    extends FlutterFlowModel<EditResponsibleAuditorWidget> {
  final formKey = GlobalKey<FormState>();
  bool? estaconectado;
  List<ResponsibleAuditor> listResponsibleAuditors = [];
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) return 'Escribe el nombre';
    return null;
  }

  @override
  void initState(BuildContext context) {
    txtnombreTextControllerValidator = _txtnombreTextControllerValidator;
  }

  @override
  void dispose() {
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();
  }
}
