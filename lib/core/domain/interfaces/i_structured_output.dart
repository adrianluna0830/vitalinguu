library structured_outputs;

import 'dart:convert';
import 'dart:math' as math;

part '../../data/implementations/nano_gpt/nano_gpt_structured_output.dart';

class SchemaException implements Exception {
  const SchemaException(this.message);

  final String message;

  @override
  String toString() => 'SchemaException: $message';
}

final class SchemaHints {
  const SchemaHints({this.minLines, this.maxLines});

  final int? minLines;
  final int? maxLines;

  bool get isEmpty => minLines == null && maxLines == null;
}

sealed class ISchema {
  const ISchema({
    this.title,
    this.description,
    this.hasDefault = false,
    this.defaultValue,
    this.examples = const [],
    this.deprecated = false,
    this.extensions = const {},
  });

  final String? title;
  final String? description;
  final bool hasDefault;
  final Object? defaultValue;
  final List<Object?> examples;
  final bool deprecated;

  final Map<String, Object?> extensions;
}

final class StringSO extends ISchema {
  const StringSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.format,
    this.hints = const SchemaHints(),
  });

  final int? minLength;
  final int? maxLength;
  final String? pattern;

  final String? format;
  final SchemaHints hints;
}

sealed class NumericSO extends ISchema {
  const NumericSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    this.minimum,
    this.maximum,
    this.exclusiveMinimum,
    this.exclusiveMaximum,
    this.multipleOf,
  });

  final num? minimum;
  final num? maximum;
  final num? exclusiveMinimum;
  final num? exclusiveMaximum;
  final num? multipleOf;
}

final class IntegerSO extends NumericSO {
  const IntegerSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    super.minimum,
    super.maximum,
    super.exclusiveMinimum,
    super.exclusiveMaximum,
    super.multipleOf,
  });
}

final class NumberSO extends NumericSO {
  const NumberSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    super.minimum,
    super.maximum,
    super.exclusiveMinimum,
    super.exclusiveMaximum,
    super.multipleOf,
  });
}

final class DoubleSO extends NumericSO {
  const DoubleSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    super.minimum,
    super.maximum,
    super.exclusiveMinimum,
    super.exclusiveMaximum,
    super.multipleOf,
  });
}

final class BooleanSO extends ISchema {
  const BooleanSO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });
}

final class NullSO extends ISchema {
  const NullSO({
    super.title,
    super.description,
    super.examples,
    super.deprecated,
    super.extensions,
  });
}

final class AnySO extends ISchema {
  const AnySO({
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });
}

final class ListSO extends ISchema {
  const ListSO({
    required this.items,
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    this.minItems,
    this.maxItems,
    this.uniqueItems = false,
  });

  final ISchema items;
  final int? minItems;
  final int? maxItems;
  final bool uniqueItems;
}

final class MapSO extends ISchema {
  const MapSO({
    required this.values,
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    this.keyPattern,
    this.minProperties,
    this.maxProperties,
  });

  final ISchema values;
  final String? keyPattern;
  final int? minProperties;
  final int? maxProperties;
}

final class SchemaField {
  const SchemaField(this.schema, {this.required = true});

  final ISchema schema;

  final bool required;
}

final class ObjectSO extends ISchema {
  const ObjectSO({
    required this.properties,
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
    this.allowAdditionalProperties = false,
    this.additionalPropertiesSchema,
    this.minProperties,
    this.maxProperties,
  }) : assert(
         additionalPropertiesSchema == null || allowAdditionalProperties,
         'A typed additional-properties schema requires '
         'allowAdditionalProperties: true.',
       );

  final Map<String, SchemaField> properties;
  final bool allowAdditionalProperties;
  final ISchema? additionalPropertiesSchema;
  final int? minProperties;
  final int? maxProperties;
}

final class NullableSO extends ISchema {
  const NullableSO(
    this.inner, {
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final ISchema inner;
}

final class EnumSO extends ISchema {
  const EnumSO(
    this.values, {
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final List<Object?> values;
}

final class ConstSO extends ISchema {
  const ConstSO(
    this.value, {
    super.title,
    super.description,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final Object? value;
}

final class AnyOfSO extends ISchema {
  const AnyOfSO(
    this.schemas, {
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final List<ISchema> schemas;
}

final class OneOfSO extends ISchema {
  const OneOfSO(
    this.schemas, {
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final List<ISchema> schemas;
}

final class AllOfSO extends ISchema {
  const AllOfSO(
    this.schemas, {
    super.title,
    super.description,
    super.hasDefault,
    super.defaultValue,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  final List<ISchema> schemas;
}

final class RefSO extends ISchema {
  const RefSO(
    this.ref, {
    super.title,
    super.description,
    super.examples,
    super.deprecated,
    super.extensions,
  });

  const RefSO.root() : this('#');

  factory RefSO.definition(String name) {
    if (name.isEmpty || name.contains('/')) {
      throw SchemaException('Invalid definition name: "$name".');
    }
    return RefSO('#/\$defs/$name');
  }

  final String ref;
}

abstract class IStructuredOutput {
  String getSchema(ISchema schema) => _encode(schema);

  String _encode(ISchema schema) {
    return switch (schema) {
      StringSO() => _encodeString(schema),
      IntegerSO() => _encodeInteger(schema),
      NumberSO() => _encodeNumber(schema),
      DoubleSO() => _encodeDouble(schema),
      BooleanSO() => _encodeBoolean(schema),
      NullSO() => _encodeNull(schema),
      AnySO() => _encodeAny(schema),
      ListSO() => _encodeList(schema),
      MapSO() => _encodeMap(schema),
      ObjectSO() => _encodeObject(schema),
      NullableSO() => _encodeNullable(schema),
      EnumSO() => _encodeEnum(schema),
      ConstSO() => _encodeConst(schema),
      AnyOfSO() => _encodeAnyOf(schema),
      OneOfSO() => _encodeOneOf(schema),
      AllOfSO() => _encodeAllOf(schema),
      RefSO() => _encodeRef(schema),
    };
  }

  String _encodeString(StringSO schema);
  String _encodeInteger(IntegerSO schema);
  String _encodeNumber(NumberSO schema);
  String _encodeDouble(DoubleSO schema);
  String _encodeBoolean(BooleanSO schema);
  String _encodeNull(NullSO schema);
  String _encodeAny(AnySO schema);
  String _encodeList(ListSO schema);
  String _encodeMap(MapSO schema);
  String _encodeObject(ObjectSO schema);
  String _encodeNullable(NullableSO schema);
  String _encodeEnum(EnumSO schema);
  String _encodeConst(ConstSO schema);
  String _encodeAnyOf(AnyOfSO schema);
  String _encodeOneOf(OneOfSO schema);
  String _encodeAllOf(AllOfSO schema);
  String _encodeRef(RefSO schema);
}

final class SchemaViolation {
  const SchemaViolation({required this.path, required this.message});

  final String path;
  final String message;

  @override
  String toString() => '$path: $message';
}

final class SchemaValidator {
  const SchemaValidator({
    this.maxDepth = 100,
    this.acceptNullForOptionalFields = false,
  });

  final int maxDepth;

  final bool acceptNullForOptionalFields;

  List<SchemaViolation> validate(
    ISchema schema,
    Object? value, {
    Map<String, ISchema> definitions = const {},
  }) {
    final violations = <SchemaViolation>[];
    _validateValue(schema, value, r'$', schema, definitions, violations, 0);
    return List.unmodifiable(violations);
  }

  void _validateValue(
    ISchema schema,
    Object? value,
    String path,
    ISchema root,
    Map<String, ISchema> definitions,
    List<SchemaViolation> out,
    int depth,
  ) {
    if (depth > maxDepth) {
      out.add(
        SchemaViolation(
          path: path,
          message: 'Validation exceeded maximum depth $maxDepth.',
        ),
      );
      return;
    }

    void error(String message) =>
        out.add(SchemaViolation(path: path, message: message));

    switch (schema) {
      case StringSO():
        if (value is! String) {
          error('Expected string, received ${_runtimeJsonType(value)}.');
          return;
        }
        final length = value.runes.length;
        if (schema.minLength != null && length < schema.minLength!) {
          error(
            'String has $length characters; minimum is ${schema.minLength}.',
          );
        }
        if (schema.maxLength != null && length > schema.maxLength!) {
          error(
            'String has $length characters; maximum is ${schema.maxLength}.',
          );
        }
        if (schema.pattern != null) {
          try {
            if (!RegExp(schema.pattern!).hasMatch(value)) {
              error('String does not match pattern ${schema.pattern}.');
            }
          } on FormatException {
            error('Schema contains an invalid regular expression.');
          }
        }
        final lines = _lineCount(value);
        if (schema.hints.minLines != null && lines < schema.hints.minLines!) {
          error(
            'String has $lines lines; minimum is ${schema.hints.minLines}.',
          );
        }
        if (schema.hints.maxLines != null && lines > schema.hints.maxLines!) {
          error(
            'String has $lines lines; maximum is ${schema.hints.maxLines}.',
          );
        }
      case IntegerSO():
        if (value is! int) {
          error('Expected integer, received ${_runtimeJsonType(value)}.');
          return;
        }
        _validateNumber(schema, value, path, out);
      case NumberSO():
        if (value is! num) {
          error('Expected number, received ${_runtimeJsonType(value)}.');
          return;
        }
        _validateNumber(schema, value, path, out);
      case DoubleSO():
        if (value is! num) {
          error('Expected number, received ${_runtimeJsonType(value)}.');
          return;
        }
        _validateNumber(schema, value, path, out);
      case BooleanSO():
        if (value is! bool) {
          error('Expected boolean, received ${_runtimeJsonType(value)}.');
        }
      case NullSO():
        if (value != null) error('Expected null.');
      case AnySO():
        if (!_isJsonValue(value)) error('Value is not JSON-compatible.');
      case ListSO():
        if (value is! List) {
          error('Expected array, received ${_runtimeJsonType(value)}.');
          return;
        }
        if (schema.minItems != null && value.length < schema.minItems!) {
          error(
            'Array has ${value.length} items; minimum is ${schema.minItems}.',
          );
        }
        if (schema.maxItems != null && value.length > schema.maxItems!) {
          error(
            'Array has ${value.length} items; maximum is ${schema.maxItems}.',
          );
        }
        if (schema.uniqueItems) {
          for (var i = 0; i < value.length; i++) {
            for (var j = i + 1; j < value.length; j++) {
              if (_jsonDeepEquals(value[i], value[j])) {
                error('Array items at indexes $i and $j are not unique.');
              }
            }
          }
        }
        for (var i = 0; i < value.length; i++) {
          _validateValue(
            schema.items,
            value[i],
            '$path[$i]',
            root,
            definitions,
            out,
            depth + 1,
          );
        }
      case MapSO():
        if (value is! Map) {
          error('Expected object, received ${_runtimeJsonType(value)}.');
          return;
        }
        if (value.keys.any((key) => key is! String)) {
          error('JSON object keys must be strings.');
          return;
        }
        _validatePropertyCount(
          value.length,
          schema.minProperties,
          schema.maxProperties,
          path,
          out,
        );
        RegExp? keyRegex;
        if (schema.keyPattern != null) {
          try {
            keyRegex = RegExp(schema.keyPattern!);
          } on FormatException {
            error('Schema contains an invalid keyPattern.');
          }
        }
        for (final entry in value.entries) {
          final key = entry.key as String;
          if (keyRegex != null && !keyRegex.hasMatch(key)) {
            out.add(
              SchemaViolation(
                path: _propertyPath(path, key),
                message: 'Key does not match ${schema.keyPattern}.',
              ),
            );
          }
          _validateValue(
            schema.values,
            entry.value,
            _propertyPath(path, key),
            root,
            definitions,
            out,
            depth + 1,
          );
        }
      case ObjectSO():
        if (value is! Map) {
          error('Expected object, received ${_runtimeJsonType(value)}.');
          return;
        }
        if (value.keys.any((key) => key is! String)) {
          error('JSON object keys must be strings.');
          return;
        }
        _validatePropertyCount(
          value.length,
          schema.minProperties,
          schema.maxProperties,
          path,
          out,
        );
        for (final field in schema.properties.entries) {
          if (!value.containsKey(field.key)) {
            if (field.value.required) {
              out.add(
                SchemaViolation(
                  path: _propertyPath(path, field.key),
                  message: 'Required property is missing.',
                ),
              );
            }
            continue;
          }
          if (!field.value.required &&
              acceptNullForOptionalFields &&
              value[field.key] == null) {
            continue;
          }
          _validateValue(
            field.value.schema,
            value[field.key],
            _propertyPath(path, field.key),
            root,
            definitions,
            out,
            depth + 1,
          );
        }
        for (final entry in value.entries) {
          final key = entry.key as String;
          if (schema.properties.containsKey(key)) continue;
          if (!schema.allowAdditionalProperties) {
            out.add(
              SchemaViolation(
                path: _propertyPath(path, key),
                message: 'Additional property is not allowed.',
              ),
            );
          } else if (schema.additionalPropertiesSchema != null) {
            _validateValue(
              schema.additionalPropertiesSchema!,
              entry.value,
              _propertyPath(path, key),
              root,
              definitions,
              out,
              depth + 1,
            );
          }
        }
      case NullableSO():
        if (value != null) {
          _validateValue(
            schema.inner,
            value,
            path,
            root,
            definitions,
            out,
            depth + 1,
          );
        }
      case EnumSO():
        if (!schema.values.any(
          (candidate) => _jsonDeepEquals(candidate, value),
        )) {
          error('Value is not one of the allowed enum values.');
        }
      case ConstSO():
        if (!_jsonDeepEquals(schema.value, value)) {
          error('Value does not equal the required constant.');
        }
      case AnyOfSO():
        final matches = _matchingBranches(
          schema.schemas,
          value,
          path,
          root,
          definitions,
          depth,
        );
        if (matches == 0) error('Value does not match any anyOf branch.');
      case OneOfSO():
        final matches = _matchingBranches(
          schema.schemas,
          value,
          path,
          root,
          definitions,
          depth,
        );
        if (matches != 1) {
          error('Value must match exactly one oneOf branch; matched $matches.');
        }
      case AllOfSO():
        for (final child in schema.schemas) {
          _validateValue(child, value, path, root, definitions, out, depth + 1);
        }
      case RefSO():
        final target = _resolveRef(schema.ref, root, definitions);
        if (target == null) {
          error('Cannot resolve reference ${schema.ref}.');
          return;
        }
        _validateValue(target, value, path, root, definitions, out, depth + 1);
    }
  }

  int _matchingBranches(
    List<ISchema> schemas,
    Object? value,
    String path,
    ISchema root,
    Map<String, ISchema> definitions,
    int depth,
  ) {
    var matches = 0;
    for (final schema in schemas) {
      final candidate = <SchemaViolation>[];
      _validateValue(
        schema,
        value,
        path,
        root,
        definitions,
        candidate,
        depth + 1,
      );
      if (candidate.isEmpty) matches++;
    }
    return matches;
  }
}

int _lineCount(String value) => value.split(RegExp(r'\r\n|\r|\n')).length;

bool _isJsonValue(Object? value) {
  if (value == null || value is String || value is bool || value is num) {
    return true;
  }
  if (value is List) return value.every(_isJsonValue);
  if (value is Map) {
    return value.keys.every((key) => key is String) &&
        value.values.every(_isJsonValue);
  }
  return false;
}

void _requireJsonValue(Object? value, String name) {
  if (!_isJsonValue(value)) {
    throw SchemaException(
      '$name must be JSON-compatible; received ${value.runtimeType}.',
    );
  }
}

bool _jsonDeepEquals(Object? left, Object? right) {
  if (identical(left, right)) return true;
  if (left is num && right is num) return left == right;
  if (left is List && right is List) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (!_jsonDeepEquals(left[i], right[i])) return false;
    }
    return true;
  }
  if (left is Map && right is Map) {
    if (left.length != right.length) return false;
    for (final key in left.keys) {
      if (!right.containsKey(key) || !_jsonDeepEquals(left[key], right[key])) {
        return false;
      }
    }
    return true;
  }
  return left == right;
}

void _validateNumber(
  NumericSO schema,
  num value,
  String path,
  List<SchemaViolation> out,
) {
  void error(String message) =>
      out.add(SchemaViolation(path: path, message: message));
  if (schema.minimum != null && value < schema.minimum!) {
    error('Number is below minimum ${schema.minimum}.');
  }
  if (schema.maximum != null && value > schema.maximum!) {
    error('Number is above maximum ${schema.maximum}.');
  }
  if (schema.exclusiveMinimum != null && value <= schema.exclusiveMinimum!) {
    error('Number must be greater than ${schema.exclusiveMinimum}.');
  }
  if (schema.exclusiveMaximum != null && value >= schema.exclusiveMaximum!) {
    error('Number must be less than ${schema.exclusiveMaximum}.');
  }
  if (schema.multipleOf != null && !_isMultipleOf(value, schema.multipleOf!)) {
    error('Number is not a multiple of ${schema.multipleOf}.');
  }
}

bool _isMultipleOf(num value, num factor) {
  if (factor <= 0) return false;
  if (value is int && factor is int) return value % factor == 0;
  final quotient = value / factor;
  final nearest = quotient.roundToDouble();
  final tolerance = 1e-10 * math.max(1.0, quotient.abs());
  return (quotient - nearest).abs() <= tolerance;
}

void _validatePropertyCount(
  int count,
  int? minimum,
  int? maximum,
  String path,
  List<SchemaViolation> out,
) {
  if (minimum != null && count < minimum) {
    out.add(
      SchemaViolation(
        path: path,
        message: 'Object has $count properties; minimum is $minimum.',
      ),
    );
  }
  if (maximum != null && count > maximum) {
    out.add(
      SchemaViolation(
        path: path,
        message: 'Object has $count properties; maximum is $maximum.',
      ),
    );
  }
}

ISchema? _resolveRef(
  String ref,
  ISchema root,
  Map<String, ISchema> definitions,
) {
  if (ref == '#') return root;
  const prefix = '#/\$defs/';
  if (!ref.startsWith(prefix)) return null;
  return definitions[ref.substring(prefix.length)];
}

String _propertyPath(String parent, String key) {
  if (RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(key)) {
    return '$parent.$key';
  }
  final escaped = key.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  return "$parent['$escaped']";
}

String _runtimeJsonType(Object? value) {
  if (value == null) return 'null';
  if (value is String) return 'string';
  if (value is bool) return 'boolean';
  if (value is int) return 'integer';
  if (value is num) return 'number';
  if (value is List) return 'array';
  if (value is Map) return 'object';
  return value.runtimeType.toString();
}
