part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedDialogExercise, SchemaValidationError>
_generatedDialogExerciseFromJson(Map<String, dynamic> data) {
  final validationError = _generatedExerciseJsonError(
    'dialog',
    _dialogOutputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    return OneOf2.first(
      _GeneratedDialogExercise(
        exerciseTask: data['exerciseTask'] as String,
        participantNames: List<String>.from(data['participantNames'] as List),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(_generatedExerciseDecodeError('dialog', error));
  }
}

class _GeneratedDialogExercise {
  final String exerciseTask;
  final List<String> participantNames;

  const _GeneratedDialogExercise({
    required this.exerciseTask,
    required this.participantNames,
  });
}
