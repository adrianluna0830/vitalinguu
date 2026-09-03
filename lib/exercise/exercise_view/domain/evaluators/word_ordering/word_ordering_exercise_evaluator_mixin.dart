part of '../../exercise_view_model.dart';

mixin WordOrderingExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWordOrderingExercise(List<String> words) async {
    final state = _exerciseStateSignal.value;
    if (state is! WordOrderingExerciseState) {
      throw StateError('The current exercise is not a word-ordering exercise.');
    }

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
    if (generated == null) return;

    final result = _toBinaryAnswerResult(generated);
    if (result is IncorrectBinaryAnswerResult) {
      _recordIncorrectAnswer(state.input, words.join(' '));
    }
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: result);
    }
  }
}
