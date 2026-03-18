import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBEcosistema.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_ecosistema_widget.dart' show EditEcosistemaWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditEcosistemaModel extends FlutterFlowModel<EditEcosistemaWidget> {
  ///  Local state fields for this component.

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

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for txtnombre widget.
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese Nombre';
    }

    return null;
  }

  // Stores action output result for [Custom Action - checkInternetConecction] action in Button widget.
  bool? estaconectado;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<EcosystemsRow>? updateEcosistema;
  // Stores action output result for [Custom Action - getEcosistemasFromSupabase] action in Button widget.
  List<EcosistemaStruct>? returnEcosistemas;
  // Stores action output result for [Custom Class Method - DBEcosistema.getAllEcosistemas] action in Button widget.
  List<EcosistemaStruct>? ecosistemasoffline;

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
