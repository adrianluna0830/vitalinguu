part of '../../fetch_exercises_view_model.dart';

mixin MultipleChoiceExerciseGeneratorMixin
    on
        FetchExercisesViewModelDependenciesMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  Future<MultipleChoiceInput> _generateMultipleChoiceExercise(
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
    final outputSchema = _createMultipleChoiceOutputSchema(
      requireContentBasedPrompt: requireContentBasedPrompt,
    );
    final exerciseSchema = AISchema<_GeneratedMultipleChoiceExercise>(
      outputSchema,
      (data) => _generatedMultipleChoiceExerciseFromJson(data, outputSchema),
    );
    final generated = (await generateStructuredResponse(
      _ai,
      _buildMultipleChoiceGenerationPrompt(
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

    return MultipleChoiceInput(
      topicId: topicId,
      topicTitle: title,
      topicContent: content,
      exercisePromptData: exercisePromptData,
      correctOption: generated.correctOption,
      incorrectOption1: generated.incorrectOption1,
      incorrectOption2: generated.incorrectOption2,
      incorrectOption3: generated.incorrectOption3,
    );
  }
}
