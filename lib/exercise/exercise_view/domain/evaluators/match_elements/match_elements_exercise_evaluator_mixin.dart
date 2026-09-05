part of '../../exercise_view_model.dart';

mixin MatchElementsExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateMatchElementsExercise(List<Match> matches) async {
    final state = _exerciseStateSignal.value;
    if (state is! MatchElementsExerciseState) {
      _logger.e('Match-elements evaluation called for ${state.runtimeType}.');
      throw StateError(
        'The current exercise is not a match-elements exercise.',
      );
    }
    if (matches.length != state.input.matches.length) {
      _logger.e(
        'Match-elements submission count mismatch. '
        'Expected: ${state.input.matches.length}; '
        'received: ${matches.length}; exercise index: ${state.currentIndex}.',
      );
      throw StateError(
        'Expected ${state.input.matches.length} matches, '
        'received ${matches.length}.',
      );
    }

    _logger.d(
      'Starting match-elements evaluation. '
      'Exercise index: ${state.currentIndex}; matches: ${matches.length}.',
    );

    final submissions = [
      for (var index = 0; index < matches.length; index++)
        {
          'index': index,
          'leftElement': matches[index].leftElement,
          'selectedRightElement': matches[index].rightElement,
          'expectedRightElement': state.input.matches
              .firstWhere(
                (expected) =>
                    expected.leftElement == matches[index].leftElement,
              )
              .rightElement,
        },
    ];
    final schema = _createMatchElementsEvaluationSchema(matches.length);
    final generated = (await generateStructuredResponse(
      _ai,
      _buildMatchElementsEvaluationPrompt(
        state,
        submissions: submissions,
        level: _level,
        learningLanguage: _learningLanguage,
        nativeLanguage: _nativeLanguage,
      ),
      schema,
      _exerciseEvaluationSystemInstruction,
    )).valueOrStopExecution();
    if (generated == null) {
      _logger.w(
        'Match-elements evaluation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final results = <MatchFeedback>[];
    for (var index = 0; index < generated.length; index++) {
      final evaluation = generated[index];
      final isCorrect = evaluation.verdict == _EvaluationVerdict.correct;
      results.add(
        MatchFeedback(
          match: matches[index],
          explanation: isCorrect ? null : evaluation.explanation,
        ),
      );
      if (!isCorrect) {
        _recordIncorrectAnswer(
          state.input,
          '${matches[index].leftElement} → ${matches[index].rightElement}',
        );
      }
    }
    final incorrectCount = results
        .where((result) => result.explanation != null)
        .length;
    _logger.i(
      'Match-elements evaluation completed. '
      'Exercise index: ${state.currentIndex}; correct: '
      '${results.length - incorrectCount}; incorrect: $incorrectCount.',
    );
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: results);
      _logger.d(
        'Applied match-elements evaluation result to the current state.',
      );
    } else {
      _logger.w(
        'Discarded match-elements evaluation result because the exercise '
        'state changed. Original index: ${state.currentIndex}.',
      );
    }
  }
}
