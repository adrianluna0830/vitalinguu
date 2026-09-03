part of '../../fetch_exercises_view_model.dart';

String _buildWordOrderingGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
}) {
  return '''
Generate one WORD-ORDERING exercise.

Topic title: $title
Topic content: $content
Specific exercise brief: $prompt
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}

${_exerciseOutputLanguageGuidance(learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}

Mandatory CEFR guidance:
${_cefrLanguageGuidance(level)}

Create one natural sentence in the learning language that implements the
specific brief and practices the topic. Its vocabulary, grammar, and length
must suit the CEFR level. Return that sentence only as wordsInOrder, split into
three to twenty ordered tokens. Attach punctuation to its neighboring word and
do not split contractions unless that is the normal orthography of the learning
language. Repeated words are allowed when grammatically necessary. The
exerciseTask must tell the learner what to construct without revealing the
complete answer. Write exerciseTask in the learning language.
''';
}
