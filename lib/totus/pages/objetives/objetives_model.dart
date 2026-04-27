import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/loading_list_tottus/loading_list_tottus_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'objetives_widget.dart' show ObjetivesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ObjetivesModel extends FlutterFlowModel<ObjetivesWidget> {

  List<dynamic> json = [];
  void addToJson(dynamic item) => json.add(item);
  void removeFromJson(dynamic item) => json.remove(item);
  void removeAtIndexFromJson(int index) => json.removeAt(index);
  void insertAtIndexInJson(int index, dynamic item) => json.insert(index, item);
  void updateJsonAtIndex(int index, Function(dynamic) updateFn) =>
      json[index] = updateFn(json[index]);


  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  ApiCallResponse? returnAPIControls;
  ApiCallResponse? returnAPIControlWalk;
  String? message;
  List<dynamic>? listControles;
  List<ControlsRow>? qControls;
  List<dynamic>? listControlesOFF;
  late LoadingListTottusModel loadingListTottusModel;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    loadingListTottusModel =
        createModel(context, () => LoadingListTottusModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    loadingListTottusModel.dispose();
  }
}
