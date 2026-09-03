part of '../../fetch_exercises_view_model.dart';

ObjectSO _createWriteListOutputSchema({
  required bool requireContentBasedPrompt,
}) => ObjectSO(
  title: 'Writing-list exercise',
  properties: {
    'exercisePromptData': SchemaField(
      _createExercisePromptDataSchema(
        requireContentBasedPrompt: requireContentBasedPrompt,
        contentMaxLength: 1800,
        taskMaxLength: 500,
      ),
    ),
    'prompts': SchemaField(
      ListSO(
        minItems: 2,
        maxItems: 5,
        uniqueItems: true,
        items: StringSO(
          minLength: 1,
          maxLength: 500,
          description:
              'One distinct writing request in the learning language. It must '
              'be self-contained for a standalone prompt or relate clearly '
              'to exerciseContent for a content-based prompt.',
        ),
      ),
    ),
  },
);
