part of '../../exercise_view_model.dart';

mixin WriteExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWriteExercise(String answer) async {
    final state = _exerciseStateSignal.value;
    if (state is! WriteExerciseState) {
      throw StateError('The current exercise is not a write exercise.');
    }

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
    if (generated == null) return;

    final result = _toAnswerResult(generated);
    if (result is! CorrectAnswerResult) {
      _recordIncorrectAnswer(state.input, answer);
    }
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: result);
    }
  }
}
