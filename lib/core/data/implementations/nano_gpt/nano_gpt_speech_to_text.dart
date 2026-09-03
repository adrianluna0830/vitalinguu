import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:vitalinguu/core/domain/models/audio_encoding.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/domain/interfaces/i_speech_to_text.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_api_key_validator.dart';

final class NanoGptSpeechToText implements ISpeechToText {
  static final Uri _endpoint = Uri.parse(
    'https://nano-gpt.com/api/v1/audio/transcriptions',
  );
  static const String _model = 'Whisper-Large-V3';

  final String _apiKey;

  NanoGptSpeechToText({required String apiKey})
    : _apiKey = requireApiKey(apiKey);

  @override
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    required LanguageLocale languageLocale,
    bool enableAutomaticPunctuation = false,
    AudioEncoding audioEncoding = AudioEncoding.WAV,
    int sampleRateHertz = 16000,
  }) async {
    final extension = _fileExtension(audioEncoding);
    final request = http.MultipartRequest('POST', _endpoint)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..fields['model'] = _model
      ..fields['language'] = languageLocale.languageCode.toLowerCase()
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          audioBytes,
          filename: 'audio.$extension',
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NanoGptSpeechToTextException(
        statusCode: response.statusCode,
        message: _errorMessage(responseBody),
      );
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'NanoGPT returned an invalid transcription response.',
      );
    }

    final transcription = switch (decoded) {
      {'text': final String text} => text.trim(),
      {'transcription': final String text} => text.trim(),
      _ => '',
    };
    if (transcription.isEmpty) {
      throw const FormatException('NanoGPT returned an empty transcription.');
    }

    return SpeechResult(
      transcription: transcription,
      words: _wordDetails(decoded['words']),
    );
  }

  static List<WordDetail> _wordDetails(Object? value) {
    if (value is! List) return const [];

    final words = <WordDetail>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final text = entry['word'] ?? entry['text'];
      final start = entry['start'];
      final end = entry['end'];
      if (text is! String || start is! num || end is! num) continue;

      words.add(
        WordDetail(
          word: text,
          start: _secondsToDuration(start),
          end: _secondsToDuration(end),
        ),
      );
    }

    return List.unmodifiable(words);
  }

  static String _fileExtension(AudioEncoding encoding) {
    return switch (encoding) {
      AudioEncoding.MP3 => 'mp3',
      AudioEncoding.OGG_OPUS => 'ogg',
      AudioEncoding.WAV => 'wav',
      AudioEncoding.LINEAR16 ||
      AudioEncoding.FLAC => throw UnsupportedAudioEncodingException(encoding),
    };
  }

  static Duration _secondsToDuration(num seconds) {
    return Duration(microseconds: (seconds.toDouble() * 1000000).round());
  }

  static String _errorMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded case {'error': {'message': final String message}}) {
        return message;
      }
      if (decoded case {'error': final String message}) return message;
      if (decoded case {'message': final String message}) return message;
    } on FormatException {
      // Preserve the original response below when it is not JSON.
    }
    return responseBody.isEmpty
        ? 'NanoGPT transcription failed.'
        : responseBody;
  }
}

final class NanoGptSpeechToTextException implements Exception {
  final int statusCode;
  final String message;

  const NanoGptSpeechToTextException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'NanoGptSpeechToTextException($statusCode): $message';
}
