part of '../../exercise_view_model.dart';

mixin WordOrderingExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWordOrderingExercise(List<String> words) async {
    final state = _exerciseStateSignal.value;
    if (state is! WordOrderingExerciseState) {
      _logger.e('Word-ordering evaluation called for ${state.runtimeType}.');
      throw StateError('The current exercise is not a word-ordering exercise.');
    }

    _logger.d(
      'Starting word-ordering evaluation. '
      'Exercise index: ${state.currentIndex}; word count: ${words.length}.',
    );

    final generated = (await generateStructuredResponse(
      _ai,
      _buildWordOrderingEvaluationPrompt(
        state,
        words: words,
        level: _level,
        learningLanguage: _learningLanguage,
        nativeLanguage: _nativeLanguage,
      ),
      _wordOrderingEvaluationSchema,
      _exerciseEvaluationSystemInstruction,
    )).valueOrStopExecution();
    if (generated == null) {
      _logger.w(
        'Word-ordering evaluation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final result = _toBinaryAnswerResult(generated);
    if (result is IncorrectBinaryAnswerResult) {
      _recordIncorrectAnswer(state.input, words.join(' '));
    }
    _logger.i(
      'Word-ordering evaluation completed. '
      'Exercise index: ${state.currentIndex}; result: ${result.runtimeType}.',
    );
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: result);
      _logger.d(
        'Applied word-ordering evaluation result to the current state.',
      );
    } else {
      _logger.w(
        'Discarded word-ordering evaluation result because the exercise '
        'state changed. Original index: ${state.currentIndex}.',
      );
    }
  }
}
