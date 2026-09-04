part of '../../fetch_exercises_view_model.dart';

String _buildWriteGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
  required bool requireContentBasedPrompt,
}) {
  return '''
Generate one WRITE exercise.

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

Create an open-ended writing task that implements the specific brief without
repeating it verbatim. Decide whether it genuinely needs separate source
material or whether a self-contained task is clearer, then choose the allowed
exercisePromptData form accordingly. Put every response requirement in
exerciseTask. Make those requirements appropriate for the CEFR level: for lower
levels request short controlled language; for higher levels require more detail,
organization, nuance, and relevant grammatical structures. The learner must
answer in the learning language. Do not supply a model answer or mention audio
in learner-facing strings.
''';
}
