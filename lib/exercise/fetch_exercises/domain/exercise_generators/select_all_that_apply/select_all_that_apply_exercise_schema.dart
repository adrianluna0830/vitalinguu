part of '../../fetch_exercises_view_model.dart';

const _selectAllCorrectOptionSchema = ObjectSO(
  properties: {
    'kind': SchemaField(
      EnumSO([
        'correct',
      ], description: 'Discriminator for a correct answer branch.'),
    ),
    'option': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 300,
        description: 'A correct answer in the learning language.',
      ),
    ),
  },
);

const _selectAllIncorrectOptionSchema = ObjectSO(
  properties: {
    'kind': SchemaField(
      EnumSO([
        'incorrect',
      ], description: 'Discriminator for an incorrect answer branch.'),
    ),
    'option': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 300,
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

ObjectSO _createSelectAllOutputSchema({
  required bool requireContentBasedPrompt,
}) => ObjectSO(
  title: 'Select-all-that-apply exercise',
  properties: {
    'exercisePromptData': SchemaField(
      _createExercisePromptDataSchema(
        requireContentBasedPrompt: requireContentBasedPrompt,
        contentMaxLength: 1200,
        taskMaxLength: 500,
      ),
    ),
    'options': SchemaField(
      ListSO(
        minItems: 3,
        maxItems: 8,
        uniqueItems: true,
        items: AnyOfSO([
          _selectAllCorrectOptionSchema,
          _selectAllIncorrectOptionSchema,
        ]),
      ),
    ),
  },
);
