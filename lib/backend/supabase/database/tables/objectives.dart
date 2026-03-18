import '../database.dart';

class ObjectivesTable extends SupabaseTable<ObjectivesRow> {
  @override
  String get tableName => 'Objectives';

  @override
  ObjectivesRow createRow(Map<String, dynamic> data) => ObjectivesRow(data);
}

class ObjectivesRow extends SupabaseDataRow {
  ObjectivesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ObjectivesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get projectId => getField<String>('project_id');
  set projectId(String? value) => setField<String>('project_id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get referenceField => getField<String>('reference');
  set referenceField(String? value) => setField<String>('reference', value);

  String? get divisionDepartment => getField<String>('division_department');
  set divisionDepartment(String? value) =>
      setField<String>('division_department', value);

  String? get position => getField<String>('position');
  set position(String? value) => setField<String>('position', value);

  dynamic? get customAttributes => getField<dynamic>('custom_attributes');
  set customAttributes(dynamic? value) =>
      setField<dynamic>('custom_attributes', value);

  String? get ownerUserId => getField<String>('owner_user_id');
  set ownerUserId(String? value) => setField<String>('owner_user_id', value);

  String? get executiveOwnerUserId =>
      getField<String>('executive_owner_user_id');
  set executiveOwnerUserId(String? value) =>
      setField<String>('executive_owner_user_id', value);

  String? get assignedUserId => getField<String>('assigned_user_id');
  set assignedUserId(String? value) =>
      setField<String>('assigned_user_id', value);

  String? get owner => getField<String>('owner');
  set owner(String? value) => setField<String>('owner', value);

  String? get executiveOwner => getField<String>('executive_owner');
  set executiveOwner(String? value) =>
      setField<String>('executive_owner', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
