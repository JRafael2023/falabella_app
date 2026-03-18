import '../database.dart';

class EcosystemsTable extends SupabaseTable<EcosystemsRow> {
  @override
  String get tableName => 'Ecosystems';

  @override
  EcosystemsRow createRow(Map<String, dynamic> data) => EcosystemsRow(data);
}

class EcosystemsRow extends SupabaseDataRow {
  EcosystemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EcosystemsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get ecosystemId => getField<String>('ecosystem_id');
  set ecosystemId(String? value) => setField<String>('ecosystem_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
