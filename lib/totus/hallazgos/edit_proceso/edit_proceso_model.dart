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

  List<ProcesoStruct> listProcesos = [];
  void addToListProcesos(ProcesoStruct item) => listProcesos.add(item);
  void removeFromListProcesos(ProcesoStruct item) => listProcesos.remove(item);
  void removeAtIndexFromListProcesos(int index) => listProcesos.removeAt(index);
  void insertAtIndexInListProcesos(int index, ProcesoStruct item) =>
      listProcesos.insert(index, item);
  void updateListProcesosAtIndex(int index, Function(ProcesoStruct) updateFn) =>
      listProcesos[index] = updateFn(listProcesos[index]);


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

  FocusNode? txtabrevFocusNode;
  TextEditingController? txtabrevTextController;
  String? Function(BuildContext, String?)? txtabrevTextControllerValidator;
  List<ProcesoStruct>? returnProcesos;
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
