part of '../../fetch_exercises_view_model.dart';

mixin DialogExerciseGeneratorMixin
    on FetchExercisesViewModelDependenciesMixin, AIErrorRetryMixin {
  final Random _dialogRandom = Random();

  bool _getRandomBool() => _dialogRandom.nextBool();

  Future<DialogInput> _generateDialogExercise(
    String prompt,
    String topicId,
    String title,
    String content,
    PromptConfiguration promptConfiguration,
    double speechSpeed,
    LanguageLocale learningLanguage,
    LanguageLocale nativeLanguage,
    CEFR level,
  ) async {
    final generated = (await generateStructuredResponse(
      _ai,
      _buildDialogGenerationPrompt(
        prompt: prompt,
        title: title,
        content: content,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
        level: level,
      ),
      _dialogExerciseSchema,
      _exerciseGeneratorSystemInstruction,
    )).unwrapOrThrowStopExecution();

    return DialogInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      promptConfiguration: promptConfiguration,
      exerciseTask: ExerciseTask(exerciseTask: generated.exerciseTask),
      participantNames: generated.participantNames,
      startWithTyping: _getRandomBool(),
      speechSpeed: speechSpeed,
    );
  }
}
