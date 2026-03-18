import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'view_files_widget.dart' show ViewFilesWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewFilesModel extends FlutterFlowModel<ViewFilesWidget> {
  ///  Local state fields for this component.

  DateTime? fecha;

  List<FFUploadedFile> list = [];
  void addToList(FFUploadedFile item) => list.add(item);
  void removeFromList(FFUploadedFile item) => list.remove(item);
  void removeAtIndexFromList(int index) => list.removeAt(index);
  void insertAtIndexInList(int index, FFUploadedFile item) =>
      list.insert(index, item);
  void updateListAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      list[index] = updateFn(list[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
