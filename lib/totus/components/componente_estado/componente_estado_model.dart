import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/components/container_completa/container_completa_widget.dart';
import '/totus/components/container_express/container_express_widget.dart';
import 'dart:ui';
import 'componente_estado_widget.dart' show ComponenteEstadoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ComponenteEstadoModel extends FlutterFlowModel<ComponenteEstadoWidget> {
  ///  Local state fields for this component.

  Color color = Color(4279506971);

  ///  State fields for stateful widgets in this component.

  // Model for ContainerExpress component.
  late ContainerExpressModel containerExpressModel;
  // Model for ContainerCompleta component.
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
