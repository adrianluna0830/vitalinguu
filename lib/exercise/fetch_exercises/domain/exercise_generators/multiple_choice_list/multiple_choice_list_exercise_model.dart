part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedMultipleChoiceListExercise, SchemaValidationError>
_generatedMultipleChoiceListExerciseFromJson(
  Map<String, dynamic> data,
  ISchema outputSchema,
) {
  final validationError = _generatedExerciseJsonError(
    'multiple-choice-list',
    outputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    IncorrectOption incorrectOption(Map<String, dynamic> value) {
      return IncorrectOption(
        text: value['text'] as String,
        explanation: value['explanation'] as String,
      );
    }

    final options = <MultipleChoiceOptions>[];
    final questionTexts = <String>{};
    final jsonOptions = data['options'] as List;
    for (var index = 0; index < jsonOptions.length; index++) {
      final item = Map<String, dynamic>.from(jsonOptions[index] as Map);
      final correct = CorrectOption(
        text:
            Map<String, dynamic>.from(item['correctOption'] as Map)['text']
                as String,
      );
      final incorrect1 = incorrectOption(
        Map<String, dynamic>.from(item['incorrectOption1'] as Map),
      );
      final incorrect2 = incorrectOption(
        Map<String, dynamic>.from(item['incorrectOption2'] as Map),
      );
      final incorrect3 = incorrectOption(
        Map<String, dynamic>.from(item['incorrectOption3'] as Map),
      );
      final normalizedAnswers = {
        correct.text.trim().toLowerCase(),
        incorrect1.text.trim().toLowerCase(),
        incorrect2.text.trim().toLowerCase(),
        incorrect3.text.trim().toLowerCase(),
      };
      if (normalizedAnswers.length != 4) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'multiple-choice-list',
            '\$.options[$index]',
            'all four answer texts must be distinct.',
          ),
        );
      }

      final questionText = item['text'] as String;
      if (!questionTexts.add(questionText.trim().toLowerCase())) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'multiple-choice-list',
            '\$.options[$index].text',
            'question texts must be distinct.',
          ),
        );
      }
      options.add(
        MultipleChoiceOptions(
          text: questionText,
          correctOption: correct,
          incorrectOption1: incorrect1,
          incorrectOption2: incorrect2,
          incorrectOption3: incorrect3,
        ),
      );
    }

    return OneOf2.first(
      _GeneratedMultipleChoiceListExercise(
        exercisePromptData: _generatedExercisePromptDataFromJson(
          Map<String, dynamic>.from(data['exercisePromptData'] as Map),
        ),
        options: List.unmodifiable(options),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      _generatedExerciseDecodeError('multiple-choice-list', error),
    );
  }
}

class _GeneratedMultipleChoiceListExercise {
  final _GeneratedExercisePromptData exercisePromptData;
  final List<MultipleChoiceOptions> options;

  const _GeneratedMultipleChoiceListExercise({
    required this.exercisePromptData,
    required this.options,
  });
}
