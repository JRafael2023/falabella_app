import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/card_projects/card_projects_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/Proyecto.dart';
import '/custom_code/Usuario.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'create_proyectos_widget.dart' show CreateProyectosWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateProyectosModel extends FlutterFlowModel<CreateProyectosWidget> {

  Proyecto? proyecto;

  List<Proyecto> listProyectos = [];
  void addToListProyectos(Proyecto item) => listProyectos.add(item);
  void removeFromListProyectos(Proyecto item) => listProyectos.remove(item);
  void removeAtIndexFromListProyectos(int index) =>
      listProyectos.removeAt(index);
  void insertAtIndexInListProyectos(int index, Proyecto item) =>
      listProyectos.insert(index, item);
  void updateListProyectosAtIndex(int index, Function(Proyecto) updateFn) =>
      listProyectos[index] = updateFn(listProyectos[index]);

  dynamic jsonSearchProyect;

  Usuario? test;

  bool usarDropdownHighbond = false;
  String? selectedHighbondProjectId;
  String? selectedHighbondProjectName;
  FormFieldController<String>? highbondProjectController;
  List<Map> displayedHighbondProjects = [];


  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese un ID Proyecto';
    }

    return null;
  }

  ApiCallResponse? apiProyects;
  String? cbomatrixValue;
  FormFieldController<String>? cbomatrixValueController;
  String? cboUserAssignValue;
  FormFieldController<String>? cboUserAssignValueController;
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  FocusNode? txtdescFocusNode;
  TextEditingController? txtdescTextController;
  String? Function(BuildContext, String?)? txtdescTextControllerValidator;
  FocusNode? txtopinionFocusNode;
  TextEditingController? txtopinionTextController;
  String? Function(BuildContext, String?)? txtopinionTextControllerValidator;
  ApiCallResponse? apiProyectsCREATE;
  ProjectsRow? returnCreateProject;
  List<dynamic>? retunListSQLiteON;
  List<dynamic>? retunListSQLiteOFF;
  late FlutterFlowDynamicModels<CardProjectsModel> cardProjectsModels1;
  String? data;
  List<dynamic>? returnsqllistSIBNBD;
  late FlutterFlowDynamicModels<CardProjectsModel> cardProjectsModels2;
  String? dataSQLLite;
  List<dynamic>? returnsqllistSQlLite;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    txtidTextControllerValidator = _txtidTextControllerValidator;
    cardProjectsModels1 = FlutterFlowDynamicModels(() => CardProjectsModel());
    cardProjectsModels2 = FlutterFlowDynamicModels(() => CardProjectsModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    txtnombreFocusNode?.dispose();
    txtnombreTextController?.dispose();

    txtdescFocusNode?.dispose();
    txtdescTextController?.dispose();

    txtopinionFocusNode?.dispose();
    txtopinionTextController?.dispose();

    cardProjectsModels1.dispose();
    cardProjectsModels2.dispose();
  }
}
