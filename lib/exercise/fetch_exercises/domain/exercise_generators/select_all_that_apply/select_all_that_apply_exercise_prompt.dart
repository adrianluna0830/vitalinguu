part of '../../fetch_exercises_view_model.dart';

String _buildSelectAllGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
  required bool requireContentBasedPrompt,
}) {
  return '''
Generate one SELECT-ALL-THAT-APPLY exercise.

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

Create a selection task that implements the specific brief at the requested
CEFR level. Decide whether it genuinely needs separate source material and
choose the allowed exercisePromptData form accordingly. Provide three to eight
distinct options in the learning language, including at least one correct and
one incorrect option. Use kind "correct" for correct branches and kind
"incorrect" for incorrect branches. Every incorrect branch must include a
specific explanation in the native language. Make all correct answers clearly
supported and all distractors plausible but definitively wrong. Do not mention
audio in learner-facing strings.
''';
}
