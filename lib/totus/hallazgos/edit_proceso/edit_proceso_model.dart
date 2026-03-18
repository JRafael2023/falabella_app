import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBProceso.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_proceso_widget.dart' show EditProcesoWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProcesoModel extends FlutterFlowModel<EditProcesoWidget> {
  ///  Local state fields for this component.

  List<ProcesoStruct> listProcesos = [];
  void addToListProcesos(ProcesoStruct item) => listProcesos.add(item);
  void removeFromListProcesos(ProcesoStruct item) => listProcesos.remove(item);
  void removeAtIndexFromListProcesos(int index) => listProcesos.removeAt(index);
  void insertAtIndexInListProcesos(int index, ProcesoStruct item) =>
      listProcesos.insert(index, item);
  void updateListProcesosAtIndex(int index, Function(ProcesoStruct) updateFn) =>
      listProcesos[index] = updateFn(listProcesos[index]);

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

  // State field(s) for txtabrev widget.
  FocusNode? txtabrevFocusNode;
  TextEditingController? txtabrevTextController;
  String? Function(BuildContext, String?)? txtabrevTextControllerValidator;
  // Stores action output result for [Custom Action - getProcesosFromSupabase] action in Button widget.
  List<ProcesoStruct>? returnProcesos;
  // Stores action output result for [Custom Class Method - DBProceso.getAllProcesos] action in Button widget.
  List<ProcesoStruct>? procesosoffline;

  @override
  void initState(BuildContext context) {
    txtnombreTextControllerValidator = _txtnombreTextControllerValidator;
  }

  @override
  void dispose() {
    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    txtabrevFocusNode?.dispose();
    txtabrevTextController?.dispose();
  }
}
