part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedWriteListExercise, SchemaValidationError>
_generatedWriteListExerciseFromJson(
  Map<String, dynamic> data,
  ISchema outputSchema,
) {
  final validationError = _generatedExerciseJsonError(
    'write-list',
    outputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    return OneOf2.first(
      _GeneratedWriteListExercise(
        exercisePromptData: _generatedExercisePromptDataFromJson(
          Map<String, dynamic>.from(data['exercisePromptData'] as Map),
        ),
        prompts: List<String>.from(data['prompts'] as List),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(_generatedExerciseDecodeError('write-list', error));
  }
}

class _GeneratedWriteListExercise {
  final _GeneratedExercisePromptData exercisePromptData;
  final List<String> prompts;

  const _GeneratedWriteListExercise({
    required this.exercisePromptData,
    required this.prompts,
  });
}
