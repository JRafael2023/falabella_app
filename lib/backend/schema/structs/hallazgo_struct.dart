// ignore_for_file: unnecessary_getters_setters

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
        _nivelRiesgo = nivelRiesgo;

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  set titulo(String? val) => _titulo = val;

  bool hasTitulo() => _titulo != null;

  // "gerencia" field.
  String? _gerencia;
  String get gerencia => _gerencia ?? '';
  set gerencia(String? val) => _gerencia = val;

  bool hasGerencia() => _gerencia != null;

  // "ecosistema" field.
  String? _ecosistema;
  String get ecosistema => _ecosistema ?? '';
  set ecosistema(String? val) => _ecosistema = val;

  bool hasEcosistema() => _ecosistema != null;

  // "fecha" field.
  String? _fecha;
  String get fecha => _fecha ?? '';
  set fecha(String? val) => _fecha = val;

  bool hasFecha() => _fecha != null;

  // "nivelriesgo" field.
  String? _nivelriesgo;
  String get nivelriesgo => _nivelriesgo ?? '';
  set nivelriesgo(String? val) => _nivelriesgo = val;

  bool hasNivelriesgo() => _nivelriesgo != null;

  // "descripcion" field.
  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  set descripcion(String? val) => _descripcion = val;

  bool hasDescripcion() => _descripcion != null;

  // "recomendacion" field.
  String? _recomendacion;
  String get recomendacion => _recomendacion ?? '';
  set recomendacion(String? val) => _recomendacion = val;

  bool hasRecomendacion() => _recomendacion != null;

  // "procesoPropuesto" field.
  String? _procesoPropuesto;
  String get procesoPropuesto => _procesoPropuesto ?? '';
  set procesoPropuesto(String? val) => _procesoPropuesto = val;

  bool hasProcesoPropuesto() => _procesoPropuesto != null;

  // "observacion" field.
  String? _observacion;
  String get observacion => _observacion ?? '';
  set observacion(String? val) => _observacion = val;

  bool hasObservacion() => _observacion != null;

  // "tituloHallazgo" field.
  String? _tituloHallazgo;
  String get tituloHallazgo => _tituloHallazgo ?? '';
  set tituloHallazgo(String? val) => _tituloHallazgo = val;

  bool hasTituloHallazgo() => _tituloHallazgo != null;

  // "nivelRiesgo" field.
  String? _nivelRiesgo;
  String get nivelRiesgo => _nivelRiesgo ?? '';
  set nivelRiesgo(String? val) => _nivelRiesgo = val;

  bool hasNivelRiesgo() => _nivelRiesgo != null;

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
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'titulo': serializeParam(
          _titulo,
          ParamType.String,
        ),
        'gerencia': serializeParam(
          _gerencia,
          ParamType.String,
        ),
        'ecosistema': serializeParam(
          _ecosistema,
          ParamType.String,
        ),
        'fecha': serializeParam(
          _fecha,
          ParamType.String,
        ),
        'nivelriesgo': serializeParam(
          _nivelriesgo,
          ParamType.String,
        ),
        'descripcion': serializeParam(
          _descripcion,
          ParamType.String,
        ),
        'recomendacion': serializeParam(
          _recomendacion,
          ParamType.String,
        ),
        'procesoPropuesto': serializeParam(
          _procesoPropuesto,
          ParamType.String,
        ),
        'observacion': serializeParam(
          _observacion,
          ParamType.String,
        ),
        'tituloHallazgo': serializeParam(
          _tituloHallazgo,
          ParamType.String,
        ),
        'nivelRiesgo': serializeParam(
          _nivelRiesgo,
          ParamType.String,
        ),
      }.withoutNulls;

  static HallazgoStruct fromSerializableMap(Map<String, dynamic> data) =>
      HallazgoStruct(
        titulo: deserializeParam(
          data['titulo'],
          ParamType.String,
          false,
        ),
        gerencia: deserializeParam(
          data['gerencia'],
          ParamType.String,
          false,
        ),
        ecosistema: deserializeParam(
          data['ecosistema'],
          ParamType.String,
          false,
        ),
        fecha: deserializeParam(
          data['fecha'],
          ParamType.String,
          false,
        ),
        nivelriesgo: deserializeParam(
          data['nivelriesgo'],
          ParamType.String,
          false,
        ),
        descripcion: deserializeParam(
          data['descripcion'],
          ParamType.String,
          false,
        ),
        recomendacion: deserializeParam(
          data['recomendacion'],
          ParamType.String,
          false,
        ),
        procesoPropuesto: deserializeParam(
          data['procesoPropuesto'],
          ParamType.String,
          false,
        ),
        observacion: deserializeParam(
          data['observacion'],
          ParamType.String,
          false,
        ),
        tituloHallazgo: deserializeParam(
          data['tituloHallazgo'],
          ParamType.String,
          false,
        ),
        nivelRiesgo: deserializeParam(
          data['nivelRiesgo'],
          ParamType.String,
          false,
        ),
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
        nivelRiesgo == other.nivelRiesgo;
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
        nivelRiesgo
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
    );
