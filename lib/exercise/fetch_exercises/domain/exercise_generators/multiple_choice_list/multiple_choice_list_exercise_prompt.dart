part of '../../fetch_exercises_view_model.dart';

String _buildMultipleChoiceListGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
  required bool requireContentBasedPrompt,
}) {
  return '''
Generate one MULTIPLE-CHOICE-LIST exercise.

Topic title: $title
Topic content: $content
Specific exercise brief: $prompt
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}

${_exerciseOutputLanguageGuidance(learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}

Mandatory CEFR guidance:
${_cefrLanguageGuidance(level)}

Mandatory prompt structure:
${_exercisePromptTypeGuidance(requireContentBasedPrompt: requireContentBasedPrompt)}

Create two to five distinct questions. Decide whether they genuinely benefit
from shared source material or work better as self-contained questions, then
choose the allowed exercisePromptData form accordingly. exerciseTask is the
overall instruction for the question list; each options item text contains one
specific question in the learning language. With a content-based prompt, every question must be
answerable from exerciseContent. With a standalone prompt, every question must
contain all information it needs. Test different details or language features
instead of repeating the same fact. For each question, provide one correct
answer and three distinct, plausible distractors in the learning language.
Explain each distractor in the native language. Do not mention audio in
learner-facing strings.
''';
}
