part of '../../fetch_exercises_view_model.dart';

mixin WriteExerciseGeneratorMixin
    on
        FetchExercisesViewModelDependenciesMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  Future<WriteInput> _generateWriteExercise(
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
    final outputSchema = _createWriteOutputSchema(
      requireContentBasedPrompt: requireContentBasedPrompt,
    );
    final exerciseSchema = AISchema<_GeneratedWriteExercise>(
      outputSchema,
      (data) => _generatedWriteExerciseFromJson(data, outputSchema),
    );
    final generated = (await generateStructuredResponse(
      _ai,
      _buildWriteGenerationPrompt(
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

    return WriteInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exercisePromptData: exercisePromptData,
    );
  }
}
