part of '../../exercise_view_model.dart';

String _buildFillTheBlankEvaluationPrompt(
  FillTheBlankExerciseState state, {
  required String completedText,
  required Object submissions,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) =>
    '''
${_evaluationPromptContext(state.input, exerciseType: 'FILL-THE-BLANK', level: level, learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}
Exercise task: ${jsonEncode(state.input.exerciseTask.exerciseTask)}
Completed reference text: ${jsonEncode(completedText)}
Answers to evaluate: ${jsonEncode(submissions)}

Return one indexed result per learner answer. Judge spelling, morphology,
grammar, meaning, and fit in the complete text. Accept capitalization or
punctuation differences that do not change correctness, and accept a valid
alternative only when it fits the same blank and meaning. This is a binary
exercise: use correct or incorrect, never partial credit. For every incorrect
answer, explain the specific problem and give the correct form in the native
feedback language.
''';
