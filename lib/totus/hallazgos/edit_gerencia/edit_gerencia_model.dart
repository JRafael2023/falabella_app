import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/DBGerencia.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_gerencia_widget.dart' show EditGerenciaWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditGerenciaModel extends FlutterFlowModel<EditGerenciaWidget> {

  List<GerenciaStruct> listGerencias = [];
  void addToListGerencias(GerenciaStruct item) => listGerencias.add(item);
  void removeFromListGerencias(GerenciaStruct item) =>
      listGerencias.remove(item);
  void removeAtIndexFromListGerencias(int index) =>
      listGerencias.removeAt(index);
  void insertAtIndexInListGerencias(int index, GerenciaStruct item) =>
      listGerencias.insert(index, item);
  void updateListGerenciasAtIndex(
          int index, Function(GerenciaStruct) updateFn) =>
      listGerencias[index] = updateFn(listGerencias[index]);


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

  bool? estaconectado;
  List<ManagementsRow>? updateEcosistema;
  List<GerenciaStruct>? returnGerencias;
  List<GerenciaStruct>? gerenciasoffline;

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
