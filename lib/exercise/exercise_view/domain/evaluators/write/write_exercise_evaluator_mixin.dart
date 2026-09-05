part of '../../exercise_view_model.dart';

mixin WriteExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWriteExercise(String answer) async {
    final state = _exerciseStateSignal.value;
    if (state is! WriteExerciseState) {
      _logger.e('Write evaluation called for ${state.runtimeType}.');
      throw StateError('The current exercise is not a write exercise.');
    }

    _logger.d(
      'Starting write evaluation. Exercise index: ${state.currentIndex}; '
      'answer length: ${answer.length}.',
    );

    final generated = (await generateStructuredResponse(
      _ai,
      _buildWriteEvaluationPrompt(
        state,
        answer: answer,
        level: _level,
        learningLanguage: _learningLanguage,
        nativeLanguage: _nativeLanguage,
      ),
      _writeEvaluationSchema,
      _exerciseEvaluationSystemInstruction,
    )).valueOrStopExecution();
    if (generated == null) {
      _logger.w(
        'Write evaluation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final result = _toAnswerResult(generated);
    if (result is! CorrectAnswerResult) {
      _recordIncorrectAnswer(state.input, answer);
    }
    _logger.i(
      'Write evaluation completed. Exercise index: ${state.currentIndex}; '
      'result: ${result.runtimeType}.',
    );
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: result);
      _logger.d('Applied write evaluation result to the current state.');
    } else {
      _logger.w(
        'Discarded write evaluation result because the exercise state '
        'changed. Original index: ${state.currentIndex}.',
      );
    }
  }
}
