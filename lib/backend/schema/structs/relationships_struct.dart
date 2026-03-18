// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RelationshipsStruct extends BaseStruct {
  RelationshipsStruct({
    WalkthroughStruct? walkthrough,
  }) : _walkthrough = walkthrough;

  // "walkthrough" field.
  WalkthroughStruct? _walkthrough;
  WalkthroughStruct get walkthrough => _walkthrough ?? WalkthroughStruct();
  set walkthrough(WalkthroughStruct? val) => _walkthrough = val;

  void updateWalkthrough(Function(WalkthroughStruct) updateFn) {
    updateFn(_walkthrough ??= WalkthroughStruct());
  }

  bool hasWalkthrough() => _walkthrough != null;

  static RelationshipsStruct fromMap(Map<String, dynamic> data) =>
      RelationshipsStruct(
        walkthrough: data['walkthrough'] is WalkthroughStruct
            ? data['walkthrough']
            : WalkthroughStruct.maybeFromMap(data['walkthrough']),
      );

  static RelationshipsStruct? maybeFromMap(dynamic data) => data is Map
      ? RelationshipsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'walkthrough': _walkthrough?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'walkthrough': serializeParam(
          _walkthrough,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static RelationshipsStruct fromSerializableMap(Map<String, dynamic> data) =>
      RelationshipsStruct(
        walkthrough: deserializeStructParam(
          data['walkthrough'],
          ParamType.DataStruct,
          false,
          structBuilder: WalkthroughStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RelationshipsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RelationshipsStruct && walkthrough == other.walkthrough;
  }

  @override
  int get hashCode => const ListEquality().hash([walkthrough]);
}

RelationshipsStruct createRelationshipsStruct({
  WalkthroughStruct? walkthrough,
}) =>
    RelationshipsStruct(
      walkthrough: walkthrough ?? WalkthroughStruct(),
    );
