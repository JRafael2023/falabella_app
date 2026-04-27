import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {

  bool? estaconectado;
  List<ProjectsRow>? queryONProjects;
  List<MatricesRow>? listONMatrices;
  String? formatjsonMatricesON;
  String? formatjsonON;
  List<UsersRow>? qONUsersList;
  String? returnInsertSQLite;
  List<UsersRow>? qUser;
  List<dynamic>? qOnProjects;
  List<dynamic>? qOnMatrices;
  List<dynamic>? qJSONROwsSupabase;
  List<TituloStruct>? tituloson;
  List<ProcesoStruct>? procesoson;
  List<GerenciaStruct>? gerenciaon;
  List<EcosistemaStruct>? ecosistemaon;
  List<dynamic>? qoffProyectos;
  dynamic? returnLOginOFF;
  List<dynamic>? qoffMatrices;
  List<dynamic>? qSQLiteUsersOFF;
  List<TituloStruct>? getTitulos;
  List<ProcesoStruct>? getProcesos;
  List<EcosistemaStruct>? getEcosistemas;
  List<GerenciaStruct>? getGerencias;

  String loadingMessage = 'Cargando Proyectos...';
  double loadingProgress = 0.0;
  int loadingTimeSeconds = 0;
  DateTime? loadingStartTime;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
