part of '../../fetch_exercises_view_model.dart';

OneOf2<_GeneratedMatchElementsExercise, SchemaValidationError>
_generatedMatchElementsExerciseFromJson(Map<String, dynamic> data) {
  final validationError = _generatedExerciseJsonError(
    'match-elements',
    _matchElementsOutputSchema,
    data,
  );
  if (validationError != null) return OneOf2.second(validationError);

  try {
    final matches = (data['matches'] as List)
        .map((value) {
          final item = Map<String, dynamic>.from(value as Map);
          return Match(
            leftElement: item['leftElement'] as String,
            rightElement: item['rightElement'] as String,
          );
        })
        .toList(growable: false);

    final leftElements = <String>{};
    final rightElements = <String>{};
    for (var index = 0; index < matches.length; index++) {
      final match = matches[index];
      if (!leftElements.add(match.leftElement.trim().toLowerCase())) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'match-elements',
            '\$.matches[$index].leftElement',
            'each left element must be unique.',
          ),
        );
      }
      if (!rightElements.add(match.rightElement.trim().toLowerCase())) {
        return OneOf2.second(
          _generatedExerciseSemanticError(
            'match-elements',
            '\$.matches[$index].rightElement',
            'each right element must be unique.',
          ),
        );
      }
    }

    return OneOf2.first(
      _GeneratedMatchElementsExercise(
        exerciseTask: data['exerciseTask'] as String,
        matches: matches,
      ),
    );
  } on Object catch (error) {
    return OneOf2.second(
      _generatedExerciseDecodeError('match-elements', error),
    );
  }
}

class _GeneratedMatchElementsExercise {
  final String exerciseTask;
  final List<Match> matches;

  const _GeneratedMatchElementsExercise({
    required this.exerciseTask,
    required this.matches,
  });
}
