import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import 'dart:ui';
import 'noiniciada_widget.dart' show NoiniciadaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoiniciadaModel extends FlutterFlowModel<NoiniciadaWidget> {

  late ContainerExpressModel containerExpressModel;
  late ContainerCompletaModel containerCompletaModel;

  @override
  void initState(BuildContext context) {
    containerExpressModel = createModel(context, () => ContainerExpressModel());
    containerCompletaModel =
        createModel(context, () => ContainerCompletaModel());
  }

  @override
  void dispose() {
    containerExpressModel.dispose();
    containerCompletaModel.dispose();
  }
}
