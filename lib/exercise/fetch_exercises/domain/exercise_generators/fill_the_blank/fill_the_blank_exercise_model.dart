part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedFillTheBlankExercise, SchemaValidationError>
_generatedFillTheBlankExerciseFromJson(Map<String, dynamic> data) {
  final validationError = _generatedExerciseJsonError(
    'fill-the-blank',
    _fillTheBlankOutputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    final fillTheBlanks = (data['fillTheBlanks'] as List)
        .map((value) {
          final item = Map<String, dynamic>.from(value as Map);
          return FillTheBlank(
            text: item['text'] as String,
            fillTheBlankType: FillTheBlankType.values.byName(
              item['fillTheBlankType'] as String,
            ),
          );
        })
        .toList(growable: false);

    if (!fillTheBlanks.any(
      (fragment) => fragment.fillTheBlankType == FillTheBlankType.answer,
    )) {
      return OneOf2.second(
        _generatedExerciseSemanticError(
          'fill-the-blank',
          r'$.fillTheBlanks',
          'at least one fragment must have fillTheBlankType "answer".',
        ),
      );
    }
    if (!fillTheBlanks.any(
      (fragment) => fragment.fillTheBlankType == FillTheBlankType.visibleText,
    )) {
      return OneOf2.second(
        _generatedExerciseSemanticError(
          'fill-the-blank',
          r'$.fillTheBlanks',
          'at least one fragment must have fillTheBlankType "visibleText".',
        ),
      );
    }

    for (var index = 0; index < fillTheBlanks.length; index++) {
      final fragment = fillTheBlanks[index];
      if (fragment.fillTheBlankType != FillTheBlankType.hint) continue;

      if (index == 0 ||
          fillTheBlanks[index - 1].fillTheBlankType !=
              FillTheBlankType.answer) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'fill-the-blank',
            '\$.fillTheBlanks[$index].fillTheBlankType',
            'a hint must immediately follow the answer it describes.',
          ),
        );
      }

      final hint = fragment.text.trim();
      if (hint.startsWith('(') || hint.endsWith(')')) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'fill-the-blank',
            '\$.fillTheBlanks[$index].text',
            'return hint content without the outer parentheses.',
          ),
        );
      }
    }

    return OneOf2.first(
      _GeneratedFillTheBlankExercise(
        exerciseTask: data['exerciseTask'] as String,
        fillTheBlanks: fillTheBlanks,
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      _generatedExerciseDecodeError('fill-the-blank', error),
    );
  }
}

class _GeneratedFillTheBlankExercise {
  final String exerciseTask;
  final List<FillTheBlank> fillTheBlanks;

  const _GeneratedFillTheBlankExercise({
    required this.exerciseTask,
    required this.fillTheBlanks,
  });
}
