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
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkInternetConecction] action in Home widget.
  bool? estaconectado;
  // Stores action output result for [Backend Call - Query Rows] action in Home widget.
  List<ProjectsRow>? queryONProjects;
  // Stores action output result for [Backend Call - Query Rows] action in Home widget.
  List<MatricesRow>? listONMatrices;
  // Stores action output result for [Custom Action - sqlLiteSaveMatricesMasivo] action in Home widget.
  String? formatjsonMatricesON;
  // Stores action output result for [Custom Action - sqlLiteSaveProyectosMasivo] action in Home widget.
  String? formatjsonON;
  // Stores action output result for [Backend Call - Query Rows] action in Home widget.
  List<UsersRow>? qONUsersList;
  // Stores action output result for [Custom Action - sqlLiteSaveUsersMasivo] action in Home widget.
  String? returnInsertSQLite;
  // Stores action output result for [Backend Call - Query Rows] action in Home widget.
  List<UsersRow>? qUser;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Home widget.
  List<dynamic>? qOnProjects;
  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in Home widget.
  List<dynamic>? qOnMatrices;
  // Stores action output result for [Custom Action - convertRowsUsers] action in Home widget.
  List<dynamic>? qJSONROwsSupabase;
  // Stores action output result for [Custom Action - getTitulosFromSupabase] action in Home widget.
  List<TituloStruct>? tituloson;
  // Stores action output result for [Custom Action - getProcesosFromSupabase] action in Home widget.
  List<ProcesoStruct>? procesoson;
  // Stores action output result for [Custom Action - getGerenciasFromSupabase] action in Home widget.
  List<GerenciaStruct>? gerenciaon;
  // Stores action output result for [Custom Action - getEcosistemasFromSupabase] action in Home widget.
  List<EcosistemaStruct>? ecosistemaon;
  // Stores action output result for [Custom Action - sqlLiteListProyectos] action in Home widget.
  List<dynamic>? qoffProyectos;
  // Stores action output result for [Custom Action - getUsuarioByEmail] action in Home widget.
  dynamic? returnLOginOFF;
  // Stores action output result for [Custom Action - sqlLiteListMatrices] action in Home widget.
  List<dynamic>? qoffMatrices;
  // Stores action output result for [Custom Action - sqLiteListUsers] action in Home widget.
  List<dynamic>? qSQLiteUsersOFF;
  // Stores action output result for [Custom Action - getTitulosFromSQLite] action in Home widget.
  List<TituloStruct>? getTitulos;
  // Stores action output result for [Custom Action - getProcesosFromSQLite] action in Home widget.
  List<ProcesoStruct>? getProcesos;
  // Stores action output result for [Custom Action - getEcosistemasFromSQLite] action in Home widget.
  List<EcosistemaStruct>? getEcosistemas;
  // Stores action output result for [Custom Action - getGerenciasFromSQLite] action in Home widget.
  List<GerenciaStruct>? getGerencias;

  // Variables para la animación de carga
  String loadingMessage = 'Cargando Proyectos...';
  double loadingProgress = 0.0;
  int loadingTimeSeconds = 0;
  DateTime? loadingStartTime;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
