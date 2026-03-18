// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ControlesDataStruct extends BaseStruct {
  ControlesDataStruct({
    String? id,
    String? type,
    AttributesStruct? attributes,
    RelationshipsStruct? relationships,
    LinksStruct? links,
  })  : _id = id,
        _type = type,
        _attributes = attributes,
        _relationships = relationships,
        _links = links;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "attributes" field.
  AttributesStruct? _attributes;
  AttributesStruct get attributes => _attributes ?? AttributesStruct();
  set attributes(AttributesStruct? val) => _attributes = val;

  void updateAttributes(Function(AttributesStruct) updateFn) {
    updateFn(_attributes ??= AttributesStruct());
  }

  bool hasAttributes() => _attributes != null;

  // "relationships" field.
  RelationshipsStruct? _relationships;
  RelationshipsStruct get relationships =>
      _relationships ?? RelationshipsStruct();
  set relationships(RelationshipsStruct? val) => _relationships = val;

  void updateRelationships(Function(RelationshipsStruct) updateFn) {
    updateFn(_relationships ??= RelationshipsStruct());
  }

  bool hasRelationships() => _relationships != null;

  // "links" field.
  LinksStruct? _links;
  LinksStruct get links => _links ?? LinksStruct();
  set links(LinksStruct? val) => _links = val;

  void updateLinks(Function(LinksStruct) updateFn) {
    updateFn(_links ??= LinksStruct());
  }

  bool hasLinks() => _links != null;

  static ControlesDataStruct fromMap(Map<String, dynamic> data) =>
      ControlesDataStruct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        attributes: data['attributes'] is AttributesStruct
            ? data['attributes']
            : AttributesStruct.maybeFromMap(data['attributes']),
        relationships: data['relationships'] is RelationshipsStruct
            ? data['relationships']
            : RelationshipsStruct.maybeFromMap(data['relationships']),
        links: data['links'] is LinksStruct
            ? data['links']
            : LinksStruct.maybeFromMap(data['links']),
      );

  static ControlesDataStruct? maybeFromMap(dynamic data) => data is Map
      ? ControlesDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'attributes': _attributes?.toMap(),
        'relationships': _relationships?.toMap(),
        'links': _links?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'attributes': serializeParam(
          _attributes,
          ParamType.DataStruct,
        ),
        'relationships': serializeParam(
          _relationships,
          ParamType.DataStruct,
        ),
        'links': serializeParam(
          _links,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static ControlesDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      ControlesDataStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        attributes: deserializeStructParam(
          data['attributes'],
          ParamType.DataStruct,
          false,
          structBuilder: AttributesStruct.fromSerializableMap,
        ),
        relationships: deserializeStructParam(
          data['relationships'],
          ParamType.DataStruct,
          false,
          structBuilder: RelationshipsStruct.fromSerializableMap,
        ),
        links: deserializeStructParam(
          data['links'],
          ParamType.DataStruct,
          false,
          structBuilder: LinksStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ControlesDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ControlesDataStruct &&
        id == other.id &&
        type == other.type &&
        attributes == other.attributes &&
        relationships == other.relationships &&
        links == other.links;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, type, attributes, relationships, links]);
}

ControlesDataStruct createControlesDataStruct({
  String? id,
  String? type,
  AttributesStruct? attributes,
  RelationshipsStruct? relationships,
  LinksStruct? links,
}) =>
    ControlesDataStruct(
      id: id,
      type: type,
      attributes: attributes ?? AttributesStruct(),
      relationships: relationships ?? RelationshipsStruct(),
      links: links ?? LinksStruct(),
    );
