part of '../../fetch_exercises_view_model.dart';

mixin SelectAllThatApplyExerciseGeneratorMixin
    on
        FetchExercisesViewModelDependenciesMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  Future<SelectAllThatApplyInput> _generateSelectAllThatApplyExercise(
    String prompt,
    String topicId,
    String title,
    String content,
    ExerciseAudioGenerationConfiguration audioGenerationConfiguration,
    LanguageLocale learningLanguage,
    LanguageLocale nativeLanguage,
    CEFR level,
  ) async {
    final requireContentBasedPrompt = audioGenerationConfiguration.isAudio;
    final outputSchema = _createSelectAllOutputSchema(
      requireContentBasedPrompt: requireContentBasedPrompt,
    );
    final exerciseSchema = AISchema<_GeneratedSelectAllExercise>(
      outputSchema,
      (data) => _generatedSelectAllExerciseFromJson(data, outputSchema),
    );
    final generated = (await generateStructuredResponse(
      _ai,
      _buildSelectAllGenerationPrompt(
        prompt: prompt,
        title: title,
        content: content,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
        level: level,
        requireContentBasedPrompt: requireContentBasedPrompt,
      ),
      exerciseSchema,
      _exerciseGeneratorSystemInstruction,
    )).unwrapOrThrowStopExecution();

    final exercisePromptData = (await _buildExercisePromptData(
      generated: generated.exercisePromptData,
      configuration: audioGenerationConfiguration,
      learningLanguage: learningLanguage,
      textToSpeech: _textToSpeech,
      audioPlayer: _audioPlayer,
      synthesizeSpeech: synthesizeSpeech,
    )).unwrapOrThrowStopExecution();

    return SelectAllThatApplyInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exercisePromptData: exercisePromptData,
      options: generated.options,
    );
  }
}
