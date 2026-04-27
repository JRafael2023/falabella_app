import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/component_controllador/component_controllador_widget.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'controles_widget.dart' show ControlesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ControlesModel extends FlutterFlowModel<ControlesWidget> {

  bool hayCambiosSinGuardar = false;

  List<FFUploadedFile> listImgUploadData = [];
  void addToListImgUploadData(FFUploadedFile item) =>
      listImgUploadData.add(item);
  void removeFromListImgUploadData(FFUploadedFile item) =>
      listImgUploadData.remove(item);
  void removeAtIndexFromListImgUploadData(int index) =>
      listImgUploadData.removeAt(index);
  void insertAtIndexInListImgUploadData(int index, FFUploadedFile item) =>
      listImgUploadData.insert(index, item);
  void updateListImgUploadDataAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      listImgUploadData[index] = updateFn(listImgUploadData[index]);

  FFUploadedFile? videoData;

  int quantityControls = 0;

  double porcentaje = 0.0;

  int trues = 0;

  bool trueAutoincrement = false;

  String? idControl;

  dynamic jsontest;


  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  FocusNode? txtidFocusNode;
  TextEditingController? txtidTextController;
  String? Function(BuildContext, String?)? txtidTextControllerValidator;
  late FlutterFlowDynamicModels<ComponentControlladorModel>
      componentControlladorModels;
  List<dynamic>? listControlesON;
  late LoadingListTottusModel loadingListTottusModel;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    componentControlladorModels =
        FlutterFlowDynamicModels(() => ComponentControlladorModel());
    loadingListTottusModel =
        createModel(context, () => LoadingListTottusModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    txtidFocusNode?.dispose();
    txtidTextController?.dispose();

    componentControlladorModels.dispose();
    loadingListTottusModel.dispose();
  }
}
