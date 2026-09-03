part of '../../exercise_view_model.dart';

String _buildMatchElementsEvaluationPrompt(
  MatchElementsExerciseState state, {
  required Object submissions,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) =>
    '''
${_evaluationPromptContext(state.input, exerciseType: 'MATCH-ELEMENTS', level: level, learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}
Exercise task: ${jsonEncode(state.input.exerciseTask.exerciseTask)}
Submitted and expected pairs: ${jsonEncode(submissions)}

Return one indexed result per pair. The expected right element is the
authoritative match. Mark correct when the selected right element expresses
that same match; otherwise mark incorrect. This is binary, with no partial
credit. For every incorrect pair, explain in the native language why the
selected association is wrong and identify the correct association.
''';
