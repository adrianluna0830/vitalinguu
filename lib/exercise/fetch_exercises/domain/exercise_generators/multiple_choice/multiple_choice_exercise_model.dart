part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedMultipleChoiceExercise, SchemaValidationError>
_generatedMultipleChoiceExerciseFromJson(
  Map<String, dynamic> data,
  ISchema outputSchema,
) {
  final validationError = _generatedExerciseJsonError(
    'multiple-choice',
    outputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    CorrectOption correctOption(Map<String, dynamic> value) {
      return CorrectOption(text: value['text'] as String);
    }

    IncorrectOption incorrectOption(Map<String, dynamic> value) {
      return IncorrectOption(
        text: value['text'] as String,
        explanation: value['explanation'] as String,
      );
    }

    final correct = correctOption(
      Map<String, dynamic>.from(data['correctOption'] as Map),
    );
    final incorrect1 = incorrectOption(
      Map<String, dynamic>.from(data['incorrectOption1'] as Map),
    );
    final incorrect2 = incorrectOption(
      Map<String, dynamic>.from(data['incorrectOption2'] as Map),
    );
    final incorrect3 = incorrectOption(
      Map<String, dynamic>.from(data['incorrectOption3'] as Map),
    );
    final normalizedOptions = {
      correct.text.trim().toLowerCase(),
      incorrect1.text.trim().toLowerCase(),
      incorrect2.text.trim().toLowerCase(),
      incorrect3.text.trim().toLowerCase(),
    };
    if (normalizedOptions.length != 4) {
      return OneOf2.second(
        _generatedExerciseSemanticError(
          'multiple-choice',
          r'$.correctOption/incorrectOption1/incorrectOption2/incorrectOption3',
          'all four option texts must be distinct.',
        ),
      );
    }

    return OneOf2.first(
      _GeneratedMultipleChoiceExercise(
        exercisePromptData: _generatedExercisePromptDataFromJson(
          Map<String, dynamic>.from(data['exercisePromptData'] as Map),
        ),
        correctOption: correct,
        incorrectOption1: incorrect1,
        incorrectOption2: incorrect2,
        incorrectOption3: incorrect3,
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      _generatedExerciseDecodeError('multiple-choice', error),
    );
  }
}

class _GeneratedMultipleChoiceExercise {
  final _GeneratedExercisePromptData exercisePromptData;
  final CorrectOption correctOption;
  final IncorrectOption incorrectOption1;
  final IncorrectOption incorrectOption2;
  final IncorrectOption incorrectOption3;

  const _GeneratedMultipleChoiceExercise({
    required this.exercisePromptData,
    required this.correctOption,
    required this.incorrectOption1,
    required this.incorrectOption2,
    required this.incorrectOption3,
  });
}
