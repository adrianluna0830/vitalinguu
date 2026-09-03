part of 'exercise_view_model.dart';

const _chatHelperSystemInstruction =
    'You are a patient language tutor. Answer the learner directly and '
    'concisely, following the response-language and learning-language '
    'instructions in the latest prompt. Use the native language for '
    'explanations and preserve learning-language words, corrections, and '
    'examples in that language. Return only the response text, without JSON, '
    'labels, or meta-commentary.';

String _buildChatHelperPrompt({
  required String message,
  required LanguageLocale nativeLanguage,
  required LanguageLocale learningLanguage,
}) =>
    '''
Respond to the learner's latest message.

Response language: ${nativeLanguage.fullName} (${nativeLanguage.bcp47})
Language being learned: ${learningLanguage.fullName} (${learningLanguage.bcp47})
Learner message as a JSON string:
${jsonEncode(message)}

Write the explanation primarily in ${nativeLanguage.fullName}. Keep words,
corrections, and examples from the language being learned in
${learningLanguage.fullName}.
''';

List<AIMessage> _toAIChatMessages(List<ChatDialogMessage> messages) => [
  for (final message in messages)
    AIMessage(message.isUserMessage, message.message),
];

mixin ChatHelperMixin on AIErrorRetryMixin, ExerciseViewModelStateMixin {
  int _chatSessionId = 0;
  Future<void> _chatRequestQueue = Future<void>.value();

  final _isTypingSignal = Signal<bool>(false);
  ReadonlySignal<bool> get isTyping => _isTypingSignal.readonly();

  final _messagesSignal = Signal<List<ChatDialogMessage>>(const []);
  ReadonlySignal<List<ChatDialogMessage>> get messages =>
      _messagesSignal.readonly();

  void newChat() {
    _chatSessionId++;
    _messagesSignal.value = const [];
    _isTypingSignal.value = false;
  }

  Future<void> sendMessage(String message) async {
    final learnerMessage = message.trim();
    if (learnerMessage.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Cannot be empty.');
    }
    if (_isTypingSignal.value) return;

    final requestSessionId = _chatSessionId;
    final previousMessages = _messagesSignal.value;
    final pendingMessages = List<ChatDialogMessage>.unmodifiable([
      ...previousMessages,
      ChatDialogMessage(isUserMessage: true, message: learnerMessage),
    ]);
    _messagesSignal.value = pendingMessages;
    _isTypingSignal.value = true;

    final previousRequest = _chatRequestQueue;
    final requestCompleted = Completer<void>();
    _chatRequestQueue = requestCompleted.future;

    try {
      await previousRequest;
      if (!_isCurrentChatRequest(requestSessionId, pendingMessages)) return;

      final generated = (await generateChatResponse(
        _ai,
        _buildChatHelperPrompt(
          message: learnerMessage,
          nativeLanguage: _nativeLanguage,
          learningLanguage: _learningLanguage,
        ),
        _toAIChatMessages(previousMessages),
        _chatHelperSystemInstruction,
      )).valueOrStopExecution();
      if (generated == null ||
          !_isCurrentChatRequest(requestSessionId, pendingMessages)) {
        return;
      }

      final botMessage = generated.trim();
      if (botMessage.isEmpty) return;

      _messagesSignal.value = List<ChatDialogMessage>.unmodifiable([
        ...pendingMessages,
        ChatDialogMessage(isUserMessage: false, message: botMessage),
      ]);
      _isTypingSignal.value = false;
    } finally {
      requestCompleted.complete();
      _stopChatTypingIfCurrent(requestSessionId, pendingMessages);
    }
  }

  bool _isCurrentChatRequest(
    int requestSessionId,
    List<ChatDialogMessage> pendingMessages,
  ) {
    return requestSessionId == _chatSessionId &&
        _isTypingSignal.value &&
        identical(_messagesSignal.value, pendingMessages);
  }

  void _stopChatTypingIfCurrent(
    int requestSessionId,
    List<ChatDialogMessage> pendingMessages,
  ) {
    if (_isCurrentChatRequest(requestSessionId, pendingMessages)) {
      _isTypingSignal.value = false;
    }
  }
}
