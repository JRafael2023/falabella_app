import '../database.dart';

class SyncLogsTable extends SupabaseTable<SyncLogsRow> {
  @override
  String get tableName => 'Sync_Logs';

  @override
  SyncLogsRow createRow(Map<String, dynamic> data) => SyncLogsRow(data);
}

class SyncLogsRow extends SupabaseDataRow {
  SyncLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SyncLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get userUid => getField<String>('user_uid')!;
  set userUid(String value) => setField<String>('user_uid', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  String? get userDisplayName => getField<String>('user_display_name');
  set userDisplayName(String? value) =>
      setField<String>('user_display_name', value);

  DateTime get syncStart => getField<DateTime>('sync_start')!;
  set syncStart(DateTime value) => setField<DateTime>('sync_start', value);

  DateTime? get syncEnd => getField<DateTime>('sync_end');
  set syncEnd(DateTime? value) => setField<DateTime>('sync_end', value);

  String? get syncType => getField<String>('sync_type');
  set syncType(String? value) => setField<String>('sync_type', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  int? get totalControlsSynced => getField<int>('total_controls_synced');
  set totalControlsSynced(int? value) =>
      setField<int>('total_controls_synced', value);

  dynamic? get controlsUpdated => getField<dynamic>('controls_updated');
  set controlsUpdated(dynamic? value) =>
      setField<dynamic>('controls_updated', value);

  String? get clientIp => getField<String>('client_ip');
  set clientIp(String? value) => setField<String>('client_ip', value);

  String? get deviceInfo => getField<String>('device_info');
  set deviceInfo(String? value) => setField<String>('device_info', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);
}
