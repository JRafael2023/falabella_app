
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LinksStruct extends BaseStruct {
  LinksStruct({
    String? ui,
  }) : _ui = ui;

  String? _ui;
  String get ui => _ui ?? '';
  set ui(String? val) => _ui = val;

  bool hasUi() => _ui != null;

  static LinksStruct fromMap(Map<String, dynamic> data) => LinksStruct(
        ui: data['ui'] as String?,
      );

  static LinksStruct? maybeFromMap(dynamic data) =>
      data is Map ? LinksStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'ui': _ui,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ui': serializeParam(
          _ui,
          ParamType.String,
        ),
      }.withoutNulls;

  static LinksStruct fromSerializableMap(Map<String, dynamic> data) =>
      LinksStruct(
        ui: deserializeParam(
          data['ui'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LinksStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LinksStruct && ui == other.ui;
  }

  @override
  int get hashCode => const ListEquality().hash([ui]);
}

LinksStruct createLinksStruct({
  String? ui,
}) =>
    LinksStruct(
      ui: ui,
    );
