part of '../../fetch_exercises_view_model.dart';

String _buildFillTheBlankGenerationPrompt({
  required String prompt,
  required String title,
  required String content,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
  required CEFR level,
}) {
  return '''
Generate one FILL-THE-BLANK exercise.

Topic title: $title
Topic content: $content
Specific exercise brief: $prompt
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}

${_exerciseOutputLanguageGuidance(learningLanguage: learningLanguage, nativeLanguage: nativeLanguage)}

Mandatory CEFR guidance:
${_cefrLanguageGuidance(level)}

Build a coherent sentence or short passage in the learning language that
implements the specific brief. Adjust vocabulary, grammar, ambiguity, and the
number of blanks to the CEFR level. Split it into ordered fillTheBlanks
fragments. Use fillTheBlankType "answer" only for exact text the learner must
enter and "visibleText" for ordinary text that remains visible. Concatenating
only visibleText and answer fragments must reconstruct the natural completed
text exactly; hint fragments are excluded from that reconstruction.

A hint is optional parenthetical guidance in the learning language for an
answer and must immediately
follow the answer fragment it describes. Its text may be a clue word, a short
phrase, a sentence, or multiple distinct candidate words, phrases, or sentences.
Separate multiple candidates clearly, preferably with " / ". A multiple-choice
hint may include the correct answer among plausible alternatives; a single-clue
hint must guide the learner without directly giving the exact answer. Return
only the content that belongs inside the parentheses: never include the outer
parentheses because the UI adds them.

Include at least one answer and at least one visibleText fragment. Preserve any
needed spaces and punctuation in visibleText and answer fragments, and do not
insert newline characters inside any fragment; the UI will wrap the complete
exercise naturally when it reaches the available width. Do not use underscore
or bracket placeholders. Write exerciseTask in the learning language.
''';
}
