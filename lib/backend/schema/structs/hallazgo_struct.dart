
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HallazgoStruct extends BaseStruct {
  HallazgoStruct({
    String? titulo,
    String? gerencia,
    String? ecosistema,
    String? fecha,
    String? nivelriesgo,
    String? descripcion,
    String? recomendacion,
    String? procesoPropuesto,
    String? observacion,
    String? tituloHallazgo,
    String? nivelRiesgo,
    String? riskLevelId, // UUID del nivel de riesgo (para dropdown)
    String? publicationStatusId,
    String? impactTypeId,
    String? ecosystemSupportId,
    String? riskTypeId,
    String? riskTypologyId,
    String? observationScopeId,
    String? riskActualLevelId,
    String? gerenteResponsable,
    String? auditorResponsable,
    String? descripcionRiesgo,
    String? causaRaiz,
  })  : _titulo = titulo,
        _gerencia = gerencia,
        _ecosistema = ecosistema,
        _fecha = fecha,
        _nivelriesgo = nivelriesgo,
        _descripcion = descripcion,
        _recomendacion = recomendacion,
        _procesoPropuesto = procesoPropuesto,
        _observacion = observacion,
        _tituloHallazgo = tituloHallazgo,
        _nivelRiesgo = nivelRiesgo,
        _riskLevelId = riskLevelId,
        _publicationStatusId = publicationStatusId,
        _impactTypeId = impactTypeId,
        _ecosystemSupportId = ecosystemSupportId,
        _riskTypeId = riskTypeId,
        _riskTypologyId = riskTypologyId,
        _observationScopeId = observationScopeId,
        _riskActualLevelId = riskActualLevelId,
        _gerenteResponsable = gerenteResponsable,
        _auditorResponsable = auditorResponsable,
        _descripcionRiesgo = descripcionRiesgo,
        _causaRaiz = causaRaiz;

  String? _titulo;
  String get titulo => _titulo ?? '';
  set titulo(String? val) => _titulo = val;

  bool hasTitulo() => _titulo != null;

  String? _gerencia;
  String get gerencia => _gerencia ?? '';
  set gerencia(String? val) => _gerencia = val;

  bool hasGerencia() => _gerencia != null;

  String? _ecosistema;
  String get ecosistema => _ecosistema ?? '';
  set ecosistema(String? val) => _ecosistema = val;

  bool hasEcosistema() => _ecosistema != null;

  String? _fecha;
  String get fecha => _fecha ?? '';
  set fecha(String? val) => _fecha = val;

  bool hasFecha() => _fecha != null;

  String? _nivelriesgo;
  String get nivelriesgo => _nivelriesgo ?? '';
  set nivelriesgo(String? val) => _nivelriesgo = val;

  bool hasNivelriesgo() => _nivelriesgo != null;

  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  set descripcion(String? val) => _descripcion = val;

  bool hasDescripcion() => _descripcion != null;

  String? _recomendacion;
  String get recomendacion => _recomendacion ?? '';
  set recomendacion(String? val) => _recomendacion = val;

  bool hasRecomendacion() => _recomendacion != null;

  String? _procesoPropuesto;
  String get procesoPropuesto => _procesoPropuesto ?? '';
  set procesoPropuesto(String? val) => _procesoPropuesto = val;

  bool hasProcesoPropuesto() => _procesoPropuesto != null;

  String? _observacion;
  String get observacion => _observacion ?? '';
  set observacion(String? val) => _observacion = val;

  bool hasObservacion() => _observacion != null;

  String? _tituloHallazgo;
  String get tituloHallazgo => _tituloHallazgo ?? '';
  set tituloHallazgo(String? val) => _tituloHallazgo = val;

  bool hasTituloHallazgo() => _tituloHallazgo != null;

  String? _nivelRiesgo;
  String get nivelRiesgo => _nivelRiesgo ?? '';
  set nivelRiesgo(String? val) => _nivelRiesgo = val;

  bool hasNivelRiesgo() => _nivelRiesgo != null;

  String? _riskLevelId;
  String get riskLevelId => _riskLevelId ?? '';
  set riskLevelId(String? val) => _riskLevelId = val;

  bool hasRiskLevelId() => _riskLevelId != null;

  String? _publicationStatusId;
  String get publicationStatusId => _publicationStatusId ?? '';
  set publicationStatusId(String? val) => _publicationStatusId = val;

  bool hasPublicationStatusId() => _publicationStatusId != null;

  String? _impactTypeId;
  String get impactTypeId => _impactTypeId ?? '';
  set impactTypeId(String? val) => _impactTypeId = val;

  bool hasImpactTypeId() => _impactTypeId != null;

  String? _ecosystemSupportId;
  String get ecosystemSupportId => _ecosystemSupportId ?? '';
  set ecosystemSupportId(String? val) => _ecosystemSupportId = val;

  bool hasEcosystemSupportId() => _ecosystemSupportId != null;

  String? _riskTypeId;
  String get riskTypeId => _riskTypeId ?? '';
  set riskTypeId(String? val) => _riskTypeId = val;

  bool hasRiskTypeId() => _riskTypeId != null;

  String? _riskTypologyId;
  String get riskTypologyId => _riskTypologyId ?? '';
  set riskTypologyId(String? val) => _riskTypologyId = val;

  bool hasRiskTypologyId() => _riskTypologyId != null;

  String? _observationScopeId;
  String get observationScopeId => _observationScopeId ?? '';
  set observationScopeId(String? val) => _observationScopeId = val;

  bool hasObservationScopeId() => _observationScopeId != null;

  String? _riskActualLevelId;
  String get riskActualLevelId => _riskActualLevelId ?? '';
  set riskActualLevelId(String? val) => _riskActualLevelId = val;

  bool hasRiskActualLevelId() => _riskActualLevelId != null;

  String? _gerenteResponsable;
  String get gerenteResponsable => _gerenteResponsable ?? '';
  set gerenteResponsable(String? val) => _gerenteResponsable = val;

  bool hasGerenteResponsable() => _gerenteResponsable != null;

  String? _auditorResponsable;
  String get auditorResponsable => _auditorResponsable ?? '';
  set auditorResponsable(String? val) => _auditorResponsable = val;

  bool hasAuditorResponsable() => _auditorResponsable != null;

  String? _descripcionRiesgo;
  String get descripcionRiesgo => _descripcionRiesgo ?? '';
  set descripcionRiesgo(String? val) => _descripcionRiesgo = val;

  bool hasDescripcionRiesgo() => _descripcionRiesgo != null;

  String? _causaRaiz;
  String get causaRaiz => _causaRaiz ?? '';
  set causaRaiz(String? val) => _causaRaiz = val;

  bool hasCausaRaiz() => _causaRaiz != null;

  static HallazgoStruct fromMap(Map<String, dynamic> data) => HallazgoStruct(
        titulo: data['titulo'] as String?,
        gerencia: data['gerencia'] as String?,
        ecosistema: data['ecosistema'] as String?,
        fecha: data['fecha'] as String?,
        nivelriesgo: data['nivelriesgo'] as String?,
        descripcion: data['descripcion'] as String?,
        recomendacion: data['recomendacion'] as String?,
        procesoPropuesto: data['procesoPropuesto'] as String?,
        observacion: data['observacion'] as String?,
        tituloHallazgo: data['tituloHallazgo'] as String?,
        nivelRiesgo: data['nivelRiesgo'] as String?,
        riskLevelId: data['riskLevelId'] as String?,
        publicationStatusId: data['publicationStatusId'] as String?,
        impactTypeId: data['impactTypeId'] as String?,
        ecosystemSupportId: data['ecosystemSupportId'] as String?,
        riskTypeId: data['riskTypeId'] as String?,
        riskTypologyId: data['riskTypologyId'] as String?,
        observationScopeId: data['observationScopeId'] as String?,
        riskActualLevelId: data['riskActualLevelId'] as String?,
        gerenteResponsable: data['gerenteResponsable'] as String?,
        auditorResponsable: data['auditorResponsable'] as String?,
        descripcionRiesgo: data['descripcionRiesgo'] as String?,
        causaRaiz: data['causaRaiz'] as String?,
      );

  static HallazgoStruct? maybeFromMap(dynamic data) =>
      data is Map ? HallazgoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'titulo': _titulo,
        'gerencia': _gerencia,
        'ecosistema': _ecosistema,
        'fecha': _fecha,
        'nivelriesgo': _nivelriesgo,
        'descripcion': _descripcion,
        'recomendacion': _recomendacion,
        'procesoPropuesto': _procesoPropuesto,
        'observacion': _observacion,
        'tituloHallazgo': _tituloHallazgo,
        'nivelRiesgo': _nivelRiesgo,
        'riskLevelId': _riskLevelId,
        'publicationStatusId': _publicationStatusId,
        'impactTypeId': _impactTypeId,
        'ecosystemSupportId': _ecosystemSupportId,
        'riskTypeId': _riskTypeId,
        'riskTypologyId': _riskTypologyId,
        'observationScopeId': _observationScopeId,
        'riskActualLevelId': _riskActualLevelId,
        'gerenteResponsable': _gerenteResponsable,
        'auditorResponsable': _auditorResponsable,
        'descripcionRiesgo': _descripcionRiesgo,
        'causaRaiz': _causaRaiz,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'titulo': serializeParam(_titulo, ParamType.String),
        'gerencia': serializeParam(_gerencia, ParamType.String),
        'ecosistema': serializeParam(_ecosistema, ParamType.String),
        'fecha': serializeParam(_fecha, ParamType.String),
        'nivelriesgo': serializeParam(_nivelriesgo, ParamType.String),
        'descripcion': serializeParam(_descripcion, ParamType.String),
        'recomendacion': serializeParam(_recomendacion, ParamType.String),
        'procesoPropuesto': serializeParam(_procesoPropuesto, ParamType.String),
        'observacion': serializeParam(_observacion, ParamType.String),
        'tituloHallazgo': serializeParam(_tituloHallazgo, ParamType.String),
        'nivelRiesgo': serializeParam(_nivelRiesgo, ParamType.String),
        'riskLevelId': serializeParam(_riskLevelId, ParamType.String),
        'publicationStatusId': serializeParam(_publicationStatusId, ParamType.String),
        'impactTypeId': serializeParam(_impactTypeId, ParamType.String),
        'ecosystemSupportId': serializeParam(_ecosystemSupportId, ParamType.String),
        'riskTypeId': serializeParam(_riskTypeId, ParamType.String),
        'riskTypologyId': serializeParam(_riskTypologyId, ParamType.String),
        'observationScopeId': serializeParam(_observationScopeId, ParamType.String),
        'riskActualLevelId': serializeParam(_riskActualLevelId, ParamType.String),
        'gerenteResponsable': serializeParam(_gerenteResponsable, ParamType.String),
        'auditorResponsable': serializeParam(_auditorResponsable, ParamType.String),
        'descripcionRiesgo': serializeParam(_descripcionRiesgo, ParamType.String),
        'causaRaiz': serializeParam(_causaRaiz, ParamType.String),
      }.withoutNulls;

  static HallazgoStruct fromSerializableMap(Map<String, dynamic> data) =>
      HallazgoStruct(
        titulo: deserializeParam(data['titulo'], ParamType.String, false),
        gerencia: deserializeParam(data['gerencia'], ParamType.String, false),
        ecosistema: deserializeParam(data['ecosistema'], ParamType.String, false),
        fecha: deserializeParam(data['fecha'], ParamType.String, false),
        nivelriesgo: deserializeParam(data['nivelriesgo'], ParamType.String, false),
        descripcion: deserializeParam(data['descripcion'], ParamType.String, false),
        recomendacion: deserializeParam(data['recomendacion'], ParamType.String, false),
        procesoPropuesto: deserializeParam(data['procesoPropuesto'], ParamType.String, false),
        observacion: deserializeParam(data['observacion'], ParamType.String, false),
        tituloHallazgo: deserializeParam(data['tituloHallazgo'], ParamType.String, false),
        nivelRiesgo: deserializeParam(data['nivelRiesgo'], ParamType.String, false),
        riskLevelId: deserializeParam(data['riskLevelId'], ParamType.String, false),
        publicationStatusId: deserializeParam(data['publicationStatusId'], ParamType.String, false),
        impactTypeId: deserializeParam(data['impactTypeId'], ParamType.String, false),
        ecosystemSupportId: deserializeParam(data['ecosystemSupportId'], ParamType.String, false),
        riskTypeId: deserializeParam(data['riskTypeId'], ParamType.String, false),
        riskTypologyId: deserializeParam(data['riskTypologyId'], ParamType.String, false),
        observationScopeId: deserializeParam(data['observationScopeId'], ParamType.String, false),
        riskActualLevelId: deserializeParam(data['riskActualLevelId'], ParamType.String, false),
        gerenteResponsable: deserializeParam(data['gerenteResponsable'], ParamType.String, false),
        auditorResponsable: deserializeParam(data['auditorResponsable'], ParamType.String, false),
        descripcionRiesgo: deserializeParam(data['descripcionRiesgo'], ParamType.String, false),
        causaRaiz: deserializeParam(data['causaRaiz'], ParamType.String, false),
      );

  @override
  String toString() => 'HallazgoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HallazgoStruct &&
        titulo == other.titulo &&
        gerencia == other.gerencia &&
        ecosistema == other.ecosistema &&
        fecha == other.fecha &&
        nivelriesgo == other.nivelriesgo &&
        descripcion == other.descripcion &&
        recomendacion == other.recomendacion &&
        procesoPropuesto == other.procesoPropuesto &&
        observacion == other.observacion &&
        tituloHallazgo == other.tituloHallazgo &&
        nivelRiesgo == other.nivelRiesgo &&
        publicationStatusId == other.publicationStatusId &&
        impactTypeId == other.impactTypeId &&
        ecosystemSupportId == other.ecosystemSupportId &&
        riskTypeId == other.riskTypeId &&
        riskTypologyId == other.riskTypologyId &&
        observationScopeId == other.observationScopeId &&
        riskActualLevelId == other.riskActualLevelId &&
        gerenteResponsable == other.gerenteResponsable &&
        auditorResponsable == other.auditorResponsable &&
        descripcionRiesgo == other.descripcionRiesgo &&
        causaRaiz == other.causaRaiz;
  }

  @override
  int get hashCode => const ListEquality().hash([
        titulo,
        gerencia,
        ecosistema,
        fecha,
        nivelriesgo,
        descripcion,
        recomendacion,
        procesoPropuesto,
        observacion,
        tituloHallazgo,
        nivelRiesgo,
        publicationStatusId,
        impactTypeId,
        ecosystemSupportId,
        riskTypeId,
        riskTypologyId,
        observationScopeId,
        riskActualLevelId,
        gerenteResponsable,
        auditorResponsable,
        descripcionRiesgo,
        causaRaiz,
      ]);
}

HallazgoStruct createHallazgoStruct({
  String? titulo,
  String? gerencia,
  String? ecosistema,
  String? fecha,
  String? nivelriesgo,
  String? descripcion,
  String? recomendacion,
  String? procesoPropuesto,
  String? observacion,
  String? tituloHallazgo,
  String? nivelRiesgo,
  String? publicationStatusId,
  String? impactTypeId,
  String? ecosystemSupportId,
  String? riskTypeId,
  String? riskTypologyId,
  String? observationScopeId,
  String? riskActualLevelId,
  String? gerenteResponsable,
  String? auditorResponsable,
  String? descripcionRiesgo,
  String? causaRaiz,
}) =>
    HallazgoStruct(
      titulo: titulo,
      gerencia: gerencia,
      ecosistema: ecosistema,
      fecha: fecha,
      nivelriesgo: nivelriesgo,
      descripcion: descripcion,
      recomendacion: recomendacion,
      procesoPropuesto: procesoPropuesto,
      observacion: observacion,
      tituloHallazgo: tituloHallazgo,
      nivelRiesgo: nivelRiesgo,
      publicationStatusId: publicationStatusId,
      impactTypeId: impactTypeId,
      ecosystemSupportId: ecosystemSupportId,
      riskTypeId: riskTypeId,
      riskTypologyId: riskTypologyId,
      observationScopeId: observationScopeId,
      riskActualLevelId: riskActualLevelId,
      gerenteResponsable: gerenteResponsable,
      auditorResponsable: auditorResponsable,
      descripcionRiesgo: descripcionRiesgo,
      causaRaiz: causaRaiz,
    );
