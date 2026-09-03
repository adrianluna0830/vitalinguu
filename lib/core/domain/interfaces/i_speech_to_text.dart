import 'dart:typed_data';

import 'package:vitalinguu/core/domain/models/audio_encoding.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';


abstract class ISpeechToText {
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    required LanguageLocale languageLocale,
    bool enableAutomaticPunctuation = false,
    AudioEncoding audioEncoding = AudioEncoding.WAV,
    int sampleRateHertz = 16000,
  });
}

class SpeechResult {
  final String transcription;
  final List<WordDetail> words;

  const SpeechResult({required this.transcription, required this.words});
}

class WordDetail {
  final String word;
  final Duration start;
  final Duration end;

  const WordDetail({
    required this.word,
    required this.start,
    required this.end,
  });
}

class UnsupportedAudioEncodingException implements Exception {
  final AudioEncoding encoding;

  const UnsupportedAudioEncodingException(this.encoding);

  @override
  String toString() =>
      'UnsupportedAudioEncodingException: the speech-to-text service does '
      'not support $encoding.';
}
