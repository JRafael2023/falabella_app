// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GerenciaStruct extends BaseStruct {
  GerenciaStruct({
    String? id,
    String? idGerencia,
    String? nombre,
    DateTime? createdAt,
    DateTime? updateAt,
    bool? estado,
  })  : _id = id,
        _idGerencia = idGerencia,
        _nombre = nombre,
        _createdAt = createdAt,
        _updateAt = updateAt,
        _estado = estado;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "idGerencia" field.
  String? _idGerencia;
  String get idGerencia => _idGerencia ?? '';
  set idGerencia(String? val) => _idGerencia = val;

  bool hasIdGerencia() => _idGerencia != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

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

  static GerenciaStruct fromMap(Map<String, dynamic> data) => GerenciaStruct(
        id: data['id'] as String?,
        idGerencia: data['idGerencia'] as String?,
        nombre: data['nombre'] as String?,
        createdAt: data['created_at'] as DateTime?,
        updateAt: data['update_at'] as DateTime?,
        estado: data['estado'] as bool?,
      );

  static GerenciaStruct? maybeFromMap(dynamic data) =>
      data is Map ? GerenciaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'idGerencia': _idGerencia,
        'nombre': _nombre,
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
        'idGerencia': serializeParam(
          _idGerencia,
          ParamType.String,
        ),
        'nombre': serializeParam(
          _nombre,
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

  static GerenciaStruct fromSerializableMap(Map<String, dynamic> data) =>
      GerenciaStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        idGerencia: deserializeParam(
          data['idGerencia'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['nombre'],
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
  String toString() => 'GerenciaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GerenciaStruct &&
        id == other.id &&
        idGerencia == other.idGerencia &&
        nombre == other.nombre &&
        createdAt == other.createdAt &&
        updateAt == other.updateAt &&
        estado == other.estado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, idGerencia, nombre, createdAt, updateAt, estado]);
}

GerenciaStruct createGerenciaStruct({
  String? id,
  String? idGerencia,
  String? nombre,
  DateTime? createdAt,
  DateTime? updateAt,
  bool? estado,
}) =>
    GerenciaStruct(
      id: id,
      idGerencia: idGerencia,
      nombre: nombre,
      createdAt: createdAt,
      updateAt: updateAt,
      estado: estado,
    );
