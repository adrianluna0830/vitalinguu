part of '../../fetch_exercises_view_model.dart';

const _fillTheBlankOutputSchema = ObjectSO(
  title: 'Fill-the-blank exercise',
  properties: {
    'exerciseTask': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description: 'The exercise instruction in the learning language.',
      ),
    ),
    'fillTheBlanks': SchemaField(
      ListSO(
        minItems: 3,
        maxItems: 15,
        items: ObjectSO(
          properties: {
            'text': SchemaField(
              StringSO(
                minLength: 1,
                maxLength: 300,
                pattern: r'\S',
                hints: SchemaHints(maxLines: 1),
                description:
                    'The fragment content in the learning language. For hint, '
                    'return only the content that belongs inside parentheses, '
                    'without the parentheses. Do not include newline '
                    'characters; the UI wraps the full exercise according to '
                    'the available width.',
              ),
            ),
            'fillTheBlankType': SchemaField(
              EnumSO(
                ['visibleText', 'answer', 'hint'],
                description:
                    'visibleText is ordinary displayed text, answer is text '
                    'the learner must supply, and hint is parenthetical '
                    'guidance for the immediately preceding answer.',
              ),
            ),
          },
        ),
      ),
    ),
  },
);

final _fillTheBlankExerciseSchema = AISchema<_GeneratedFillTheBlankExercise>(
  _fillTheBlankOutputSchema,
  _generatedFillTheBlankExerciseFromJson,
);
