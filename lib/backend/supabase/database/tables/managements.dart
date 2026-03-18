import '../database.dart';

class ManagementsTable extends SupabaseTable<ManagementsRow> {
  @override
  String get tableName => 'Managements';

  @override
  ManagementsRow createRow(Map<String, dynamic> data) => ManagementsRow(data);
}

class ManagementsRow extends SupabaseDataRow {
  ManagementsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ManagementsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get managementId => getField<String>('management_id');
  set managementId(String? value) => setField<String>('management_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
