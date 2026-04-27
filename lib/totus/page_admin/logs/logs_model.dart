import '/backend/api_requests/api_calls.dart';
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
import '/totus/components/list_audits/list_audits_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import '/totus/components/tasks/tasks_widget.dart';
import 'dart:ui';
import '/custom_code/Proyecto.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'logs_widget.dart' show LogsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogsModel extends FlutterFlowModel<LogsWidget> {

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


  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  String? cboAuditoresValue;
  FormFieldController<String>? cboAuditoresValueController;
  String? cboPaisValue;
  FormFieldController<String>? cboPaisValueController;
  late FlutterFlowDynamicModels<ListAuditsModel> listAuditsModels;
  Completer<ApiCallResponse>? apiRequestCompleter;
  late FlutterFlowDynamicModels<TasksModel> tasksModels;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    listAuditsModels = FlutterFlowDynamicModels(() => ListAuditsModel());
    tasksModels = FlutterFlowDynamicModels(() => TasksModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    listAuditsModels.dispose();
    tasksModels.dispose();
  }

  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
