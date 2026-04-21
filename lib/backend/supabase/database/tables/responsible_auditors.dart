import '../database.dart';

class ResponsibleAuditorsTable extends SupabaseTable<ResponsibleAuditorsRow> {
  @override
  String get tableName => 'ResponsibleAuditors';

  @override
  ResponsibleAuditorsRow createRow(Map<String, dynamic> data) =>
      ResponsibleAuditorsRow(data);
}

class ResponsibleAuditorsRow extends SupabaseDataRow {
  ResponsibleAuditorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ResponsibleAuditorsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get responsibleAuditorId => getField<String>('responsible_auditor_id');
  set responsibleAuditorId(String? value) =>
      setField<String>('responsible_auditor_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
