part of '../../fetch_exercises_view_model.dart';

String _buildMultipleChoiceGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
  required bool requireContentBasedPrompt,
}) {
  return '''
Generate one MULTIPLE-CHOICE exercise.

Topic title: $title
Topic content: $content
Specific exercise brief: $prompt
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}

${_exerciseOutputLanguageGuidance(learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}

$_exerciseTopicSuggestionGuidance

Mandatory CEFR guidance:
${_cefrLanguageGuidance(level)}

Mandatory prompt structure:
${_exercisePromptTypeGuidance(requireContentBasedPrompt: requireContentBasedPrompt)}

Create a multiple-choice question that implements the specific brief and
practices the topic at the requested CEFR level. Decide whether it genuinely
needs separate source material and choose the allowed exercisePromptData form
accordingly. Provide exactly one correct option and three distinct, plausible
distractors in the learning language. A distractor must be genuinely wrong,
not merely less preferable. Explain each distractor in the native language
without revealing unrelated answers. Do not mention audio in learner-facing
strings.
''';
}
