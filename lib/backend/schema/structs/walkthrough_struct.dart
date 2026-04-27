
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalkthroughStruct extends BaseStruct {
  WalkthroughStruct({
    DataStruct? data,
  }) : _data = data;

  DataStruct? _data;
  DataStruct get data => _data ?? DataStruct();
  set data(DataStruct? val) => _data = val;

  void updateData(Function(DataStruct) updateFn) {
    updateFn(_data ??= DataStruct());
  }

  bool hasData() => _data != null;

  static WalkthroughStruct fromMap(Map<String, dynamic> data) =>
      WalkthroughStruct(
        data: data['data'] is DataStruct
            ? data['data']
            : DataStruct.maybeFromMap(data['data']),
      );

  static WalkthroughStruct? maybeFromMap(dynamic data) => data is Map
      ? WalkthroughStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'data': _data?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'data': serializeParam(
          _data,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static WalkthroughStruct fromSerializableMap(Map<String, dynamic> data) =>
      WalkthroughStruct(
        data: deserializeStructParam(
          data['data'],
          ParamType.DataStruct,
          false,
          structBuilder: DataStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'WalkthroughStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalkthroughStruct && data == other.data;
  }

  @override
  int get hashCode => const ListEquality().hash([data]);
}

WalkthroughStruct createWalkthroughStruct({
  DataStruct? data,
}) =>
    WalkthroughStruct(
      data: data ?? DataStruct(),
    );
