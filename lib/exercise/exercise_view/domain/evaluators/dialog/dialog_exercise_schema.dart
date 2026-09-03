part of '../../exercise_view_model.dart';

AISchema<_GeneratedDialogTurn> _createDialogTurnSchema({
  required List<String> participantNames,
  required bool evaluatesLearnerMessage,
  required bool allowDialogEnd,
}) {
  final finalResultSchema = ObjectSO(
    title: 'Final dialog evaluation',
    description:
        'A holistic CEFR-based result used only when this message ends the '
        'conversation.',
    properties: {
      'status': SchemaField(
        EnumSO(const [
          'correct',
          'partiallyCorrect',
          'incorrect',
        ], description: 'The learner performance across the whole dialog.'),
      ),
      'explanation': SchemaField(
        NullableSO(
          StringSO(
            minLength: 1,
            maxLength: 1200,
            hints: SchemaHints(maxLines: 7),
            description:
                'Concise final feedback primarily in the native language.',
          ),
          description:
              'Must be null for correct and non-null for partiallyCorrect or '
              'incorrect.',
        ),
      ),
    },
  );
  final userFeedbackSchema = ObjectSO(
    title: 'Current learner message feedback',
    properties: {
      'status': SchemaField(
        EnumSO(
          const ['good', 'partial', 'bad'],
          description:
              'The verdict for grammar, meaning-relevant spelling, and '
              'grammatical or idiomatic naturalness in only the current '
              'learner message. CEFR may adjust error severity but cannot '
              'redefine whether an error exists.',
        ),
      ),
      'explanation': SchemaField(
        NullableSO(
          StringSO(
            minLength: 1,
            maxLength: 1000,
            hints: SchemaHints(maxLines: 6),
            description:
                'Short, self-contained feedback about grammar, incorrect word '
                'choice, meaning-relevant spelling, unnatural phrasing, or '
                'wording that is clearly outdated in ordinary modern '
                'conversation. '
                'Identify the problematic part, provide a corrected '
                'learning-language version, and explain in plain native-language '
                'words why the correction is needed and how the correct form is '
                'built. A rule name may be included, but the explanation must '
                'not depend on the learner knowing linguistic terminology. Do '
                'not discuss harmless punctuation, content, relevance, task '
                'completion, register, or the quality of the learner\'s idea.',
          ),
          description: 'Must be null for good and non-null for partial or bad.',
        ),
      ),
    },
  );
  final outputSchema = ObjectSO(
    title: 'Dialog conversation turn',
    description:
        'Feedback for the current learner message, when present, followed by '
        'one natural batch of AI-controlled participant messages.',
    properties: {
      'userFeedback': SchemaField(
        NullableSO(
          userFeedbackSchema,
          description: evaluatesLearnerMessage
              ? 'Required feedback for the current learner message.'
              : 'Must be null because this is the initial bot turn.',
        ),
      ),
      'botMessages': SchemaField(
        ListSO(
          minItems: 1,
          maxItems: 8,
          items: ObjectSO(
            title: 'Bot dialog message',
            properties: {
              'name': SchemaField(
                EnumSO(
                  participantNames,
                  description:
                      'The exact name of the AI-controlled participant '
                      'sending this message.',
                ),
              ),
              'message': SchemaField(
                StringSO(
                  minLength: 1,
                  maxLength: 1200,
                  hints: SchemaHints(maxLines: 8),
                  description:
                      'A natural message written in the learning language.',
                ),
              ),
              'dialogOverResult': SchemaField(
                NullableSO(
                  finalResultSchema,
                  description: allowDialogEnd
                      ? 'Keep null unless this participant genuinely ends the '
                            'dialog now. Only the last message may end it.'
                      : 'Must be null on the initial bot turn.',
                ),
              ),
            },
          ),
        ),
      ),
    },
  );

  return AISchema(
    outputSchema,
    (data) => _generatedDialogTurnFromJson(
      data,
      outputSchema,
      participantNames: participantNames,
      evaluatesLearnerMessage: evaluatesLearnerMessage,
      allowDialogEnd: allowDialogEnd,
    ),
  );
}

OneOf2<_GeneratedDialogTurn, SchemaValidationError>
_generatedDialogTurnFromJson(
  Map<String, dynamic> data,
  ISchema schema, {
  required List<String> participantNames,
  required bool evaluatesLearnerMessage,
  required bool allowDialogEnd,
}) {
  final validationError = _evaluationJsonError(schema, data);
  if (validationError != null) return OneOf2.second(validationError);

  try {
    final rawFeedback = data['userFeedback'];
    if (evaluatesLearnerMessage && rawFeedback == null) {
      throw const FormatException(
        r'$.userFeedback is required after a learner message.',
      );
    }
    if (!evaluatesLearnerMessage && rawFeedback != null) {
      throw const FormatException(
        r'$.userFeedback must be null on the initial bot turn.',
      );
    }

    final userFeedback = rawFeedback == null
        ? null
        : _decodeDialogUserFeedback(
            Map<String, dynamic>.from(rawFeedback as Map),
          );
    final rawBotMessages = data['botMessages'] as List;
    final botMessages = <_GeneratedDialogBotMessage>[];

    for (var index = 0; index < rawBotMessages.length; index++) {
      final rawMessage = Map<String, dynamic>.from(
        rawBotMessages[index] as Map,
      );
      final name = rawMessage['name'] as String;
      if (!participantNames.contains(name)) {
        throw FormatException(
          '\$.botMessages[$index].name is not a configured participant.',
        );
      }

      final rawFinalResult = rawMessage['dialogOverResult'];
      final finalResult = rawFinalResult == null
          ? null
          : _decodeDialogFinalResult(
              Map<String, dynamic>.from(rawFinalResult as Map),
            );
      if (finalResult != null && !allowDialogEnd) {
        throw FormatException(
          '\$.botMessages[$index].dialogOverResult must be null on the '
          'initial bot turn.',
        );
      }
      if (finalResult != null && index != rawBotMessages.length - 1) {
        throw FormatException(
          '\$.botMessages[$index].dialogOverResult can only be set on the '
          'last bot message.',
        );
      }

      botMessages.add(
        _GeneratedDialogBotMessage(
          name: name,
          message: rawMessage['message'] as String,
          dialogOverResult: finalResult,
        ),
      );
    }

    return OneOf2.first(
      _GeneratedDialogTurn(
        userFeedback: userFeedback,
        botMessages: List.unmodifiable(botMessages),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      SchemaValidationError(
        message: 'Could not decode dialog turn JSON: $error',
      ),
    );
  }
}

_GeneratedDialogUserFeedback _decodeDialogUserFeedback(
  Map<String, dynamic> data,
) {
  final verdict = _DialogUserFeedbackVerdict.values.byName(
    data['status'] as String,
  );
  final explanation = data['explanation'] as String?;
  if (verdict == _DialogUserFeedbackVerdict.good && explanation != null) {
    throw const FormatException(
      r'$.userFeedback.explanation must be null for good.',
    );
  }
  if (verdict != _DialogUserFeedbackVerdict.good &&
      (explanation == null || explanation.trim().isEmpty)) {
    throw const FormatException(
      r'$.userFeedback.explanation is required for partial or bad.',
    );
  }

  return _GeneratedDialogUserFeedback(
    verdict: verdict,
    explanation: explanation,
  );
}

_GeneratedDialogFinalResult _decodeDialogFinalResult(
  Map<String, dynamic> data,
) {
  final verdict = _DialogFinalVerdict.values.byName(data['status'] as String);
  final explanation = data['explanation'] as String?;
  if (verdict == _DialogFinalVerdict.correct && explanation != null) {
    throw const FormatException(
      'dialogOverResult.explanation must be null for correct.',
    );
  }
  if (verdict != _DialogFinalVerdict.correct &&
      (explanation == null || explanation.trim().isEmpty)) {
    throw const FormatException(
      'dialogOverResult.explanation is required for a non-correct result.',
    );
  }

  return _GeneratedDialogFinalResult(
    verdict: verdict,
    explanation: explanation,
  );
}
