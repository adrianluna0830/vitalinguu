part of '../../fetch_exercises_view_model.dart';

String _buildMatchElementsGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
}) {
  return '''
Generate one MATCH-ELEMENTS exercise.

Topic title: $title
Topic content: $content
Specific exercise brief: $prompt
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}

${_exerciseOutputLanguageGuidance(learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}

Mandatory CEFR guidance:
${_cefrLanguageGuidance(level)}

Create three to eight unambiguous pairs that implement the specific brief and
practice distinct aspects of the topic. Write both leftElement and rightElement
in the learning language. Pair an expression, sentence, or example with a
matching definition, meaning, completion, response, or equivalent that is also
in the learning language; never translate either side into the native language.
Make each side unique so every item has exactly one reasonable match. Increase
nuance, idiomaticity, and grammatical complexity for higher CEFR levels. Write
exerciseTask in the learning language.
''';
}
