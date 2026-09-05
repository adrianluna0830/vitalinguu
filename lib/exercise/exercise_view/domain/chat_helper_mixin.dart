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
    _logger.i('Started chat helper session $_chatSessionId.');
  }

  Future<void> sendMessage(String message) async {
    final learnerMessage = message.trim();
    if (learnerMessage.isEmpty) {
      _logger.w('Rejected an empty chat helper message.');
      throw ArgumentError.value(message, 'message', 'Cannot be empty.');
    }
    if (_isTypingSignal.value) {
      _logger.t(
        'Skipped chat helper message because session $_chatSessionId is busy.',
      );
      return;
    }

    final requestSessionId = _chatSessionId;
    final previousMessages = _messagesSignal.value;
    final pendingMessages = List<ChatDialogMessage>.unmodifiable([
      ...previousMessages,
      ChatDialogMessage(isUserMessage: true, message: learnerMessage),
    ]);
    _messagesSignal.value = pendingMessages;
    _isTypingSignal.value = true;
    _logger.d(
      'Queued chat helper request. Session: $requestSessionId; '
      'prior messages: ${previousMessages.length}; '
      'message length: ${learnerMessage.length}.',
    );

    final previousRequest = _chatRequestQueue;
    final requestCompleted = Completer<void>();
    _chatRequestQueue = requestCompleted.future;

    try {
      await previousRequest;
      if (!_isCurrentChatRequest(requestSessionId, pendingMessages)) {
        _logger.t(
          'Discarded queued chat helper request because its session or state '
          'is no longer current. Session: $requestSessionId.',
        );
        return;
      }

      _logger.d('Sending chat helper request for session $requestSessionId.');
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
      if (generated == null) {
        _logger.w(
          'Chat helper request stopped without a result. '
          'Session: $requestSessionId.',
        );
        return;
      }
      if (!_isCurrentChatRequest(requestSessionId, pendingMessages)) {
        _logger.t(
          'Discarded chat helper response because its session or state is no '
          'longer current. Session: $requestSessionId.',
        );
        return;
      }

      final botMessage = generated.trim();
      if (botMessage.isEmpty) {
        _logger.w(
          'Chat helper returned an empty response. Session: $requestSessionId.',
        );
        return;
      }

      _messagesSignal.value = List<ChatDialogMessage>.unmodifiable([
        ...pendingMessages,
        ChatDialogMessage(isUserMessage: false, message: botMessage),
      ]);
      _isTypingSignal.value = false;
      _logger.i(
        'Chat helper response applied. Session: $requestSessionId; '
        'response length: ${botMessage.length}; '
        'total messages: ${_messagesSignal.value.length}.',
      );
    } finally {
      requestCompleted.complete();
      _stopChatTypingIfCurrent(requestSessionId, pendingMessages);
      _logger.t('Released chat helper queue slot. Session: $requestSessionId.');
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
      _logger.d(
        'Cleared chat helper typing state. Session: $requestSessionId.',
      );
    }
  }
}
