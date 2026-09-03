part of '../../exercise_view_model.dart';

String _buildWordOrderingEvaluationPrompt(
  WordOrderingExerciseState state, {
  required List<String> words,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) =>
    '''
${_evaluationPromptContext(state.input, exerciseType: 'WORD-ORDERING', level: level, learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}
Exercise task: ${jsonEncode(state.input.exerciseTask.exerciseTask)}
Reference order: ${jsonEncode(state.input.wordsInOrder)}
Learner order: ${jsonEncode(words)}
Reference sentence: ${jsonEncode(state.input.wordsInOrder.join(' '))}
Learner sentence: ${jsonEncode(words.join(' '))}

Determine whether the learner order forms the intended grammatically correct,
natural sentence and fulfills the task. The reference order is authoritative,
but accept another order only if it uses the supplied tokens and is genuinely
valid in context without changing the intended meaning. This is binary, with
no partial credit. If incorrect, explain the ordering or grammar problem in the
native language and show the corrected sentence.
''';
