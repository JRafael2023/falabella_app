import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/totus/components/container_text/container_text_widget.dart';
import '/totus/create_hallasgo/create_hallasgo_widget.dart';
import '/totus/description_control/description_control_widget.dart';
import '/totus/view_files/view_files_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_controllador_model.dart';
export 'component_controllador_model.dart';

class ComponentControlladorWidget extends StatefulWidget {
  const ComponentControlladorWidget({
    super.key,
    String? nameProyect,
    String? nameControl,
    this.onUpdateDinamic,
    bool? estado,
    this.controlestext,
    this.idControl,
    this.idObjetivo,
    this.walkthroughId,
    this.description,
    String? categoria,
    this.findingStatus,
    this.listImages,
    this.listArchives,
    this.listVideos,
  })  : this.nameProyect = nameProyect ?? 'null',
        this.nameControl = nameControl ?? 'null',
        this.estado = estado ?? false,
        this.categoria = categoria ?? 'null';

  final String nameProyect;
  final String nameControl;
  final Future Function(bool? state)? onUpdateDinamic;
  final bool estado;
  final String? controlestext;
  final String? idControl;
  final String? idObjetivo;
  final String? walkthroughId;
  final String? description;
  final String categoria;
  final int? findingStatus;
  final List<FFUploadedFile>? listImages;
  final List<FFUploadedFile>? listArchives;
  final List<FFUploadedFile>? listVideos;

  @override
  State<ComponentControlladorWidget> createState() =>
      _ComponentControlladorWidgetState();
}

class _ComponentControlladorWidgetState
    extends State<ComponentControlladorWidget> {
  late ComponentControlladorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentControlladorModel());

    _model.txtdescripcionTextController ??= TextEditingController(
        text: widget.controlestext == 'null' ? '' : widget.controlestext);
    _model.txtdescripcionFocusNode ??= FocusNode();

    // Inicializar el estado del control basándose en findingStatus
    if (widget.findingStatus != null) {
      _model.selectStateControl = widget.findingStatus;
    }

    // Cargar datos completos del control (control_text, photos, videos, archives)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ⚠️ Verificar que idControl no sea null antes de continuar
      if (widget.idControl == null || widget.idControl!.isEmpty) {
        return;
      }

      // ⚠️ Verificar que el widget aún está montado
      if (!mounted) {
        return;
      }

      // Cargar control completo desde la base de datos
      final controlCompleto =
          await actions.obtenerControlCompleto(widget.idControl!);

      if (controlCompleto != null && mounted) {
        // Cargar control_text si está vacío
        if (widget.controlestext == null ||
            widget.controlestext == 'null' ||
            widget.controlestext!.isEmpty) {
          final controlText = controlCompleto['control_text'];
          if (controlText != null && controlText.toString().isNotEmpty && mounted) {
            // Verificar que el controller no fue disposed
            if (_model.txtdescripcionTextController != null &&
                !(_model.txtdescripcionTextController?.hasListeners == false)) {
              _model.txtdescripcionTextController?.text = controlText.toString();
            }
          }
        }

        // Cargar fotos si la lista está vacía
        if (widget.listImages == null || widget.listImages!.isEmpty) {
          final photosJson = controlCompleto['photos'];
          if (photosJson != null) {
            _model.listImagesData =
                functions.convertBase64StringToUploadFiles(photosJson, 'image') ??
                    [];
          }
        } else {
          _model.listImagesData = widget.listImages!.toList();
        }

        // Cargar videos si la lista está vacía
        if (widget.listVideos == null || widget.listVideos!.isEmpty) {
          final videosJson = controlCompleto['video'];
          if (videosJson != null) {
            _model.listvideomp4Data =
                functions.convertBase64StringToUploadFiles(videosJson, 'video') ??
                    [];
          }
        } else {
          _model.listvideomp4Data = widget.listVideos!.toList();
        }

        // Cargar archivos si la lista está vacía
        if (widget.listArchives == null || widget.listArchives!.isEmpty) {
          final archivesJson = controlCompleto['archives'];
          if (archivesJson != null) {
            _model.listarchiveData = functions.convertBase64StringToUploadFiles(
                    archivesJson, 'archives') ??
                [];
          }
        } else {
          _model.listarchiveData = widget.listArchives!.toList();
        }

        // ⭐ CARGAR DATOS DE HALLAZGO - Prioridad a datos temporales
        // 1️⃣ Intentar cargar desde FFAppState (datos temporales NO guardados)
        final datosTemporales = FFAppState().getHallazgoTemporal(widget.idControl!);

        if (datosTemporales != null) {
          // Hay datos temporales - usar esos
          _model.observacion = datosTemporales['observacion'];
          _model.gerencia = datosTemporales['gerencia'];
          _model.ecosistema = datosTemporales['ecosistema'];
          _model.fecha = datosTemporales['fecha'];
          _model.descripcion = datosTemporales['descripcion'];
          _model.recomendacion = datosTemporales['recomendacion'];
          _model.procesoPropuesto = datosTemporales['procesoPropuesto'];
          _model.tituloHallazgo = datosTemporales['titulo'];
          _model.nivelRiesgo = datosTemporales['nivelRiesgo'];
          _model.titulo = datosTemporales['observacion']; // titulo observación
          // ⭐ v19 campos adicionales
          _model.riskLevelId = datosTemporales['riskLevelId'];
          _model.publicationStatusId = datosTemporales['publicationStatusId'];
          _model.estadoPublicacion = datosTemporales['estadoPublicacion'];
          _model.impactTypeId = datosTemporales['impactTypeId'];
          _model.tipoImpacto = datosTemporales['tipoImpacto'];
          _model.ecosystemSupportId = datosTemporales['ecosystemSupportId'];
          _model.soporteEcosistema = datosTemporales['soporteEcosistema'];
          _model.riskTypeId = datosTemporales['riskTypeId'];
          _model.tipoRiesgo = datosTemporales['tipoRiesgo'];
          _model.riskTypologyId = datosTemporales['riskTypologyId'];
          _model.tipologiaRiesgo = datosTemporales['tipologiaRiesgo'];
          _model.gerenteResponsable = datosTemporales['gerenteResponsable'];
          _model.auditorResponsable = datosTemporales['auditorResponsable'];
          _model.descripcionRiesgo = datosTemporales['descripcionRiesgo'];
          _model.observationScopeId = datosTemporales['observationScopeId'];
          _model.alcanceObservacion = datosTemporales['alcanceObservacion'];
          _model.riskActualLevelId = datosTemporales['riskActualLevelId'];
          _model.riesgoActual = datosTemporales['riesgoActual'];
          _model.causaRaiz = datosTemporales['causaRaiz'];
        } else {
          // No hay datos temporales - cargar desde SQLite (datos guardados)
          _model.observacion = controlCompleto['observacion'];
          _model.gerencia = controlCompleto['gerencia'];
          _model.ecosistema = controlCompleto['ecosistema'];
          _model.fecha = controlCompleto['fecha'];
          _model.descripcion = controlCompleto['descripcion_hallazgo'];
          _model.recomendacion = controlCompleto['recomendacion'];
          _model.procesoPropuesto = controlCompleto['proceso_propuesto'];
          _model.tituloHallazgo = controlCompleto['titulo'];
          _model.nivelRiesgo = controlCompleto['nivel_riesgo'];
          _model.titulo = controlCompleto['observacion']; // titulo observación
          // ⭐ v19 campos adicionales
          _model.riskLevelId = controlCompleto['risk_level_id'];
          _model.publicationStatusId = controlCompleto['publication_status_id'];
          _model.estadoPublicacion = controlCompleto['estado_publicacion'];
          _model.impactTypeId = controlCompleto['impact_type_id'];
          _model.tipoImpacto = controlCompleto['tipo_impacto'];
          _model.ecosystemSupportId = controlCompleto['ecosystem_support_id'];
          _model.soporteEcosistema = controlCompleto['soporte_ecosistema'];
          _model.riskTypeId = controlCompleto['risk_type_id'];
          _model.tipoRiesgo = controlCompleto['tipo_riesgo'];
          _model.riskTypologyId = controlCompleto['risk_typology_id'];
          _model.tipologiaRiesgo = controlCompleto['tipologia_riesgo'];
          _model.gerenteResponsable = controlCompleto['gerente_responsable'];
          _model.auditorResponsable = controlCompleto['auditor_responsable'];
          _model.descripcionRiesgo = controlCompleto['descripcion_riesgo'];
          _model.observationScopeId = controlCompleto['observation_scope_id'];
          _model.alcanceObservacion = controlCompleto['alcance_observacion'];
          _model.riskActualLevelId = controlCompleto['risk_actual_level_id'];
          _model.riesgoActual = controlCompleto['riesgo_actual'];
          _model.causaRaiz = controlCompleto['causa_raiz'];
        }

        // ⭐ CARGAR datos temporales COMPLETOS del control (imágenes, texto, estado, etc.)
        // SOLO si hay datos temporales reales (no vacíos)
        final controlTemporal = FFAppState().getControlTemporal(widget.idControl!);
        if (controlTemporal != null && controlTemporal.isNotEmpty) {
          // Cargar imágenes temporales (SOLO si hay imágenes)
          if (controlTemporal['imagenes'] != null &&
              (controlTemporal['imagenes'] as List).isNotEmpty) {
            _model.listImagesData = List<FFUploadedFile>.from(controlTemporal['imagenes']);
          }

          // Cargar videos temporales (SOLO si hay videos)
          if (controlTemporal['videos'] != null &&
              (controlTemporal['videos'] as List).isNotEmpty) {
            _model.listvideomp4Data = List<FFUploadedFile>.from(controlTemporal['videos']);
          }

          // Cargar archivos temporales (SOLO si hay archivos)
          if (controlTemporal['archivos'] != null &&
              (controlTemporal['archivos'] as List).isNotEmpty) {
            _model.listarchiveData = List<FFUploadedFile>.from(controlTemporal['archivos']);
          }

          // Cargar texto temporal (SOLO si hay texto)
          if (controlTemporal['texto'] != null &&
              (controlTemporal['texto'] as String).isNotEmpty) {
            _model.txtdescripcionTextController?.text = controlTemporal['texto'];
          }

          // Cargar estado temporal
          if (controlTemporal['estado'] != null) {
            _model.selectStateControl = controlTemporal['estado'];
          }
        }

        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    // 💾 Guardar datos temporalmente ANTES de destruir el componente
    // Solo si hay cambios pendientes Y idControl no es null
    if (widget.idControl != null &&
        widget.idControl!.isNotEmpty &&
        (_model.listImagesData.isNotEmpty ||
            _model.listvideomp4Data.isNotEmpty ||
            _model.listarchiveData.isNotEmpty ||
            (_model.txtdescripcionTextController?.text.isNotEmpty ?? false) ||
            _model.selectStateControl != null)) {


      FFAppState().setControlTemporal(
        widget.idControl!,
        {
          'imagenes': _model.listImagesData,
          'videos': _model.listvideomp4Data,
          'archivos': _model.listarchiveData,
          'texto': _model.txtdescripcionTextController?.text ?? '',
          'estado': _model.selectStateControl,
        },
      );
    }

    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, -1.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).containerColorPrimary,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 4.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: wrapWithModel(
                      model: _model.containerTextModel,
                      updateCallback: () => safeSetState(() {}),
                      child: ContainerTextWidget(
                        textName: widget.categoria,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: valueOrDefault<Color>(
                          widget.estado
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).inefectivo,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 8.0, 12.0, 8.0),
                        child: Text(
                          valueOrDefault<String>(
                            widget.estado == true
                                ? 'Completado'
                                : 'Incompleto',
                            'Completado',
                          ),
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 5.0)),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Text(
                          widget.nameControl,
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) => Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).alternate,
                          icon: Icon(
                            Icons.notes_outlined,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
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
                                  child: DescriptionControlWidget(
                                    descripcion: functions.clearTextControlHTML(
                                        widget.description),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Text(
                  'Estado de control',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 15.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        _model.selectStateControl = 1;
                        safeSetState(() {});
                        // NO limpiar datos del hallazgo para mantenerlos temporalmente
                      },
                      text: 'Efectivo',
                      icon: FaIcon(
                        FontAwesomeIcons.checkCircle,
                        size: 15.0,
                      ),
                      options: FFButtonOptions(
                        width: 150.0,
                        height: 47.8,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: valueOrDefault<Color>(
                          () {
                            // Si el usuario ha seleccionado manualmente
                            if (_model.selectStateControl != null) {
                              if (_model.selectStateControl == 1) {
                                return FlutterFlowTheme.of(context).efectivo;
                              }
                            }
                            // Si no ha seleccionado, usar el valor guardado
                            else if (widget.findingStatus == 1) {
                              return FlutterFlowTheme.of(context).efectivo;
                            }
                            return FlutterFlowTheme.of(context).chicoContainer;
                          }(),
                          FlutterFlowTheme.of(context).chicoContainer,
                        ),
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: TextStyle(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).customColor4bbbbb,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        _model.selectStateControl = 0;
                        safeSetState(() {});
                      },
                      text: 'Inefectivo',
                      icon: FaIcon(
                        FontAwesomeIcons.checkCircle,
                        size: 15.0,
                      ),
                      options: FFButtonOptions(
                        width: 150.0,
                        height: 47.8,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: valueOrDefault<Color>(
                          () {
                            // Si el usuario ha seleccionado manualmente
                            if (_model.selectStateControl != null) {
                              if (_model.selectStateControl == 0) {
                                return FlutterFlowTheme.of(context).inefectivo;
                              }
                            }
                            // Si no ha seleccionado, usar el valor guardado
                            else if (widget.findingStatus == 0) {
                              return FlutterFlowTheme.of(context).inefectivo;
                            }
                            return FlutterFlowTheme.of(context).chicoContainer;
                          }(),
                          FlutterFlowTheme.of(context).chicoContainer,
                        ),
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: TextStyle(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).customColor4bbbbb,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                  child: Text(
                    'Notas y observaciones',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          child: TextFormField(
                            controller: _model.txtdescripcionTextController,
                            focusNode: _model.txtdescripcionFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.txtdescripcionTextController',
                              Duration(milliseconds: 50),
                              () => safeSetState(() {}),
                            ),
                            autofocus: false,
                            enabled: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Escribe tus notas aqui',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .customColor4bbbbb,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .mouseregionTEXT,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
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
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            maxLines: 20,
                            maxLength: 1000,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) =>
                                null,
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            enableInteractiveSelection: true,
                            validator: _model
                                .txtdescripcionTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 85.0,
                          height: 200.0,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: custom_widgets.WidgetWritexText(
                                width: double.infinity,
                                height: double.infinity,
                                state: true,
                                textValue: _model.txtdescripcionTextController?.text, // Pasar texto actual para acumular correctamente
                                action: (txtdota2) async {
                                  safeSetState(() {
                                    _model.txtdescripcionTextController?.text =
                                        txtdota2;
                                    _model.txtdescripcionFocusNode
                                        ?.requestFocus();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _model.txtdescripcionTextController
                                          ?.selection = TextSelection.collapsed(
                                        offset: _model
                                            .txtdescripcionTextController!
                                            .text
                                            .length,
                                      );
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final selectedFiles = await selectFiles(
                                  multiFile: true,
                                );
                                if (selectedFiles != null) {
                                  safeSetState(() => _model
                                      .isDataUploading_archiveData = true);
                                  var selectedUploadedFiles =
                                      <FFUploadedFile>[];

                                  try {
                                    selectedUploadedFiles = selectedFiles
                                        .map((m) => FFUploadedFile(
                                              name:
                                                  m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              originalFilename:
                                                  m.originalFilename,
                                            ))
                                        .toList();
                                  } finally {
                                    _model.isDataUploading_archiveData = false;
                                  }
                                  if (selectedUploadedFiles.length ==
                                      selectedFiles.length) {
                                    safeSetState(() {
                                      _model.uploadedLocalFiles_archiveData =
                                          selectedUploadedFiles;
                                    });
                                  } else {
                                    safeSetState(() {});
                                    return;
                                  }
                                }

                                // Agregar nuevos archivos sin duplicar (no reemplazar)
                                if (_model.uploadedLocalFiles_archiveData.isNotEmpty) {
                                  for (var newArchive in _model.uploadedLocalFiles_archiveData) {
                                    // Verificar si el archivo ya existe
                                    bool existe = _model.listarchiveData.any((archive) =>
                                      archive.name == newArchive.name &&
                                      archive.bytes?.length == newArchive.bytes?.length
                                    );

                                    // Solo agregar si no existe
                                    if (!existe) {
                                      _model.addToListarchiveData(newArchive);
                                    }
                                  }
                                }
                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 8.0, 8.0, 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '📎',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Archivo ${_model.listarchiveData.isNotEmpty ? _model.listarchiveData.length.toString() : valueOrDefault<String>(
                                            widget.listArchives?.length
                                                ?.toString(),
                                            '0',
                                          )}',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                var confirmDialogResponse =
                                    await showDialog<bool>(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Elija tipo de Carga de Imagenes'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext,
                                                          false),
                                                  child: Text('Galeria'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext,
                                                          true),
                                                  child: Text('Tomar Captura'),
                                                ),
                                              ],
                                            );
                                          },
                                        ) ??
                                        false;
                                if (confirmDialogResponse) {
                                  final selectedMedia = await selectMedia(
                                    imageQuality: 100,
                                    multiImage: false,
                                  );
                                  if (selectedMedia != null &&
                                      selectedMedia.every((m) =>
                                          validateFileFormat(
                                              m.storagePath, context))) {
                                    safeSetState(() => _model
                                            .isDataUploading_imagenesUploadCaptura =
                                        true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];

                                    try {
                                      selectedUploadedFiles = selectedMedia
                                          .map((m) => FFUploadedFile(
                                                name: m.storagePath
                                                    .split('/')
                                                    .last,
                                                bytes: m.bytes,
                                                height: m.dimensions?.height,
                                                width: m.dimensions?.width,
                                                blurHash: m.blurHash,
                                                originalFilename:
                                                    m.originalFilename,
                                              ))
                                          .toList();
                                    } finally {
                                      _model.isDataUploading_imagenesUploadCaptura =
                                          false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                        selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile_imagenesUploadCaptura =
                                            selectedUploadedFiles.first;
                                      });
                                      _model.addToListImagesData(_model
                                          .uploadedLocalFile_imagenesUploadCaptura);
                                      safeSetState(() {});
                                    } else {
                                      safeSetState(() {});
                                      return;
                                    }
                                  }
                                } else {
                                  _model.uploadList = await actions
                                      .pickMultipleImagesFromGallery();
                                  if (_model.uploadList != null &&
                                      (_model.uploadList)!.isNotEmpty) {
                                    _model.listImagesData.addAll(_model
                                        .uploadList!
                                        .cast<FFUploadedFile>());
                                    safeSetState(() {});
                                  }
                                }

                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 8.0, 8.0, 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '📷',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Imagen ${_model.listImagesData.isNotEmpty ? valueOrDefault<String>(
                                            _model.listImagesData.length
                                                .toString(),
                                            '0',
                                          ) : valueOrDefault<String>(
                                            widget.listImages?.length
                                                ?.toString(),
                                            '0',
                                          )}',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                var confirmDialogResponse =
                                    await showDialog<bool>(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Elija tipo de Carga de Videos'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext,
                                                          false),
                                                  child: Text('Galeria'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext,
                                                          true),
                                                  child: Text('Grabar'),
                                                ),
                                              ],
                                            );
                                          },
                                        ) ??
                                        false;
                                if (confirmDialogResponse) {
                                  // Abrir cámara para grabar video
                                  final selectedMedia = await selectMedia(
                                    isVideo: true,
                                    mediaSource: MediaSource.camera,
                                    multiImage: false,
                                  );
                                  if (selectedMedia != null &&
                                      selectedMedia.every((m) =>
                                          validateFileFormat(
                                              m.storagePath, context))) {
                                    safeSetState(() => _model
                                            .isDataUploading_videoflutterflowwidgetx =
                                        true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];

                                    try {
                                      selectedUploadedFiles = selectedMedia
                                          .map((m) => FFUploadedFile(
                                                name: m.storagePath
                                                    .split('/')
                                                    .last,
                                                bytes: m.bytes,
                                                height: m.dimensions?.height,
                                                width: m.dimensions?.width,
                                                blurHash: m.blurHash,
                                                originalFilename:
                                                    m.originalFilename,
                                              ))
                                          .toList();
                                    } finally {
                                      _model.isDataUploading_videoflutterflowwidgetx =
                                          false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                        selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile_videoflutterflowwidgetx =
                                            selectedUploadedFiles.first;
                                      });
                                      _model.addToListvideomp4Data(_model
                                          .uploadedLocalFile_videoflutterflowwidgetx);
                                      safeSetState(() {});
                                    } else {
                                      safeSetState(() {});
                                      return;
                                    }
                                  }
                                } else {
                                  // Seleccionar múltiples videos desde galería
                                  _model.uploadListVideo = await actions
                                      .pickMultipleVideosFromGallery();
                                  if (_model.uploadListVideo != null &&
                                      (_model.uploadListVideo)!.isNotEmpty) {
                                    // AGREGAR los nuevos videos a la lista existente (sin duplicar)
                                    for (var newVideo in _model.uploadListVideo!) {
                                      // Solo agregar si no existe ya en la lista
                                      bool existe = _model.listvideomp4Data.any((video) =>
                                        video.name == newVideo.name &&
                                        video.bytes?.length == newVideo.bytes?.length
                                      );

                                      if (!existe) {
                                        _model.addToListvideomp4Data(newVideo);
                                      }
                                    }
                                    safeSetState(() {});
                                  }
                                }

                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 8.0, 8.0, 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '🎥',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Video ${_model.listvideomp4Data.isNotEmpty ? _model.listvideomp4Data.length.toString() : valueOrDefault<String>(
                                            widget.listVideos?.length
                                                ?.toString(),
                                            '0',
                                          )}',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: TextStyle(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Builder(
                          builder: (context) => FFButtonWidget(
                            onPressed: () async {
                              if (widget.listImages != null &&
                                  (widget.listImages)!.isNotEmpty) {
                                _model.listImagesData = functions
                                    .addValuesUploadListExist(
                                        _model.listImagesData.toList(),
                                        widget.listImages?.toList())!
                                    .toList()
                                    .cast<FFUploadedFile>();
                                safeSetState(() {});
                              } else if (widget.listArchives != null &&
                                  (widget.listArchives)!.isNotEmpty) {
                                _model.listarchiveData = functions
                                    .addValuesUploadListExist(
                                        _model.listarchiveData.toList(),
                                        widget.listArchives?.toList())!
                                    .toList()
                                    .cast<FFUploadedFile>();
                                safeSetState(() {});
                              } else if (widget.listVideos != null &&
                                  (widget.listVideos)!.isNotEmpty) {
                                _model.listvideomp4Data = functions
                                    .addValuesUploadListExist(
                                        _model.listvideomp4Data.toList(),
                                        widget.listVideos?.toList())!
                                    .toList()
                                    .cast<FFUploadedFile>();
                                safeSetState(() {});
                              }

                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: ViewFilesWidget(
                                      listImages: _model.listImagesData,
                                      videomp4: _model.listvideomp4Data,
                                      archive: _model.listarchiveData,
                                      parameterAcctionImagen:
                                          (listImages, id) async {
                                        _model.removeAtIndexFromListImagesData(
                                            id!);
                                        safeSetState(() {});
                                      },
                                      parameterActionVideo: (videoIndex) async {
                                        if (videoIndex != null) {
                                          _model.removeAtIndexFromListvideomp4Data(
                                              videoIndex);
                                        }
                                        safeSetState(() {});
                                      },
                                      parameterActionArchive: (archiveIndex) async {
                                        if (archiveIndex != null) {
                                          _model.removeAtIndexFromListarchiveData(
                                              archiveIndex);
                                        }
                                        safeSetState(() {});
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            text: 'Ver Documentos',
                            icon: Icon(
                              Icons.auto_awesome_motion,
                              size: 20.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 47.8,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconAlignment: IconAlignment.start,
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconColor:
                                  FlutterFlowTheme.of(context).negroLinea,
                              color:
                                  FlutterFlowTheme.of(context).chicoContainer,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .customColor4bbbbb,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      // ⭐ Mostrar botón Hallazgo si:
                      // 1. Control nuevo marcado como inefectivo (_model.selectStateControl == 0)
                      // 2. Control guardado que es inefectivo (widget.findingStatus == 0)
                      if (_model.selectStateControl == 0 || widget.findingStatus == 0)
                        Flexible(
                          child: Builder(
                            builder: (context) => FFButtonWidget(
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
                                      child: CreateHallasgoWidget(
                                        // ⭐ Pasar hallazgo existente si hay datos cargados
                                        hallazgo: (_model.procesoPropuesto != null ||
                                                   _model.titulo != null ||
                                                   _model.gerencia != null ||
                                                   _model.ecosistema != null ||
                                                   _model.fecha != null ||
                                                   _model.descripcion != null ||
                                                   _model.recomendacion != null ||
                                                   _model.tituloHallazgo != null ||
                                                   _model.nivelRiesgo != null ||
                                                   _model.publicationStatusId != null ||
                                                   _model.impactTypeId != null ||
                                                   _model.ecosystemSupportId != null ||
                                                   _model.riskTypeId != null ||
                                                   _model.observationScopeId != null ||
                                                   _model.riskActualLevelId != null ||
                                                   _model.gerenteResponsable != null)
                                            ? () {
                                                // 🔍 Convertir nombres (texto) a IDs para los dropdowns
                                                String? procesoPropuestoId;

                                                // procesoPropuesto se almacena como nombre del proceso
                                                // (create_hallasgo lo busca por nombre o idProceso al restaurar)
                                                if (_model.procesoPropuesto != null && _model.procesoPropuesto!.isNotEmpty) {
                                                  procesoPropuestoId = _model.procesoPropuesto;
                                                }

                                                return HallazgoStruct(
                                                  observacion: _model.titulo,
                                                  gerencia: _model.gerencia,
                                                  ecosistema: _model.ecosistema,
                                                  fecha: _model.fecha,
                                                  descripcion: _model.descripcion,
                                                  recomendacion: _model.recomendacion,
                                                  procesoPropuesto: procesoPropuestoId ?? _model.procesoPropuesto,
                                                  titulo: _model.tituloHallazgo,
                                                  tituloHallazgo: _model.tituloHallazgo,
                                                  nivelRiesgo: _model.nivelRiesgo,
                                                  riskLevelId: _model.riskLevelId ?? '',
                                                  // ⭐ v19
                                                  publicationStatusId: _model.publicationStatusId ?? '',
                                                  impactTypeId: _model.impactTypeId ?? '',
                                                  ecosystemSupportId: _model.ecosystemSupportId ?? '',
                                                  riskTypeId: _model.riskTypeId ?? '',
                                                  riskTypologyId: _model.riskTypologyId ?? '',
                                                  observationScopeId: _model.observationScopeId ?? '',
                                                  riskActualLevelId: _model.riskActualLevelId ?? '',
                                                  gerenteResponsable: _model.gerenteResponsable ?? '',
                                                  auditorResponsable: _model.auditorResponsable ?? '',
                                                  descripcionRiesgo: _model.descripcionRiesgo ?? '',
                                                  causaRaiz: _model.causaRaiz ?? '',
                                                );
                                              }()
                                            : null,
                                        createHallazgo: (tituloObservacion,
                                            gerencia,
                                            ecosistema,
                                            fecha,
                                            descripcion,
                                            recomendacion,
                                            procesoPropuesto,
                                            titulo,
                                            nivelRiesgo,
                                            riskLevelId,
                                            publicationStatusId,
                                            estadoPublicacion,
                                            impactTypeId,
                                            tipoImpacto,
                                            ecosystemSupportId,
                                            soporteEcosistema,
                                            riskTypeId,
                                            tipoRiesgo,
                                            riskTypologyId,
                                            tipologiaRiesgo,
                                            gerenteResponsable,
                                            auditorResponsable,
                                            descripcionRiesgo,
                                            observationScopeId,
                                            alcanceObservacion,
                                            riskActualLevelId,
                                            riesgoActual,
                                            causaRaiz) async {
                                          print('💾 Guardando datos de hallazgo TEMPORALMENTE...');

                                          // Guardar en _model (memoria local del componente)
                                          _model.titulo = tituloObservacion;
                                          _model.gerencia = gerencia;
                                          _model.ecosistema = ecosistema;
                                          _model.fecha = fecha;
                                          _model.nivelriesgo = nivelRiesgo;
                                          _model.descripcion = descripcion;
                                          _model.recomendacion = recomendacion;
                                          _model.procesoPropuesto = procesoPropuesto;
                                          _model.observacion = tituloObservacion;
                                          _model.tituloHallazgo = titulo;
                                          _model.nivelRiesgo = nivelRiesgo;
                                          // ⭐ v19
                                          _model.riskLevelId = riskLevelId;
                                          _model.publicationStatusId = publicationStatusId;
                                          _model.estadoPublicacion = estadoPublicacion;
                                          _model.impactTypeId = impactTypeId;
                                          _model.tipoImpacto = tipoImpacto;
                                          _model.ecosystemSupportId = ecosystemSupportId;
                                          _model.soporteEcosistema = soporteEcosistema;
                                          _model.riskTypeId = riskTypeId;
                                          _model.tipoRiesgo = tipoRiesgo;
                                          _model.riskTypologyId = riskTypologyId;
                                          _model.tipologiaRiesgo = tipologiaRiesgo;
                                          _model.gerenteResponsable = gerenteResponsable;
                                          _model.auditorResponsable = auditorResponsable;
                                          _model.descripcionRiesgo = descripcionRiesgo;
                                          _model.observationScopeId = observationScopeId;
                                          _model.alcanceObservacion = alcanceObservacion;
                                          _model.riskActualLevelId = riskActualLevelId;
                                          _model.riesgoActual = riesgoActual;
                                          _model.causaRaiz = causaRaiz;

                                          // ⭐ Guardar en FFAppState para que persista entre navegaciones
                                          FFAppState().setHallazgoTemporal(
                                            widget.idControl!,
                                            {
                                              'observacion': tituloObservacion,
                                              'gerencia': gerencia,
                                              'ecosistema': ecosistema,
                                              'fecha': fecha,
                                              'descripcion': descripcion,
                                              'recomendacion': recomendacion,
                                              'procesoPropuesto': procesoPropuesto,
                                              'titulo': titulo,
                                              'nivelRiesgo': nivelRiesgo,
                                              // ⭐ v19
                                              'riskLevelId': riskLevelId,
                                              'publicationStatusId': publicationStatusId,
                                              'estadoPublicacion': estadoPublicacion,
                                              'impactTypeId': impactTypeId,
                                              'tipoImpacto': tipoImpacto,
                                              'ecosystemSupportId': ecosystemSupportId,
                                              'soporteEcosistema': soporteEcosistema,
                                              'riskTypeId': riskTypeId,
                                              'tipoRiesgo': tipoRiesgo,
                                              'riskTypologyId': riskTypologyId,
                                              'tipologiaRiesgo': tipologiaRiesgo,
                                              'gerenteResponsable': gerenteResponsable,
                                              'auditorResponsable': auditorResponsable,
                                              'descripcionRiesgo': descripcionRiesgo,
                                              'observationScopeId': observationScopeId,
                                              'alcanceObservacion': alcanceObservacion,
                                              'riskActualLevelId': riskActualLevelId,
                                              'riesgoActual': riesgoActual,
                                              'causaRaiz': causaRaiz,
                                            },
                                          );

                                          safeSetState(() {});
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              text: 'Hallazgo',
                              icon: Icon(
                                Icons.fact_check,
                                size: 24.0,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 47.8,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color:
                                    FlutterFlowTheme.of(context).chicoContainer,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: TextStyle(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .customColor4bbbbb,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      var _shouldSetState = false;
                      _model.estaconectado =
                          await actions.checkInternetConecction();
                      _shouldSetState = true;
                      if (widget.listImages != null &&
                          (widget.listImages)!.isNotEmpty) {
                        _model.listImagesData = functions
                            .addValuesUploadListExist(
                                _model.listImagesData.toList(),
                                widget.listImages?.toList())!
                            .toList()
                            .cast<FFUploadedFile>();
                        safeSetState(() {});
                      } else if (widget.listArchives != null &&
                          (widget.listArchives)!.isNotEmpty) {
                        _model.listarchiveData = functions
                            .addValuesUploadListExist(
                                _model.listarchiveData.toList(),
                                widget.listArchives?.toList())!
                            .toList()
                            .cast<FFUploadedFile>();
                        safeSetState(() {});
                      } else if (widget.listVideos != null &&
                          (widget.listVideos)!.isNotEmpty) {
                        _model.listvideomp4Data = functions
                            .addValuesUploadListExist(
                                _model.listvideomp4Data.toList(),
                                widget.listVideos?.toList())!
                            .toList()
                            .cast<FFUploadedFile>();
                        safeSetState(() {});
                      }
                      // ⚠️ NO resetear selectStateControl aquí - ya fue actualizado al presionar el botón

                      if (_model.estaconectado!) {
                        // ✅ Validar: si selectStateControl es null, usar widget.findingStatus como fallback
                        int? estadoControl = _model.selectStateControl ?? widget.findingStatus;

                        if (estadoControl != null) {
                          if (estadoControl == 1) {
                            if ((_model.listImagesData.isNotEmpty) ||
                                (_model.listvideomp4Data.isNotEmpty) ||
                                (_model.listarchiveData.isNotEmpty)) {
                              // 🔓 Descomprimir imágenes GZIP antes de enviar a HighBond
                              var compressedImages = functions.convertListUploadFIletoBase64List(
                                  _model.listImagesData.toList());
                              var compressedVideos = functions.convertListUploadFIletoBase64List(
                                  _model.listvideomp4Data.toList());
                              var compressedArchivos = functions.convertListUploadFIletoBase64List(
                                  _model.listarchiveData.toList());

                              _model.apiResultsjoEfectivo =
                                  await SupabaseFunctionsGroup
                                      .updateControlHighbondInefectivoCall
                                      .call(
                                projectId: FFAppState().idproyect,
                                idControl: widget.idControl,
                                procesoPropuesto: _model.procesoPropuesto,
                                tituloObservacion: _model.titulo,
                                titulo: _model.tituloHallazgo,
                                gerencia: _model.gerencia,
                                ecosistema: _model.ecosistema,
                                fecha: _model.fecha,
                                nivelRiesgo: _model.nivelRiesgo,
                                descripcion: _model.descripcion,
                                recomendacion: _model.recomendacion,
                                imagesList: functions.decompressGzipBase64List(compressedImages),
                                videosList: functions.decompressGzipBase64List(compressedVideos),
                                archivosList: functions.decompressGzipBase64List(compressedArchivos),
                                projectName: FFAppState().projectName.isNotEmpty ? FFAppState().projectName : widget.nameProyect,
                                controlText: widget.nameControl,
                                publicationStatusId: _model.publicationStatusId,
                                estadoPublicacion: _model.estadoPublicacion,
                                impactTypeId: _model.impactTypeId,
                                tipoImpacto: _model.tipoImpacto,
                                ecosystemSupportId: _model.ecosystemSupportId,
                                soporteEcosistema: _model.soporteEcosistema,
                                riskTypeId: _model.riskTypeId,
                                tipoRiesgo: _model.tipoRiesgo,
                                riskTypologyId: _model.riskTypologyId,
                                tipologiaRiesgo: _model.tipologiaRiesgo,
                                observationScopeId: _model.observationScopeId,
                                alcanceObservacion: _model.alcanceObservacion,
                                riskActualLevelId: _model.riskActualLevelId,
                                riesgoActual: _model.riesgoActual,
                                gerenteResponsable: _model.gerenteResponsable,
                                auditorResponsable: _model.auditorResponsable,
                                descripcionRiesgo: _model.descripcionRiesgo,
                                causaRaiz: _model.causaRaiz,
                              );

                              _shouldSetState = true;
                              if ((_model.apiResultsjoEfectivo?.succeeded ??
                                  true)) {
                                _model.updateControlEfectivo =
                                    await SupabaseFunctionsGroup
                                        .updateControlHighbondCall
                                        .call(
                                  idWalkthrough: widget.walkthroughId,
                                  walkthroughResults:
                                      _model.txtdescripcionTextController.text,
                                  controlDesign: true,
                                );

                                _shouldSetState = true;
                                if ((_model.updateControlEfectivo?.succeeded ??
                                    true)) {
                                  // ⚡⚡⚡ CREAR MAPA DINÁMICO - SOLO incluir campos con valor
                                  Map<String, dynamic> dataToUpdate = {
                                    'completed': true,
                                    'finding_status': 1,
                                    'control_text': _model.txtdescripcionTextController.text,
                                  };

                                  // 🔥 SOLO actualizar multimedia si el usuario MODIFICÓ la lista
                                  // Comparar con widget.listImages original
                                  final photosChanged = widget.listImages == null ||
                                      widget.listImages!.length != _model.listImagesData.length;
                                  final videosChanged = widget.listVideos == null ||
                                      widget.listVideos!.length != _model.listvideomp4Data.length;
                                  final archivesChanged = widget.listArchives == null ||
                                      widget.listArchives!.length != _model.listarchiveData.length;

                                  // Solo enviar si cambió
                                  if (photosChanged) {
                                    dataToUpdate['photos'] = _model.listImagesData.isNotEmpty
                                        ? functions.convertUploadsListtoJSON(_model.listImagesData.toList())
                                        : null;
                                  }

                                  if (videosChanged) {
                                    dataToUpdate['video'] = _model.listvideomp4Data.isNotEmpty
                                        ? functions.convertUploadsListtoJSON(_model.listvideomp4Data.toList())
                                        : null;
                                  }

                                  if (archivesChanged) {
                                    dataToUpdate['archives'] = _model.listarchiveData.isNotEmpty
                                        ? functions.convertUploadsListtoJSON(_model.listarchiveData.toList())
                                        : null;
                                  }

                                  // Solo actualizar campos de hallazgo si tienen valor
                                  if (_model.observacion != null && _model.observacion!.isNotEmpty) {
                                    dataToUpdate['observacion'] = _model.observacion;
                                  }
                                  if (_model.gerencia != null && _model.gerencia!.isNotEmpty) {
                                    dataToUpdate['gerencia'] = _model.gerencia;
                                  }
                                  if (_model.ecosistema != null && _model.ecosistema!.isNotEmpty) {
                                    dataToUpdate['ecosistema'] = _model.ecosistema;
                                  }
                                  if (_model.fecha != null && _model.fecha!.isNotEmpty) {
                                    dataToUpdate['fecha'] = _model.fecha;
                                  }
                                  if (_model.descripcion != null && _model.descripcion!.isNotEmpty) {
                                    dataToUpdate['descripcion_hallazgo'] = _model.descripcion;
                                  }
                                  if (_model.recomendacion != null && _model.recomendacion!.isNotEmpty) {
                                    dataToUpdate['recomendacion'] = _model.recomendacion;
                                  }
                                  if (_model.procesoPropuesto != null && _model.procesoPropuesto!.isNotEmpty) {
                                    dataToUpdate['proceso_propuesto'] = _model.procesoPropuesto;
                                  }
                                  if (_model.tituloHallazgo != null && _model.tituloHallazgo!.isNotEmpty) {
                                    dataToUpdate['titulo'] = _model.tituloHallazgo;
                                  }
                                  if (_model.nivelRiesgo != null && _model.nivelRiesgo!.isNotEmpty) {
                                    dataToUpdate['nivel_riesgo'] = _model.nivelRiesgo;
                                  }
                                  // ⭐ v19
                                  if (_model.titulo != null && _model.titulo!.isNotEmpty) {
                                    dataToUpdate['titulo_observacion'] = _model.titulo;
                                  }
                                  if (_model.publicationStatusId != null) dataToUpdate['publication_status_id'] = _model.publicationStatusId;
                                  if (_model.estadoPublicacion != null) dataToUpdate['estado_publicacion'] = _model.estadoPublicacion;
                                  if (_model.impactTypeId != null) dataToUpdate['impact_type_id'] = _model.impactTypeId;
                                  if (_model.tipoImpacto != null) dataToUpdate['tipo_impacto'] = _model.tipoImpacto;
                                  if (_model.ecosystemSupportId != null) dataToUpdate['ecosystem_support_id'] = _model.ecosystemSupportId;
                                  if (_model.soporteEcosistema != null) dataToUpdate['soporte_ecosistema'] = _model.soporteEcosistema;
                                  if (_model.riskTypeId != null) dataToUpdate['risk_type_id'] = _model.riskTypeId;
                                  if (_model.tipoRiesgo != null) dataToUpdate['tipo_riesgo'] = _model.tipoRiesgo;
                                  if (_model.riskTypologyId != null) dataToUpdate['risk_typology_id'] = _model.riskTypologyId;
                                  if (_model.tipologiaRiesgo != null) dataToUpdate['tipologia_riesgo'] = _model.tipologiaRiesgo;
                                  if (_model.gerenteResponsable != null) dataToUpdate['gerente_responsable'] = _model.gerenteResponsable;
                                  if (_model.auditorResponsable != null) dataToUpdate['auditor_responsable'] = _model.auditorResponsable;
                                  if (_model.descripcionRiesgo != null) dataToUpdate['descripcion_riesgo'] = _model.descripcionRiesgo;
                                  if (_model.observationScopeId != null) dataToUpdate['observation_scope_id'] = _model.observationScopeId;
                                  if (_model.alcanceObservacion != null) dataToUpdate['alcance_observacion'] = _model.alcanceObservacion;
                                  if (_model.riskActualLevelId != null) dataToUpdate['risk_actual_level_id'] = _model.riskActualLevelId;
                                  if (_model.riesgoActual != null) dataToUpdate['riesgo_actual'] = _model.riesgoActual;
                                  if (_model.causaRaiz != null) dataToUpdate['causa_raiz'] = _model.causaRaiz;

                                  await ControlsTable().update(
                                    data: dataToUpdate,
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id_control',
                                      widget.idControl,
                                    ),
                                  );
                                  await actions.actualizarControlSqLite(
                                    widget.idControl!,
                                    widget.description!,
                                    FFAppState().idobejetivo,
                                    _model.listImagesData.toList(),
                                    _model.listvideomp4Data.toList(),
                                    _model.listarchiveData.toList(),
                                    1,
                                    _model.observacion,
                                    _model.gerencia,
                                    _model.ecosistema,
                                    _model.fecha,
                                    _model.descripcion,
                                    _model.recomendacion,
                                    _model.procesoPropuesto,
                                    _model.tituloHallazgo,
                                    _model.nivelRiesgo,
                                    _model.txtdescripcionTextController.text,
                                    _model.riskLevelId,
                                    _model.publicationStatusId,
                                    _model.estadoPublicacion,
                                    _model.impactTypeId,
                                    _model.tipoImpacto,
                                    _model.ecosystemSupportId,
                                    _model.soporteEcosistema,
                                    _model.riskTypeId,
                                    _model.tipoRiesgo,
                                    _model.riskTypologyId,
                                    _model.tipologiaRiesgo,
                                    _model.gerenteResponsable,
                                    _model.auditorResponsable,
                                    _model.descripcionRiesgo,
                                    _model.observationScopeId,
                                    _model.alcanceObservacion,
                                    _model.riskActualLevelId,
                                    _model.riesgoActual,
                                    _model.causaRaiz,
                                  );

                                  // ⚡ Actualizar FFAppState con el control modificado
                                  await actions.actualizarControlEnAppState(widget.idControl!);

                                  // 🗑️ Limpiar datos temporales después de guardar permanentemente
                                  FFAppState().clearHallazgoTemporal(widget.idControl!);
                                  FFAppState().clearControlTemporal(widget.idControl!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  ),
                                );
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }
                            } else {
                              _model.updateControlEfectivosinImagenes =
                                  await SupabaseFunctionsGroup
                                      .updateControlHighbondCall
                                      .call(
                                idWalkthrough: widget.walkthroughId,
                                walkthroughResults:
                                    _model.txtdescripcionTextController.text,
                                controlDesign: true,
                              );

                              _shouldSetState = true;
                              if ((_model.updateControlEfectivosinImagenes
                                      ?.succeeded ??
                                  true)) {
                                // 🔥 SOLO actualizar multimedia si el usuario MODIFICÓ la lista
                                Map<String, dynamic> dataToUpdateEfectivo = {
                                  'completed': true,
                                  'finding_status': 1,
                                  'control_text': _model.txtdescripcionTextController.text,
                                };

                                final photosChanged = widget.listImages == null ||
                                    widget.listImages!.length != _model.listImagesData.length;
                                final videosChanged = widget.listVideos == null ||
                                    widget.listVideos!.length != _model.listvideomp4Data.length;
                                final archivesChanged = widget.listArchives == null ||
                                    widget.listArchives!.length != _model.listarchiveData.length;

                                if (photosChanged) {
                                  dataToUpdateEfectivo['photos'] = _model.listImagesData.isNotEmpty
                                      ? functions.convertUploadsListtoJSON(_model.listImagesData.toList())
                                      : null;
                                }
                                if (videosChanged) {
                                  dataToUpdateEfectivo['video'] = _model.listvideomp4Data.isNotEmpty
                                      ? functions.convertUploadsListtoJSON(_model.listvideomp4Data.toList())
                                      : null;
                                }
                                if (archivesChanged) {
                                  dataToUpdateEfectivo['archives'] = _model.listarchiveData.isNotEmpty
                                      ? functions.convertUploadsListtoJSON(_model.listarchiveData.toList())
                                      : null;
                                }
                                // ⭐ v19
                                if (_model.publicationStatusId != null) dataToUpdateEfectivo['publication_status_id'] = _model.publicationStatusId;
                                if (_model.estadoPublicacion != null) dataToUpdateEfectivo['estado_publicacion'] = _model.estadoPublicacion;
                                if (_model.impactTypeId != null) dataToUpdateEfectivo['impact_type_id'] = _model.impactTypeId;
                                if (_model.tipoImpacto != null) dataToUpdateEfectivo['tipo_impacto'] = _model.tipoImpacto;
                                if (_model.ecosystemSupportId != null) dataToUpdateEfectivo['ecosystem_support_id'] = _model.ecosystemSupportId;
                                if (_model.soporteEcosistema != null) dataToUpdateEfectivo['soporte_ecosistema'] = _model.soporteEcosistema;
                                if (_model.riskTypeId != null) dataToUpdateEfectivo['risk_type_id'] = _model.riskTypeId;
                                if (_model.tipoRiesgo != null) dataToUpdateEfectivo['tipo_riesgo'] = _model.tipoRiesgo;
                                if (_model.riskTypologyId != null) dataToUpdateEfectivo['risk_typology_id'] = _model.riskTypologyId;
                                if (_model.tipologiaRiesgo != null) dataToUpdateEfectivo['tipologia_riesgo'] = _model.tipologiaRiesgo;
                                if (_model.gerenteResponsable != null) dataToUpdateEfectivo['gerente_responsable'] = _model.gerenteResponsable;
                                if (_model.auditorResponsable != null) dataToUpdateEfectivo['auditor_responsable'] = _model.auditorResponsable;
                                if (_model.descripcionRiesgo != null) dataToUpdateEfectivo['descripcion_riesgo'] = _model.descripcionRiesgo;
                                if (_model.observationScopeId != null) dataToUpdateEfectivo['observation_scope_id'] = _model.observationScopeId;
                                if (_model.alcanceObservacion != null) dataToUpdateEfectivo['alcance_observacion'] = _model.alcanceObservacion;
                                if (_model.riskActualLevelId != null) dataToUpdateEfectivo['risk_actual_level_id'] = _model.riskActualLevelId;
                                if (_model.riesgoActual != null) dataToUpdateEfectivo['riesgo_actual'] = _model.riesgoActual;
                                if (_model.causaRaiz != null) dataToUpdateEfectivo['causa_raiz'] = _model.causaRaiz;

                                await ControlsTable().update(
                                  data: dataToUpdateEfectivo,
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'id_control',
                                    widget.idControl,
                                  ),
                                );
                                await actions.actualizarControlSqLite(
                                  widget.idControl!,
                                  widget.description!,
                                  FFAppState().idobejetivo,
                                  _model.listImagesData.toList(),
                                  _model.listvideomp4Data.toList(),
                                  _model.listarchiveData.toList(),
                                  1,
                                  _model.observacion,
                                  _model.gerencia,
                                  _model.ecosistema,
                                  _model.fecha,
                                  _model.descripcion,
                                  _model.recomendacion,
                                  _model.procesoPropuesto,
                                  _model.tituloHallazgo,
                                  _model.nivelRiesgo,
                                  _model.txtdescripcionTextController.text,
                                  _model.riskLevelId,
                                  _model.publicationStatusId,
                                  _model.estadoPublicacion,
                                  _model.impactTypeId,
                                  _model.tipoImpacto,
                                  _model.ecosystemSupportId,
                                  _model.soporteEcosistema,
                                  _model.riskTypeId,
                                  _model.tipoRiesgo,
                                  _model.riskTypologyId,
                                  _model.tipologiaRiesgo,
                                  _model.gerenteResponsable,
                                  _model.auditorResponsable,
                                  _model.descripcionRiesgo,
                                  _model.observationScopeId,
                                  _model.alcanceObservacion,
                                  _model.riskActualLevelId,
                                  _model.riesgoActual,
                                  _model.causaRaiz,
                                );

                                // ⚡ Actualizar FFAppState con el control modificado
                                await actions.actualizarControlEnAppState(widget.idControl!);

                                // 🗑️ Limpiar datos temporales después de guardar permanentemente
                                FFAppState().clearHallazgoTemporal(widget.idControl!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  ),
                                );
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }
                            }
                          } else {
                            if ((_model.listImagesData.isNotEmpty) ||
                                (widget.listVideos != null &&
                                    (widget.listVideos)!.isNotEmpty) ||
                                (widget.listArchives != null &&
                                    (widget.listArchives)!.isNotEmpty)) {
                              // 🔓 Descomprimir imágenes GZIP antes de enviar a HighBond
                              var compressedImages2 = functions.convertListUploadFIletoBase64List(
                                  _model.listImagesData.toList());
                              var compressedVideos2 = functions.convertListUploadFIletoBase64List(
                                  _model.listvideomp4Data.toList());
                              var compressedArchivos2 = functions.convertListUploadFIletoBase64List(
                                  _model.listarchiveData.toList());

                              _model.apiResultInefectivo =
                                  await SupabaseFunctionsGroup
                                      .updateControlHighbondInefectivoCall
                                      .call(
                                projectId: FFAppState().idproyect,
                                idControl: widget.idControl,
                                procesoPropuesto: _model.procesoPropuesto,
                                tituloObservacion: _model.titulo,
                                titulo: _model.tituloHallazgo,
                                gerencia: _model.gerencia,
                                ecosistema: _model.ecosistema,
                                fecha: _model.fecha,
                                nivelRiesgo: _model.nivelRiesgo,
                                descripcion: _model.descripcion,
                                recomendacion: _model.recomendacion,
                                imagesList: functions.decompressGzipBase64List(compressedImages2),
                                videosList: functions.decompressGzipBase64List(compressedVideos2),
                                archivosList: functions.decompressGzipBase64List(compressedArchivos2),
                                projectName: FFAppState().projectName.isNotEmpty ? FFAppState().projectName : widget.nameProyect,
                                controlText: widget.nameControl,
                                publicationStatusId: _model.publicationStatusId,
                                estadoPublicacion: _model.estadoPublicacion,
                                impactTypeId: _model.impactTypeId,
                                tipoImpacto: _model.tipoImpacto,
                                ecosystemSupportId: _model.ecosystemSupportId,
                                soporteEcosistema: _model.soporteEcosistema,
                                riskTypeId: _model.riskTypeId,
                                tipoRiesgo: _model.tipoRiesgo,
                                riskTypologyId: _model.riskTypologyId,
                                tipologiaRiesgo: _model.tipologiaRiesgo,
                                observationScopeId: _model.observationScopeId,
                                alcanceObservacion: _model.alcanceObservacion,
                                riskActualLevelId: _model.riskActualLevelId,
                                riesgoActual: _model.riesgoActual,
                                gerenteResponsable: _model.gerenteResponsable,
                                auditorResponsable: _model.auditorResponsable,
                                descripcionRiesgo: _model.descripcionRiesgo,
                                causaRaiz: _model.causaRaiz,
                              );

                              _shouldSetState = true;
                              if ((_model.apiResultInefectivo?.succeeded ??
                                  true)) {
                                _model.updateControlAPIEfectgivo =
                                    await SupabaseFunctionsGroup
                                        .updateControlHighbondCall
                                        .call(
                                  idWalkthrough: widget.walkthroughId,
                                  walkthroughResults:
                                      _model.txtdescripcionTextController.text,
                                  controlDesign: false,
                                );

                                _shouldSetState = true;
                                if ((_model
                                        .updateControlAPIEfectgivo?.succeeded ??
                                    true)) {
                                  // ⚡⚡⚡ CREAR MAPA DINÁMICO - SOLO incluir campos con valor
                                  Map<String, dynamic> dataToUpdate2 = {
                                    'completed': true,
                                    'finding_status': 0,
                                    'control_text': _model.txtdescripcionTextController.text,
                                  };

                                  // Solo actualizar photos si hay imágenes
                                  if (_model.listImagesData.isNotEmpty) {
                                    dataToUpdate2['photos'] = functions.convertUploadsListtoJSON(_model.listImagesData.toList());
                                  }

                                  // Solo actualizar video si hay videos
                                  if (_model.listvideomp4Data.isNotEmpty) {
                                    dataToUpdate2['video'] = functions.convertUploadsListtoJSON(_model.listvideomp4Data.toList());
                                  }

                                  // Solo actualizar archives si hay archivos
                                  if (_model.listarchiveData.isNotEmpty) {
                                    dataToUpdate2['archives'] = functions.convertUploadsListtoJSON(_model.listarchiveData.toList());
                                  }

                                  // Solo actualizar campos de hallazgo si tienen valor
                                  if (_model.observacion != null && _model.observacion!.isNotEmpty) {
                                    dataToUpdate2['observacion'] = _model.observacion;
                                  }
                                  if (_model.gerencia != null && _model.gerencia!.isNotEmpty) {
                                    dataToUpdate2['gerencia'] = _model.gerencia;
                                  }
                                  if (_model.ecosistema != null && _model.ecosistema!.isNotEmpty) {
                                    dataToUpdate2['ecosistema'] = _model.ecosistema;
                                  }
                                  if (_model.fecha != null && _model.fecha!.isNotEmpty) {
                                    dataToUpdate2['fecha'] = _model.fecha;
                                  }
                                  if (_model.descripcion != null && _model.descripcion!.isNotEmpty) {
                                    dataToUpdate2['descripcion_hallazgo'] = _model.descripcion;
                                  }
                                  if (_model.recomendacion != null && _model.recomendacion!.isNotEmpty) {
                                    dataToUpdate2['recomendacion'] = _model.recomendacion;
                                  }
                                  if (_model.procesoPropuesto != null && _model.procesoPropuesto!.isNotEmpty) {
                                    dataToUpdate2['proceso_propuesto'] = _model.procesoPropuesto;
                                  }
                                  if (_model.tituloHallazgo != null && _model.tituloHallazgo!.isNotEmpty) {
                                    dataToUpdate2['titulo'] = _model.tituloHallazgo;
                                  }
                                  if (_model.nivelRiesgo != null && _model.nivelRiesgo!.isNotEmpty) {
                                    dataToUpdate2['nivel_riesgo'] = _model.nivelRiesgo;
                                  }
                                  // ⭐ v19
                                  if (_model.publicationStatusId != null) dataToUpdate2['publication_status_id'] = _model.publicationStatusId;
                                  if (_model.estadoPublicacion != null) dataToUpdate2['estado_publicacion'] = _model.estadoPublicacion;
                                  if (_model.impactTypeId != null) dataToUpdate2['impact_type_id'] = _model.impactTypeId;
                                  if (_model.tipoImpacto != null) dataToUpdate2['tipo_impacto'] = _model.tipoImpacto;
                                  if (_model.ecosystemSupportId != null) dataToUpdate2['ecosystem_support_id'] = _model.ecosystemSupportId;
                                  if (_model.soporteEcosistema != null) dataToUpdate2['soporte_ecosistema'] = _model.soporteEcosistema;
                                  if (_model.riskTypeId != null) dataToUpdate2['risk_type_id'] = _model.riskTypeId;
                                  if (_model.tipoRiesgo != null) dataToUpdate2['tipo_riesgo'] = _model.tipoRiesgo;
                                  if (_model.riskTypologyId != null) dataToUpdate2['risk_typology_id'] = _model.riskTypologyId;
                                  if (_model.tipologiaRiesgo != null) dataToUpdate2['tipologia_riesgo'] = _model.tipologiaRiesgo;
                                  if (_model.gerenteResponsable != null) dataToUpdate2['gerente_responsable'] = _model.gerenteResponsable;
                                  if (_model.auditorResponsable != null) dataToUpdate2['auditor_responsable'] = _model.auditorResponsable;
                                  if (_model.descripcionRiesgo != null) dataToUpdate2['descripcion_riesgo'] = _model.descripcionRiesgo;
                                  if (_model.observationScopeId != null) dataToUpdate2['observation_scope_id'] = _model.observationScopeId;
                                  if (_model.alcanceObservacion != null) dataToUpdate2['alcance_observacion'] = _model.alcanceObservacion;
                                  if (_model.riskActualLevelId != null) dataToUpdate2['risk_actual_level_id'] = _model.riskActualLevelId;
                                  if (_model.riesgoActual != null) dataToUpdate2['riesgo_actual'] = _model.riesgoActual;
                                  if (_model.causaRaiz != null) dataToUpdate2['causa_raiz'] = _model.causaRaiz;

                                  await ControlsTable().update(
                                    data: dataToUpdate2,
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id_control',
                                      widget.idControl,
                                    ),
                                  );
                                  await actions.actualizarControlSqLite(
                                    widget.idControl!,
                                    widget.description!,
                                    FFAppState().idobejetivo,
                                    _model.listImagesData.toList(),
                                    _model.listvideomp4Data.toList(),
                                    _model.listarchiveData.toList(),
                                    0,
                                    _model.observacion,
                                    _model.gerencia,
                                    _model.ecosistema,
                                    _model.fecha,
                                    _model.descripcion,
                                    _model.recomendacion,
                                    _model.procesoPropuesto,
                                    _model.tituloHallazgo,
                                    _model.nivelRiesgo,
                                    _model.txtdescripcionTextController.text,
                                    _model.riskLevelId,
                                    _model.publicationStatusId,
                                    _model.estadoPublicacion,
                                    _model.impactTypeId,
                                    _model.tipoImpacto,
                                    _model.ecosystemSupportId,
                                    _model.soporteEcosistema,
                                    _model.riskTypeId,
                                    _model.tipoRiesgo,
                                    _model.riskTypologyId,
                                    _model.tipologiaRiesgo,
                                    _model.gerenteResponsable,
                                    _model.auditorResponsable,
                                    _model.descripcionRiesgo,
                                    _model.observationScopeId,
                                    _model.alcanceObservacion,
                                    _model.riskActualLevelId,
                                    _model.riesgoActual,
                                    _model.causaRaiz,
                                  );

                                  // ⚡ Actualizar FFAppState con el control modificado
                                  await actions.actualizarControlEnAppState(widget.idControl!);

                                  // 🗑️ Limpiar datos temporales después de guardar permanentemente
                                  FFAppState().clearHallazgoTemporal(widget.idControl!);
                                  FFAppState().clearControlTemporal(widget.idControl!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  ),
                                );
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }
                            } else {
                              // ⭐ Sin adjuntos: primero crear hallazgo en HighBond con listas vacías
                              _model.apiResultInefectivoSinAdjuntos =
                                  await SupabaseFunctionsGroup
                                      .updateControlHighbondInefectivoCall
                                      .call(
                                projectId: FFAppState().idproyect,
                                idControl: widget.idControl,
                                procesoPropuesto: _model.procesoPropuesto,
                                tituloObservacion: _model.titulo,
                                titulo: _model.tituloHallazgo,
                                gerencia: _model.gerencia,
                                ecosistema: _model.ecosistema,
                                fecha: _model.fecha,
                                nivelRiesgo: _model.nivelRiesgo,
                                descripcion: _model.descripcion,
                                recomendacion: _model.recomendacion,
                                imagesList: [],
                                videosList: [],
                                archivosList: [],
                                projectName: FFAppState().projectName.isNotEmpty ? FFAppState().projectName : widget.nameProyect,
                                controlText: widget.nameControl,
                                publicationStatusId: _model.publicationStatusId,
                                estadoPublicacion: _model.estadoPublicacion,
                                impactTypeId: _model.impactTypeId,
                                tipoImpacto: _model.tipoImpacto,
                                ecosystemSupportId: _model.ecosystemSupportId,
                                soporteEcosistema: _model.soporteEcosistema,
                                riskTypeId: _model.riskTypeId,
                                tipoRiesgo: _model.tipoRiesgo,
                                riskTypologyId: _model.riskTypologyId,
                                tipologiaRiesgo: _model.tipologiaRiesgo,
                                observationScopeId: _model.observationScopeId,
                                alcanceObservacion: _model.alcanceObservacion,
                                riskActualLevelId: _model.riskActualLevelId,
                                riesgoActual: _model.riesgoActual,
                                gerenteResponsable: _model.gerenteResponsable,
                                auditorResponsable: _model.auditorResponsable,
                                descripcionRiesgo: _model.descripcionRiesgo,
                                causaRaiz: _model.causaRaiz,
                              );
                              _shouldSetState = true;
                              if (!(_model.apiResultInefectivoSinAdjuntos?.succeeded ?? true)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudo registrar el hallazgo en HighBond. Por favor intente nuevamente.',
                                      style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                  ),
                                );
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }

                              _model.updateControlInefectivosinImagenes =
                                  await SupabaseFunctionsGroup
                                      .updateControlHighbondCall
                                      .call(
                                idWalkthrough: widget.walkthroughId,
                                walkthroughResults:
                                    _model.txtdescripcionTextController.text,
                                controlDesign: false,
                              );

                              _shouldSetState = true;
                              if ((_model.updateControlInefectivosinImagenes
                                      ?.succeeded ??
                                  true)) {
                                // ⭐ v19 campos adicionales
                                Map<String, dynamic> dataToUpdate3 = {
                                  'completed': true,
                                  'finding_status': 0,
                                  'control_text': _model.txtdescripcionTextController.text,
                                };
                                if (_model.publicationStatusId != null) dataToUpdate3['publication_status_id'] = _model.publicationStatusId;
                                if (_model.estadoPublicacion != null) dataToUpdate3['estado_publicacion'] = _model.estadoPublicacion;
                                if (_model.impactTypeId != null) dataToUpdate3['impact_type_id'] = _model.impactTypeId;
                                if (_model.tipoImpacto != null) dataToUpdate3['tipo_impacto'] = _model.tipoImpacto;
                                if (_model.ecosystemSupportId != null) dataToUpdate3['ecosystem_support_id'] = _model.ecosystemSupportId;
                                if (_model.soporteEcosistema != null) dataToUpdate3['soporte_ecosistema'] = _model.soporteEcosistema;
                                if (_model.riskTypeId != null) dataToUpdate3['risk_type_id'] = _model.riskTypeId;
                                if (_model.tipoRiesgo != null) dataToUpdate3['tipo_riesgo'] = _model.tipoRiesgo;
                                if (_model.riskTypologyId != null) dataToUpdate3['risk_typology_id'] = _model.riskTypologyId;
                                if (_model.tipologiaRiesgo != null) dataToUpdate3['tipologia_riesgo'] = _model.tipologiaRiesgo;
                                if (_model.gerenteResponsable != null) dataToUpdate3['gerente_responsable'] = _model.gerenteResponsable;
                                if (_model.auditorResponsable != null) dataToUpdate3['auditor_responsable'] = _model.auditorResponsable;
                                if (_model.descripcionRiesgo != null) dataToUpdate3['descripcion_riesgo'] = _model.descripcionRiesgo;
                                if (_model.observationScopeId != null) dataToUpdate3['observation_scope_id'] = _model.observationScopeId;
                                if (_model.alcanceObservacion != null) dataToUpdate3['alcance_observacion'] = _model.alcanceObservacion;
                                if (_model.riskActualLevelId != null) dataToUpdate3['risk_actual_level_id'] = _model.riskActualLevelId;
                                if (_model.riesgoActual != null) dataToUpdate3['riesgo_actual'] = _model.riesgoActual;
                                if (_model.causaRaiz != null) dataToUpdate3['causa_raiz'] = _model.causaRaiz;

                                await ControlsTable().update(
                                  data: dataToUpdate3,
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'id_control',
                                    widget.idControl,
                                  ),
                                );
                                await actions.actualizarControlSqLite(
                                  widget.idControl!,
                                  widget.description!,
                                  FFAppState().idobejetivo,
                                  _model.listImagesData.toList(),
                                  _model.listvideomp4Data.toList(),
                                  _model.listarchiveData.toList(),
                                  0,
                                  _model.observacion,
                                  _model.gerencia,
                                  _model.ecosistema,
                                  _model.fecha,
                                  _model.descripcion,
                                  _model.recomendacion,
                                  _model.procesoPropuesto,
                                  _model.tituloHallazgo,
                                  _model.nivelRiesgo,
                                  _model.txtdescripcionTextController.text,
                                  _model.riskLevelId,
                                  _model.publicationStatusId,
                                  _model.estadoPublicacion,
                                  _model.impactTypeId,
                                  _model.tipoImpacto,
                                  _model.ecosystemSupportId,
                                  _model.soporteEcosistema,
                                  _model.riskTypeId,
                                  _model.tipoRiesgo,
                                  _model.riskTypologyId,
                                  _model.tipologiaRiesgo,
                                  _model.gerenteResponsable,
                                  _model.auditorResponsable,
                                  _model.descripcionRiesgo,
                                  _model.observationScopeId,
                                  _model.alcanceObservacion,
                                  _model.riskActualLevelId,
                                  _model.riesgoActual,
                                  _model.causaRaiz,
                                );

                                // ⚡ Actualizar FFAppState con el control modificado
                                await actions.actualizarControlEnAppState(widget.idControl!);

                                // 🗑️ Limpiar datos temporales después de guardar permanentemente
                                FFAppState().clearHallazgoTemporal(widget.idControl!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudieron cargar los archivos a HighBond. Por favor intente nuevamente.',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  ),
                                );
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }
                            }
                          }

                          _model.sqliListInefectivono =
                              await actions.sqlLiteListControles(
                            FFAppState().idobejetivo,
                          );
                          _shouldSetState = true;
                        } else {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                content:
                                    Text('Seleccione Efectivo o Inefectivo'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (_shouldSetState) safeSetState(() {});
                          return;
                        }
                      } else {
                        // 📴 MODO OFFLINE - Guardar SOLO en SQLite
                        // ✅ Usar widget.findingStatus como fallback si selectStateControl es null (igual que modo online)
                        int? estadoControlOffline = _model.selectStateControl ?? widget.findingStatus;
                        if (estadoControlOffline != null) {
                          // Guardar en SQLite según el estado (Efectivo=1 o Inefectivo=0)
                          await actions.actualizarControlSqLite(
                            widget.idControl!,
                            widget.description!,
                            FFAppState().idobejetivo,
                            _model.listImagesData.toList(),
                            _model.listvideomp4Data.toList(),
                            _model.listarchiveData.toList(),
                            estadoControlOffline, // 0 o 1 (con fallback a widget.findingStatus)
                            _model.observacion,
                            _model.gerencia,
                            _model.ecosistema,
                            _model.fecha,
                            _model.descripcion,
                            _model.recomendacion,
                            _model.procesoPropuesto,
                            _model.tituloHallazgo,
                            _model.nivelRiesgo,
                            _model.txtdescripcionTextController.text,
                            _model.riskLevelId,
                            _model.publicationStatusId,
                            _model.estadoPublicacion,
                            _model.impactTypeId,
                            _model.tipoImpacto,
                            _model.ecosystemSupportId,
                            _model.soporteEcosistema,
                            _model.riskTypeId,
                            _model.tipoRiesgo,
                            _model.riskTypologyId,
                            _model.tipologiaRiesgo,
                            _model.gerenteResponsable,
                            _model.auditorResponsable,
                            _model.descripcionRiesgo,
                            _model.observationScopeId,
                            _model.alcanceObservacion,
                            _model.riskActualLevelId,
                            _model.riesgoActual,
                            _model.causaRaiz,
                          );

                          // ⚡ Actualizar FFAppState con el control modificado
                          await actions.actualizarControlEnAppState(widget.idControl!);

                          // Limpiar datos temporales
                          FFAppState().clearHallazgoTemporal(widget.idControl!);
                          FFAppState().clearControlTemporal(widget.idControl!);

                          // Mostrar mensaje de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '📴 Control guardado localmente (Sin conexión)',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).warning,
                            ),
                          );

                          _shouldSetState = true;
                        } else {
                          // Error: No seleccionó Efectivo/Inefectivo
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                content: Text('Seleccione Efectivo o Inefectivo'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (_shouldSetState) safeSetState(() {});
                          return;
                        }
                      }

                      await Future.wait([
                        Future(() async {
                          safeSetState(() {
                            _model.isDataUploading_imagenesUploadCaptura =
                                false;
                            _model.uploadedLocalFile_imagenesUploadCaptura =
                                FFUploadedFile(
                                    bytes: Uint8List.fromList([]),
                                    originalFilename: '');
                          });
                        }),
                        Future(() async {
                          safeSetState(() {
                            _model.isDataUploading_archiveData = false;
                            _model.uploadedLocalFiles_archiveData = [];
                          });
                        }),
                        Future(() async {
                          safeSetState(() {
                            _model.isDataUploading_videoflutterflowwidgetx =
                                false;
                            _model.uploadedLocalFile_videoflutterflowwidgetx =
                                FFUploadedFile(
                                    bytes: Uint8List.fromList([]),
                                    originalFilename: '');
                          });
                        }),
                        Future(() async {
                          // NO limpiar las listas para que los contadores sigan mostrando los archivos
                          // _model.listImagesData = [];
                          // _model.listvideomp4Data = [];
                          // _model.listarchiveData = [];
                          _model.selectStateControl = null;
                          safeSetState(() {});
                        }),
                      ]);
                      await widget.onUpdateDinamic?.call(
                        true,
                      );
                      if (_shouldSetState) safeSetState(() {});
                    },
                    text: valueOrDefault<String>(
                      widget.estado == false
                          ? 'Guardar Control'
                          : 'Control Guardado',
                      'Guardar Controlador',
                    ),
                    icon: Icon(
                      Icons.save_alt,
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 47.8,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                      iconColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      color: valueOrDefault<Color>(
                        widget.estado == false
                            ? FlutterFlowTheme.of(context).secondary
                            : FlutterFlowTheme.of(context).negroLinea,
                        FlutterFlowTheme.of(context).secondary,
                      ),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: TextStyle(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ),
    );
  }
}
