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
import '/totus/components/container_admin/container_admin_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'home_page_admin_widget.dart' show HomePageAdminWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageAdminModel extends FlutterFlowModel<HomePageAdminWidget> {

  InstantTimer? instantTimer;
  bool? estaconectado;
  late WifiComponentModel wifiComponentModel;
  late ExitComponentModel exitComponentModel;
  bool? returnSincronizacion;
  List<dynamic>? masivodb;
  List<dynamic>? usersMasivo;
  late ContainerAdminModel containerAdminModel1;
  List<dynamic>? usersMasivo1;
  late ContainerAdminModel containerAdminModel2;
  late ContainerAdminModel containerAdminModel3;
  late ContainerAdminModel containerAdminModel4;
  late ContainerAdminModel containerAdminModel5;
  late ContainerAdminModel containerAdminModel6;
  String? returnImport;

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
  }

  Future cargarMatrices(BuildContext context) async {
    List<MatricesRow>? qMatricesRowsSupabase;
    String? formatjsonMatricesON;
    List<dynamic>? qONMatrices;
    List<dynamic>? listOFFmatrices;

    if (estaconectado!) {
      qMatricesRowsSupabase = await MatricesTable().queryRows(
        queryFn: (q) => q,
      );
      formatjsonMatricesON = await actions.sqlLiteSaveMatricesMasivo(
        qMatricesRowsSupabase!.toList(),
      );
      qONMatrices = await actions.sqlLiteListMatrices();
      FFAppState().jsonMatrices = qONMatrices!.toList().cast<dynamic>();
    } else {
      listOFFmatrices = await actions.sqlLiteListMatrices();
      FFAppState().jsonMatrices = listOFFmatrices!.toList().cast<dynamic>();
    }
  }
}
