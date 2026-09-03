part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedWordOrderingExercise, SchemaValidationError>
_generatedWordOrderingExerciseFromJson(Map<String, dynamic> data) {
  final validationError = _generatedExerciseJsonError(
    'word-ordering',
    _wordOrderingOutputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    return OneOf2.first(
      _GeneratedWordOrderingExercise(
        exerciseTask: data['exerciseTask'] as String,
        wordsInOrder: List<String>.from(data['wordsInOrder'] as List),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(_generatedExerciseDecodeError('word-ordering', error));
  }
}

class _GeneratedWordOrderingExercise {
  final String exerciseTask;
  final List<String> wordsInOrder;

  const _GeneratedWordOrderingExercise({
    required this.exerciseTask,
    required this.wordsInOrder,
  });
}
