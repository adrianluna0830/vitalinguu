part of '../../exercise_view_model.dart';

String _buildWriteEvaluationPrompt(
  WriteExerciseState state, {
  required String answer,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) =>
    '''
${_evaluationPromptContext(state.input, exerciseType: 'WRITE', level: level, learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}
Exercise content: ${jsonEncode(state.input.exercisePromptData.exerciseContentOrNull?.exerciseContent)}
Exercise task: ${jsonEncode(state.input.exercisePromptData.exerciseTask.exerciseTask)}
Learner answer: ${jsonEncode(answer)}

Evaluate task fulfillment, relevance, comprehensibility, grammar, vocabulary,
organization, and use of the learning language at the requested CEFR level.
Use correct when the response fulfills the task and any remaining errors are
acceptable at that level. Use partiallyCorrect when it substantially addresses
the task but has important omissions or errors. Use incorrect when it misses
the objective, uses the wrong language, is too limited to assess, or is largely
incomprehensible. For partial or incorrect, give concise actionable feedback
in the native language and include corrected learning-language examples when
helpful. Do not demand complexity above the requested CEFR level.
''';
