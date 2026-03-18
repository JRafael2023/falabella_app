import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/card_matriz/card_matriz_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'matrices_widget.dart' show MatricesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MatricesModel extends FlutterFlowModel<MatricesWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConecction] action in Matrices widget.
  bool? estaconectado;
  // Model for wifiComponent component.
  late WifiComponentModel wifiComponentModel;
  // Model for exitComponent component.
  late ExitComponentModel exitComponentModel;
  // State field(s) for txtnombre widget.
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa Nombre';
    }

    return null;
  }

  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in Button widget.
  List<dynamic>? listONMatriz;
  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in Button widget.
  List<dynamic>? listOFFMatriz;
  // Models for cardMatriz dynamic component.
  late FlutterFlowDynamicModels<CardMatrizModel> cardMatrizModels1;
  // Stores action output result for [Custom Action - sqlLiteEliminarMatriz] action in cardMatriz widget.
  String? eliminate;
  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in cardMatriz widget.
  List<dynamic>? returnMatrices;
  // Models for cardMatriz dynamic component.
  late FlutterFlowDynamicModels<CardMatrizModel> cardMatrizModels2;
  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in cardMatriz widget.
  List<dynamic>? returnListSqLite;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    txtnombreTextControllerValidator = _txtnombreTextControllerValidator;
    cardMatrizModels1 = FlutterFlowDynamicModels(() => CardMatrizModel());
    cardMatrizModels2 = FlutterFlowDynamicModels(() => CardMatrizModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    cardMatrizModels1.dispose();
    cardMatrizModels2.dispose();
  }
}
