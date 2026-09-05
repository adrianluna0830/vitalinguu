part of '../../exercise_view_model.dart';

mixin WriteListExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWriteListExercise(List<String> answers) async {
    final state = _exerciseStateSignal.value;
    if (state is! WriteListExerciseState) {
      _logger.e('Write-list evaluation called for ${state.runtimeType}.');
      throw StateError('The current exercise is not a write-list exercise.');
    }
    if (answers.length != state.input.prompts.length) {
      _logger.e(
        'Write-list answer count mismatch. '
        'Expected: ${state.input.prompts.length}; received: ${answers.length}; '
        'exercise index: ${state.currentIndex}.',
      );
      throw StateError(
        'Expected ${state.input.prompts.length} writing answers, '
        'received ${answers.length}.',
      );
    }

    _logger.d(
      'Starting write-list evaluation. '
      'Exercise index: ${state.currentIndex}; answers: ${answers.length}.',
    );

    final submissions = [
      for (var index = 0; index < answers.length; index++)
        {
          'index': index,
          'writingPrompt': state.input.prompts[index],
          'learnerAnswer': answers[index],
        },
    ];
    final schema = _createWriteListEvaluationSchema(answers.length);
    final generated = (await generateStructuredResponse(
      _ai,
      _buildWriteListEvaluationPrompt(
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
        'Write-list evaluation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final results = generated.map(_toAnswerResult).toList();
    for (var index = 0; index < results.length; index++) {
      if (results[index] is! CorrectAnswerResult) {
        _recordIncorrectAnswer(
          state.input,
          '${state.input.prompts[index]}: ${answers[index]}',
        );
      }
    }
    final correctCount = results.whereType<CorrectAnswerResult>().length;
    _logger.i(
      'Write-list evaluation completed. '
      'Exercise index: ${state.currentIndex}; correct: $correctCount; '
      'partially correct or incorrect: ${results.length - correctCount}.',
    );
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: results);
      _logger.d('Applied write-list evaluation result to the current state.');
    } else {
      _logger.w(
        'Discarded write-list evaluation result because the exercise state '
        'changed. Original index: ${state.currentIndex}.',
      );
    }
  }
}
