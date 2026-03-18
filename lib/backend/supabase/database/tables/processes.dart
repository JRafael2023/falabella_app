import '../database.dart';

class ProcessesTable extends SupabaseTable<ProcessesRow> {
  @override
  String get tableName => 'Processes';

  @override
  ProcessesRow createRow(Map<String, dynamic> data) => ProcessesRow(data);
}

class ProcessesRow extends SupabaseDataRow {
  ProcessesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProcessesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get abbreviation => getField<String>('abbreviation');
  set abbreviation(String? value) => setField<String>('abbreviation', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  String? get processId => getField<String>('process_id');
  set processId(String? value) => setField<String>('process_id', value);
}
