part of '../../fetch_exercises_view_model.dart';

mixin WriteListExerciseGeneratorMixin
    on
        FetchExercisesViewModelDependenciesMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  Future<WriteListInput> _generateWriteListExercise(
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
    final outputSchema = _createWriteListOutputSchema(
      requireContentBasedPrompt: requireContentBasedPrompt,
    );
    final exerciseSchema = AISchema<_GeneratedWriteListExercise>(
      outputSchema,
      (data) => _generatedWriteListExerciseFromJson(data, outputSchema),
    );
    final generated = (await generateStructuredResponse(
      _ai,
      _buildWriteListGenerationPrompt(
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

    return WriteListInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exercisePromptData: exercisePromptData,
      prompts: generated.prompts,
    );
  }
}
