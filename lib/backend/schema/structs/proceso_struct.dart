// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProcesoStruct extends BaseStruct {
  ProcesoStruct({
    String? id,
    String? idProceso,
    String? nombre,
    String? abreviacion,
    DateTime? createdAt,
    DateTime? updateAt,
    bool? estado,
  })  : _id = id,
        _idProceso = idProceso,
        _nombre = nombre,
        _abreviacion = abreviacion,
        _createdAt = createdAt,
        _updateAt = updateAt,
        _estado = estado;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "idProceso" field.
  String? _idProceso;
  String get idProceso => _idProceso ?? '';
  set idProceso(String? val) => _idProceso = val;

  bool hasIdProceso() => _idProceso != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "abreviacion" field.
  String? _abreviacion;
  String get abreviacion => _abreviacion ?? '';
  set abreviacion(String? val) => _abreviacion = val;

  bool hasAbreviacion() => _abreviacion != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "update_at" field.
  DateTime? _updateAt;
  DateTime? get updateAt => _updateAt;
  set updateAt(DateTime? val) => _updateAt = val;

  bool hasUpdateAt() => _updateAt != null;

  // "estado" field.
  bool? _estado;
  bool get estado => _estado ?? false;
  set estado(bool? val) => _estado = val;

  bool hasEstado() => _estado != null;

  static ProcesoStruct fromMap(Map<String, dynamic> data) => ProcesoStruct(
        id: data['id'] as String?,
        idProceso: data['idProceso'] as String?,
        nombre: data['nombre'] as String?,
        abreviacion: data['abreviacion'] as String?,
        createdAt: data['created_at'] as DateTime?,
        updateAt: data['update_at'] as DateTime?,
        estado: data['estado'] as bool?,
      );

  static ProcesoStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProcesoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'idProceso': _idProceso,
        'nombre': _nombre,
        'abreviacion': _abreviacion,
        'created_at': _createdAt,
        'update_at': _updateAt,
        'estado': _estado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'idProceso': serializeParam(
          _idProceso,
          ParamType.String,
        ),
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'abreviacion': serializeParam(
          _abreviacion,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'update_at': serializeParam(
          _updateAt,
          ParamType.DateTime,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ProcesoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProcesoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        idProceso: deserializeParam(
          data['idProceso'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
        abreviacion: deserializeParam(
          data['abreviacion'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
        updateAt: deserializeParam(
          data['update_at'],
          ParamType.DateTime,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ProcesoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProcesoStruct &&
        id == other.id &&
        idProceso == other.idProceso &&
        nombre == other.nombre &&
        abreviacion == other.abreviacion &&
        createdAt == other.createdAt &&
        updateAt == other.updateAt &&
        estado == other.estado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, idProceso, nombre, abreviacion, createdAt, updateAt, estado]);
}

ProcesoStruct createProcesoStruct({
  String? id,
  String? idProceso,
  String? nombre,
  String? abreviacion,
  DateTime? createdAt,
  DateTime? updateAt,
  bool? estado,
}) =>
    ProcesoStruct(
      id: id,
      idProceso: idProceso,
      nombre: nombre,
      abreviacion: abreviacion,
      createdAt: createdAt,
      updateAt: updateAt,
      estado: estado,
    );
