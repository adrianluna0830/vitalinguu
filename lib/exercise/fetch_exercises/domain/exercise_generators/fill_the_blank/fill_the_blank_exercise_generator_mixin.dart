part of '../../fetch_exercises_view_model.dart';

mixin FillTheBlankExerciseGeneratorMixin
    on FetchExercisesViewModelDependenciesMixin, AIErrorRetryMixin {
  Future<FillTheBlankInput> _generateFillTheBlankExercise(
    String prompt,
    String topicId,
    String title,
    String content,
    LanguageLocale learningLanguage,
    LanguageLocale nativeLanguage,
    CEFR level,
  ) async {
    final generated = (await generateStructuredResponse(
      _ai,
      _buildFillTheBlankGenerationPrompt(
        prompt: prompt,
        title: title,
        content: content,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
        level: level,
      ),
      _fillTheBlankExerciseSchema,
      _exerciseGeneratorSystemInstruction,
    )).unwrapOrThrowStopExecution();

    return FillTheBlankInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exerciseTask: ExerciseTask(exerciseTask: generated.exerciseTask),
      fillTheBlanks: generated.fillTheBlanks,
    );
  }
}
