import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'create_hallasgo_model.dart';
export 'create_hallasgo_model.dart';
import '/custom_code/DBRiskLevel.dart';
import '/custom_code/DBPublicationStatus.dart';
import '/custom_code/DBImpactType.dart';
import '/custom_code/DBEcosystemSupport.dart';
import '/custom_code/DBRiskType.dart';
import '/custom_code/DBRiskTypology.dart';
import '/custom_code/DBObservationScope.dart';
import '/custom_code/RiskLevel.dart';
import '/custom_code/RiskTypology.dart';
import '/backend/supabase/supabase.dart';

class CreateHallasgoWidget extends StatefulWidget {
  const CreateHallasgoWidget({
    super.key,
    required this.createHallazgo,
    this.hallazgo,
  });

  final Future Function(
      String tituloObservacion,
      String gerencia,
      String? ecosistema,
      String? fecha,
      String descripcion,
      String? recomendacion,
      String? procesoPropuesto,
      String? titulo,
      String? nivelRiesgo,
      String? riskLevelId,
      String? publicationStatusId,
      String? estadoPublicacion,
      String? impactTypeId,
      String? tipoImpacto,
      String? ecosystemSupportId,
      String? soporteEcosistema,
      String? riskTypeId,
      String? tipoRiesgo,
      String? riskTypologyId,
      String? tipologiaRiesgo,
      String? gerenteResponsable,
      String? auditorResponsable,
      String? descripcionRiesgo,
      String? observationScopeId,
      String? alcanceObservacion,
      String? riskActualLevelId,
      String? riesgoActual,
      String? causaRaiz)? createHallazgo;
  final HallazgoStruct? hallazgo;

  @override
  State<CreateHallasgoWidget> createState() => _CreateHallasgoWidgetState();
}

class _CreateHallasgoWidgetState extends State<CreateHallasgoWidget> {
  late CreateHallasgoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateHallasgoModel());

    // Helper: si el valor es null o el string literal "null", devuelve ''
    String safeText(String? val) => (val == null || val == 'null') ? '' : val;

    _model.txtdescripcionTextController ??= TextEditingController(
      text: safeText(widget.hallazgo?.descripcion),
    );
    _model.txtdescripcionFocusNode ??= FocusNode();

    _model.txtrecomendacionTextController ??= TextEditingController(
      text: safeText(widget.hallazgo?.recomendacion),
    );
    _model.txtrecomendacionFocusNode ??= FocusNode();

    // New text controllers
    _model.txtGerenteResponsableController ??= TextEditingController(text: '');
    _model.txtGerenteResponsableFocusNode ??= FocusNode();
    _model.txtAuditorResponsableController ??= TextEditingController(text: '');
    _model.txtAuditorResponsableFocusNode ??= FocusNode();
    _model.txtDescripcionRiesgoController ??= TextEditingController(text: '');
    _model.txtDescripcionRiesgoFocusNode ??= FocusNode();
    _model.txtCausaRaizController ??= TextEditingController(text: '');
    _model.txtCausaRaizFocusNode ??= FocusNode();

    // Precargar datos del hallazgo si existen
    if (widget.hallazgo != null) {
      // 1. Proceso Propuesto - buscar por idProceso O por nombre (backward compat)
      final procesoPropuestoValue = widget.hallazgo?.procesoPropuesto;
      if (procesoPropuestoValue != null && procesoPropuestoValue.isNotEmpty) {
        final procesoMatch = FFAppState().listaprocesos.where(
          (e) => e.idProceso == procesoPropuestoValue || e.nombre == procesoPropuestoValue,
        ).firstOrNull;
        if (procesoMatch != null) {
          final value = procesoMatch.idProceso.isNotEmpty ? procesoMatch.idProceso : procesoMatch.nombre;
          _model.cmdprocesoValue = value;
          _model.cmdprocesoValueController = FormFieldController<String>(value);
        }
      }

      // 2. Observación - buscar por nombre en todos los títulos
      final observacionValue = widget.hallazgo?.observacion;
      if (observacionValue != null && observacionValue.isNotEmpty) {
        final tituloExists = FFAppState().listatitulos.any((e) => e.nombre == observacionValue);
        if (tituloExists) {
          _model.cmdobservacionValue = observacionValue;
          _model.cmdobservacionValueController = FormFieldController<String>(observacionValue);
        }
      }

      // 3. Gerencia - directo por nombre
      final gerenciaValue = widget.hallazgo?.gerencia;
      if (gerenciaValue != null && gerenciaValue.isNotEmpty) {
        final gerenciaExists = FFAppState().listagenerencia.any((e) => e.nombre == gerenciaValue);
        if (gerenciaExists) {
          _model.cmdgerenciaValue = gerenciaValue;
          _model.cmdgerenciaValueController = FormFieldController<String>(gerenciaValue);
        }
      }

      // 4. Ecosistema - directo por nombre
      final ecosistemaValue = widget.hallazgo?.ecosistema;
      if (ecosistemaValue != null && ecosistemaValue.isNotEmpty) {
        final ecosistemaExists = FFAppState().listaecosistema.any((e) => e.nombre == ecosistemaValue);
        if (ecosistemaExists) {
          _model.cmdecosistemaValue = ecosistemaValue;
          _model.cmdecosistemaValueController = FormFieldController<String>(ecosistemaValue);
        }
      }

      // 5. Nivel Riesgo — usar riskLevelId (UUID) para que coincida con las opciones del dropdown
      final riskLevelIdToRestore = widget.hallazgo!.riskLevelId.isNotEmpty
          ? widget.hallazgo!.riskLevelId
          : null;
      if (riskLevelIdToRestore != null) {
        _model.cmdriesgoValue = riskLevelIdToRestore;
        _model.cmdriesgoValueController = FormFieldController<String>(riskLevelIdToRestore);
      }

      // 6. Fecha - parsear string a DateTime
      if (widget.hallazgo?.fecha != null && widget.hallazgo!.fecha.isNotEmpty) {
        final parsedDate = DateTime.tryParse(widget.hallazgo!.fecha);
        if (parsedDate != null) {
          _model.fecha = parsedDate;
          _model.datePicked = parsedDate;
        }
      }

      // 7. v19 fields pre-population
      if (widget.hallazgo!.publicationStatusId.isNotEmpty) {
        _model.cmdPublicationStatusValue = widget.hallazgo!.publicationStatusId;
      }
      if (widget.hallazgo!.impactTypeId.isNotEmpty) {
        _model.cmdImpactTypeValue = widget.hallazgo!.impactTypeId;
      }
      if (widget.hallazgo!.ecosystemSupportId.isNotEmpty) {
        _model.cmdEcosystemSupportValue = widget.hallazgo!.ecosystemSupportId;
      }
      if (widget.hallazgo!.riskTypeId.isNotEmpty) {
        _model.cmdRiskTypeValue = widget.hallazgo!.riskTypeId;
      }
      if (widget.hallazgo!.riskTypologyId.isNotEmpty) {
        _model.cmdRiskTypologyValue = widget.hallazgo!.riskTypologyId;
      }
      if (widget.hallazgo!.observationScopeId.isNotEmpty) {
        _model.cmdObservationScopeValue = widget.hallazgo!.observationScopeId;
      }
      if (widget.hallazgo!.riskActualLevelId.isNotEmpty) {
        _model.cmdRiskActualLevelValue = widget.hallazgo!.riskActualLevelId;
      }
      if (widget.hallazgo!.gerenteResponsable.isNotEmpty) {
        _model.txtGerenteResponsableController =
            TextEditingController(text: widget.hallazgo!.gerenteResponsable);
      }
      if (widget.hallazgo!.auditorResponsable.isNotEmpty) {
        _model.txtAuditorResponsableController =
            TextEditingController(text: widget.hallazgo!.auditorResponsable);
      }
      if (widget.hallazgo!.descripcionRiesgo.isNotEmpty) {
        _model.txtDescripcionRiesgoController =
            TextEditingController(text: widget.hallazgo!.descripcionRiesgo);
      }
      if (widget.hallazgo!.causaRaiz.isNotEmpty) {
        _model.txtCausaRaizController =
            TextEditingController(text: widget.hallazgo!.causaRaiz);
      }
    }

    // Initialize all dropdown controllers so they are stable across rebuilds
    _model.cmdriesgoValueController ??=
        FormFieldController<String>(_model.cmdriesgoValue);
    _model.cmdPublicationStatusController ??=
        FormFieldController<String>(_model.cmdPublicationStatusValue);
    _model.cmdImpactTypeController ??=
        FormFieldController<String>(_model.cmdImpactTypeValue);
    _model.cmdEcosystemSupportController ??=
        FormFieldController<String>(_model.cmdEcosystemSupportValue);
    _model.cmdRiskTypeController ??=
        FormFieldController<String>(_model.cmdRiskTypeValue);
    _model.cmdRiskTypologyController ??=
        FormFieldController<String>(_model.cmdRiskTypologyValue);
    _model.cmdObservationScopeController ??=
        FormFieldController<String>(_model.cmdObservationScopeValue);
    _model.cmdRiskActualLevelController ??=
        FormFieldController<String>(_model.cmdRiskActualLevelValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeSetState(() {});
      _loadMaestros();
    });
  }

  Future<void> _loadMaestros() async {
    // Cargar desde SQLite primero
    _model.riskLevels = await DBRiskLevel.getAllRiskLevels();
    _model.publicationStatuses = await DBPublicationStatus.getAllPublicationStatuses();
    _model.impactTypes = await DBImpactType.getAllImpactTypes();
    _model.ecosystemSupports = await DBEcosystemSupport.getAllEcosystemSupports();
    _model.riskTypes = await DBRiskType.getAllRiskTypes();
    _model.riskTypologies = await DBRiskTypology.getAllRiskTypologies();
    _model.filteredRiskTypologies = _model.riskTypologies;
    _model.observationScopes = await DBObservationScope.getAllObservationScopes();

    // Si SQLite está vacío, sincronizar desde Supabase y recargar
    final necesitaSync = _model.riskLevels.isEmpty ||
        _model.publicationStatuses.isEmpty ||
        _model.impactTypes.isEmpty ||
        _model.ecosystemSupports.isEmpty ||
        _model.riskTypes.isEmpty ||
        _model.observationScopes.isEmpty;

    if (necesitaSync) {
      print('⚠️ Maestros v19 vacíos en SQLite — sincronizando desde Supabase...');
      try {
        await Future.wait([
          _syncMaestroFromSupabase('RiskLevels', 'risk_level_id',
              (data) => DBRiskLevel.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('PublicationStatuses', 'publication_status_id',
              (data) => DBPublicationStatus.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('ImpactTypes', 'impact_type_id',
              (data) => DBImpactType.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('EcosystemSupports', 'ecosystem_support_id',
              (data) => DBEcosystemSupport.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('RiskTypes', 'risk_type_id',
              (data) => DBRiskType.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('RiskTypologies', 'risk_typology_id',
              (data) => DBRiskTypology.insertBatchFromSupabase(data)),
          _syncMaestroFromSupabase('ObservationScopes', 'observation_scope_id',
              (data) => DBObservationScope.insertBatchFromSupabase(data)),
        ]);
        // Recargar desde SQLite tras sync
        _model.riskLevels = await DBRiskLevel.getAllRiskLevels();
        _model.publicationStatuses = await DBPublicationStatus.getAllPublicationStatuses();
        _model.impactTypes = await DBImpactType.getAllImpactTypes();
        _model.ecosystemSupports = await DBEcosystemSupport.getAllEcosystemSupports();
        _model.riskTypes = await DBRiskType.getAllRiskTypes();
        _model.riskTypologies = await DBRiskTypology.getAllRiskTypologies();
        _model.filteredRiskTypologies = _model.riskTypologies;
        _model.observationScopes = await DBObservationScope.getAllObservationScopes();
        print('✅ Maestros v19 sincronizados: '
            'riskLevels=${_model.riskLevels.length}, '
            'pubStatuses=${_model.publicationStatuses.length}');
      } catch (e) {
        print('⚠️ Error sincronizando maestros v19 desde Supabase: $e');
      }
    }

    // ⭐ Después de cargar los maestros, refrescar los controllers de dropdowns
    // que se pre-popularon en initState (los valores son correctos pero las opciones
    // no existían aún cuando se crearon los controllers).
    if (widget.hallazgo != null) {
      void _refreshController(
        String? value,
        FormFieldController<String>? Function() getter,
        void Function(FormFieldController<String>) setter,
      ) {
        if (value != null && value.isNotEmpty) {
          setter(FormFieldController<String>(value));
        }
      }

      // Si cmdriesgoValue está vacío pero hay nivelRiesgo por nombre, buscar el ID
      if ((_model.cmdriesgoValue == null || _model.cmdriesgoValue!.isEmpty) &&
          widget.hallazgo!.nivelRiesgo.isNotEmpty) {
        final match = _model.riskLevels.where(
          (r) => (r.name ?? '').toUpperCase() == widget.hallazgo!.nivelRiesgo.toUpperCase(),
        ).firstOrNull;
        if (match?.riskLevelId != null && match!.riskLevelId!.isNotEmpty) {
          _model.cmdriesgoValue = match.riskLevelId;
          _model.cmdriesgoValueController = FormFieldController<String>(match.riskLevelId!);
        }
      }
      _refreshController(_model.cmdriesgoValue,
          () => _model.cmdriesgoValueController,
          (c) => _model.cmdriesgoValueController = c);
      _refreshController(_model.cmdPublicationStatusValue,
          () => _model.cmdPublicationStatusController,
          (c) => _model.cmdPublicationStatusController = c);
      _refreshController(_model.cmdImpactTypeValue,
          () => _model.cmdImpactTypeController,
          (c) => _model.cmdImpactTypeController = c);
      _refreshController(_model.cmdEcosystemSupportValue,
          () => _model.cmdEcosystemSupportController,
          (c) => _model.cmdEcosystemSupportController = c);
      _refreshController(_model.cmdRiskTypeValue,
          () => _model.cmdRiskTypeController,
          (c) => _model.cmdRiskTypeController = c);
      _refreshController(_model.cmdRiskTypologyValue,
          () => _model.cmdRiskTypologyController,
          (c) => _model.cmdRiskTypologyController = c);
      _refreshController(_model.cmdObservationScopeValue,
          () => _model.cmdObservationScopeController,
          (c) => _model.cmdObservationScopeController = c);
      _refreshController(_model.cmdRiskActualLevelValue,
          () => _model.cmdRiskActualLevelController,
          (c) => _model.cmdRiskActualLevelController = c);
    }

    if (mounted) safeSetState(() {});
  }

  Future<void> _syncMaestroFromSupabase(
    String supaTable,
    String idField,
    Future<String> Function(List<dynamic>) insertBatch,
  ) async {
    try {
      final response = await SupaFlow.client
          .from(supaTable)
          .select()
          .eq('status', true);
      if ((response as List).isNotEmpty) {
        await insertBatch(response);
        print('📥 $supaTable: ${response.length} registros sincronizados');
      }
    } catch (e) {
      print('⚠️ Error fetch $supaTable: $e');
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Helper: label text style
  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: TextStyle(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            fontSize: 18.0,
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
    );
  }

  // Helper: build a standard searchable dropdown column
  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required List<String> options,
    List<String>? optionLabels,
    required String? currentValue,
    required FormFieldController<String>? controller,
    required void Function(String?) onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: FlutterFlowDropDown<String>(
                controller: controller ?? FormFieldController<String>(currentValue),
                options: options,
                optionLabels: optionLabels,
                onChanged: onChanged,
                height: 50.0,
                searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      font: TextStyle(
                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: TextStyle(
                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: TextStyle(
                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Seleccione',
                searchHintText: 'Buscar...',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: FlutterFlowTheme.of(context).customColor4bbbbb,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                isOverButton: false,
                isSearchable: true,
                isMultiSelect: false,
                maxHeight: 200.0,
              ),
            ),
          ],
        ),
      ].divide(SizedBox(height: 5.0)),
    );
  }

  // Helper: build a standard text field column
  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController? controller,
    FocusNode? focusNode,
    String hintText = 'Escribe aquí',
    int maxLines = 3,
    int minLines = 3,
    bool readOnly = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,
                  readOnly: readOnly,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hintText,
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                          font: TextStyle(
                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).customColor4bbbbb,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).mouseregionTEXT,
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
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: TextStyle(
                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  maxLines: maxLines,
                  minLines: minLines,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                ),
              ),
            ),
          ],
        ),
      ].divide(SizedBox(height: 5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Close button row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                // Title
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'Registrar Hallazgos',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          ),
                          fontSize: 21.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
                // Subtitle
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                    child: Text(
                      'Completa la información del hallazgo detectado',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          ),
                    ),
                  ),
                ),
                // Form
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 17.0, 0.0, 0.0),
                  child: Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // 1. Título Observación
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Título Observación',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: TextStyle(
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model.cmdobservacionValueController ??=
                                              FormFieldController<String>(null),
                                          options: FFAppState().listatitulos.map((e) => e.nombre).toList(),
                                          onChanged: (val) =>
                                              safeSetState(() => _model.cmdobservacionValue = val),
                                          height: 66.61,
                                          searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                font: TextStyle(
                                                  fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                          searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: TextStyle(
                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                              ),
                                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: TextStyle(
                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                              ),
                                          hintText: 'Seleccione',
                                          searchHintText: 'Buscar...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: FlutterFlowTheme.of(context).customColor4bbbbb,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          disabled: false,
                                          isOverButton: false,
                                          isSearchable: true,
                                          isMultiSelect: false,
                                          maxHeight: 200.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 5.0)),
                              ),
                            ),
                          ].divide(SizedBox(width: 15.0)),
                        ),
                        // 2. Descripción/Hallazgo (with microphone)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descripción',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    child: TextFormField(
                                      controller: _model.txtdescripcionTextController,
                                      focusNode: _model.txtdescripcionFocusNode,
                                      autofocus: false,
                                      enabled: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        hintText: 'Escribe tus notas aqui',
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).customColor4bbbbb,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).mouseregionTEXT,
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
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: TextStyle(
                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                      maxLines: 5,
                                      minLines: 5,
                                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model.txtdescripcionTextControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 85.0,
                                  height: 182.0,
                                  decoration: BoxDecoration(),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: custom_widgets.WidgetWritexText(
                                      width: double.infinity,
                                      height: double.infinity,
                                      state: true,
                                      textValue: _model.txtdescripcionTextController.text != null &&
                                              _model.txtdescripcionTextController.text != ''
                                          ? _model.txtdescripcionTextController.text
                                          : null,
                                      action: (txtdota2) async {
                                        safeSetState(() {
                                          _model.txtdescripcionTextController?.text = txtdota2;
                                          _model.txtdescripcionFocusNode?.requestFocus();
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            _model.txtdescripcionTextController?.selection =
                                                TextSelection.collapsed(
                                              offset: _model.txtdescripcionTextController!.text.length,
                                            );
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                        // 3. Gerencia Responsable (ancho completo)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gerencia Responsable',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.cmdgerenciaValueController ??=
                                  FormFieldController<String>(null),
                              options: FFAppState()
                                  .listagenerencia
                                  .map((e) => e.nombre)
                                  .toSet()
                                  .toList(),
                              onChanged: (val) =>
                                  safeSetState(() => _model.cmdgerenciaValue = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                              hintText: 'Seleccione',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              elevation: 2.0,
                              borderColor: FlutterFlowTheme.of(context).customColor4bbbbb,
                              borderWidth: 0.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: true,
                              isMultiSelect: false,
                              maxHeight: 200.0,
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                        // 4. Ecosistema Físico Digital (ancho completo)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ecosistema Físico Digital',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.cmdecosistemaValueController ??=
                                  FormFieldController<String>(null),
                              options: FFAppState()
                                  .listaecosistema
                                  .map((e) => e.nombre)
                                  .toSet()
                                  .toList(),
                              onChanged: (val) =>
                                  safeSetState(() => _model.cmdecosistemaValue = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                              hintText: 'Seleccione',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              elevation: 2.0,
                              borderColor: FlutterFlowTheme.of(context).customColor4bbbbb,
                              borderWidth: 0.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: true,
                              isMultiSelect: false,
                              maxHeight: 200.0,
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                        // 5. Fecha Identificación hallazgo (ancho completo)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha Identificación hallazgo',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final _datePickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: getCurrentTimestamp,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2050),
                                  builder: (context, child) {
                                    return wrapInMaterialDatePickerTheme(
                                      context,
                                      child!,
                                      headerBackgroundColor: FlutterFlowTheme.of(context).primary,
                                      headerForegroundColor: FlutterFlowTheme.of(context).info,
                                      headerTextStyle: FlutterFlowTheme.of(context).headlineLarge.override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                            ),
                                            fontSize: 32.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                          ),
                                      pickerBackgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                      pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
                                      selectedDateTimeBackgroundColor: FlutterFlowTheme.of(context).primary,
                                      selectedDateTimeForegroundColor: FlutterFlowTheme.of(context).info,
                                      actionButtonForegroundColor: FlutterFlowTheme.of(context).primaryText,
                                      iconSize: 24.0,
                                    );
                                  },
                                );
                                if (_datePickedDate != null) {
                                  safeSetState(() {
                                    _model.datePicked = DateTime(
                                      _datePickedDate.year,
                                      _datePickedDate.month,
                                      _datePickedDate.day,
                                    );
                                  });
                                } else if (_model.datePicked != null) {
                                  safeSetState(() {
                                    _model.datePicked = getCurrentTimestamp;
                                  });
                                }
                                _model.fecha = _model.datePicked;
                                safeSetState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(),
                                child: FlutterFlowDropDown<String>(
                                  controller: _model.dropDownValueController ??=
                                      FormFieldController<String>(null),
                                  options: <String>[],
                                  onChanged: (val) =>
                                      safeSetState(() => _model.dropDownValue = val),
                                  width: double.infinity,
                                  height: 50.0,
                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: TextStyle(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                  hintText: valueOrDefault<String>(
                                    _model.fecha != null
                                        ? dateTimeFormat(
                                            "d/M/y",
                                            _model.fecha,
                                            locale: FFLocalizations.of(context).languageCode,
                                          )
                                        : 'Seleccione fecha',
                                    'Seleccione fecha',
                                  ),
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  elevation: 2.0,
                                  borderColor: FlutterFlowTheme.of(context).customColor4bbbbb,
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  disabled: true,
                                  isOverButton: false,
                                  isSearchable: true,
                                  isMultiSelect: false,
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                        // 6. Nivel de Riesgo (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Nivel de Riesgo',
                          options: _model.riskLevels.map((r) => r.riskLevelId ?? '').toList(),
                          optionLabels: _model.riskLevels.map((r) => r.name ?? '').toList(),
                          currentValue: _model.cmdriesgoValue,
                          controller: _model.cmdriesgoValueController,
                          onChanged: (val) => safeSetState(() => _model.cmdriesgoValue = val),
                        ),
                        // 7. Estado de Publicación (Publicado/a) (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Estado de Publicación',
                          options: _model.publicationStatuses.map((s) => s.publicationStatusId ?? '').toList(),
                          optionLabels: _model.publicationStatuses.map((s) => s.name ?? '').toList(),
                          currentValue: _model.cmdPublicationStatusValue,
                          controller: _model.cmdPublicationStatusController,
                          onChanged: (val) => safeSetState(() => _model.cmdPublicationStatusValue = val),
                        ),
                        // 8. Recomendaciones (ancho completo)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recomendación',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: TextStyle(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    child: TextFormField(
                                      controller: _model.txtrecomendacionTextController,
                                      focusNode: _model.txtrecomendacionFocusNode,
                                      autofocus: false,
                                      enabled: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        hintText: 'Escribe tus notas aqui',
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: TextStyle(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).customColor4bbbbb,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).mouseregionTEXT,
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
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: TextStyle(
                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                      maxLines: 5,
                                      minLines: 5,
                                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model.txtrecomendacionTextControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                        // 9. Tipo de Impacto (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Tipo de Impacto',
                          options: _model.impactTypes.map((t) => t.impactTypeId ?? '').toList(),
                          optionLabels: _model.impactTypes.map((t) => t.name ?? '').toList(),
                          currentValue: _model.cmdImpactTypeValue,
                          controller: _model.cmdImpactTypeController,
                          onChanged: (val) => safeSetState(() => _model.cmdImpactTypeValue = val),
                        ),
                        // 10. Soporte al Ecosistema (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Soporte al Ecosistema',
                          options: _model.ecosystemSupports.map((e) => e.ecosystemSupportId ?? '').toList(),
                          optionLabels: _model.ecosystemSupports.map((e) => e.name ?? '').toList(),
                          currentValue: _model.cmdEcosystemSupportValue,
                          controller: _model.cmdEcosystemSupportController,
                          onChanged: (val) => safeSetState(() => _model.cmdEcosystemSupportValue = val),
                        ),
                        // 11. Tipo de Riesgo (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Tipo de Riesgo',
                          options: _model.riskTypes.map((t) => t.riskTypeId ?? '').toList(),
                          optionLabels: _model.riskTypes.map((t) => t.name ?? '').toList(),
                          currentValue: _model.cmdRiskTypeValue,
                          controller: _model.cmdRiskTypeController,
                          onChanged: (val) {
                            safeSetState(() {
                              _model.cmdRiskTypeValue = val;
                              final filtered = _model.riskTypologies
                                  .where((t) => t.riskTypeId == val)
                                  .toList();
                              // Si no hay tipologías con ese riskTypeId, mostrar todas
                              _model.filteredRiskTypologies = filtered.isNotEmpty ? filtered : _model.riskTypologies;
                              _model.cmdRiskTypologyValue = null;
                              _model.cmdRiskTypologyController = FormFieldController<String>(null);
                            });
                          },
                        ),
                        // 12. Tipología de Riesgo (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Tipología de Riesgo',
                          options: _model.filteredRiskTypologies.map((t) => t.riskTypologyId ?? '').toList(),
                          optionLabels: _model.filteredRiskTypologies.map((t) => t.name ?? '').toList(),
                          currentValue: _model.cmdRiskTypologyValue,
                          controller: _model.cmdRiskTypologyController,
                          onChanged: (val) => safeSetState(() => _model.cmdRiskTypologyValue = val),
                        ),
                        // 13. Alcance de Observación (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Alcance de Observación',
                          options: _model.observationScopes.map((s) => s.observationScopeId ?? '').toList(),
                          optionLabels: _model.observationScopes.map((s) => s.name ?? '').toList(),
                          currentValue: _model.cmdObservationScopeValue,
                          controller: _model.cmdObservationScopeController,
                          onChanged: (val) => safeSetState(() => _model.cmdObservationScopeValue = val),
                        ),
                        // 14. Riesgo Actual (ancho completo)
                        _buildDropdownField(
                          context: context,
                          label: 'Riesgo Actual',
                          options: _model.riskLevels.map((r) => r.riskLevelId ?? '').toList(),
                          optionLabels: _model.riskLevels.map((r) => r.name ?? '').toList(),
                          currentValue: _model.cmdRiskActualLevelValue,
                          controller: _model.cmdRiskActualLevelController,
                          onChanged: (val) => safeSetState(() => _model.cmdRiskActualLevelValue = val),
                        ),
                        // 15. Gerente Responsable (ancho completo)
                        _buildTextField(
                          context: context,
                          label: 'Gerente Responsable',
                          controller: _model.txtGerenteResponsableController,
                          focusNode: _model.txtGerenteResponsableFocusNode,
                          hintText: 'Escribe aquí',
                          maxLines: 1,
                          minLines: 1,
                        ),
                        // 16. Auditor Responsable (ancho completo)
                        _buildTextField(
                          context: context,
                          label: 'Auditor Responsable',
                          controller: _model.txtAuditorResponsableController,
                          focusNode: _model.txtAuditorResponsableFocusNode,
                          hintText: 'Escribe aquí',
                          maxLines: 1,
                          minLines: 1,
                        ),
                        // 17. Descripción del Riesgo (ancho completo)
                        _buildTextField(
                          context: context,
                          label: 'Descripción del Riesgo',
                          controller: _model.txtDescripcionRiesgoController,
                          focusNode: _model.txtDescripcionRiesgoFocusNode,
                          hintText: 'Escribe aquí',
                          maxLines: 3,
                          minLines: 3,
                        ),
                        // 18. Causa Raíz (ancho completo)
                        _buildTextField(
                          context: context,
                          label: 'Causa Raíz',
                          controller: _model.txtCausaRaizController,
                          focusNode: _model.txtCausaRaizFocusNode,
                          hintText: 'Escribe aquí',
                          maxLines: 3,
                          minLines: 3,
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ),
                ),
                // Guardar Hallazgo button
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            await widget.createHallazgo?.call(
                              _model.cmdobservacionValue ?? '',
                              _model.cmdgerenciaValue ?? '',
                              _model.cmdecosistemaValue,
                              _model.fecha?.toIso8601String().split('T')[0],
                              _model.txtdescripcionTextController?.text ?? '',
                              _model.txtrecomendacionTextController?.text,
                              FFAppState()
                                  .listaprocesos
                                  .where((e) => _model.cmdprocesoValue == e.idProceso)
                                  .firstOrNull
                                  ?.nombre,
                              _model.cmdobservacionValue,
                              _model.riskLevels
                                      .where((r) => r.riskLevelId == _model.cmdriesgoValue)
                                      .firstOrNull
                                      ?.name ??
                                  _model.cmdriesgoValue,
                              _model.cmdriesgoValue,
                              _model.cmdPublicationStatusValue,
                              _model.publicationStatuses
                                  .where((s) => s.publicationStatusId == _model.cmdPublicationStatusValue)
                                  .firstOrNull
                                  ?.name,
                              _model.cmdImpactTypeValue,
                              _model.impactTypes
                                  .where((t) => t.impactTypeId == _model.cmdImpactTypeValue)
                                  .firstOrNull
                                  ?.name,
                              _model.cmdEcosystemSupportValue,
                              _model.ecosystemSupports
                                  .where((e) => e.ecosystemSupportId == _model.cmdEcosystemSupportValue)
                                  .firstOrNull
                                  ?.name,
                              _model.cmdRiskTypeValue,
                              _model.riskTypes
                                  .where((t) => t.riskTypeId == _model.cmdRiskTypeValue)
                                  .firstOrNull
                                  ?.name,
                              _model.cmdRiskTypologyValue,
                              _model.filteredRiskTypologies
                                  .where((t) => t.riskTypologyId == _model.cmdRiskTypologyValue)
                                  .firstOrNull
                                  ?.name,
                              _model.txtGerenteResponsableController?.text,
                              _model.txtAuditorResponsableController?.text,
                              _model.txtDescripcionRiesgoController?.text,
                              _model.cmdObservationScopeValue,
                              _model.observationScopes
                                  .where((s) => s.observationScopeId == _model.cmdObservationScopeValue)
                                  .firstOrNull
                                  ?.name,
                              _model.cmdRiskActualLevelValue,
                              _model.riskLevels
                                  .where((r) => r.riskLevelId == _model.cmdRiskActualLevelValue)
                                  .firstOrNull
                                  ?.name,
                              _model.txtCausaRaizController?.text,
                            );
                            Navigator.pop(context);
                          },
                          text: 'Guardar Hallazgo',
                          options: FFButtonOptions(
                            height: 47.8,
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).completada,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  font: TextStyle(
                                    fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).completada,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
