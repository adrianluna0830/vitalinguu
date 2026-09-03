part of '../exercise_view_model.dart';

const _exerciseEvaluationSystemInstruction =
    'You are a careful language teacher evaluating one learner submission. '
    'Apply the requested CEFR standard fairly, accept valid linguistic '
    'alternatives, and do not invent requirements absent from the task. '
    'Return only the structured response requested by the schema.';

enum _EvaluationVerdict { correct, partiallyCorrect, incorrect }

class _GeneratedEvaluation {
  final int? index;
  final _EvaluationVerdict verdict;
  final String? explanation;

  const _GeneratedEvaluation({
    required this.index,
    required this.verdict,
    required this.explanation,
  });
}

AISchema<_GeneratedEvaluation> _createSingleEvaluationSchema({
  required bool allowPartial,
}) {
  final outputSchema = _evaluationObjectSchema(
    allowPartial: allowPartial,
    includeIndex: false,
  );
  return AISchema(
    outputSchema,
    (data) => _singleEvaluationFromJson(
      data,
      outputSchema,
      allowPartial: allowPartial,
    ),
  );
}

AISchema<List<_GeneratedEvaluation>> _createIndexedEvaluationSchema(
  int resultCount, {
  required bool allowPartial,
}) {
  final outputSchema = ObjectSO(
    title: 'Indexed exercise evaluation',
    properties: {
      'results': SchemaField(
        ListSO(
          minItems: resultCount,
          maxItems: resultCount,
          uniqueItems: true,
          items: _evaluationObjectSchema(
            allowPartial: allowPartial,
            includeIndex: true,
            maximumIndex: resultCount - 1,
          ),
        ),
      ),
    },
  );
  return AISchema(
    outputSchema,
    (data) => _indexedEvaluationFromJson(
      data,
      outputSchema,
      resultCount,
      allowPartial: allowPartial,
    ),
  );
}

ObjectSO _evaluationObjectSchema({
  required bool allowPartial,
  required bool includeIndex,
  int? maximumIndex,
}) {
  return ObjectSO(
    properties: {
      if (includeIndex)
        'index': SchemaField(
          IntegerSO(
            minimum: 0,
            maximum: maximumIndex,
            description: 'The unchanged zero-based submission index.',
          ),
        ),
      'status': SchemaField(
        EnumSO(
          allowPartial
              ? const ['correct', 'partiallyCorrect', 'incorrect']
              : const ['correct', 'incorrect'],
          description: 'The learner submission verdict.',
        ),
      ),
      'explanation': SchemaField(
        NullableSO(
          StringSO(
            minLength: 1,
            maxLength: 1000,
            hints: SchemaHints(maxLines: 6),
            description:
                'Actionable feedback in the native language. Include '
                'learning-language corrections or examples when useful.',
          ),
          description:
              'Must be null for correct and non-null for any other status.',
        ),
      ),
    },
  );
}

OneOf2<_GeneratedEvaluation, SchemaValidationError> _singleEvaluationFromJson(
  Map<String, dynamic> data,
  ISchema schema, {
  required bool allowPartial,
}) {
  final validationError = _evaluationJsonError(schema, data);
  if (validationError != null) return OneOf2.second(validationError);

  try {
    return OneOf2.first(
      _decodeEvaluation(
        data,
        r'$',
        allowPartial: allowPartial,
        includeIndex: false,
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      SchemaValidationError(
        message: 'Could not decode exercise evaluation JSON: $error',
      ),
    );
  }
}

OneOf2<List<_GeneratedEvaluation>, SchemaValidationError>
_indexedEvaluationFromJson(
  Map<String, dynamic> data,
  ISchema schema,
  int expectedResultCount, {
  required bool allowPartial,
}) {
  final validationError = _evaluationJsonError(schema, data);
  if (validationError != null) return OneOf2.second(validationError);

  try {
    final results = <_GeneratedEvaluation>[];
    final indexes = <int>{};
    final jsonResults = data['results'] as List;
    for (var position = 0; position < jsonResults.length; position++) {
      final result = _decodeEvaluation(
        Map<String, dynamic>.from(jsonResults[position] as Map),
        '\$.results[$position]',
        allowPartial: allowPartial,
        includeIndex: true,
      );
      if (!indexes.add(result.index!)) {
        throw FormatException(
          '\$.results[$position].index duplicates index ${result.index}.',
        );
      }
      results.add(result);
    }

    final missingIndexes = [
      for (var index = 0; index < expectedResultCount; index++)
        if (!indexes.contains(index)) index,
    ];
    if (missingIndexes.isNotEmpty) {
      throw FormatException(
        '\$.results is missing indexes ${missingIndexes.join(', ')}.',
      );
    }

    results.sort((first, second) => first.index!.compareTo(second.index!));
    return OneOf2.first(List.unmodifiable(results));
  } on Object catch (error) {
    return OneOf2.second(
      SchemaValidationError(
        message: 'Could not decode indexed exercise evaluation JSON: $error',
      ),
    );
  }
}

_GeneratedEvaluation _decodeEvaluation(
  Map<String, dynamic> data,
  String path, {
  required bool allowPartial,
  required bool includeIndex,
}) {
  final verdict = _EvaluationVerdict.values.byName(data['status'] as String);
  final explanation = data['explanation'] as String?;

  if (!allowPartial && verdict == _EvaluationVerdict.partiallyCorrect) {
    throw FormatException('$path.status cannot be partiallyCorrect.');
  }
  if (verdict == _EvaluationVerdict.correct && explanation != null) {
    throw FormatException('$path.explanation must be null for correct.');
  }
  if (verdict != _EvaluationVerdict.correct &&
      (explanation == null || explanation.trim().isEmpty)) {
    throw FormatException(
      '$path.explanation is required when the answer is not correct.',
    );
  }

  return _GeneratedEvaluation(
    index: includeIndex ? data['index'] as int : null,
    verdict: verdict,
    explanation: explanation,
  );
}

SchemaValidationError? _evaluationJsonError(
  ISchema schema,
  Map<String, dynamic> data,
) {
  final violations = const SchemaValidator().validate(schema, data);
  if (violations.isEmpty) return null;

  final details = violations.take(8).join('; ');
  final remaining = violations.length - 8;
  return SchemaValidationError(
    message:
        'Invalid exercise evaluation JSON: '
        '$details${remaining > 0 ? '; and $remaining more' : ''}.',
  );
}

String _evaluationPromptContext(
  ExerciseInput input, {
  required String exerciseType,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) {
  return '''
Exercise type: $exerciseType
Topic title: ${jsonEncode(input.topicTitle)}
Topic content: ${jsonEncode(input.topicContent)}
CEFR level used for grading: ${level.name.toUpperCase()}
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native feedback language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})

Grade against the task and the ${level.name.toUpperCase()} CEFR expectations. Feedback must be
primarily in ${nativeLanguage.fullName}. Use ${learningLanguage.fullName} only
for quoted corrections, target forms, or examples that help the learner.
''';
}

BinaryAnswerResult _toBinaryAnswerResult(_GeneratedEvaluation evaluation) {
  return switch (evaluation.verdict) {
    _EvaluationVerdict.correct => CorrectBinaryAnswerResult(),
    _EvaluationVerdict.incorrect => IncorrectBinaryAnswerResult(
      evaluation.explanation!,
    ),
    _EvaluationVerdict.partiallyCorrect => throw StateError(
      'A binary evaluation cannot be partially correct.',
    ),
  };
}

AnswerResult _toAnswerResult(_GeneratedEvaluation evaluation) {
  return switch (evaluation.verdict) {
    _EvaluationVerdict.correct => CorrectAnswerResult(),
    _EvaluationVerdict.partiallyCorrect => PartiallyCorrectAnswerResult(
      evaluation.explanation!,
    ),
    _EvaluationVerdict.incorrect => IncorrectAnswerResult(
      evaluation.explanation!,
    ),
  };
}

extension _GeneratedEvaluationResponse<T> on OneOf2<T, StopExecution> {
  T? valueOrStopExecution() {
    return when(first: (value) => value, second: (_) => null);
  }
}
