class Control {
  int? id;
  String idControl;
  String title;
  String description;
  String? photos;
  String? video;
  String? archives;
  int? findingStatus;
  String objectiveId;
  String? titleId;
  String? walkthroughId;
  int sincronizadoNube;
  int sincronizadoLocal;
  String createdAt;
  String updatedAt;
  bool status;
  bool completed;

  String? observacion;
  String? gerencia;
  String? ecosistema;
  String? fecha;
  String? descripcionHallazgo;
  String? recomendacion;
  String? procesoPropuesto;
  String? titulo;
  String? nivelRiesgo;
  String? controlText;

  String? tituloObservacion;
  String? riskLevelId;
  String? publicationStatusId;
  String? estadoPublicacion;
  String? impactTypeId;
  String? tipoImpacto;
  String? ecosystemSupportId;
  String? soporteEcosistema;
  String? riskTypeId;
  String? tipoRiesgo;
  String? riskTypologyId;
  String? tipologiaRiesgo;
  String? gerenteResponsable;
  String? auditorResponsable;
  String? descripcionRiesgo;
  String? observationScopeId;
  String? alcanceObservacion;
  String? riskActualLevelId;
  String? riesgoActual;
  String? causaRaiz;

  static const String separator = '|||';

  Control({
    this.id,
    required this.idControl,
    required this.title,
    this.description = "",
    this.photos,
    this.video,
    this.archives,
    this.findingStatus,
    required this.objectiveId,
    this.titleId,
    this.walkthroughId,
    this.sincronizadoNube = 1,
    this.sincronizadoLocal = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.status = true,
    this.completed = false,
    this.observacion,
    this.gerencia,
    this.ecosistema,
    this.fecha,
    this.descripcionHallazgo,
    this.recomendacion,
    this.procesoPropuesto,
    this.titulo,
    this.nivelRiesgo,
    this.controlText,
    this.tituloObservacion,
    this.riskLevelId,
    this.publicationStatusId,
    this.estadoPublicacion,
    this.impactTypeId,
    this.tipoImpacto,
    this.ecosystemSupportId,
    this.soporteEcosistema,
    this.riskTypeId,
    this.tipoRiesgo,
    this.riskTypologyId,
    this.tipologiaRiesgo,
    this.gerenteResponsable,
    this.auditorResponsable,
    this.descripcionRiesgo,
    this.observationScopeId,
    this.alcanceObservacion,
    this.riskActualLevelId,
    this.riesgoActual,
    this.causaRaiz,
  });


  List<String> getPhotosList() {
    return (photos ?? '').split(separator).where((s) => s.isNotEmpty).toList();
  }

  void setPhotosList(List<String> list) {
    photos = list.isEmpty ? null : list.join(separator);
  }

  void addPhoto(String photoBase64) {
    List<String> list = getPhotosList();
    list.add(photoBase64);
    setPhotosList(list);
  }

  List<String> getVideosList() {
    return (video ?? '').split(separator).where((s) => s.isNotEmpty).toList();
  }

  void setVideosList(List<String> list) {
    video = list.isEmpty ? null : list.join(separator);
  }

  void addVideo(String videoBase64) {
    List<String> list = getVideosList();
    list.add(videoBase64);
    setVideosList(list);
  }

  List<String> getArchivesList() {
    return (archives ?? '')
        .split(separator)
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void setArchivesList(List<String> list) {
    archives = list.isEmpty ? null : list.join(separator);
  }

  void addArchive(String archiveBase64) {
    List<String> list = getArchivesList();
    list.add(archiveBase64);
    setArchivesList(list);
  }


  Map<String, dynamic> toMap() {
    return {
      'id_control': idControl,
      'title': title,
      'description': description,
      'photos': (photos?.isNotEmpty ?? false) ? photos : null,
      'video': (video?.isNotEmpty ?? false) ? video : null,
      'archives': (archives?.isNotEmpty ?? false) ? archives : null,
      'finding_status': findingStatus,
      'objective_id': objectiveId,
      'title_id': titleId,
      'walkthrough_id': walkthroughId,
      'sincronizadoNube': sincronizadoNube,
      'sincronizadoLocal': sincronizadoLocal,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status ? 1 : 0,
      'completed': completed ? 1 : 0,
      'observacion': (observacion?.isNotEmpty ?? false) ? observacion : null,
      'gerencia': (gerencia?.isNotEmpty ?? false) ? gerencia : null,
      'ecosistema': (ecosistema?.isNotEmpty ?? false) ? ecosistema : null,
      'fecha': (fecha?.isNotEmpty ?? false) ? fecha : null,
      'descripcion_hallazgo': (descripcionHallazgo?.isNotEmpty ?? false)
          ? descripcionHallazgo
          : null,
      'recomendacion':
          (recomendacion?.isNotEmpty ?? false) ? recomendacion : null,
      'proceso_propuesto':
          (procesoPropuesto?.isNotEmpty ?? false) ? procesoPropuesto : null,
      'titulo': (titulo?.isNotEmpty ?? false) ? titulo : null,
      'nivel_riesgo': (nivelRiesgo?.isNotEmpty ?? false) ? nivelRiesgo : null,
      'control_text': (controlText?.isNotEmpty ?? false) ? controlText : null,
      'titulo_observacion': (tituloObservacion?.isNotEmpty ?? false) ? tituloObservacion : null,
      'risk_level_id': (riskLevelId?.isNotEmpty ?? false) ? riskLevelId : null,
      'publication_status_id': (publicationStatusId?.isNotEmpty ?? false) ? publicationStatusId : null,
      'estado_publicacion': (estadoPublicacion?.isNotEmpty ?? false) ? estadoPublicacion : null,
      'impact_type_id': (impactTypeId?.isNotEmpty ?? false) ? impactTypeId : null,
      'tipo_impacto': (tipoImpacto?.isNotEmpty ?? false) ? tipoImpacto : null,
      'ecosystem_support_id': (ecosystemSupportId?.isNotEmpty ?? false) ? ecosystemSupportId : null,
      'soporte_ecosistema': (soporteEcosistema?.isNotEmpty ?? false) ? soporteEcosistema : null,
      'risk_type_id': (riskTypeId?.isNotEmpty ?? false) ? riskTypeId : null,
      'tipo_riesgo': (tipoRiesgo?.isNotEmpty ?? false) ? tipoRiesgo : null,
      'risk_typology_id': (riskTypologyId?.isNotEmpty ?? false) ? riskTypologyId : null,
      'tipologia_riesgo': (tipologiaRiesgo?.isNotEmpty ?? false) ? tipologiaRiesgo : null,
      'gerente_responsable': (gerenteResponsable?.isNotEmpty ?? false) ? gerenteResponsable : null,
      'auditor_responsable': (auditorResponsable?.isNotEmpty ?? false) ? auditorResponsable : null,
      'descripcion_riesgo': (descripcionRiesgo?.isNotEmpty ?? false) ? descripcionRiesgo : null,
      'observation_scope_id': (observationScopeId?.isNotEmpty ?? false) ? observationScopeId : null,
      'alcance_observacion': (alcanceObservacion?.isNotEmpty ?? false) ? alcanceObservacion : null,
      'risk_actual_level_id': (riskActualLevelId?.isNotEmpty ?? false) ? riskActualLevelId : null,
      'riesgo_actual': (riesgoActual?.isNotEmpty ?? false) ? riesgoActual : null,
      'causa_raiz': (causaRaiz?.isNotEmpty ?? false) ? causaRaiz : null,
    };
  }

  factory Control.fromMap(Map<String, dynamic> map) {
    String? _limpiarNull(dynamic valor) {
      if (valor == null || valor == 'null' || (valor is String && valor.trim().isEmpty)) {
        return null;
      }
      return valor.toString();
    }

    return Control(
      id: map['id'],
      idControl: map['id_control'],
      title: map['title'],
      description: map['description'] ?? '',
      photos: _limpiarNull(map['photos']),
      video: _limpiarNull(map['video']),
      archives: _limpiarNull(map['archives']),
      findingStatus: map['finding_status'],
      objectiveId: map['objective_id'],
      titleId: map['title_id'],
      walkthroughId: map['walkthrough_id'],
      sincronizadoNube: map['sincronizadoNube'] ?? 1,
      sincronizadoLocal: map['sincronizadoLocal'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      status: map['status'] == 1,
      completed: map['completed'] == 1,
      observacion: _limpiarNull(map['observacion']),
      gerencia: _limpiarNull(map['gerencia']),
      ecosistema: _limpiarNull(map['ecosistema']),
      fecha: _limpiarNull(map['fecha']),
      descripcionHallazgo: _limpiarNull(map['descripcion_hallazgo']),
      recomendacion: _limpiarNull(map['recomendacion']),
      procesoPropuesto: _limpiarNull(map['proceso_propuesto']),
      titulo: _limpiarNull(map['titulo']),
      nivelRiesgo: _limpiarNull(map['nivel_riesgo']),
      controlText: _limpiarNull(map['control_text']),
      tituloObservacion: _limpiarNull(map['titulo_observacion']),
      riskLevelId: _limpiarNull(map['risk_level_id']),
      publicationStatusId: _limpiarNull(map['publication_status_id']),
      estadoPublicacion: _limpiarNull(map['estado_publicacion']),
      impactTypeId: _limpiarNull(map['impact_type_id']),
      tipoImpacto: _limpiarNull(map['tipo_impacto']),
      ecosystemSupportId: _limpiarNull(map['ecosystem_support_id']),
      soporteEcosistema: _limpiarNull(map['soporte_ecosistema']),
      riskTypeId: _limpiarNull(map['risk_type_id']),
      tipoRiesgo: _limpiarNull(map['tipo_riesgo']),
      riskTypologyId: _limpiarNull(map['risk_typology_id']),
      tipologiaRiesgo: _limpiarNull(map['tipologia_riesgo']),
      gerenteResponsable: _limpiarNull(map['gerente_responsable']),
      auditorResponsable: _limpiarNull(map['auditor_responsable']),
      descripcionRiesgo: _limpiarNull(map['descripcion_riesgo']),
      observationScopeId: _limpiarNull(map['observation_scope_id']),
      alcanceObservacion: _limpiarNull(map['alcance_observacion']),
      riskActualLevelId: _limpiarNull(map['risk_actual_level_id']),
      riesgoActual: _limpiarNull(map['riesgo_actual']),
      causaRaiz: _limpiarNull(map['causa_raiz']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_control': idControl,
      'title': title,
      'description': description,
      'photos': (photos?.isNotEmpty ?? false) ? photos : null,
      'video': (video?.isNotEmpty ?? false) ? video : null,
      'archives': (archives?.isNotEmpty ?? false) ? archives : null,
      'finding_status': findingStatus,
      'id_objective': objectiveId,
      'walkthrough_id': walkthroughId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'completed': completed,
      'observacion': (observacion?.isNotEmpty ?? false) ? observacion : null,
      'gerencia': (gerencia?.isNotEmpty ?? false) ? gerencia : null,
      'ecosistema': (ecosistema?.isNotEmpty ?? false) ? ecosistema : null,
      'fecha': (fecha?.isNotEmpty ?? false) ? fecha : null,
      'descripcion_hallazgo': (descripcionHallazgo?.isNotEmpty ?? false)
          ? descripcionHallazgo
          : null,
      'recomendacion':
          (recomendacion?.isNotEmpty ?? false) ? recomendacion : null,
      'proceso_propuesto':
          (procesoPropuesto?.isNotEmpty ?? false) ? procesoPropuesto : null,
      'titulo': (titulo?.isNotEmpty ?? false) ? titulo : null,
      'nivel_riesgo': (nivelRiesgo?.isNotEmpty ?? false) ? nivelRiesgo : null,
      'control_text': (controlText?.isNotEmpty ?? false) ? controlText : null,
      'titulo_observacion': (tituloObservacion?.isNotEmpty ?? false) ? tituloObservacion : null,
      'risk_level_id': (riskLevelId?.isNotEmpty ?? false) ? riskLevelId : null,
      'publication_status_id': (publicationStatusId?.isNotEmpty ?? false) ? publicationStatusId : null,
      'estado_publicacion': (estadoPublicacion?.isNotEmpty ?? false) ? estadoPublicacion : null,
      'impact_type_id': (impactTypeId?.isNotEmpty ?? false) ? impactTypeId : null,
      'tipo_impacto': (tipoImpacto?.isNotEmpty ?? false) ? tipoImpacto : null,
      'ecosystem_support_id': (ecosystemSupportId?.isNotEmpty ?? false) ? ecosystemSupportId : null,
      'soporte_ecosistema': (soporteEcosistema?.isNotEmpty ?? false) ? soporteEcosistema : null,
      'risk_type_id': (riskTypeId?.isNotEmpty ?? false) ? riskTypeId : null,
      'tipo_riesgo': (tipoRiesgo?.isNotEmpty ?? false) ? tipoRiesgo : null,
      'risk_typology_id': (riskTypologyId?.isNotEmpty ?? false) ? riskTypologyId : null,
      'tipologia_riesgo': (tipologiaRiesgo?.isNotEmpty ?? false) ? tipologiaRiesgo : null,
      'gerente_responsable': (gerenteResponsable?.isNotEmpty ?? false) ? gerenteResponsable : null,
      'auditor_responsable': (auditorResponsable?.isNotEmpty ?? false) ? auditorResponsable : null,
      'descripcion_riesgo': (descripcionRiesgo?.isNotEmpty ?? false) ? descripcionRiesgo : null,
      'observation_scope_id': (observationScopeId?.isNotEmpty ?? false) ? observationScopeId : null,
      'alcance_observacion': (alcanceObservacion?.isNotEmpty ?? false) ? alcanceObservacion : null,
      'risk_actual_level_id': (riskActualLevelId?.isNotEmpty ?? false) ? riskActualLevelId : null,
      'riesgo_actual': (riesgoActual?.isNotEmpty ?? false) ? riesgoActual : null,
      'causa_raiz': (causaRaiz?.isNotEmpty ?? false) ? causaRaiz : null,
    };
  }

  factory Control.fromHighBondJson(Map<String, dynamic> json) {
    final fecha = DateTime.now().toIso8601String();

    String objectiveId = '';
    if (json['relationships']?['objective']?['data']?['id'] != null) {
      objectiveId = json['relationships']['objective']['data']['id'].toString();
    }

    String? walkthroughId;
    if (json['relationships']?['walkthrough']?['data']?['id'] != null) {
      walkthroughId =
          json['relationships']['walkthrough']['data']['id'].toString();
    }

    return Control(
      idControl: json['id']?.toString() ?? '',
      title: json['attributes']?['title'] ?? '',
      description: json['attributes']?['description'] ?? '',
      photos: null,
      video: null,
      archives: null,
      findingStatus: null,
      objectiveId: objectiveId,
      titleId: null,
      walkthroughId: walkthroughId,
      sincronizadoNube: 1,
      sincronizadoLocal: 0,
      createdAt: json['attributes']?['created_at'] ?? fecha,
      updatedAt: json['attributes']?['updated_at'] ?? fecha,
      status: true,
      completed: false,
      observacion: null,
      gerencia: null,
      ecosistema: null,
      fecha: null,
      descripcionHallazgo: null,
      recomendacion: null,
      procesoPropuesto: null,
      titulo: null,
      nivelRiesgo: null,
      controlText: null,
    );
  }

  factory Control.fromSupabase(Map<String, dynamic> data) {
    return Control(
      idControl: data['id_control'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      photos: data['photos']?.toString(),
      video: data['video']?.toString(),
      archives: data['archives']?.toString(),
      findingStatus: data['finding_status'],
      objectiveId: data['id_objective'],
      titleId: null,
      walkthroughId: data['walkthrough_id'],
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
      status: data['status'] ?? true,
      completed: data['completed'] ?? false,
      observacion: data['observacion'],
      gerencia: data['gerencia'],
      ecosistema: data['ecosistema'],
      fecha: data['fecha'],
      descripcionHallazgo: data['descripcion_hallazgo'],
      recomendacion: data['recomendacion'],
      procesoPropuesto: data['proceso_propuesto'],
      titulo: data['titulo'],
      nivelRiesgo: data['nivel_riesgo'],
      controlText: data['control_text'],
      tituloObservacion: data['titulo_observacion'],
      riskLevelId: data['risk_level_id'],
      publicationStatusId: data['publication_status_id'],
      estadoPublicacion: data['estado_publicacion'],
      impactTypeId: data['impact_type_id'],
      tipoImpacto: data['tipo_impacto'],
      ecosystemSupportId: data['ecosystem_support_id'],
      soporteEcosistema: data['soporte_ecosistema'],
      riskTypeId: data['risk_type_id'],
      tipoRiesgo: data['tipo_riesgo'],
      riskTypologyId: data['risk_typology_id'],
      tipologiaRiesgo: data['tipologia_riesgo'],
      gerenteResponsable: data['gerente_responsable'],
      auditorResponsable: data['auditor_responsable'],
      descripcionRiesgo: data['descripcion_riesgo'],
      observationScopeId: data['observation_scope_id'],
      alcanceObservacion: data['alcance_observacion'],
      riskActualLevelId: data['risk_actual_level_id'],
      riesgoActual: data['riesgo_actual'],
      causaRaiz: data['causa_raiz'],
    );
  }

  static List<Control> convercionListControles(List<dynamic> data) {
    return data.map<Control>((item) {
      return Control.fromHighBondJson(item);
    }).toList();
  }
}
