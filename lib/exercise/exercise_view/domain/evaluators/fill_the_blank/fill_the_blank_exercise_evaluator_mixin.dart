part of '../../exercise_view_model.dart';

mixin FillTheBlankExerciseEvaluatorMixin
    on ExerciseViewModelStateMixin, AIErrorRetryMixin {
  Future<void> evaluateFillTheBlankExercise(List<String> answers) async {
    final state = _exerciseStateSignal.value;
    if (state is! FillTheBlankExerciseState) {
      throw StateError(
        'The current exercise is not a fill-the-blank exercise.',
      );
    }

    final expectedAnswers = [
      for (final fragment in state.input.fillTheBlanks)
        if (fragment.fillTheBlankType == FillTheBlankType.answer) fragment.text,
    ];
    if (answers.length != expectedAnswers.length) {
      throw StateError(
        'Expected ${expectedAnswers.length} fill-the-blank answers, '
        'received ${answers.length}.',
      );
    }

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
    if (generated == null) return;

    final results = generated.map(_toBinaryAnswerResult).toList();
    for (var index = 0; index < results.length; index++) {
      if (results[index] is IncorrectBinaryAnswerResult) {
        _recordIncorrectAnswer(state.input, answers[index]);
      }
    }
    if (identical(_exerciseStateSignal.value, state)) {
      _exerciseStateSignal.value = state.copyWith(answerResult: results);
    }
  }
}
