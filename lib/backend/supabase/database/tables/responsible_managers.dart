import '../database.dart';

class ResponsibleManagersTable extends SupabaseTable<ResponsibleManagersRow> {
  @override
  String get tableName => 'ResponsibleManagers';

  @override
  ResponsibleManagersRow createRow(Map<String, dynamic> data) =>
      ResponsibleManagersRow(data);
}

class ResponsibleManagersRow extends SupabaseDataRow {
  ResponsibleManagersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ResponsibleManagersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get responsibleManagerId => getField<String>('responsible_manager_id');
  set responsibleManagerId(String? value) =>
      setField<String>('responsible_manager_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
