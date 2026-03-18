import '../database.dart';

class TitlesTable extends SupabaseTable<TitlesRow> {
  @override
  String get tableName => 'Titles';

  @override
  TitlesRow createRow(Map<String, dynamic> data) => TitlesRow(data);
}

class TitlesRow extends SupabaseDataRow {
  TitlesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TitlesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get processId => getField<String>('process_id');
  set processId(String? value) => setField<String>('process_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  String? get titlesId => getField<String>('titles_id');
  set titlesId(String? value) => setField<String>('titles_id', value);
}
