import '../database.dart';

class ProjectsTable extends SupabaseTable<ProjectsRow> {
  @override
  String get tableName => 'Projects';

  @override
  ProjectsRow createRow(Map<String, dynamic> data) => ProjectsRow(data);
}

class ProjectsRow extends SupabaseDataRow {
  ProjectsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProjectsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get projectState => getField<String>('project_state');
  set projectState(String? value) => setField<String>('project_state', value);

  String? get projectStatus => getField<String>('project_status');
  set projectStatus(String? value) => setField<String>('project_status', value);

  String? get opinion => getField<String>('opinion');
  set opinion(String? value) => setField<String>('opinion', value);

  double? get progress => getField<double>('progress');
  set progress(double? value) => setField<double>('progress', value);

  String? get matrixType => getField<String>('matrix_type');
  set matrixType(String? value) => setField<String>('matrix_type', value);

  String? get assignUser => getField<String>('assign_user');
  set assignUser(String? value) => setField<String>('assign_user', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  String? get idProject => getField<String>('id_project');
  set idProject(String? value) => setField<String>('id_project', value);
}
