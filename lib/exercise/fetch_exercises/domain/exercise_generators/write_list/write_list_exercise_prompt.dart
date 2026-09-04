part of '../../fetch_exercises_view_model.dart';

String _buildWriteListGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
  required bool requireContentBasedPrompt,
}) {
  return '''
Generate one WRITE-LIST exercise.

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

Create two to five distinct writing requests in prompts. Decide whether they
genuinely benefit from shared source material or work better independently,
then choose the allowed exercisePromptData form accordingly. exerciseTask is
the overall instruction for the list. With a content-based prompt, each request
must relate clearly to exerciseContent. With a standalone prompt, each request
must contain all specific context it needs. Write exerciseTask and every string
in prompts in the learning language. Each request asks for a separate response
in the learning language. Together they must implement the specific
brief while practicing different aspects of the topic. Scale response length,
grammar, vocabulary, inference, and precision to the CEFR level. Do not supply
answers or mention audio in learner-facing strings.
''';
}
