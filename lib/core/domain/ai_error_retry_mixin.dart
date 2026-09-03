import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vitalinguu/core/domain/api_failure.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/interfaces/i_text_to_speech.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/domain/one_of.dart';


bool isRetryableApiFailure(ApiFailure failure) {
  return switch (failure) {
    UsageLimitFailure() || TemporaryFailure() => true,
    AuthenticationFailure() || RequestFailure() => false,
  };
}

final class StopExecution implements Exception {
  const StopExecution();
}

mixin AIErrorRetryMixin {
  final StreamController<ApiFailure> _errorStreamController =
      StreamController<ApiFailure>.broadcast();

  Stream<ApiFailure> get errorStream => _errorStreamController.stream;

  Completer<bool>? _retryCompleter;

  void relayUserRetryDecision(bool retry) {
    final retryCompleter = _retryCompleter;
    if (retryCompleter == null) {
      throw StateError('No retry is in progress. Cannot relay user decision.');
    }
    retryCompleter.complete(retry);
  }

  @protected
  Future<OneOf2<String, StopExecution>> generateResponse(
    IAI ai,
    String prompt,
    String? systemInstruction, {
    int attemptsBeforeNotifying = 3,
  }) {
    return _generateWithRetry(
      () => ai.generateResponse(prompt, systemInstruction),
      attemptsBeforeNotifying: attemptsBeforeNotifying,
    );
  }

  @protected
  Future<OneOf2<T, StopExecution>> generateStructuredResponse<T>(
    IAI ai,
    String prompt,
    AISchema<T> schema,
    String? systemInstruction, {
    int attemptsBeforeNotifying = 3,
  }) {
    return _generateWithRetry(
      () => ai.generateStructuredResponse(prompt, schema, systemInstruction),
      attemptsBeforeNotifying: attemptsBeforeNotifying,
    );
  }

  Future<OneOf2<T, StopExecution>> _generateWithRetry<T>(
    Future<OneOf2<T, AIError>> Function() generate, {
    required int attemptsBeforeNotifying,
  }) {
    if (attemptsBeforeNotifying < 1) {
      throw ArgumentError.value(
        attemptsBeforeNotifying,
        'attemptsBeforeNotifying',
        'Must be at least 1.',
      );
    }
    if (_retryCompleter != null) {
      throw StateError(
        'A retry is already in progress. Please wait for it to complete '
        'before starting a new one.',
      );
    }

    _retryCompleter = Completer<bool>();
    return _executeWithRetry(
      generate,
      attemptsBeforeNotifying: attemptsBeforeNotifying,
    );
  }

  Future<OneOf2<T, StopExecution>> _executeWithRetry<T>(
    Future<OneOf2<T, AIError>> Function() generate, {
    required int attemptsBeforeNotifying,
  }) async {
    var failedAttempts = 0;
    try {
      while (true) {
        final response = await generate();
        ApiFailure? retryableFailure;
        final completedResponse = response.when<OneOf2<T, StopExecution>?>(
          first: (value) => OneOf2<T, StopExecution>.first(value),
          second: (error) {
            final failure = mapAIErrorToApiFailure(error);
            if (isRetryableApiFailure(failure)) {
              retryableFailure = failure;
              return null;
            }

            _errorStreamController.add(failure);
            return OneOf2.second(const StopExecution());
          },
        );

        if (completedResponse != null) return completedResponse;

        failedAttempts++;
        if (failedAttempts < attemptsBeforeNotifying) continue;

        _errorStreamController.add(retryableFailure!);
        final retry = await _retryCompleter!.future;
        if (!retry) {
          return OneOf2.second(const StopExecution());
        }

        failedAttempts = 0;
        _retryCompleter = Completer<bool>();
      }
    } finally {
      _retryCompleter = null;
    }
  }
}

mixin TextToSpeechErrorRetryMixin on AIErrorRetryMixin {
  @protected
  Future<OneOf2<TextToSpeechSuccess, StopExecution>> synthesizeSpeech(
    ITextToSpeech textToSpeech, {
    required String text,
    required LanguageLocale languageLocale,
    double speed = 1.0,
    int attemptsBeforeNotifying = 3,
  }) async {
    if (attemptsBeforeNotifying < 1) {
      throw ArgumentError.value(
        attemptsBeforeNotifying,
        'attemptsBeforeNotifying',
        'Must be at least 1.',
      );
    }
    if (_retryCompleter != null) {
      throw StateError(
        'A retry is already in progress. Please wait for it to complete '
        'before starting a new one.',
      );
    }

    _retryCompleter = Completer<bool>();
    var failedAttempts = 0;

    try {
      while (true) {
        final result = await textToSpeech.synthesize(
          text: text,
          languageLocale: languageLocale,
          speed: speed,
        );

        switch (result) {
          case TextToSpeechSuccess():
            return OneOf2.first(result);
          case final TextToSpeechFailure error:
            final failure = mapTextToSpeechFailureToApiFailure(error);
            if (!isRetryableApiFailure(failure)) {
              _errorStreamController.add(failure);
              return OneOf2.second(const StopExecution());
            }

            failedAttempts++;
            if (failedAttempts < attemptsBeforeNotifying) continue;

            _errorStreamController.add(failure);
            final retry = await _retryCompleter!.future;
            if (!retry) return OneOf2.second(const StopExecution());

            failedAttempts = 0;
            _retryCompleter = Completer<bool>();
        }
      }
    } finally {
      _retryCompleter = null;
    }
  }
}
