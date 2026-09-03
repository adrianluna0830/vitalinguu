enum AudioEncoding {
  LINEAR16('.raw'),
  FLAC('.flac'),
  MP3('.mp3'),
  OGG_OPUS('.opus'),
  WAV('.wav');

  const AudioEncoding(this.extension);

  final String extension;
}
