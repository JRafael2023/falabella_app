import '../database.dart';

class ControlsTable extends SupabaseTable<ControlsRow> {
  @override
  String get tableName => 'Controls';

  @override
  ControlsRow createRow(Map<String, dynamic> data) => ControlsRow(data);
}

class ControlsRow extends SupabaseDataRow {
  ControlsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ControlsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get findingStatus => getField<int>('finding_status');
  set findingStatus(int? value) => setField<int>('finding_status', value);

  dynamic? get photos => getField<dynamic>('photos');
  set photos(dynamic? value) => setField<dynamic>('photos', value);

  dynamic? get video => getField<dynamic>('video');
  set video(dynamic? value) => setField<dynamic>('video', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  String? get walkthroughId => getField<String>('walkthrough_id');
  set walkthroughId(String? value) => setField<String>('walkthrough_id', value);

  String? get idControl => getField<String>('id_control');
  set idControl(String? value) => setField<String>('id_control', value);

  bool? get completed => getField<bool>('completed');
  set completed(bool? value) => setField<bool>('completed', value);

  String? get idObjective => getField<String>('id_objective');
  set idObjective(String? value) => setField<String>('id_objective', value);

  dynamic? get archives => getField<dynamic>('archives');
  set archives(dynamic? value) => setField<dynamic>('archives', value);

  String? get observacion => getField<String>('observacion');
  set observacion(String? value) => setField<String>('observacion', value);

  String? get gerencia => getField<String>('gerencia');
  set gerencia(String? value) => setField<String>('gerencia', value);

  String? get ecosistema => getField<String>('ecosistema');
  set ecosistema(String? value) => setField<String>('ecosistema', value);

  String? get fecha => getField<String>('fecha');
  set fecha(String? value) => setField<String>('fecha', value);

  String? get descripcionHallazgo => getField<String>('descripcion_hallazgo');
  set descripcionHallazgo(String? value) =>
      setField<String>('descripcion_hallazgo', value);

  String? get recomendacion => getField<String>('recomendacion');
  set recomendacion(String? value) => setField<String>('recomendacion', value);

  String? get procesoPropuesto => getField<String>('proceso_propuesto');
  set procesoPropuesto(String? value) =>
      setField<String>('proceso_propuesto', value);

  String? get titulo => getField<String>('titulo');
  set titulo(String? value) => setField<String>('titulo', value);

  String? get nivelRiesgo => getField<String>('nivel_riesgo');
  set nivelRiesgo(String? value) => setField<String>('nivel_riesgo', value);

  String? get controlText => getField<String>('control_text');
  set controlText(String? value) => setField<String>('control_text', value);

  // ⭐ v19 campos adicionales del hallazgo
  String? get tituloObservacion => getField<String>('titulo_observacion');
  set tituloObservacion(String? value) => setField<String>('titulo_observacion', value);

  String? get riskLevelId => getField<String>('risk_level_id');
  set riskLevelId(String? value) => setField<String>('risk_level_id', value);

  String? get publicationStatusId => getField<String>('publication_status_id');
  set publicationStatusId(String? value) => setField<String>('publication_status_id', value);

  String? get estadoPublicacion => getField<String>('estado_publicacion');
  set estadoPublicacion(String? value) => setField<String>('estado_publicacion', value);

  String? get impactTypeId => getField<String>('impact_type_id');
  set impactTypeId(String? value) => setField<String>('impact_type_id', value);

  String? get tipoImpacto => getField<String>('tipo_impacto');
  set tipoImpacto(String? value) => setField<String>('tipo_impacto', value);

  String? get ecosystemSupportId => getField<String>('ecosystem_support_id');
  set ecosystemSupportId(String? value) => setField<String>('ecosystem_support_id', value);

  String? get soporteEcosistema => getField<String>('soporte_ecosistema');
  set soporteEcosistema(String? value) => setField<String>('soporte_ecosistema', value);

  String? get riskTypeId => getField<String>('risk_type_id');
  set riskTypeId(String? value) => setField<String>('risk_type_id', value);

  String? get tipoRiesgo => getField<String>('tipo_riesgo');
  set tipoRiesgo(String? value) => setField<String>('tipo_riesgo', value);

  String? get riskTypologyId => getField<String>('risk_typology_id');
  set riskTypologyId(String? value) => setField<String>('risk_typology_id', value);

  String? get tipologiaRiesgo => getField<String>('tipologia_riesgo');
  set tipologiaRiesgo(String? value) => setField<String>('tipologia_riesgo', value);

  String? get gerenteResponsable => getField<String>('gerente_responsable');
  set gerenteResponsable(String? value) => setField<String>('gerente_responsable', value);

  String? get auditorResponsable => getField<String>('auditor_responsable');
  set auditorResponsable(String? value) => setField<String>('auditor_responsable', value);

  String? get descripcionRiesgo => getField<String>('descripcion_riesgo');
  set descripcionRiesgo(String? value) => setField<String>('descripcion_riesgo', value);

  String? get observationScopeId => getField<String>('observation_scope_id');
  set observationScopeId(String? value) => setField<String>('observation_scope_id', value);

  String? get alcanceObservacion => getField<String>('alcance_observacion');
  set alcanceObservacion(String? value) => setField<String>('alcance_observacion', value);

  String? get riskActualLevelId => getField<String>('risk_actual_level_id');
  set riskActualLevelId(String? value) => setField<String>('risk_actual_level_id', value);

  String? get riesgoActual => getField<String>('riesgo_actual');
  set riesgoActual(String? value) => setField<String>('riesgo_actual', value);

  String? get causaRaiz => getField<String>('causa_raiz');
  set causaRaiz(String? value) => setField<String>('causa_raiz', value);
}
