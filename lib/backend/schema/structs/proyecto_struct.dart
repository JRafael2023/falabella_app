// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProyectoStruct extends BaseStruct {
  ProyectoStruct({
    String? id,
    String? name,
    String? description,
    String? projectState,
    String? projectStatus,
    String? opinion,
    double? progress,
    String? matrixType,
    String? assignUser,
    bool? status,
    String? idProject,
  })  : _id = id,
        _name = name,
        _description = description,
        _projectState = projectState,
        _projectStatus = projectStatus,
        _opinion = opinion,
        _progress = progress,
        _matrixType = matrixType,
        _assignUser = assignUser,
        _status = status,
        _idProject = idProject;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "project_state" field.
  String? _projectState;
  String get projectState => _projectState ?? '';
  set projectState(String? val) => _projectState = val;

  bool hasProjectState() => _projectState != null;

  // "project_status" field.
  String? _projectStatus;
  String get projectStatus => _projectStatus ?? '';
  set projectStatus(String? val) => _projectStatus = val;

  bool hasProjectStatus() => _projectStatus != null;

  // "opinion" field.
  String? _opinion;
  String get opinion => _opinion ?? '';
  set opinion(String? val) => _opinion = val;

  bool hasOpinion() => _opinion != null;

  // "progress" field.
  double? _progress;
  double get progress => _progress ?? 0.0;
  set progress(double? val) => _progress = val;

  void incrementProgress(double amount) => progress = progress + amount;

  bool hasProgress() => _progress != null;

  // "matrix_type" field.
  String? _matrixType;
  String get matrixType => _matrixType ?? '';
  set matrixType(String? val) => _matrixType = val;

  bool hasMatrixType() => _matrixType != null;

  // "assign_user" field.
  String? _assignUser;
  String get assignUser => _assignUser ?? '';
  set assignUser(String? val) => _assignUser = val;

  bool hasAssignUser() => _assignUser != null;

  // "status" field.
  bool? _status;
  bool get status => _status ?? false;
  set status(bool? val) => _status = val;

  bool hasStatus() => _status != null;

  // "id_project" field.
  String? _idProject;
  String get idProject => _idProject ?? '';
  set idProject(String? val) => _idProject = val;

  bool hasIdProject() => _idProject != null;

  static ProyectoStruct fromMap(Map<String, dynamic> data) => ProyectoStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        projectState: data['project_state'] as String?,
        projectStatus: data['project_status'] as String?,
        opinion: data['opinion'] as String?,
        progress: castToType<double>(data['progress']),
        matrixType: data['matrix_type'] as String?,
        assignUser: data['assign_user'] as String?,
        status: data['status'] as bool?,
        idProject: data['id_project'] as String?,
      );

  static ProyectoStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProyectoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'description': _description,
        'project_state': _projectState,
        'project_status': _projectStatus,
        'opinion': _opinion,
        'progress': _progress,
        'matrix_type': _matrixType,
        'assign_user': _assignUser,
        'status': _status,
        'id_project': _idProject,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'project_state': serializeParam(
          _projectState,
          ParamType.String,
        ),
        'project_status': serializeParam(
          _projectStatus,
          ParamType.String,
        ),
        'opinion': serializeParam(
          _opinion,
          ParamType.String,
        ),
        'progress': serializeParam(
          _progress,
          ParamType.double,
        ),
        'matrix_type': serializeParam(
          _matrixType,
          ParamType.String,
        ),
        'assign_user': serializeParam(
          _assignUser,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.bool,
        ),
        'id_project': serializeParam(
          _idProject,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProyectoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProyectoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        projectState: deserializeParam(
          data['project_state'],
          ParamType.String,
          false,
        ),
        projectStatus: deserializeParam(
          data['project_status'],
          ParamType.String,
          false,
        ),
        opinion: deserializeParam(
          data['opinion'],
          ParamType.String,
          false,
        ),
        progress: deserializeParam(
          data['progress'],
          ParamType.double,
          false,
        ),
        matrixType: deserializeParam(
          data['matrix_type'],
          ParamType.String,
          false,
        ),
        assignUser: deserializeParam(
          data['assign_user'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.bool,
          false,
        ),
        idProject: deserializeParam(
          data['id_project'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProyectoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProyectoStruct &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        projectState == other.projectState &&
        projectStatus == other.projectStatus &&
        opinion == other.opinion &&
        progress == other.progress &&
        matrixType == other.matrixType &&
        assignUser == other.assignUser &&
        status == other.status &&
        idProject == other.idProject;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        description,
        projectState,
        projectStatus,
        opinion,
        progress,
        matrixType,
        assignUser,
        status,
        idProject
      ]);
}

ProyectoStruct createProyectoStruct({
  String? id,
  String? name,
  String? description,
  String? projectState,
  String? projectStatus,
  String? opinion,
  double? progress,
  String? matrixType,
  String? assignUser,
  bool? status,
  String? idProject,
}) =>
    ProyectoStruct(
      id: id,
      name: name,
      description: description,
      projectState: projectState,
      projectStatus: projectStatus,
      opinion: opinion,
      progress: progress,
      matrixType: matrixType,
      assignUser: assignUser,
      status: status,
      idProject: idProject,
    );
