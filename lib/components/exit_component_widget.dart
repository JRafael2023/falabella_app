import '/components/modal_form_exit_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'exit_component_model.dart';
export 'exit_component_model.dart';

class ExitComponentWidget extends StatefulWidget {
  const ExitComponentWidget({super.key});

  @override
  State<ExitComponentWidget> createState() => _ExitComponentWidgetState();
}

class _ExitComponentWidgetState extends State<ExitComponentWidget> {
  late ExitComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExitComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      constraints: BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
        maxWidth: 40.0,
        maxHeight: 40.0,
      ),
      decoration: BoxDecoration(),
      child: Builder(
        builder: (context) => FlutterFlowIconButton(
          borderRadius: 9.0,
          buttonSize: 40.0,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          icon: FaIcon(
            FontAwesomeIcons.signOutAlt,
            color: Color(0xFFEC6262),
            size: 20.0,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: AlignmentDirectional(0.0, 0.0)
                      .resolve(Directionality.of(context)),
                  child: ModalFormExitWidget(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
