import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:signals/signals_core.dart';
import 'package:vitalinguu/core/domain/interfaces/i_audio_player.dart';

/// [IAudioPlayer] implementado con el paquete `audioplayers`.
///
/// Internamente mantiene un [AudioPlayer] por cada `path`, pero solo permite
/// una reproducción activa a la vez. El estado de reproducción de cada
/// `path` se expone de forma reactiva mediante un "signals container"
/// (`signalContainer`), que crea y cachea perezosamente un
/// `Signal<AudioPlaybackState>` por path la primera vez que se pide.
class AudioPlayersPlayer implements IAudioPlayer {
  String? _activePath;
  int _playRequestId = 0;

  /// Un [AudioPlayer] nativo por cada `path`.
  final Map<String, AudioPlayer> _players = {};

  /// Suscripciones que conectan el stream de estado de `audioplayers` con
  /// nuestros signals.
  final Map<String, StreamSubscription<PlayerState>> _stateSubscriptions = {};

  /// Stream **estable** de posición por path. `audioplayers` expone
  /// `onPositionChanged` como un getter que apunta al `positionUpdater`
  /// activo en ese instante; si luego cambiamos el `positionUpdater` (lo
  /// hacemos en [_ensurePositionUpdater]), cualquier referencia al stream
  /// vieja deja de emitir. Por eso mantenemos nuestro propio controller que
  /// no cambia nunca de identidad, y lo re-conectamos por dentro cuando sea
  /// necesario.
  final Map<String, StreamController<Duration>> _positionControllers = {};
  final Map<String, StreamSubscription<Duration>> _positionSubscriptions = {};

  /// Último `positionUpdateInterval` aplicado por path, para no recrear el
  /// `TimerPositionUpdater` (y re-conectar streams) en cada llamada a
  /// `playOrResume` si el intervalo no cambió.
  final Map<String, Duration> _positionUpdateIntervals = {};

  /// Container de signals: crea (y cachea, `cache: true`) un
  /// `Signal<AudioPlaybackState>` por cada `path` la primera vez que se
  /// solicita. Esto es lo que reemplaza tener que manejar un `Map<String,
  /// Signal<...>>` a mano.
  late final _playbackState = signalContainer<AudioPlaybackState, String>(
    (path) => signal(AudioPlaybackState.inactive),
    cache: true,
  );

  /// Devuelve el [AudioPlayer] de [path], creándolo y conectando sus
  /// streams a los signals la primera vez que se usa.
  AudioPlayer _playerFor(String path) {
    return _players.putIfAbsent(path, () {
      final player = AudioPlayer();
      final stateSignal = _playbackState(path);
      _stateSubscriptions[path] = player.onPlayerStateChanged.listen((state) {
        final playbackState = _toAudioPlaybackState(state);
        stateSignal.value = playbackState;
        if (_activePath == path &&
            (playbackState == AudioPlaybackState.completed ||
                playbackState == AudioPlaybackState.inactive)) {
          _activePath = null;
        }
      });
      // Conecta el stream estable de posición desde ya, usando el
      // `FramePositionUpdater` por defecto que trae el `AudioPlayer` recién
      // creado. Así `getPositionStream` funciona aunque se llame antes de
      // `playOrResume`.
      _bindPositionForwarding(path, player);
      return player;
    });
  }

  /// (Re)conecta nuestro [StreamController] estable de [path] al
  /// `onPositionChanged` *actual* del player. Hay que llamar esto de nuevo
  /// cada vez que se reemplaza `player.positionUpdater`, porque
  /// `onPositionChanged` apunta al updater vigente en el momento en que se
  /// lee, no al que esté activo en el futuro.
  void _bindPositionForwarding(String path, AudioPlayer player) {
    _positionSubscriptions[path]?.cancel();
    final controller = _positionControllers.putIfAbsent(
      path,
      () => StreamController<Duration>.broadcast(),
    );
    _positionSubscriptions[path] = player.onPositionChanged.listen(
      controller.add,
      onError: controller.addError,
    );
  }

  /// Aplica [interval] como `positionUpdater` de [player] solo si cambió
  /// respecto al que ya tenía, y re-conecta el forwarding en ese caso.
  /// Evita destruir/recrear el `TimerPositionUpdater` (y por lo tanto el
  /// stream interno) en cada `play`/`resume` si nada cambió.
  void _ensurePositionUpdater(
    String path,
    AudioPlayer player,
    Duration interval,
  ) {
    if (_positionUpdateIntervals[path] == interval) return;
    player.positionUpdater = TimerPositionUpdater(
      interval: interval,
      getPosition: player.getCurrentPosition,
    );
    _positionUpdateIntervals[path] = interval;
    _bindPositionForwarding(path, player);
  }

  /// Traduce el [PlayerState] de `audioplayers` a nuestro propio
  /// [AudioPlaybackState].
  ///
  /// ⚠️ No tengo el contenido real de `i_audio_player.dart`, así que estoy
  /// asumiendo que [AudioPlaybackState] tiene los valores `playing`,
  /// `paused`, `completed` y `stopped`. Ajusta este switch a los nombres
  /// reales que hayas declarado.
  AudioPlaybackState _toAudioPlaybackState(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        return AudioPlaybackState.playing;
      case PlayerState.paused:
        return AudioPlaybackState.paused;
      case PlayerState.completed:
        return AudioPlaybackState.completed;
      case PlayerState.stopped:
      case PlayerState.disposed:
        return AudioPlaybackState.inactive;
    }
  }

  /// Construye el [Source] correcto a partir de un `path`.
  ///
  /// Asumo esta convención simple (URL remota / prefijo `asset:` / archivo
  /// local). Ajústala si tu app ya distingue los tipos de otra forma.
  Source _sourceFor(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return UrlSource(path);
    }
    if (path.startsWith('asset:')) {
      return AssetSource(path.substring('asset:'.length));
    }
    return DeviceFileSource(path);
  }

  /// Asegura que [player] tenga un source cargado.
  ///
  /// `audioplayers` no tiene nada sobre qué posicionarse (seek) ni puede
  /// reportar duración si todavía no se le asignó un audio. Si ya tiene uno
  /// (por ejemplo porque ya se llamó `play`/`resume` antes), no hace nada.
  Future<void> _ensureSourceSet(AudioPlayer player, String path) async {
    if (player.source == null) {
      await player.setSource(_sourceFor(path));
    }
  }

  @override
  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String path) {
    _playerFor(path); // asegura que el player y su binding ya existan.
    return _playbackState(path);
  }

  @override
  Future<void> playOrResume(
    String path, {
    bool loop = false,
    double volume = 1.0,
    double speed = 1.0,
    Duration positionUpdateInterval = const Duration(milliseconds: 10),
  }) async {
    final requestId = ++_playRequestId;
    final previousPath = _activePath;
    _activePath = path;

    if (previousPath != null && previousPath != path) {
      await _stopPlayer(previousPath);
    }
    if (requestId != _playRequestId) return;

    final player = _playerFor(path);

    _ensurePositionUpdater(path, player, positionUpdateInterval);

    await player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    await player.setVolume(volume);
    await player.setPlaybackRate(speed);
    if (requestId != _playRequestId) return;

    switch (_playbackState(path).value) {
      case AudioPlaybackState.paused:
        await player.resume();
      case AudioPlaybackState.playing:
        break;
      case AudioPlaybackState.completed:
      case AudioPlaybackState.inactive:
        await player.play(_sourceFor(path));
    }
  }

  @override
  Future<void> pause(String path) async {
    await _playerFor(path).pause();
    _playbackState(path).value = AudioPlaybackState.paused;
  }

  @override
  Future<void> stop(String path) async {
    if (_activePath == path) {
      _playRequestId++;
      _activePath = null;
    }
    await _stopPlayer(path);
  }

  Future<void> _stopPlayer(String path) async {
    final player = _players[path];
    if (player != null) await player.stop();
    _playbackState(path).value = AudioPlaybackState.inactive;
    _positionControllers[path]?.add(Duration.zero);
  }

  @override
  Future<void> seek(String path, Duration position) async {
    final player = _playerFor(path);
    await _ensureSourceSet(player, path);
    await player.seek(position);
  }

  @override
  Stream<Duration> getPositionStream(String path) {
    _playerFor(path); // asegura que el player y su binding ya existan.
    return _positionControllers[path]!.stream;
  }

  @override
  Future<Duration> getTotalDuration(String path) async {
    final player = _playerFor(path);
    final durationCompleter = Completer<Duration>();
    final durationSubscription = player.onDurationChanged
        .where((duration) => duration > Duration.zero)
        .listen(
          (duration) {
            if (!durationCompleter.isCompleted) {
              durationCompleter.complete(duration);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!durationCompleter.isCompleted) {
              durationCompleter.completeError(error, stackTrace);
            }
          },
        );

    try {
      await _ensureSourceSet(player, path);

      final cachedDuration = await player.getDuration();
      if (cachedDuration != null && cachedDuration > Duration.zero) {
        return cachedDuration;
      }

      var isSilentProbePlaying = false;
      try {
        await player.setVolume(0);
        await player.resume();
        isSilentProbePlaying = true;

        final duration = await durationCompleter.future.timeout(
          const Duration(seconds: 15),
        );

        return duration;
      } finally {
        if (isSilentProbePlaying) {
          await player.stop();
        }
      }
    } finally {
      await durationSubscription.cancel();
    }
  }

  @override
  Future<void> dispose() async {
    await Future.wait(_stateSubscriptions.values.map((s) => s.cancel()));
    _stateSubscriptions.clear();

    await Future.wait(_positionSubscriptions.values.map((s) => s.cancel()));
    _positionSubscriptions.clear();

    await Future.wait(_positionControllers.values.map((c) => c.close()));
    _positionControllers.clear();
    _positionUpdateIntervals.clear();

    await Future.wait(_players.values.map((p) => p.dispose()));
    _players.clear();
    _activePath = null;
    _playRequestId++;

    _playbackState.dispose();
  }
}
