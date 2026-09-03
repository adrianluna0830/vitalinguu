part of '../../fetch_exercises_view_model.dart';

const _matchElementsOutputSchema = ObjectSO(
  title: 'Match-elements exercise',
  properties: {
    'exerciseTask': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description: 'The matching instruction in the learning language.',
      ),
    ),
    'matches': SchemaField(
      ListSO(
        minItems: 3,
        maxItems: 8,
        uniqueItems: true,
        items: ObjectSO(
          properties: {
            'leftElement': SchemaField(
              StringSO(
                minLength: 1,
                maxLength: 180,
                description: 'The learning-language side of the pair.',
              ),
            ),
            'rightElement': SchemaField(
              StringSO(
                minLength: 1,
                maxLength: 180,
                description:
                    'The matching definition, meaning, completion, response, '
                    'or equivalent in the learning language.',
              ),
            ),
          },
        ),
      ),
    ),
  },
);

final _matchElementsExerciseSchema = AISchema<_GeneratedMatchElementsExercise>(
  _matchElementsOutputSchema,
  _generatedMatchElementsExerciseFromJson,
);
