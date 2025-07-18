// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaboration_enitiy.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CollaborationSchema = Schema(
  name: r'Collaboration',
  id: -7724512964405308142,
  properties: {
    r'isShared': PropertySchema(
      id: 0,
      name: r'isShared',
      type: IsarType.bool,
    ),
    r'sharedWith': PropertySchema(
      id: 1,
      name: r'sharedWith',
      type: IsarType.stringList,
    )
  },
  estimateSize: _collaborationEstimateSize,
  serialize: _collaborationSerialize,
  deserialize: _collaborationDeserialize,
  deserializeProp: _collaborationDeserializeProp,
);

int _collaborationEstimateSize(
  Collaboration object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sharedWith.length * 3;
  {
    for (var i = 0; i < object.sharedWith.length; i++) {
      final value = object.sharedWith[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _collaborationSerialize(
  Collaboration object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isShared);
  writer.writeStringList(offsets[1], object.sharedWith);
}

Collaboration _collaborationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Collaboration();
  object.isShared = reader.readBool(offsets[0]);
  object.sharedWith = reader.readStringList(offsets[1]) ?? [];
  return object;
}

P _collaborationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CollaborationQueryFilter
    on QueryBuilder<Collaboration, Collaboration, QFilterCondition> {
  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      isSharedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShared',
        value: value,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sharedWith',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sharedWith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sharedWith',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedWith',
        value: '',
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sharedWith',
        value: '',
      ));
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Collaboration, Collaboration, QAfterFilterCondition>
      sharedWithLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedWith',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension CollaborationQueryObject
    on QueryBuilder<Collaboration, Collaboration, QFilterCondition> {}
