part of '../../fetch_exercises_view_model.dart';

mixin MatchElementsExerciseGeneratorMixin
    on FetchExercisesViewModelDependenciesMixin, AIErrorRetryMixin {
  Future<MatchElementsInput> _generateMatchElementsExercise(
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
      _buildMatchElementsGenerationPrompt(
        prompt: prompt,
        title: title,
        content: content,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
        level: level,
      ),
      _matchElementsExerciseSchema,
      _exerciseGeneratorSystemInstruction,
    )).unwrapOrThrowStopExecution();

    return MatchElementsInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exerciseTask: ExerciseTask(exerciseTask: generated.exerciseTask),
      matches: generated.matches,
    );
  }
}
