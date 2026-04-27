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
  ///  Local state fields for this page.

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

  /// true = mostrar dropdown de proyectos Highbond, false = ingresar ID manual
  bool usarDropdownHighbond = false;
  String? selectedHighbondProjectId;
  String? selectedHighbondProjectName;
  FormFieldController<String>? highbondProjectController;
  List<Map> displayedHighbondProjects = [];

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConecction] action in CreateProyectos widget.
  bool? estaconectado;
  // Model for wifiComponent component.
  late WifiComponentModel wifiComponentModel;
  // Model for exitComponent component.
  late ExitComponentModel exitComponentModel;
  // State field(s) for txtid widget.
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  String? _txtidTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ingrese un ID Proyecto';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (Get Projects Highbond)] action in btnSearchProject widget.
  ApiCallResponse? apiProyects;
  // State field(s) for cbomatrix widget.
  String? cbomatrixValue;
  FormFieldController<String>? cbomatrixValueController;
  // State field(s) for cboUserAssign widget.
  String? cboUserAssignValue;
  FormFieldController<String>? cboUserAssignValueController;
  // State field(s) for txtnombre widget.
  FocusNode? txtnombreFocusNode;
  TextEditingController? txtnombreTextController;
  String? Function(BuildContext, String?)? txtnombreTextControllerValidator;
  // State field(s) for txtdesc widget.
  FocusNode? txtdescFocusNode;
  TextEditingController? txtdescTextController;
  String? Function(BuildContext, String?)? txtdescTextControllerValidator;
  // State field(s) for txtopinion widget.
  FocusNode? txtopinionFocusNode;
  TextEditingController? txtopinionTextController;
  String? Function(BuildContext, String?)? txtopinionTextControllerValidator;
  // Stores action output result for [Backend Call - API (Get Projects Highbond)] action in Button widget.
  ApiCallResponse? apiProyectsCREATE;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ProjectsRow? returnCreateProject;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Button widget.
  List<dynamic>? retunListSQLiteON;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Button widget.
  List<dynamic>? retunListSQLiteOFF;
  // Models for cardProjects dynamic component.
  late FlutterFlowDynamicModels<CardProjectsModel> cardProjectsModels1;
  // Stores action output result for [Custom Action - sqlLiteEliminarProyectos] action in cardProjects widget.
  String? data;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in cardProjects widget.
  List<dynamic>? returnsqllistSIBNBD;
  // Models for cardProjects dynamic component.
  late FlutterFlowDynamicModels<CardProjectsModel> cardProjectsModels2;
  // Stores action output result for [Custom Action - sqlLiteEliminarProyectos] action in cardProjects widget.
  String? dataSQLLite;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in cardProjects widget.
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
