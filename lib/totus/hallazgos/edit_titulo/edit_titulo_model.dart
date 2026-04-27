import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/DBTitulo.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_titulo_widget.dart' show EditTituloWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditTituloModel extends FlutterFlowModel<EditTituloWidget> {

  List<TituloStruct> listTitulos = [];
  void addToListTitulos(TituloStruct item) => listTitulos.add(item);
  void removeFromListTitulos(TituloStruct item) => listTitulos.remove(item);
  void removeAtIndexFromListTitulos(int index) => listTitulos.removeAt(index);
  void insertAtIndexInListTitulos(int index, TituloStruct item) =>
      listTitulos.insert(index, item);
  void updateListTitulosAtIndex(int index, Function(TituloStruct) updateFn) =>
      listTitulos[index] = updateFn(listTitulos[index]);


  final formKey = GlobalKey<FormState>();
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  String? _txtnombreTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingresa Nombre';
    }

    return null;
  }

  String? cboprocesoValue;
  FormFieldController<String>? cboprocesoValueController;
  List<TituloStruct>? returnTituls;
  List<TituloStruct>? titulosoffline;

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
