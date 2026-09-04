part of '../../exercise_view_model.dart';

const _dialogConversationSystemInstruction =
    'You simulate a natural group conversation for a language learner. '
    'Keep every participant consistent with the assigned name and '
    'personality, follow the scenario objective, keep every participant '
    'message within the requested CEFR level instead of defaulting to '
    'native-speaker complexity, and grade the learner fairly at that level. '
    'Return only the structured response requested by the schema.';

const _dialogPersonalityTemplates = [
  'Warm and attentive. Encourages others and asks natural follow-up questions.',
  'Practical and direct. Contributes concise opinions and concrete examples.',
  'Thoughtful and curious. Notices details and asks clarifying questions.',
  'Playful but respectful. Uses light humor and imaginative observations.',
];

String _dialogParticipantProfiles(List<String> participantNames) {
  return [
    for (var index = 0; index < participantNames.length; index++)
      '- ${jsonEncode(participantNames[index])}: '
          '${_dialogPersonalityTemplates[index]}',
  ].join('\n');
}

Map<String, Object?> _dialogMessageToJson(DialogMessage dialogMessage) {
  return switch (dialogMessage) {
    User(:final message, :final feedback) => {
      'speakerType': 'learner',
      'message': message,
      'feedback': switch (feedback) {
        GoodFeedback() => {'status': 'good', 'explanation': null},
        PartialFeedback(:final message) => {
          'status': 'partial',
          'explanation': message,
        },
        BadFeedback(:final message) => {
          'status': 'bad',
          'explanation': message,
        },
        null => null,
      },
    },
    Bot(:final name, :final message, :final dialogOverResult) => {
      'speakerType': 'participant',
      'name': name,
      'message': message,
      'dialogOverResult': switch (dialogOverResult) {
        CorrectAnswerResult() => {'status': 'correct', 'explanation': null},
        PartiallyCorrectAnswerResult(:final explanation) => {
          'status': 'partiallyCorrect',
          'explanation': explanation,
        },
        IncorrectAnswerResult(:final explanation) => {
          'status': 'incorrect',
          'explanation': explanation,
        },
        null => null,
      },
    },
  };
}

String _dialogCefrMessageGuidance(CEFR level) => switch (level) {
  CEFR.a1 =>
    'Use very common, concrete words and basic memorized expressions. Prefer '
        'one or two short sentences per message, simple present forms, basic '
        'questions, and one idea at a time. Avoid idioms, figurative language, '
        'dense clauses, and advanced phrasal verbs.',
  CEFR.a2 =>
    'Use familiar everyday vocabulary and short, direct messages. Basic past '
        'and future forms and simple connectors such as and, but, and because '
        'are appropriate. Avoid abstract wording, uncommon idioms, and long '
        'multi-clause sentences.',
  CEFR.b1 =>
    'Use common vocabulary and clearly connected sentences about familiar '
        'or practical matters. Allow straightforward explanations, opinions, '
        'and the usual past, present, and future forms. Keep uncommon idioms, '
        'subtle implications, and syntactically dense wording to a minimum.',
  CEFR.b2 =>
    'Use a broader vocabulary, natural multi-clause sentences, explanations, '
        'and supported opinions. Common idioms and phrasal verbs are allowed '
        'when context makes them clear, but avoid needlessly literary, highly '
        'specialized, or C1-level nuanced wording.',
  CEFR.c1 =>
    'Use flexible and precise language, complex structures, natural idioms, '
        'and some implicit meaning. Keep it accessible at C1: do not add '
        'obscure vocabulary, specialist jargon, or elaborate native-speaker '
        'wordplay unless the scenario genuinely requires it.',
  CEFR.c2 =>
    'Use highly flexible, precise, and nuanced language appropriate for C2. '
        'Near-native complexity is acceptable at this level, but avoid '
        'obscurity, jargon, or cultural wordplay that does not serve the '
        'conversation.',
};

String _buildDialogTurnPrompt(
  DialogExerciseState state, {
  required bool isInitialTurn,
  required String? currentLearnerMessage,
  required CEFR level,
  required LanguageLocale learningLanguage,
  required LanguageLocale nativeLanguage,
}) {
  final input = state.input;
  final learnerTurnCount = state.messages.whereType<User>().length;
  final history = state.messages.map(_dialogMessageToJson).toList();

  return '''
Continue one DIALOG exercise as a natural multi-person conversation.

Topic title: ${jsonEncode(input.topicTitle)}
Topic content and learning goal: ${jsonEncode(input.topicContent)}
Learner-facing task: ${jsonEncode(input.exerciseTask.exerciseTask)}
CEFR level: ${level.name.toUpperCase()}
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Native language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
Completed learner turns including the current message: $learnerTurnCount

Mandatory CEFR language profile for every bot message:
${_dialogCefrMessageGuidance(level)}

AI-controlled participants and their permanent personalities:
${_dialogParticipantProfiles(input.participantNames)}

Conversation history in chronological order:
${jsonEncode(history)}

Current learner message: ${currentLearnerMessage == null ? 'There is no learner message; generate the opening turn.' : jsonEncode(currentLearnerMessage)}

Generate one batch containing between one and eight botMessages. A batch is not
limited to one speaker: choose the natural number of messages and which named
participants speak. Participants may answer the learner, answer or react to
another participant, return to an earlier point, disagree politely, ask each
other questions, or let another participant take over. If the learner asks the
group, allow every relevant participant to answer. Do not rotate speakers
mechanically and do not force every participant to speak on every turn. The
conversation should feel socially real and should not make every message revolve
around the learner, while still leaning toward the topic, task, and
opportunities for the learner to practice.

Follow the learner-facing task literally and consistently. On the opening
turn, immediately establish the promised situation and invite the exact kind
of participation described by the task. Do not replace the task with a lesson,
tutorial, quiz, or different activity. Do not introduce response mechanics
that the dialog interface does not support.

If there is only one AI-controlled participant, that participant may send one
or multiple consecutive messages in the same batch when this feels natural.
Do not force multiple messages; use only the number the conversation needs.

Every participant must keep the exact configured name and permanent personality.
Write every bot message in ${learningLanguage.fullName}. Treat the CEFR profile
above as a hard ceiling for vocabulary, grammar, sentence length, discourse
complexity, idioms, and implied meaning. The messages must be correct and
natural, so do not insert deliberate learner errors to imitate a lower level.
Make the conversation feel real through reactions and personality without
exceeding ${level.name.toUpperCase()} language.

${isInitialTurn ? '''This is the initial bot turn. userFeedback and every dialogOverResult must be null. Open the situation naturally and give the learner a clear opportunity to participate. Do not finish the dialog before the learner has participated.''' : '''Evaluate only the current learner message in userFeedback, and evaluate only:
- grammatical correctness;
- vocabulary or word choice when the selected word communicates a different
  meaning, creates genuine ambiguity, or does not work in that context;
- spelling or orthography when it changes a word or meaning, creates real ambiguity, or hinders understanding in ${learningLanguage.fullName}; and
- grammatical or idiomatic naturalness when wording is technically possible but
  clearly sounds strange, is not normally said that way, or is clearly outdated
  in ordinary modern conversation despite having a common natural alternative.

Do not evaluate the message's relevance, factual content, task completion,
politeness, register, sophistication, or quality of ideas in userFeedback. Do
not penalize missing periods, commas, capitalization, accents, or other surface
punctuation when they do not affect meaning or grammatical interpretation in
${learningLanguage.fullName}; if that is the only issue, use good. Correct
punctuation or orthography only when that language uses it to distinguish a
word, meaning, or grammatical interpretation and the learner's usage could
genuinely communicate something different.

First determine whether a linguistic problem exists independently of CEFR. A
real grammar or word-choice error remains an error at every level, and clearly
unnatural wording remains unnatural at every level. Use good when there is no
problem in the allowed categories. Use partial when the intended meaning remains
reliably recoverable but there is a real grammar, word-choice, or
meaning-relevant spelling problem.
Also use partial when the wording is technically grammatical but clearly
unnatural, abnormally uncommon, or clearly outdated in ordinary modern
conversation; provide the natural contemporary alternative. Do not use partial
merely because wording is formal, informal, literary, or regional when it is
still valid and natural in the conversation's context. Do not promote genuinely
unnatural wording to good because of CEFR. Use bad when
grammar, incorrect word choice, or meaning-relevant spelling makes the intended
meaning unreliable, substantially changes it, or makes the message seriously
malformed.

Use CEFR only to calibrate the severity of an actual grammar, word-choice, or spelling error,
never to make an error disappear. An error may be partial for an A1/A2 learner
when the intended meaning is still clear, yet bad for a C1/C2 learner when it is
a foundational rule that learner should already control. Increase expectations
progressively at B1/B2. Do not penalize a lower-level learner merely for not
using advanced vocabulary or grammar. Technically correct but clearly unnatural
wording stays partial rather than becoming bad solely because the CEFR is high.

For partial or bad, write brief, self-contained teaching feedback primarily in
${nativeLanguage.fullName}. It must:
1. identify the exact word or fragment that needs correction;
2. provide a corrected, natural ${learningLanguage.fullName} version;
3. explain in plain language what caused the problem and why the correction
   expresses the intended meaning or sounds natural; and
4. when useful, show the short structure or pattern the learner can reuse.

You may name a grammar, vocabulary, or spelling rule, but never use its name as
the explanation by itself. Assume the learner does not know technical terms. If
you use one, immediately explain what it means in ordinary words. For example,
do not say only "wrong conjugation" or "preposition error"; explain which form
belongs there and why. Keep this concise and focused on the current message.
Keep explanation null for good.

Decide whether the conversation genuinely ends on this turn; do not use a fixed turn count. Keep every dialogOverResult null while the conversation should continue. A non-null dialogOverResult is a final decision now, not a prediction that a later turn might end. The dialog may end when the communicative objective has been sufficiently achieved, the learner or participants naturally close it, or the learner has shown enough sustained difficulty that continuing is no longer useful. Do not end merely because of one recoverable mistake. For the holistic dialogOverResult only, apply CEFR tolerance: be generous about expected basic errors at A1/A2 when meaning succeeds, expect progressively stronger control and detail at B1/B2, and judge precision, nuance, and register more strictly at C1/C2.

Any configured participant may deliver the closing message. If the dialog ends, put the holistic correct, partiallyCorrect, or incorrect result only in dialogOverResult of the final botMessage and emit no message after it. Grade the whole conversation against the task and CEFR level. Keep the final explanation null for correct; for partiallyCorrect or incorrect, explain the outcome primarily in ${nativeLanguage.fullName}.'''}

Do not generate or describe audio metadata. Audio delivery is handled
separately after the structured response is received.
''';
}
