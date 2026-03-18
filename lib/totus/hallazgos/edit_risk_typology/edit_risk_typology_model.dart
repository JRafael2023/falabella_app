import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBRiskTypology.dart';
import '/custom_code/RiskTypology.dart';
import '/custom_code/DBRiskType.dart';
import '/custom_code/RiskType.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_risk_typology_widget.dart' show EditRiskTypologyWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditRiskTypologyModel extends FlutterFlowModel<EditRiskTypologyWidget> {
  List<RiskTypology> listRiskTypology = [];
  List<RiskType> listRiskTypes = [];
  final formKey = GlobalKey<FormState>();
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) return 'Ingrese Nombre';
    return null;
  }
  String? selectedRiskTypeId;
  bool? estaconectado;

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
