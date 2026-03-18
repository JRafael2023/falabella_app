import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/DBEcosystemSupport.dart';
import '/custom_code/EcosystemSupport.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'ecosystem_support_widget.dart' show EcosystemSupportWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EcosystemSupportModel extends FlutterFlowModel<EcosystemSupportWidget> {
  List<EcosystemSupport> listEcosystemSupport = [];
  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  bool? conexion;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) return 'Escribe ';
    return null;
  }
  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    txtnombreTextControllerValidator = _txtnombreTextControllerValidator;
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();
  }
}
