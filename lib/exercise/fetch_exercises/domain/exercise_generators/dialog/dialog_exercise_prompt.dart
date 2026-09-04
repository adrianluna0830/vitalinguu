part of '../../fetch_exercises_view_model.dart';

String _buildDialogGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
}) {
  return '''
Generate one DIALOG exercise.

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

Create a concrete role-play scenario that follows the specific brief and uses
the topic without merely restating it. The challenge, vocabulary, social
register, and communicative objective must suit the CEFR level. Write
exerciseTask in the learning language.

exerciseTask must be one concise instruction containing only the situation, the
learner's role, the communicative goal, and any necessary constraint. Never
include an example or model conversation, speaker turns, sample phrases,
suggested learner responses, a script, or an answer. Do not complete any part of
the role-play on the learner's behalf.

Generate between one and four culturally plausible names for the AI-controlled
participants in participantNames; do not include a name for the learner.
''';
}
