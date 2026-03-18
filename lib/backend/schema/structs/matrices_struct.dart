// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MatricesStruct extends BaseStruct {
  MatricesStruct({
    String? id,
    String? matrixId,
    String? name,
    bool? status,
  })  : _id = id,
        _matrixId = matrixId,
        _name = name,
        _status = status;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "matrix_id" field.
  String? _matrixId;
  String get matrixId => _matrixId ?? '';
  set matrixId(String? val) => _matrixId = val;

  bool hasMatrixId() => _matrixId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "status" field.
  bool? _status;
  bool get status => _status ?? false;
  set status(bool? val) => _status = val;

  bool hasStatus() => _status != null;

  static MatricesStruct fromMap(Map<String, dynamic> data) => MatricesStruct(
        id: data['id'] as String?,
        matrixId: data['matrix_id'] as String?,
        name: data['name'] as String?,
        status: data['status'] as bool?,
      );

  static MatricesStruct? maybeFromMap(dynamic data) =>
      data is Map ? MatricesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'matrix_id': _matrixId,
        'name': _name,
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'matrix_id': serializeParam(
          _matrixId,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MatricesStruct fromSerializableMap(Map<String, dynamic> data) =>
      MatricesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        matrixId: deserializeParam(
          data['matrix_id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MatricesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MatricesStruct &&
        id == other.id &&
        matrixId == other.matrixId &&
        name == other.name &&
        status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash([id, matrixId, name, status]);
}

MatricesStruct createMatricesStruct({
  String? id,
  String? matrixId,
  String? name,
  bool? status,
}) =>
    MatricesStruct(
      id: id,
      matrixId: matrixId,
      name: name,
      status: status,
    );
