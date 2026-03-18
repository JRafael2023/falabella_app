import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/hallazgos/edit_ecosistema/edit_ecosistema_widget.dart';
import 'dart:ui';
import '/custom_code/DBEcosistema.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'ecosistema_widget.dart' show EcosistemaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EcosistemaModel extends FlutterFlowModel<EcosistemaWidget> {
  ///  Local state fields for this page.

  List<EcosistemaStruct> listEcosistema = [];
  void addToListEcosistema(EcosistemaStruct item) => listEcosistema.add(item);
  void removeFromListEcosistema(EcosistemaStruct item) =>
      listEcosistema.remove(item);
  void removeAtIndexFromListEcosistema(int index) =>
      listEcosistema.removeAt(index);
  void insertAtIndexInListEcosistema(int index, EcosistemaStruct item) =>
      listEcosistema.insert(index, item);
  void updateListEcosistemaAtIndex(
          int index, Function(EcosistemaStruct) updateFn) =>
      listEcosistema[index] = updateFn(listEcosistema[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConecction] action in Ecosistema widget.
  bool? estaconectado;
  // Stores action output result for [Custom Action - getEcosistemasFromSupabase] action in Ecosistema widget.
  List<EcosistemaStruct>? qSupabaseEcosistema;
  // Stores action output result for [Custom Action - checkInternetConecction] action in Ecosistema widget.
  bool? conexion;
  // Stores action output result for [Custom Action - getEcosistemasFromSQLite] action in Ecosistema widget.
  List<EcosistemaStruct>? getEcosistemas;
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
      return 'Escribe ';
    }

    return null;
  }

  // Stores action output result for [Custom Action - getEcosistemasFromSupabase] action in Button widget.
  List<EcosistemaStruct>? returnEcosistemas;
  // Stores action output result for [Custom Class Method - DBEcosistema.getAllEcosistemas] action in Button widget.
  List<EcosistemaStruct>? ecosistemasoffline;
  // Stores action output result for [Custom Action - getEcosistemasFromSupabase] action in IconDeleteOn widget.
  List<EcosistemaStruct>? qSupabaseEcositemasOn;
  // Stores action output result for [Custom Action - getEcosistemasFromSQLite] action in IconDeleteOff widget.
  List<EcosistemaStruct>? getEcosistemaoff;

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
