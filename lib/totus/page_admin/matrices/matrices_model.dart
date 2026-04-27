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

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa Nombre';
    }

    return null;
  }

  List<dynamic>? listONMatriz;
  List<dynamic>? listOFFMatriz;
  late FlutterFlowDynamicModels<CardMatrizModel> cardMatrizModels1;
  String? eliminate;
  List<dynamic>? returnMatrices;
  late FlutterFlowDynamicModels<CardMatrizModel> cardMatrizModels2;
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
