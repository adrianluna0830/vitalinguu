part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedWriteExercise, SchemaValidationError>
_generatedWriteExerciseFromJson(
  Map<String, dynamic> data,
  ISchema outputSchema,
) {
  final validationError = _generatedExerciseJsonError(
    'write',
    outputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    return OneOf2.first(
      _GeneratedWriteExercise(
        exercisePromptData: _generatedExercisePromptDataFromJson(
          Map<String, dynamic>.from(data['exercisePromptData'] as Map),
        ),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(_generatedExerciseDecodeError('write', error));
  }
}

class _GeneratedWriteExercise {
  final _GeneratedExercisePromptData exercisePromptData;

  const _GeneratedWriteExercise({required this.exercisePromptData});
}
