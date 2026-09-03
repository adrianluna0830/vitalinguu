part of '../../fetch_exercises_view_model.dart';

const _wordOrderingOutputSchema = ObjectSO(
  title: 'Word-ordering exercise',
  properties: {
    'exerciseTask': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description: 'The ordering instruction in the learning language.',
      ),
    ),
    'wordsInOrder': SchemaField(
      ListSO(
        minItems: 3,
        maxItems: 20,
        items: StringSO(
          minLength: 1,
          maxLength: 80,
          description:
              'One learning-language token of the answer in its correct order.',
        ),
      ),
    ),
  },
);

final _wordOrderingExerciseSchema = AISchema<_GeneratedWordOrderingExercise>(
  _wordOrderingOutputSchema,
  _generatedWordOrderingExerciseFromJson,
);
