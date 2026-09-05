part of '../../exercise_view_model.dart';

const _dialogBotMessageDelay = Duration(seconds: 3);

mixin DialogExerciseEvaluatorMixin
    on
        ExerciseViewModelStateMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  final Random _random = Random();

  bool _shouldGenerateAudio(PromptConfiguration configuration) {
    final shouldGenerate = switch (configuration) {
      TextOnly() => false,
      AudioOnly() => true,
      TextAndAudio(:final textPriority, :final audioPriority) => () {
        final textWeight = _getWeightedPriority(textPriority);
        final audioWeight = _getWeightedPriority(audioPriority);
        return _random.nextInt(textWeight + audioWeight) >= textWeight;
      }(),
    };
    _logger.t(
      'Resolved dialog audio generation. Configuration: '
      '${configuration.runtimeType}; generate audio: $shouldGenerate.',
    );
    return shouldGenerate;
  }

  int _getWeightedPriority(Priority priority) {
    return switch (priority) {
      Priority.low => 1,
      Priority.medium => 2,
      Priority.high => 4,
    };
  }

  Future<OneOf2<List<Bot>, StopExecution>> _toDialogBotMessages(
    _GeneratedDialogTurn generated,
    DialogInput input,
  ) async {
    final messages = <Bot>[];
    _logger.d(
      'Converting ${generated.botMessages.length} generated dialog messages.',
    );

    for (var index = 0; index < generated.botMessages.length; index++) {
      final botMessage = generated.botMessages[index];
      AudioData? audioData;
      if (_shouldGenerateAudio(input.promptConfiguration)) {
        _logger.d(
          'Synthesizing audio for dialog bot message $index. '
          'Text length: ${botMessage.message.length}.',
        );
        final response = (await synthesizeSpeech(
          _textToSpeech,
          text: botMessage.message,
          languageLocale: _learningLanguage,
          speed: input.speechSpeed,
        )).valueOrStopExecution();
        if (response == null) {
          _logger.w(
            'Dialog bot message conversion stopped because speech synthesis '
            'did not complete. Message index: $index.',
          );
          return OneOf2.second(const StopExecution());
        }

        final audioPath = await getAudioPath(
          audioBytes: response.audioBytes,
          persistent: false,
          audioEncoding: response.audioEncoding,
        );
        final duration = await _audioPlayer.getTotalDuration(audioPath);
        audioData = AudioData(audioFilePath: audioPath, duration: duration);
        _logger.d(
          'Dialog audio prepared. Message index: $index; '
          'duration: ${duration.inMilliseconds}ms; '
          'encoding: ${response.audioEncoding}.',
        );
      }

      messages.add(
        Bot(
          name: botMessage.name,
          message: botMessage.message,
          audioData: audioData,
          dialogOverResult: _toDialogFinalResult(botMessage.dialogOverResult),
        ),
      );
    }

    _logger.i('Converted ${messages.length} dialog bot messages successfully.');
    return OneOf2.first(messages);
  }

  void endDialogAbruptly() {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      _logger.e('Abrupt dialog ending called for ${state.runtimeType}.');
      throw StateError('The current exercise is not a dialog exercise.');
    }

    _logger.w(
      'Dialog ended abruptly. Exercise index: ${state.currentIndex}; '
      'messages recorded as incorrect: ${state.messages.length}.',
    );
    _addIncorrectAnswers(state.input, [
      for (final message in state.messages)
        jsonEncode(_dialogMessageToJson(message)),
    ]);
  }

  Future<void> setInitialMessage() async {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      _logger.e('Initial dialog message requested for ${state.runtimeType}.');
      throw StateError('The current exercise is not a dialog exercise.');
    }
    if (state.isTyping || state.messages.isNotEmpty) {
      _logger.t(
        'Skipped initial dialog message. Exercise index: '
        '${state.currentIndex}; is typing: ${state.isTyping}; '
        'existing messages: ${state.messages.length}.',
      );
      return;
    }
    _validateDialogParticipants(state.input.participantNames);
    _logger.d(
      'Starting initial dialog turn. Exercise index: ${state.currentIndex}; '
      'participants: ${state.input.participantNames.length}.',
    );

    final pendingState = state.copyWith(isTyping: true);
    _exerciseStateSignal.value = pendingState;

    final generated = (await generateStructuredResponse(
      _ai,
      _buildDialogTurnPrompt(
        pendingState,
        isInitialTurn: true,
        currentLearnerMessage: null,
        level: _level,
        learningLanguage: _learningLanguage,
        nativeLanguage: _nativeLanguage,
      ),
      _createDialogTurnSchema(
        participantNames: state.input.participantNames,
        evaluatesLearnerMessage: false,
        allowDialogEnd: false,
      ),
      _dialogConversationSystemInstruction,
    )).valueOrStopExecution();
    if (generated == null) {
      _logger.w(
        'Initial dialog generation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) {
      _logger.t(
        'Discarded initial dialog generation because the state changed. '
        'Original exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final botMessages = (await _toDialogBotMessages(
      generated,
      state.input,
    )).valueOrStopExecution();
    if (botMessages == null) {
      _logger.w(
        'Initial dialog message conversion stopped. '
        'Exercise index: ${state.currentIndex}.',
      );
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) {
      _logger.t(
        'Discarded converted initial dialog messages because the state '
        'changed. Original exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final appended = await _appendDialogBotMessages(pendingState, botMessages);
    if (appended) {
      _logger.i(
        'Initial dialog turn completed. Exercise index: '
        '${state.currentIndex}; bot messages: ${botMessages.length}.',
      );
    }
  }

  Future<void> sendDialogMessage(String message) async {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      _logger.e('Dialog message submission called for ${state.runtimeType}.');
      throw StateError('The current exercise is not a dialog exercise.');
    }
    final learnerMessage = message.trim();
    if (learnerMessage.isEmpty) {
      _logger.w(
        'Rejected an empty dialog message. '
        'Exercise index: ${state.currentIndex}.',
      );
      throw ArgumentError.value(message, 'message', 'Cannot be empty.');
    }
    if (state.isTyping || _isDialogOver(state)) {
      _logger.t(
        'Skipped dialog message submission. Exercise index: '
        '${state.currentIndex}; is typing: ${state.isTyping}; '
        'dialog over: ${_isDialogOver(state)}.',
      );
      return;
    }
    _validateDialogParticipants(state.input.participantNames);
    _logger.d(
      'Starting learner dialog turn. Exercise index: ${state.currentIndex}; '
      'message length: ${learnerMessage.length}; '
      'prior messages: ${state.messages.length}.',
    );

    final pendingState = state.copyWith(
      isTyping: true,
      messages: [
        ...state.messages,
        User(message: learnerMessage, feedback: null),
      ],
    );
    _exerciseStateSignal.value = pendingState;

    final generated = (await generateStructuredResponse(
      _ai,
      _buildDialogTurnPrompt(
        pendingState,
        isInitialTurn: false,
        currentLearnerMessage: learnerMessage,
        level: _level,
        learningLanguage: _learningLanguage,
        nativeLanguage: _nativeLanguage,
      ),
      _createDialogTurnSchema(
        participantNames: state.input.participantNames,
        evaluatesLearnerMessage: true,
        allowDialogEnd: true,
      ),
      _dialogConversationSystemInstruction,
    )).valueOrStopExecution();
    if (generated == null) {
      _logger.w(
        'Dialog turn generation stopped without a result. '
        'Exercise index: ${state.currentIndex}.',
      );
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) {
      _logger.t(
        'Discarded generated dialog turn because the state changed. '
        'Original exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final botMessages = (await _toDialogBotMessages(
      generated,
      state.input,
    )).valueOrStopExecution();
    if (botMessages == null) {
      _logger.w(
        'Dialog bot message conversion stopped. '
        'Exercise index: ${state.currentIndex}.',
      );
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) {
      _logger.t(
        'Discarded converted dialog messages because the state changed. '
        'Original exercise index: ${state.currentIndex}.',
      );
      return;
    }

    final generatedFeedback = generated.userFeedback!;
    final feedback = _toDialogUserFeedback(generatedFeedback);
    final feedbackState = pendingState.copyWith(
      isTyping: true,
      messages: <DialogMessage>[
        ...pendingState.messages.take(pendingState.messages.length - 1),
        User(message: learnerMessage, feedback: feedback),
      ],
    );
    _exerciseStateSignal.value = feedbackState;
    _logger.d(
      'Applied learner dialog feedback. Exercise index: '
      '${state.currentIndex}; result: ${feedback.runtimeType}.',
    );

    if (feedback is! GoodFeedback) {
      _recordIncorrectAnswer(
        state.input,
        'Learner message: $learnerMessage\n'
        'Feedback: ${generatedFeedback.explanation}',
      );
    }
    final finalResult = generated.botMessages.last.dialogOverResult;
    if (finalResult != null &&
        finalResult.verdict != _DialogFinalVerdict.correct) {
      _recordIncorrectAnswer(
        state.input,
        'Dialog outcome: ${finalResult.explanation}',
      );
    }

    final appended = await _appendDialogBotMessages(feedbackState, botMessages);
    if (appended) {
      final currentState = _exerciseStateSignal.value as DialogExerciseState;
      _logger.i(
        'Learner dialog turn completed. Exercise index: '
        '${state.currentIndex}; bot messages: ${botMessages.length}; '
        'dialog over: ${_isDialogOver(currentState)}.',
      );
    }
  }

  Future<bool> _appendDialogBotMessages(
    DialogExerciseState pendingState,
    List<Bot> botMessages,
  ) async {
    var currentState = pendingState;
    _logger.d(
      'Appending ${botMessages.length} dialog bot messages. '
      'Exercise index: ${pendingState.currentIndex}.',
    );

    for (var index = 0; index < botMessages.length; index++) {
      if (!identical(_exerciseStateSignal.value, currentState)) {
        _logger.t(
          'Stopped appending dialog bot messages because the state changed. '
          'Next message index: $index.',
        );
        return false;
      }

      currentState = currentState.copyWith(
        isTyping: true,
        messages: [...currentState.messages, botMessages[index]],
      );
      _exerciseStateSignal.value = currentState;
      _logger.t(
        'Appended dialog bot message ${index + 1} of ${botMessages.length}.',
      );

      if (index < botMessages.length - 1) {
        await Future<void>.delayed(_dialogBotMessageDelay);
      }
    }

    if (!identical(_exerciseStateSignal.value, currentState)) {
      _logger.t('Did not clear dialog typing state because the state changed.');
      return false;
    }
    _exerciseStateSignal.value = currentState.copyWith(isTyping: false);
    _logger.d(
      'Finished appending dialog bot messages and cleared typing state.',
    );
    return true;
  }

  void _validateDialogParticipants(List<String> participantNames) {
    if (participantNames.isEmpty) {
      _logger.e('Dialog validation failed: no bot participants.');
      throw StateError('A dialog requires at least one bot participant.');
    }
    if (participantNames.length > _dialogPersonalityTemplates.length) {
      _logger.e(
        'Dialog validation failed: ${participantNames.length} participants '
        'exceed the limit of ${_dialogPersonalityTemplates.length}.',
      );
      throw StateError(
        'A dialog supports at most ${_dialogPersonalityTemplates.length} '
        'bot participants.',
      );
    }
    if (participantNames.toSet().length != participantNames.length) {
      _logger.e('Dialog validation failed: participant names are not unique.');
      throw StateError('Dialog participant names must be unique.');
    }
    _logger.t('Validated ${participantNames.length} dialog bot participants.');
  }

  bool _isDialogOver(DialogExerciseState state) {
    if (state.messages.isEmpty) return false;
    return switch (state.messages.last) {
      Bot(:final dialogOverResult) => dialogOverResult != null,
      User() => false,
    };
  }

  void _stopDialogTypingIfCurrent(DialogExerciseState pendingState) {
    if (!identical(_exerciseStateSignal.value, pendingState)) {
      _logger.t(
        'Did not stop dialog typing because the state is no longer current.',
      );
      return;
    }
    _exerciseStateSignal.value = pendingState.copyWith(isTyping: false);
    _logger.d(
      'Stopped dialog typing. Exercise index: ${pendingState.currentIndex}.',
    );
  }
}
