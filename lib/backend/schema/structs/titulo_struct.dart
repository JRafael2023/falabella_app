// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TituloStruct extends BaseStruct {
  TituloStruct({
    String? id,
    String? nombre,
    String? idTitulo,
    String? idProceso,
    DateTime? createdAt,
    DateTime? updateAt,
    bool? estado,
  })  : _id = id,
        _nombre = nombre,
        _idTitulo = idTitulo,
        _idProceso = idProceso,
        _createdAt = createdAt,
        _updateAt = updateAt,
        _estado = estado;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "idTitulo" field.
  String? _idTitulo;
  String get idTitulo => _idTitulo ?? '';
  set idTitulo(String? val) => _idTitulo = val;

  bool hasIdTitulo() => _idTitulo != null;

  // "idProceso" field.
  String? _idProceso;
  String get idProceso => _idProceso ?? '';
  set idProceso(String? val) => _idProceso = val;

  bool hasIdProceso() => _idProceso != null;

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

  static TituloStruct fromMap(Map<String, dynamic> data) => TituloStruct(
        id: data['id'] as String?,
        nombre: data['nombre'] as String?,
        idTitulo: data['idTitulo'] as String?,
        idProceso: data['idProceso'] as String?,
        createdAt: data['created_at'] as DateTime?,
        updateAt: data['update_at'] as DateTime?,
        estado: data['estado'] as bool?,
      );

  static TituloStruct? maybeFromMap(dynamic data) =>
      data is Map ? TituloStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nombre': _nombre,
        'idTitulo': _idTitulo,
        'idProceso': _idProceso,
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
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'idTitulo': serializeParam(
          _idTitulo,
          ParamType.String,
        ),
        'idProceso': serializeParam(
          _idProceso,
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

  static TituloStruct fromSerializableMap(Map<String, dynamic> data) =>
      TituloStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
        idTitulo: deserializeParam(
          data['idTitulo'],
          ParamType.String,
          false,
        ),
        idProceso: deserializeParam(
          data['idProceso'],
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
  String toString() => 'TituloStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TituloStruct &&
        id == other.id &&
        nombre == other.nombre &&
        idTitulo == other.idTitulo &&
        idProceso == other.idProceso &&
        createdAt == other.createdAt &&
        updateAt == other.updateAt &&
        estado == other.estado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nombre, idTitulo, idProceso, createdAt, updateAt, estado]);
}

TituloStruct createTituloStruct({
  String? id,
  String? nombre,
  String? idTitulo,
  String? idProceso,
  DateTime? createdAt,
  DateTime? updateAt,
  bool? estado,
}) =>
    TituloStruct(
      id: id,
      nombre: nombre,
      idTitulo: idTitulo,
      idProceso: idProceso,
      createdAt: createdAt,
      updateAt: updateAt,
      estado: estado,
    );
