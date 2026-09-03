part of '../../fetch_exercises_view_model.dart';

const _dialogOutputSchema = ObjectSO(
  title: 'Dialog exercise',
  description: 'A role-play exercise for a language learner.',
  properties: {
    'exerciseTask': SchemaField(
      StringSO(
        minLength: 1,
        maxLength: 500,
        description:
            'A concise role-play instruction in the learning language. It '
            'states only the situation, learner role, communicative goal, and '
            'necessary constraints. It contains no example or model dialog, '
            'sample utterance, suggested response, script, or answer.',
      ),
    ),
    'participantNames': SchemaField(
      ListSO(
        minItems: 1,
        maxItems: 4,
        uniqueItems: true,
        items: StringSO(
          minLength: 1,
          maxLength: 80,
          description: 'A natural name for one AI-controlled participant.',
        ),
      ),
    ),
  },
);

final _dialogExerciseSchema = AISchema<_GeneratedDialogExercise>(
  _dialogOutputSchema,
  _generatedDialogExerciseFromJson,
);
