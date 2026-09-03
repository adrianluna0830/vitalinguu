part of '../../exercise_view_model.dart';

mixin WriteListExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateWriteListExercise(List<String> answers) async {
    final state = _exerciseStateSignal.value;
    if (state is! WriteListExerciseState) {
      throw StateError('The current exercise is not a write-list exercise.');
    }
    if (answers.length != state.input.prompts.length) {
      throw StateError(
        'Expected ${state.input.prompts.length} writing answers, '
        'received ${answers.length}.',
      );
    }

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
    if (generated == null) return;

    final results = generated.map(_toAnswerResult).toList();
    for (var index = 0; index < results.length; index++) {
      if (results[index] is! CorrectAnswerResult) {
        _recordIncorrectAnswer(
          state.input,
          '${state.input.prompts[index]}: ${answers[index]}',
        );
      }
    }
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: results);
    }
  }
}
