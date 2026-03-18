import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/totus/page_admin/edit_project/edit_project_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_projects_model.dart';
export 'card_projects_model.dart';

class CardProjectsWidget extends StatefulWidget {
  const CardProjectsWidget({
    super.key,
    this.nombre,
    this.descripcion,
    this.estado,
    this.estatus,
    this.updateCardProject,
    this.idProyecto,
    this.tipoMatriz,
    this.userId,
    this.opinion,
  });

  final String? nombre;
  final String? descripcion;
  final String? estado;
  final String? estatus;
  final Future Function(String? idProyecto)? updateCardProject;
  final String? idProyecto;
  final String? tipoMatriz;
  final String? userId;
  final String? opinion;

  @override
  State<CardProjectsWidget> createState() => _CardProjectsWidgetState();
}

class _CardProjectsWidgetState extends State<CardProjectsWidget>
    with TickerProviderStateMixin {
  late CardProjectsModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardProjectsModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(50.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 260.0.ms,
            duration: 1200.0.ms,
            color: FlutterFlowTheme.of(context).alternate,
            angle: -2.182,
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).linealogin,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x230E151B),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).containerExpress,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 2.0, 4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 8.0, 8.0, 8.0),
                                    child: SelectionArea(
                                        child: Text(
                                      valueOrDefault<String>(
                                        widget!.idProyecto,
                                        '...',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    )),
                                  ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: SelectionArea(
                                      child: Text(
                                    valueOrDefault<String>(
                                      widget!.nombre,
                                      '...',
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    widget!.tipoMatriz,
                                    '...',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                        ), // closes Expanded(child: Container)
                      ].divide(SizedBox(width: 12.0)),
                    ),
                    ), // closes Expanded(child: Row)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (context) => FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderWidth: 1.0,
                            icon: Icon(
                              Icons.edit_outlined,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                            showLoadingIndicator: true,
                            onPressed: () async {
                              _model.estadoConexion =
                                  await actions.checkInternetConecction();
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: EditProjectWidget(
                                      conexion: _model.estadoConexion!,
                                      idProject: widget!.idProyecto,
                                      matriz: widget!.tipoMatriz,
                                      userId: widget!.userId,
                                      name: widget!.nombre,
                                      description: widget!.descripcion,
                                      opinion: widget!.opinion,
                                    ),
                                  );
                                },
                              );

                              _model.returnProjects =
                                  await actions.sqlLiteListProyectos();
                              FFAppState().jsonProyectos = _model
                                  .returnProjects!
                                  .toList()
                                  .cast<dynamic>();
                              safeSetState(() {});

                              safeSetState(() {});
                            },
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderWidth: 1.0,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: FlutterFlowTheme.of(context).inefectivo,
                            size: 20.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .error
                                                .withOpacity(0.12),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: FlutterFlowTheme.of(context).error,
                                            size: 28.0,
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        Text(
                                          '¿Eliminar proyecto?',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: TextStyle(fontWeight: FontWeight.w700),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Esta acción eliminará el proyecto "${widget.nombre ?? ''}" de forma permanente y no se puede deshacer.',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: TextStyle(fontWeight: FontWeight.normal),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        SizedBox(height: 24.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () => Navigator.pop(dialogContext, false),
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                  side: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                ),
                                                child: Text(
                                                  'Cancelar',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: TextStyle(fontWeight: FontWeight.w600),
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.pop(dialogContext, true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: FlutterFlowTheme.of(context).error,
                                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                ),
                                                child: Text(
                                                  'Eliminar',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: TextStyle(fontWeight: FontWeight.w600),
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            if (confirmar == true) {
                              await widget.updateCardProject?.call(
                                widget!.idProyecto,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 4.0, 16.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        size: 14.0,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Text(
                                          () {
                                            final users = FFAppState().jsonUsers;
                                            for (final u in users) {
                                              final uid = getJsonField(u, r'''$.user_uid''')?.toString();
                                              if (uid != null && uid == widget.userId) {
                                                final name = getJsonField(u, r'''$.display_name''')?.toString();
                                                if (name != null && name != 'null' && name.isNotEmpty) return name;
                                                return getJsonField(u, r'''$.email''')?.toString() ?? '...';
                                              }
                                            }
                                            return widget.userId ?? '...';
                                          }(),
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      widget!.estado,
                                      'active',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      widget!.estatus,
                                      'completado',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
    );
  }
}
