import '/backend/supabase/supabase.dart';
import '/components/modal_update_user_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/DBUsuarios.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'modal_user_options_model.dart';
export 'modal_user_options_model.dart';

class ModalUserOptionsWidget extends StatefulWidget {
  const ModalUserOptionsWidget({
    super.key,
    String? idUser,
    this.onActionUser,
    this.uidUsuario,
    this.nombre,
    this.contra,
    this.pais,
    this.rol,
    this.correo,
  }) : this.idUser = idUser ?? '';

  final String idUser;
  final Future Function()? onActionUser;
  final String? uidUsuario;
  final String? nombre;
  final String? contra;
  final String? pais;
  final String? rol;
  final String? correo;

  @override
  State<ModalUserOptionsWidget> createState() => _ModalUserOptionsWidgetState();
}

class _ModalUserOptionsWidgetState extends State<ModalUserOptionsWidget> {
  late ModalUserOptionsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalUserOptionsModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 32.0, 0.0),
      child: Container(
        width: 150.0,
        height: 130.0,
        constraints: BoxConstraints(
          maxWidth: 150.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).info,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 0.0),
                child: Text(
                  'Opciones',
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: TextStyle(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
              Builder(
                builder: (context) => InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: ModalUpdateUserWidget(
                            uidUsuario: widget!.uidUsuario,
                            nombre: widget!.nombre,
                            correo: widget!.correo,
                            contra: widget!.contra,
                            pais: widget!.pais,
                            rol: widget!.rol,
                            onUpdate: () async {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: FlutterFlowTheme.of(context).customColor1,
                              size: 20.0,
                            ),
                          ),
                          Text(
                            'Editar',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: TextStyle(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  // Cerrar el menú de opciones primero
                  Navigator.pop(context);

                  // Mostrar modal de confirmación
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
                                '¿Eliminar usuario?',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Esta acción eliminará al usuario "${widget.nombre ?? ''}" de forma permanente y no se puede deshacer.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 24.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        side: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancelar',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Eliminar',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
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

                  if (confirmar != true) return;

                  // Verificar conexión
                  final conectado = await actions.checkInternetConecction();

                  if (conectado == true) {
                    // ✅ Online: eliminar en Supabase + borrar de SQLite
                    await UsersTable().delete(
                      matchingRows: (rows) => rows.eqOrNull(
                        'user_uid',
                        widget!.uidUsuario,
                      ),
                    );
                    _model.dataUser = await actions.sqEliminarUsuarios(
                      widget!.uidUsuario!,
                    );
                  } else {
                    // ✅ Offline: marcar pendienteEliminar = 1 para sincronizar después
                    // No borramos la fila para que el sync pueda eliminarla en Supabase luego
                    await DBUsuarios.marcarPendienteEliminar(widget!.uidUsuario!);
                    _model.dataUser = "Marcado para eliminar";
                  }

                  // Refrescar lista desde SQLite
                  _model.returnListUserSInConexion =
                      await actions.sqLiteListUsers();
                  FFAppState().jsonUsers = _model.returnListUserSInConexion!
                      .toList()
                      .cast<dynamic>();
                  FFAppState().update(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Usuario eliminado correctamente',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      duration: Duration(milliseconds: 3000),
                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                    ),
                  );

                  await widget.onActionUser?.call();
                  safeSetState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: Icon(
                            Icons.delete_outline,
                            color: FlutterFlowTheme.of(context).error,
                            size: 20.0,
                          ),
                        ),
                        Text(
                          'Eliminar',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
