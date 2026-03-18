import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalUserDetailWidget extends StatelessWidget {
  const ModalUserDetailWidget({
    super.key,
    this.nombre,
    this.correo,
    this.rol,
    this.pais,
    this.fechaCreacion,
    this.uidUsuario,
  });

  final String? nombre;
  final String? correo;
  final String? rol;
  final String? pais;
  final DateTime? fechaCreacion;
  final String? uidUsuario;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 4.0),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 12.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Detalle del Usuario',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Avatar / Iniciales
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 8.0),
              child: Container(
                width: 72.0,
                height: 72.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (nombre != null && nombre!.isNotEmpty)
                        ? nombre![0].toUpperCase()
                        : '?',
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                          font: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
            ),

            // Nombre destacado
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 20.0, 4.0),
              child: Text(
                functions.capitalizeFunction(nombre ?? ''),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
            ),

            // Badge de rol
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 6.0, 16.0, 6.0),
                  child: Text(
                    functions.capitalizeFunction(rol ?? 'Usuario'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          color: FlutterFlowTheme.of(context).info,
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
            ),

            Divider(
              height: 1.0,
              thickness: 1.0,
              indent: 20.0,
              endIndent: 20.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),

            // Datos en lista
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 24.0),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.badge_outlined,
                    label: 'ID de Usuario',
                    value: (uidUsuario != null && uidUsuario!.isNotEmpty && uidUsuario != 'null')
                        ? uidUsuario!
                        : '—',
                  ),
                  SizedBox(height: 12.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.email_outlined,
                    label: 'Correo',
                    value: correo ?? '—',
                  ),
                  SizedBox(height: 12.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.flag_outlined,
                    label: 'País',
                    value: (pais != null && pais!.isNotEmpty) ? pais! : '—',
                  ),
                  SizedBox(height: 12.0),
                  _buildInfoRow(
                    context,
                    icon: Icons.date_range_outlined,
                    label: 'Fecha de Creación',
                    value: fechaCreacion != null
                        ? dateTimeFormat(
                            "d/M/y",
                            fechaCreacion,
                            locale: FFLocalizations.of(context).languageCode,
                          )
                        : '—',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: FlutterFlowTheme.of(context).secondary,
          size: 20.0,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 2.0),
              Text(
                value,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
