part of '../../exercise_view_model.dart';

mixin FillTheBlankExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateFillTheBlankExercise(List<String> answers) async {
    final state = _exerciseStateSignal.value;
    if (state is! FillTheBlankExerciseState) {
      _logger.e('Fill-the-blank evaluation called for ${state.runtimeType}.');
      throw StateError(
        'The current exercise is not a fill-the-blank exercise.',
      );
    }

    final expectedAnswers = [
      for (final fragment in state.input.fillTheBlanks)
        if (fragment.fillTheBlankType == FillTheBlankType.answer) fragment.text,
    ];
    if (answers.length != expectedAnswers.length) {
      _logger.e(
        'Fill-the-blank answer count mismatch. '
        'Expected: ${expectedAnswers.length}; received: ${answers.length}; '
        'exercise index: ${state.currentIndex}.',
      );
      throw StateError(
        'Expected ${expectedAnswers.length} fill-the-blank answers, '
        'received ${answers.length}.',
      );
    }

    _logger.d(
      'Starting fill-the-blank evaluation. '
      'Exercise index: ${state.currentIndex}; answers: ${answers.length}.',
    );

    final submissions = [
      for (var index = 0; index < answers.length; index++)
        {
          'index': index,
          'expectedAnswer': expectedAnswers[index],
          'learnerAnswer': answers[index],
        },
    ];
    final completedText = state.input.fillTheBlanks
        .where((fragment) => fragment.fillTheBlankType != FillTheBlankType.hint)
        .map((fragment) => fragment.text)
        .join();
    final schema = _createFillTheBlankEvaluationSchema(answers.length);
    final generated = (await generateStructuredResponse(
      _ai,
      _buildFillTheBlankEvaluationPrompt(
        state,
        completedText: completedText,
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
        'Fill-the-blank evaluation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final results = generated.map(_toBinaryAnswerResult).toList();
    for (var index = 0; index < results.length; index++) {
      if (results[index] is IncorrectBinaryAnswerResult) {
        _recordIncorrectAnswer(state.input, answers[index]);
      }
    }
    final incorrectCount = results
        .whereType<IncorrectBinaryAnswerResult>()
        .length;
    _logger.i(
      'Fill-the-blank evaluation completed. '
      'Exercise index: ${state.currentIndex}; correct: '
      '${results.length - incorrectCount}; incorrect: $incorrectCount.',
    );
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: results);
      _logger.d(
        'Applied fill-the-blank evaluation result to the current state.',
      );
    } else {
      _logger.w(
        'Discarded fill-the-blank evaluation result because the exercise '
        'state changed. Original index: ${state.currentIndex}.',
      );
    }
  }
}
