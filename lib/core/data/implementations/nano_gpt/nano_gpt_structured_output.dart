part of '../../../domain/interfaces/i_structured_output.dart';

final class NanoGptStructuredOutput extends IStructuredOutput {
  NanoGptStructuredOutput({required this.name, this.strict = true}) {
    if (name.trim().isEmpty) {
      throw const SchemaException('NanoGPT schema name cannot be empty.');
    }
  }

  final String name;
  final bool strict;

  String getResponseFormat(ISchema schema) {
    if (strict && schema is! ObjectSO) {
      throw const SchemaException(
        'NanoGPT strict structured output requires an ObjectSO root.',
      );
    }

    return jsonEncode({
      'type': 'json_schema',
      'json_schema': {
        'name': name,
        'strict': strict,
        'schema': jsonDecode(getSchema(schema)),
      },
    });
  }

  String getRequestFragment(ISchema schema) {
    return jsonEncode({
      'response_format': jsonDecode(getResponseFormat(schema)),
    });
  }

  Object? _encoded(ISchema schema) => jsonDecode(_encode(schema));

  String _result(
    ISchema schema,
    Map<String, Object?> value, {
    String? description,
  }) {
    if (schema.title != null) value['title'] = schema.title;

    final effectiveDescription = description ?? schema.description;
    if (effectiveDescription != null) {
      value['description'] = effectiveDescription;
    }

    if (schema.hasDefault) {
      if (!_isJsonValue(schema.defaultValue)) {
        throw const SchemaException('Schema default must be JSON-compatible.');
      }
      value['default'] = schema.defaultValue;
    }

    if (schema.examples.isNotEmpty) {
      if (!schema.examples.every(_isJsonValue)) {
        throw const SchemaException('Schema examples must be JSON-compatible.');
      }
      value['examples'] = schema.examples;
    }

    if (schema.deprecated) value['deprecated'] = true;

    for (final entry in schema.extensions.entries) {
      if (!entry.key.startsWith('x-')) {
        throw SchemaException(
          'Schema extension "${entry.key}" must start with "x-".',
        );
      }
      if (!_isJsonValue(entry.value)) {
        throw SchemaException(
          'Schema extension "${entry.key}" must be JSON-compatible.',
        );
      }
      value[entry.key] = entry.value;
    }

    return jsonEncode(value);
  }

  String? _stringDescription(StringSO schema) {
    final constraints = <String>[];

    if (schema.hints.minLines != null) {
      constraints.add('Minimum ${schema.hints.minLines} lines.');
    }
    if (schema.hints.maxLines != null) {
      constraints.add('Maximum ${schema.hints.maxLines} lines.');
    }

    if (constraints.isEmpty) return schema.description;
    if (schema.description == null || schema.description!.trim().isEmpty) {
      return constraints.join(' ');
    }
    return '${schema.description} ${constraints.join(' ')}';
  }

  String _numeric(NumericSO schema, String type) {
    return _result(schema, {
      'type': type,
      if (schema.minimum != null) 'minimum': schema.minimum,
      if (schema.maximum != null) 'maximum': schema.maximum,
      if (schema.exclusiveMinimum != null)
        'exclusiveMinimum': schema.exclusiveMinimum,
      if (schema.exclusiveMaximum != null)
        'exclusiveMaximum': schema.exclusiveMaximum,
      if (schema.multipleOf != null) 'multipleOf': schema.multipleOf,
    });
  }

  @override
  String _encodeString(StringSO schema) {
    return _result(schema, {
      'type': 'string',
      if (schema.minLength != null) 'minLength': schema.minLength,
      if (schema.maxLength != null) 'maxLength': schema.maxLength,
      if (schema.pattern != null) 'pattern': schema.pattern,
      if (schema.format != null) 'format': schema.format,
    }, description: _stringDescription(schema));
  }

  @override
  String _encodeInteger(IntegerSO schema) => _numeric(schema, 'integer');

  @override
  String _encodeNumber(NumberSO schema) => _numeric(schema, 'number');

  @override
  String _encodeDouble(DoubleSO schema) => _numeric(schema, 'number');

  @override
  String _encodeBoolean(BooleanSO schema) {
    return _result(schema, {'type': 'boolean'});
  }

  @override
  String _encodeNull(NullSO schema) {
    return _result(schema, {'type': 'null'});
  }

  @override
  String _encodeAny(AnySO schema) {
    if (strict) {
      throw const SchemaException(
        'NanoGPT strict structured output does not support AnySO.',
      );
    }
    return _result(schema, {});
  }

  @override
  String _encodeList(ListSO schema) {
    return _result(schema, {
      'type': 'array',
      'items': _encoded(schema.items),
      if (schema.minItems != null) 'minItems': schema.minItems,
      if (schema.maxItems != null) 'maxItems': schema.maxItems,
    });
  }

  @override
  String _encodeMap(MapSO schema) {
    if (strict) {
      throw const SchemaException(
        'NanoGPT strict structured output requires additionalProperties: false '
        'and cannot represent MapSO.',
      );
    }

    return _result(schema, {
      'type': 'object',
      'additionalProperties': _encoded(schema.values),
      if (schema.keyPattern != null)
        'propertyNames': {'pattern': schema.keyPattern},
      if (schema.minProperties != null) 'minProperties': schema.minProperties,
      if (schema.maxProperties != null) 'maxProperties': schema.maxProperties,
    });
  }

  @override
  String _encodeObject(ObjectSO schema) {
    if (strict && schema.allowAdditionalProperties) {
      throw const SchemaException(
        'NanoGPT strict structured output requires additionalProperties: false.',
      );
    }

    final properties = <String, Object?>{};
    final required = <String>[];

    for (final entry in schema.properties.entries) {
      final field = entry.value;
      var encoded = _encoded(field.schema);

      if (strict) {
        required.add(entry.key);
        if (!field.required && !_nanoGptAcceptsNull(field.schema)) {
          encoded = {
            'anyOf': [
              encoded,
              {'type': 'null'},
            ],
          };
        }
      } else if (field.required) {
        required.add(entry.key);
      }

      properties[entry.key] = encoded;
    }

    Object? additionalProperties = false;
    if (!strict && schema.allowAdditionalProperties) {
      additionalProperties = schema.additionalPropertiesSchema == null
          ? true
          : _encoded(schema.additionalPropertiesSchema!);
    }

    return _result(schema, {
      'type': 'object',
      'properties': properties,
      'required': required,
      'additionalProperties': additionalProperties,
      if (schema.minProperties != null) 'minProperties': schema.minProperties,
      if (schema.maxProperties != null) 'maxProperties': schema.maxProperties,
    });
  }

  @override
  String _encodeNullable(NullableSO schema) {
    return _result(schema, {
      'anyOf': [
        _encoded(schema.inner),
        {'type': 'null'},
      ],
    });
  }

  @override
  String _encodeEnum(EnumSO schema) {
    if (schema.values.isEmpty) {
      throw const SchemaException('EnumSO requires at least one value.');
    }

    final type = _nanoGptEnumType(schema.values);
    return _result(schema, {
      if (type != null) 'type': type,
      'enum': schema.values,
    });
  }

  @override
  String _encodeConst(ConstSO schema) {
    if (strict) {
      throw const SchemaException(
        'NanoGPT strict structured output does not support const. Use a '
        'single-value EnumSO as a discriminator instead.',
      );
    }
    if (!_isJsonValue(schema.value)) {
      throw const SchemaException('ConstSO value must be JSON-compatible.');
    }
    return _result(schema, {'const': schema.value});
  }

  @override
  String _encodeAnyOf(AnyOfSO schema) {
    if (schema.schemas.isEmpty) {
      throw const SchemaException('AnyOfSO requires at least one schema.');
    }
    return _result(schema, {
      'anyOf': [for (final child in schema.schemas) _encoded(child)],
    });
  }

  @override
  String _encodeOneOf(OneOfSO schema) {
    if (strict) {
      throw const SchemaException(
        'NanoGPT strict structured output does not support oneOf. Use '
        'discriminator-based AnyOfSO branches instead.',
      );
    }
    if (schema.schemas.isEmpty) {
      throw const SchemaException('OneOfSO requires at least one schema.');
    }
    return _result(schema, {
      'oneOf': [for (final child in schema.schemas) _encoded(child)],
    });
  }

  @override
  String _encodeAllOf(AllOfSO schema) {
    if (schema.schemas.isEmpty) {
      throw const SchemaException('AllOfSO requires at least one schema.');
    }
    return _result(schema, {
      'allOf': [for (final child in schema.schemas) _encoded(child)],
    });
  }

  @override
  String _encodeRef(RefSO schema) {
    if (schema.ref != '#') {
      throw const SchemaException(
        'NanoGptStructuredOutput only supports root recursion because '
        'IStructuredOutput.getSchema does not receive definitions.',
      );
    }
    return _result(schema, {r'$ref': schema.ref});
  }
}

bool _nanoGptAcceptsNull(ISchema schema) {
  return switch (schema) {
    NullSO() || NullableSO() || AnySO() => true,
    EnumSO() => schema.values.any((value) => value == null),
    ConstSO() => schema.value == null,
    AnyOfSO() => schema.schemas.any(_nanoGptAcceptsNull),
    OneOfSO() => schema.schemas.any(_nanoGptAcceptsNull),
    _ => false,
  };
}

Object? _nanoGptEnumType(List<Object?> values) {
  if (!values.every(_isJsonValue)) {
    throw const SchemaException('EnumSO values must be JSON-compatible.');
  }

  final nonNull = values.where((value) => value != null).toList();
  if (nonNull.isEmpty) return 'null';

  String typeOf(Object? value) {
    if (value is String) return 'string';
    if (value is bool) return 'boolean';
    if (value is int) return 'integer';
    if (value is num) return 'number';
    if (value is List) return 'array';
    if (value is Map) return 'object';
    throw SchemaException('Unsupported enum value type: ${value.runtimeType}.');
  }

  var type = typeOf(nonNull.first);
  for (final value in nonNull.skip(1)) {
    final current = typeOf(value);
    if ((type == 'integer' && current == 'number') ||
        (type == 'number' && current == 'integer')) {
      type = 'number';
      continue;
    }
    if (current != type) {
      throw const SchemaException(
        'EnumSO values must have one JSON type, optionally including null.',
      );
    }
  }

  return values.any((value) => value == null) ? [type, 'null'] : type;
}
