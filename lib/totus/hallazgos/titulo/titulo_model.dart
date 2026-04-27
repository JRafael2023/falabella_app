import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_titulo/edit_titulo_widget.dart';
import 'dart:ui';
import '/custom_code/DBProceso.dart';
import '/custom_code/DBTitulo.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'titulo_widget.dart' show TituloWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TituloModel extends FlutterFlowModel<TituloWidget> {

  List<TituloStruct> listTitulos = [];
  void addToListTitulos(TituloStruct item) => listTitulos.add(item);
  void removeFromListTitulos(TituloStruct item) => listTitulos.remove(item);
  void removeAtIndexFromListTitulos(int index) => listTitulos.removeAt(index);
  void insertAtIndexInListTitulos(int index, TituloStruct item) =>
      listTitulos.insert(index, item);
  void updateListTitulosAtIndex(int index, Function(TituloStruct) updateFn) =>
      listTitulos[index] = updateFn(listTitulos[index]);

  List<ProcesoStruct> listProcesosPageState = [];
  void addToListProcesosPageState(ProcesoStruct item) =>
      listProcesosPageState.add(item);
  void removeFromListProcesosPageState(ProcesoStruct item) =>
      listProcesosPageState.remove(item);
  void removeAtIndexFromListProcesosPageState(int index) =>
      listProcesosPageState.removeAt(index);
  void insertAtIndexInListProcesosPageState(int index, ProcesoStruct item) =>
      listProcesosPageState.insert(index, item);
  void updateListProcesosPageStateAtIndex(
          int index, Function(ProcesoStruct) updateFn) =>
      listProcesosPageState[index] = updateFn(listProcesosPageState[index]);

  DBProceso? proceso;


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  List<ProcesoStruct>? qSupabaseProceso;
  List<TituloStruct>? qSupabaseTitulos;
  bool? conexion;
  List<ProcesoStruct>? getprocesos;
  List<TituloStruct>? getTitulos;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe is required';
    }

    return null;
  }

  String? cboprocesoValue;
  FormFieldController<String>? cboprocesoValueController;
  String? sincronizado;
  List<TituloStruct>? returnTituls;
  List<TituloStruct>? titulosoffline;
  List<TituloStruct>? qSupabaseTitulosOn;
  List<TituloStruct>? getTitulosoff;

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
