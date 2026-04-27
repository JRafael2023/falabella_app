import '/backend/api_requests/api_calls.dart';
import '/components/exit_component_widget.dart';
import '/components/matriz_dinamic_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/DBGerencia.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'home_proyects_widget.dart' show HomeProyectsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeProyectsModel extends FlutterFlowModel<HomeProyectsWidget> {

  List<dynamic> noIniciadasJson = [];
  void addToNoIniciadasJson(dynamic item) => noIniciadasJson.add(item);
  void removeFromNoIniciadasJson(dynamic item) => noIniciadasJson.remove(item);
  void removeAtIndexFromNoIniciadasJson(int index) =>
      noIniciadasJson.removeAt(index);
  void insertAtIndexInNoIniciadasJson(int index, dynamic item) =>
      noIniciadasJson.insert(index, item);
  void updateNoIniciadasJsonAtIndex(int index, Function(dynamic) updateFn) =>
      noIniciadasJson[index] = updateFn(noIniciadasJson[index]);

  List<dynamic> progresoJson = [];
  void addToProgresoJson(dynamic item) => progresoJson.add(item);
  void removeFromProgresoJson(dynamic item) => progresoJson.remove(item);
  void removeAtIndexFromProgresoJson(int index) => progresoJson.removeAt(index);
  void insertAtIndexInProgresoJson(int index, dynamic item) =>
      progresoJson.insert(index, item);
  void updateProgresoJsonAtIndex(int index, Function(dynamic) updateFn) =>
      progresoJson[index] = updateFn(progresoJson[index]);

  List<dynamic> completasJson = [];
  void addToCompletasJson(dynamic item) => completasJson.add(item);
  void removeFromCompletasJson(dynamic item) => completasJson.remove(item);
  void removeAtIndexFromCompletasJson(int index) =>
      completasJson.removeAt(index);
  void insertAtIndexInCompletasJson(int index, dynamic item) =>
      completasJson.insert(index, item);
  void updateCompletasJsonAtIndex(int index, Function(dynamic) updateFn) =>
      completasJson[index] = updateFn(completasJson[index]);

  dynamic tipoMatrizes;

  DBGerencia? bd;

  String? inciada;

  String? completa = '100.0';

  String? autioriaType = 'no_iniciadas';

  String ultimaSyncText = 'Cargando...';


  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  late MatrizDinamicModel matrizDinamicOnModel;
  late MatrizDinamicModel matrizDinamicOffModel;
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter3;
  late FlutterFlowDynamicModels<ContainerExpressModel> containerExpressModels1;
  late FlutterFlowDynamicModels<ContainerExpressModel> containerExpressModels2;
  Completer<ApiCallResponse>? apiRequestCompleter1;
  late FlutterFlowDynamicModels<ContainerExpressModel> containerExpressModels3;
  late FlutterFlowDynamicModels<ContainerExpressModel> containerExpressModels4;
  Completer<ApiCallResponse>? apiRequestCompleter2;
  late FlutterFlowDynamicModels<ContainerCompletaModel>
      containerCompletaModels1;
  late FlutterFlowDynamicModels<ContainerCompletaModel>
      containerCompletaModels2;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    matrizDinamicOnModel = createModel(context, () => MatrizDinamicModel());
    matrizDinamicOffModel = createModel(context, () => MatrizDinamicModel());
    containerExpressModels1 =
        FlutterFlowDynamicModels(() => ContainerExpressModel());
    containerExpressModels2 =
        FlutterFlowDynamicModels(() => ContainerExpressModel());
    containerExpressModels3 =
        FlutterFlowDynamicModels(() => ContainerExpressModel());
    containerExpressModels4 =
        FlutterFlowDynamicModels(() => ContainerExpressModel());
    containerCompletaModels1 =
        FlutterFlowDynamicModels(() => ContainerCompletaModel());
    containerCompletaModels2 =
        FlutterFlowDynamicModels(() => ContainerCompletaModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    matrizDinamicOnModel.dispose();
    matrizDinamicOffModel.dispose();
    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    containerExpressModels1.dispose();
    containerExpressModels2.dispose();
    containerExpressModels3.dispose();
    containerExpressModels4.dispose();
    containerCompletaModels1.dispose();
    containerCompletaModels2.dispose();
  }

  Future objetives(
    BuildContext context, {
    required String? idProyecto,
    String? title,
    String? tipoMatriz,
  }) async {
    FFAppState().idproyect = idProyecto!;
    FFAppState().projectName = title ?? '';
    FFAppState().update(() {});

    context.pushNamed(
      ObjetivesWidget.routeName,
      queryParameters: {
        'titleProject': serializeParam(
          title,
          ParamType.String,
        ),
        'tipoMatriz': serializeParam(
          tipoMatriz,
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }

  Future waitForApiRequestCompleted3({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter3?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForApiRequestCompleted1({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter1?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForApiRequestCompleted2({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter2?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
