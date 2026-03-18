// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    String? id,
    String? uidUsuario,
    String? country,
    String? displayName,
    String? email,
    String? rol,
    DateTime? createdAt,
  })  : _id = id,
        _uidUsuario = uidUsuario,
        _country = country,
        _displayName = displayName,
        _email = email,
        _rol = rol,
        _createdAt = createdAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "uidUsuario" field.
  String? _uidUsuario;
  String get uidUsuario => _uidUsuario ?? '';
  set uidUsuario(String? val) => _uidUsuario = val;

  bool hasUidUsuario() => _uidUsuario != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  set displayName(String? val) => _displayName = val;

  bool hasDisplayName() => _displayName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "rol" field.
  String? _rol;
  String get rol => _rol ?? '';
  set rol(String? val) => _rol = val;

  bool hasRol() => _rol != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        id: data['id'] as String?,
        uidUsuario: data['uidUsuario'] as String?,
        country: data['country'] as String?,
        displayName: data['display_name'] as String?,
        email: data['email'] as String?,
        rol: data['rol'] as String?,
        createdAt: data['created_at'] as DateTime?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'uidUsuario': _uidUsuario,
        'country': _country,
        'display_name': _displayName,
        'email': _email,
        'rol': _rol,
        'created_at': _createdAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'uidUsuario': serializeParam(
          _uidUsuario,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'display_name': serializeParam(
          _displayName,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'rol': serializeParam(
          _rol,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        uidUsuario: deserializeParam(
          data['uidUsuario'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        displayName: deserializeParam(
          data['display_name'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        rol: deserializeParam(
          data['rol'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        id == other.id &&
        uidUsuario == other.uidUsuario &&
        country == other.country &&
        displayName == other.displayName &&
        email == other.email &&
        rol == other.rol &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, uidUsuario, country, displayName, email, rol, createdAt]);
}

UserStruct createUserStruct({
  String? id,
  String? uidUsuario,
  String? country,
  String? displayName,
  String? email,
  String? rol,
  DateTime? createdAt,
}) =>
    UserStruct(
      id: id,
      uidUsuario: uidUsuario,
      country: country,
      displayName: displayName,
      email: email,
      rol: rol,
      createdAt: createdAt,
    );
