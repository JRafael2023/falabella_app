import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/page_admin/edit_project/edit_project_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'card_projects_widget.dart' show CardProjectsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardProjectsModel extends FlutterFlowModel<CardProjectsWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - checkInternetConecction] action in iconUpdate widget.
  bool? estadoConexion;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in iconUpdate widget.
  List<dynamic>? returnProjects;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
