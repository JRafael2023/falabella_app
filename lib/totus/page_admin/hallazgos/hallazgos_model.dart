import '/components/exit_component_widget.dart';
import '/components/no_internet_dialog_widget_widget.dart';
import '/components/wifi_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/totus/components/container_admin/container_admin_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'hallazgos_widget.dart' show HallazgosWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HallazgosModel extends FlutterFlowModel<HallazgosWidget> {

  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  List<dynamic>? masivodb;
  List<dynamic>? usersMasivo;
  late ContainerAdminModel containerAdminModel1;
  late ContainerAdminModel containerAdminModel2;
  late ContainerAdminModel containerAdminModel3;
  late ContainerAdminModel containerAdminModel4;
  late ContainerAdminModel containerAdminModel5;
  late ContainerAdminModel containerAdminModel6;
  late ContainerAdminModel containerAdminModel7;
  late ContainerAdminModel containerAdminModel8;
  late ContainerAdminModel containerAdminModel9;
  late ContainerAdminModel containerAdminModel10;
  late ContainerAdminModel containerAdminModel11;
  late ContainerAdminModel containerAdminModel12;
  late ContainerAdminModel containerAdminModel13;

  @override
  void initState(BuildContext context) {
    wifiComponentModel = createModel(context, () => WifiComponentModel());
    exitComponentModel = createModel(context, () => ExitComponentModel());
    containerAdminModel1 = createModel(context, () => ContainerAdminModel());
    containerAdminModel2 = createModel(context, () => ContainerAdminModel());
    containerAdminModel3 = createModel(context, () => ContainerAdminModel());
    containerAdminModel4 = createModel(context, () => ContainerAdminModel());
    containerAdminModel5 = createModel(context, () => ContainerAdminModel());
    containerAdminModel6 = createModel(context, () => ContainerAdminModel());
    containerAdminModel7 = createModel(context, () => ContainerAdminModel());
    containerAdminModel8 = createModel(context, () => ContainerAdminModel());
    containerAdminModel9 = createModel(context, () => ContainerAdminModel());
    containerAdminModel10 = createModel(context, () => ContainerAdminModel());
    containerAdminModel11 = createModel(context, () => ContainerAdminModel());
    containerAdminModel12 = createModel(context, () => ContainerAdminModel());
    containerAdminModel13 = createModel(context, () => ContainerAdminModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    wifiComponentModel.dispose();
    exitComponentModel.dispose();
    containerAdminModel1.dispose();
    containerAdminModel2.dispose();
    containerAdminModel3.dispose();
    containerAdminModel4.dispose();
    containerAdminModel5.dispose();
    containerAdminModel6.dispose();
    containerAdminModel7.dispose();
    containerAdminModel8.dispose();
    containerAdminModel9.dispose();
    containerAdminModel10.dispose();
    containerAdminModel11.dispose();
    containerAdminModel12.dispose();
    containerAdminModel13.dispose();
  }
}
