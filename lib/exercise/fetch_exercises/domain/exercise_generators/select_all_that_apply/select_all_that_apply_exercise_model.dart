part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedSelectAllExercise, SchemaValidationError>
_generatedSelectAllExerciseFromJson(
  Map<String, dynamic> data,
  ISchema outputSchema,
) {
  final validationError = _generatedExerciseJsonError(
    'select-all-that-apply',
    outputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    final options = <SelectAllThatApplyExerciseOption>[];
    final optionTexts = <String>{};
    var correctCount = 0;
    var incorrectCount = 0;
    final jsonOptions = data['options'] as List;
    for (var index = 0; index < jsonOptions.length; index++) {
      final item = Map<String, dynamic>.from(jsonOptions[index] as Map);
      final option = item['option'] as String;
      if (!optionTexts.add(option.trim().toLowerCase())) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'select-all-that-apply',
            '\$.options[$index].option',
            'option texts must be distinct.',
          ),
        );
      }

      switch (item['kind']) {
        case 'correct':
          correctCount++;
          options.add(SelectAllThatApplyCorrectOption(option: option));
        case 'incorrect':
          incorrectCount++;
          options.add(
            SelectAllThatApplyIncorrectOption(
              option: option,
              explanation: item['explanation'] as String,
            ),
          );
        case final unknownKind:
          return OneOf2.second(
            _generatedExerciseSemanticError(
              'select-all-that-apply',
              '\$.options[$index].kind',
              'unknown oneOf discriminator "$unknownKind".',
            ),
          );
      }
    }

    if (correctCount == 0 || incorrectCount == 0) {
      return OneOf2.second(
        _generatedExerciseSemanticError(
          'select-all-that-apply',
          r'$.options',
          'the oneOf list must contain at least one correct and one incorrect branch.',
        ),
      );
    }

    return OneOf2.first(
      _GeneratedSelectAllExercise(
        exercisePromptData: _generatedExercisePromptDataFromJson(
          Map<String, dynamic>.from(data['exercisePromptData'] as Map),
        ),
        options: List.unmodifiable(options),
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      _generatedExerciseDecodeError('select-all-that-apply', error),
    );
  }
}

class _GeneratedSelectAllExercise {
  final _GeneratedExercisePromptData exercisePromptData;
  final List<SelectAllThatApplyExerciseOption> options;

  const _GeneratedSelectAllExercise({
    required this.exercisePromptData,
    required this.options,
  });
}
