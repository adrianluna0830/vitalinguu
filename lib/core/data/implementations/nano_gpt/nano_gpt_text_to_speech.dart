import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_api_key_validator.dart';
import 'package:vitalinguu/core/domain/interfaces/i_text_to_speech.dart';
import 'package:vitalinguu/core/domain/models/audio_encoding.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';

class NanoGptTextToSpeech extends ITextToSpeech {
  static final _url = Uri.parse(
    'https://nano-gpt.com/api/v1/audio/speech',
  );

  static const _model = 'inworld-tts-1.5-mini';
  static const _timeout = Duration(seconds: 100);

  final String _apiKey;

  NanoGptTextToSpeech({required String apiKey})
      : _apiKey = requireApiKey(apiKey);

  @override
  Future<TextToSpeechResult> synthesize({
    required String text,
    required LanguageLocale languageLocale,
    double speed = 1.0,
  }) async {
    final http.Response response;
    final voice = _voiceFor(languageLocale);

    try {
      response = await http
          .post(
            _url,
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
              'Accept': 'audio/mpeg',
            },
            body: jsonEncode({
              'model': _model,
              'input': text,
              'voice': voice,
              'response_format': 'mp3',
              'speed': speed,
            }),
          )
          .timeout(_timeout);
    } on TimeoutException catch (error) {
      return TextToSpeechTemporaryFailure(
        message: 'The NanoGPT TTS request timed out: $error',
      );
    } on http.ClientException catch (error) {
      return TextToSpeechTemporaryFailure(
        message: 'Could not connect to the NanoGPT TTS API: $error',
      );
    } on Object catch (error) {
      return TextToSpeechTemporaryFailure(
        message: 'Unexpected NanoGPT TTS client error: $error',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return _failureFrom(response);
    }

    if (response.bodyBytes.isEmpty) {
      return const TextToSpeechTemporaryFailure(
        message: 'NanoGPT returned an empty TTS response.',
      );
    }

    return TextToSpeechSuccess(
      audioBytes: response.bodyBytes,
      audioEncoding: AudioEncoding.MP3,
    );
  }

  String _voiceFor(LanguageLocale locale) => switch (locale) {
        LanguageLocale.en => 'Dennis',
        LanguageLocale.es => 'Lupita',
        LanguageLocale.de => 'Johanna',
        LanguageLocale.pt => 'Maitê',
        LanguageLocale.fr => 'Hélène',
        LanguageLocale.it => 'Gianni',
      };

  TextToSpeechFailure _failureFrom(http.Response response) {
    final message = _errorMessage(response);

    return switch (response.statusCode) {
      401 => TextToSpeechAuthenticationFailure(message: message),
      402 || 429 => TextToSpeechUsageLimitFailure(message: message),
      408 || 504 || >= 500 => TextToSpeechTemporaryFailure(message: message),
      _ => TextToSpeechRequestFailure(message: message),
    };
  }

  String _errorMessage(http.Response response) {
    final body = utf8.decode(
      response.bodyBytes,
      allowMalformed: true,
    );

    var message = body.trim();

    try {
      final decoded = jsonDecode(body);

      message = switch (decoded) {
        {'error': {'message': final Object value}} => value.toString(),
        {'error': final String value} => value,
        {'message': final Object value} => value.toString(),
        _ => message,
      };
    } on FormatException {
      // Keep the raw response when NanoGPT does not return JSON.
    }

    return [
      if (message.isNotEmpty) message,
      'HTTP status: ${response.statusCode}',
      if (response.headers['x-request-id'] case final requestId?)
        'X-Request-ID: $requestId',
    ].join('\n');
  }
}