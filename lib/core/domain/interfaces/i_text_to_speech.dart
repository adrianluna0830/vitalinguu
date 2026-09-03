import 'dart:typed_data';

import 'package:vitalinguu/core/domain/api_failure.dart';
import 'package:vitalinguu/core/domain/models/audio_encoding.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';

sealed class TextToSpeechResult {
  const TextToSpeechResult();
}

final class TextToSpeechSuccess extends TextToSpeechResult {
  const TextToSpeechSuccess({
    required this.audioBytes,
    required this.audioEncoding,
  });

  final Uint8List audioBytes;
  final AudioEncoding audioEncoding;
}

sealed class TextToSpeechFailure extends TextToSpeechResult {
  const TextToSpeechFailure({this.message});

  final String? message;
}

final class TextToSpeechAuthenticationFailure extends TextToSpeechFailure {
  const TextToSpeechAuthenticationFailure({super.message});
}

final class TextToSpeechUsageLimitFailure extends TextToSpeechFailure {
  const TextToSpeechUsageLimitFailure({super.message});
}

final class TextToSpeechTemporaryFailure extends TextToSpeechFailure {
  const TextToSpeechTemporaryFailure({super.message});
}

final class TextToSpeechRequestFailure extends TextToSpeechFailure {
  const TextToSpeechRequestFailure({super.message});
}

ApiFailure mapTextToSpeechFailureToApiFailure(TextToSpeechFailure failure) {
  return switch (failure) {
    TextToSpeechAuthenticationFailure(:final message) => AuthenticationFailure(
      details: message,
    ),
    TextToSpeechUsageLimitFailure(:final message) => UsageLimitFailure(
      details: message,
    ),
    TextToSpeechTemporaryFailure(:final message) => TemporaryFailure(
      details: message,
    ),
    TextToSpeechRequestFailure(:final message) => RequestFailure(
      details: message,
    ),
  };
}

abstract class ITextToSpeech {
  Future<TextToSpeechResult> synthesize({
    required String text,
    required LanguageLocale languageLocale,
    double speed = 1.0,
  });
}

abstract class ITextToSpeechIPA {
  Future<TextToSpeechResult> synthesize({
    required String text,
    required LanguageLocale languageLocale,
    double speed = 1.0,
  });
}
