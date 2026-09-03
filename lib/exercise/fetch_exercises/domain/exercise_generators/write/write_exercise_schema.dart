part of '../../fetch_exercises_view_model.dart';

ObjectSO _createWriteOutputSchema({required bool requireContentBasedPrompt}) =>
    ObjectSO(
      title: 'Writing exercise',
      properties: {
        'exercisePromptData': SchemaField(
          _createExercisePromptDataSchema(
            requireContentBasedPrompt: requireContentBasedPrompt,
            contentMaxLength: 1600,
            taskMaxLength: 700,
          ),
        ),
      },
    );
