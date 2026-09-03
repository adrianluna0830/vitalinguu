import 'package:signals/signals_core.dart';

abstract class IAudioPlayer {
  Future<void> playOrResume(
    String path, {
    bool loop = false,
    double volume = 1.0,
    double speed = 1.0,
    Duration positionUpdateInterval = const Duration(milliseconds: 10),
  });

  Stream<Duration> getPositionStream(String path);

  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String path);
  Future<void> seek(String path, Duration position);
  Future<void> stop(String path);
  Future<void> pause(String path);
  Future<void> dispose();
  Future<Duration> getTotalDuration(String path);
}

enum AudioPlaybackState { playing, paused, completed, inactive }
