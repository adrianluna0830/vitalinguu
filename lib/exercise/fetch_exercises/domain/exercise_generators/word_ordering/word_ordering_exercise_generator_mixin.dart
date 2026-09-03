part of '../../fetch_exercises_view_model.dart';

mixin WordOrderingExerciseGeneratorMixin
    on FetchExercisesViewModelDependenciesMixin, AIErrorRetryMixin {
  Future<WordOrderingInput> _generateWordOrderingExercise(
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
      _buildWordOrderingGenerationPrompt(
        prompt: prompt,
        title: title,
        content: content,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
        level: level,
      ),
      _wordOrderingExerciseSchema,
      _exerciseGeneratorSystemInstruction,
    )).unwrapOrThrowStopExecution();

    return WordOrderingInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exerciseTask: ExerciseTask(exerciseTask: generated.exerciseTask),
      wordsInOrder: generated.wordsInOrder,
    );
  }
}
