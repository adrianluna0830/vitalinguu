import 'package:signals/signals_core.dart';
import 'package:vitalinguu/core/domain/interfaces/i_audio_player.dart';

class GlobalAudioPlayer implements IAudioPlayer {
  GlobalAudioPlayer(this._player);

  final IAudioPlayer _player;

  double _speed = 1.0;
  ({String path, bool loop, double volume, Duration positionUpdateInterval})?
  _activeAudio;

  Future<void> changeSpeed(double speed) async {
    _speed = speed;
    final activeAudio = _activeAudio;
    if (activeAudio == null ||
        _player.getPlaybackStateSignal(activeAudio.path).value !=
            AudioPlaybackState.playing) {
      return;
    }

    await _player.playOrResume(
      activeAudio.path,
      loop: activeAudio.loop,
      volume: activeAudio.volume,
      speed: _speed,
      positionUpdateInterval: activeAudio.positionUpdateInterval,
    );
  }

  @override
  Future<void> playOrResume(
    String path, {
    bool loop = false,
    double volume = 1.0,
    double speed = 1.0,
    Duration positionUpdateInterval = const Duration(milliseconds: 10),
  }) async {
    _activeAudio = (
      path: path,
      loop: loop,
      volume: volume,
      positionUpdateInterval: positionUpdateInterval,
    );
    await _player.playOrResume(
      path,
      loop: loop,
      volume: volume,
      speed: _speed,
      positionUpdateInterval: positionUpdateInterval,
    );
  }

  @override
  Stream<Duration> getPositionStream(String path) =>
      _player.getPositionStream(path);

  @override
  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String path) =>
      _player.getPlaybackStateSignal(path);

  @override
  Future<void> seek(String path, Duration position) =>
      _player.seek(path, position);

  @override
  Future<void> stop(String path) async {
    if (_activeAudio?.path == path) _activeAudio = null;
    await _player.stop(path);
  }

  @override
  Future<void> pause(String path) => _player.pause(path);

  @override
  Future<Duration> getTotalDuration(String path) =>
      _player.getTotalDuration(path);

  @override
  Future<void> dispose() => _player.dispose();
}
