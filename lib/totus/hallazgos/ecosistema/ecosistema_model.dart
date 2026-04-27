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


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  List<EcosistemaStruct>? qSupabaseEcosistema;
  bool? conexion;
  List<EcosistemaStruct>? getEcosistemas;
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

  List<EcosistemaStruct>? returnEcosistemas;
  List<EcosistemaStruct>? ecosistemasoffline;
  List<EcosistemaStruct>? qSupabaseEcositemasOn;
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
