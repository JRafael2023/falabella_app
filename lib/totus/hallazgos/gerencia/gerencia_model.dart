import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_gerencia/edit_gerencia_widget.dart';
import 'dart:ui';
import '/custom_code/DBGerencia.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'gerencia_widget.dart' show GerenciaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GerenciaModel extends FlutterFlowModel<GerenciaWidget> {

  List<GerenciaStruct> listGerenciaPageState = [];
  void addToListGerenciaPageState(GerenciaStruct item) =>
      listGerenciaPageState.add(item);
  void removeFromListGerenciaPageState(GerenciaStruct item) =>
      listGerenciaPageState.remove(item);
  void removeAtIndexFromListGerenciaPageState(int index) =>
      listGerenciaPageState.removeAt(index);
  void insertAtIndexInListGerenciaPageState(int index, GerenciaStruct item) =>
      listGerenciaPageState.insert(index, item);
  void updateListGerenciaPageStateAtIndex(
          int index, Function(GerenciaStruct) updateFn) =>
      listGerenciaPageState[index] = updateFn(listGerenciaPageState[index]);


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  List<GerenciaStruct>? qSupabaseGerencia;
  bool? conexion;
  List<GerenciaStruct>? getGerencias;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe ';
    }

    return null;
  }

  List<GerenciaStruct>? returnGerencias;
  List<GerenciaStruct>? gerenciaoffline;
  List<GerenciaStruct>? qSupabaseGerenciaOn;
  List<GerenciaStruct>? getEcosistemaoff;

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
