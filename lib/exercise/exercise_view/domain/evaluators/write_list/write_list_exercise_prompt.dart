part of '../../exercise_view_model.dart';

String _buildWriteListEvaluationPrompt(
  WriteListExerciseState state, {
  required Object submissions,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) =>
    '''
${_evaluationPromptContext(state.input, exerciseType: 'WRITE-LIST', level: level, learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}
Shared exercise content: ${jsonEncode(state.input.exercisePromptData.exerciseContentOrNull?.exerciseContent)}
Exercise task: ${jsonEncode(state.input.exercisePromptData.exerciseTask.exerciseTask)}
Writing submissions: ${jsonEncode(submissions)}

Return one indexed evaluation for every submission. Evaluate each answer only
against its corresponding writing prompt and the shared content. Consider task
fulfillment, relevance, comprehensibility, grammar, vocabulary, and appropriate
CEFR complexity. Use correct when it fulfills the prompt with only level-
appropriate minor errors; partiallyCorrect for meaningful but incomplete or
significantly flawed answers; and incorrect for answers that fail the prompt,
use the wrong language, are too limited, or are largely incomprehensible. For
partial or incorrect, give distinct actionable feedback in the native language
and a corrected learning-language example when useful.
''';
