import '/backend/supabase/supabase.dart';
import '/components/modal_update_user_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'modal_user_options_widget.dart' show ModalUserOptionsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalUserOptionsModel extends FlutterFlowModel<ModalUserOptionsWidget> {

  String? dataUser;
  List<dynamic>? returnListUserSInConexion;
  String? dataUserSqLite;
  List<dynamic>? returnSqListUsers;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
