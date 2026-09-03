part of '../../fetch_exercises_view_model.dart';

const _multipleChoiceListIncorrectOptionSchema = ObjectSO(
  properties: {
    'text': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 250,
        description:
            'A plausible but incorrect answer in the learning language.',
      ),
    ),
    'explanation': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description: 'Why this answer is wrong, in the native language.',
      ),
    ),
  },
);

const _multipleChoiceListItemSchema = ObjectSO(
  properties: {
    'text': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description:
            'One distinct question in the learning language. It must be '
            'self-contained for a standalone prompt or answerable from '
            'exerciseContent for a content-based prompt, and it must not '
            'reveal an answer.',
      ),
    ),
    'correctOption': SchemaField(
      ObjectSO(
        properties: {
          'text': SchemaField(
            StringSO(
              minLength: 1,
              maxLength: 250,
              description:
                  'The only correct answer to this question, in the learning '
                  'language.',
            ),
          ),
        },
      ),
    ),
    'incorrectOption1': SchemaField(_multipleChoiceListIncorrectOptionSchema),
    'incorrectOption2': SchemaField(_multipleChoiceListIncorrectOptionSchema),
    'incorrectOption3': SchemaField(_multipleChoiceListIncorrectOptionSchema),
  },
);

ObjectSO _createMultipleChoiceListOutputSchema({
  required bool requireContentBasedPrompt,
}) => ObjectSO(
  title: 'Multiple-choice-list exercise',
  properties: {
    'exercisePromptData': SchemaField(
      _createExercisePromptDataSchema(
        requireContentBasedPrompt: requireContentBasedPrompt,
        contentMaxLength: 1800,
        taskMaxLength: 500,
      ),
    ),
    'options': SchemaField(
      ListSO(
        minItems: 2,
        maxItems: 5,
        uniqueItems: true,
        items: _multipleChoiceListItemSchema,
      ),
    ),
  },
);
