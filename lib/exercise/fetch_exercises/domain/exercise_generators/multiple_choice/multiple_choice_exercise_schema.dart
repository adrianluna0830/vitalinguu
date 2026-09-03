part of '../../fetch_exercises_view_model.dart';

ObjectSO _createMultipleChoiceOutputSchema({
  required bool requireContentBasedPrompt,
}) => ObjectSO(
  title: 'Multiple-choice exercise',
  properties: {
    'exercisePromptData': SchemaField(
      _createExercisePromptDataSchema(
        requireContentBasedPrompt: requireContentBasedPrompt,
        contentMaxLength: 1200,
        taskMaxLength: 500,
      ),
    ),
    'correctOption': SchemaField(
      ObjectSO(
        properties: {
          'text': SchemaField(
            StringSO(
              minLength: 1,
              maxLength: 250,
              description: 'The only correct answer, in the learning language.',
            ),
          ),
        },
      ),
    ),
    'incorrectOption1': SchemaField(_multipleChoiceIncorrectOptionSchema),
    'incorrectOption2': SchemaField(_multipleChoiceIncorrectOptionSchema),
    'incorrectOption3': SchemaField(_multipleChoiceIncorrectOptionSchema),
  },
);

const _multipleChoiceIncorrectOptionSchema = ObjectSO(
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
        description: 'Why this option is wrong, in the native language.',
      ),
    ),
  },
);
