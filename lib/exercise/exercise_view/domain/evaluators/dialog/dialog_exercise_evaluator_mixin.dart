part of '../../exercise_view_model.dart';

mixin DialogExerciseEvaluatorMixin
    on
        ExerciseViewModelStateMixin,
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin {
  final Random _random = Random();

  bool _shouldGenerateAudio(PromptConfiguration configuration) {
    return switch (configuration) {
      TextOnly() => false,
      AudioOnly() => true,
      TextAndAudio(:final textPriority, :final audioPriority) => () {
        final textWeight = _getWeightedPriority(textPriority);
        final audioWeight = _getWeightedPriority(audioPriority);
        return _random.nextInt(textWeight + audioWeight) >= textWeight;
      }(),
    };
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

    for (final botMessage in generated.botMessages) {
      AudioData? audioData;
      if (_shouldGenerateAudio(input.promptConfiguration)) {
        final response = (await synthesizeSpeech(
          _textToSpeech,
          text: botMessage.message,
          languageLocale: _learningLanguage,
          speed: input.speechSpeed,
        )).valueOrStopExecution();
        if (response == null) {
          return OneOf2.second(const StopExecution());
        }

        final audioPath = await getAudioPath(
          audioBytes: response.audioBytes,
          persistent: false,
          audioEncoding: response.audioEncoding,
        );
        final duration = await _audioPlayer.getTotalDuration(audioPath);
        audioData = AudioData(audioFilePath: audioPath, duration: duration);
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

    return OneOf2.first(messages);
  }

  void endDialogAbruptly() {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      throw StateError('The current exercise is not a dialog exercise.');
    }

    _addIncorrectAnswers(state.input, [
      for (final message in state.messages)
        jsonEncode(_dialogMessageToJson(message)),
    ]);
  }

  Future<void> setInitialMessage() async {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      throw StateError('The current exercise is not a dialog exercise.');
    }
    if (state.isTyping || state.messages.isNotEmpty) return;
    _validateDialogParticipants(state.input.participantNames);

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
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) return;

    final botMessages = (await _toDialogBotMessages(
      generated,
      state.input,
    )).valueOrStopExecution();
    if (botMessages == null) {
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) return;

    _exerciseStateSignal.value = pendingState.copyWith(
      isTyping: false,
      messages: [...pendingState.messages, ...botMessages],
    );
  }

  Future<void> sendMessage(String message) async {
    final state = _exerciseStateSignal.value;
    if (state is! DialogExerciseState) {
      throw StateError('The current exercise is not a dialog exercise.');
    }
    final learnerMessage = message.trim();
    if (learnerMessage.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Cannot be empty.');
    }
    if (state.isTyping || _isDialogOver(state)) {
      return;
    }
    _validateDialogParticipants(state.input.participantNames);

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
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) return;

    final botMessages = (await _toDialogBotMessages(
      generated,
      state.input,
    )).valueOrStopExecution();
    if (botMessages == null) {
      _stopDialogTypingIfCurrent(pendingState);
      return;
    }
    if (!identical(_exerciseStateSignal.value, pendingState)) return;

    final generatedFeedback = generated.userFeedback!;
    final feedback = _toDialogUserFeedback(generatedFeedback);
    final finalMessages = <DialogMessage>[
      ...pendingState.messages.take(pendingState.messages.length - 1),
      User(message: learnerMessage, feedback: feedback),
      ...botMessages,
    ];

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

    _exerciseStateSignal.value = pendingState.copyWith(
      isTyping: false,
      messages: finalMessages,
    );
  }

  void _validateDialogParticipants(List<String> participantNames) {
    if (participantNames.isEmpty) {
      throw StateError('A dialog requires at least one bot participant.');
    }
    if (participantNames.length > _dialogPersonalityTemplates.length) {
      throw StateError(
        'A dialog supports at most ${_dialogPersonalityTemplates.length} '
        'bot participants.',
      );
    }
    if (participantNames.toSet().length != participantNames.length) {
      throw StateError('Dialog participant names must be unique.');
    }
  }

  bool _isDialogOver(DialogExerciseState state) {
    if (state.messages.isEmpty) return false;
    return switch (state.messages.last) {
      Bot(:final dialogOverResult) => dialogOverResult != null,
      User() => false,
    };
  }

  void _stopDialogTypingIfCurrent(DialogExerciseState pendingState) {
    if (!identical(_exerciseStateSignal.value, pendingState)) return;
    _exerciseStateSignal.value = pendingState.copyWith(isTyping: false);
  }
}
