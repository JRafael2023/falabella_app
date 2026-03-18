import '../database.dart';

class MatricesTable extends SupabaseTable<MatricesRow> {
  @override
  String get tableName => 'Matrices';

  @override
  MatricesRow createRow(Map<String, dynamic> data) => MatricesRow(data);
}

class MatricesRow extends SupabaseDataRow {
  MatricesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MatricesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get matrixId => getField<String>('matrix_id');
  set matrixId(String? value) => setField<String>('matrix_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);
}
