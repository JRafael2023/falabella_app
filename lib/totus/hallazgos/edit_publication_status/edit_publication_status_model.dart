import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBPublicationStatus.dart';
import '/custom_code/PublicationStatus.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_publication_status_widget.dart' show EditPublicationStatusWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPublicationStatusModel extends FlutterFlowModel<EditPublicationStatusWidget> {
  ///  Local state fields for this component.

  List<PublicationStatus> listPublicationStatus = [];

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese Nombre';
    }
    return null;
  }


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
