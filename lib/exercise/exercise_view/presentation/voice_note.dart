import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/domain/interfaces/i_audio_player.dart';

class VoiceNote extends StatefulWidget {
  final String audioPath;
  final Duration totalDuration;
  final IAudioPlayer player;

  const VoiceNote({
    super.key,
    required this.audioPath,
    required this.totalDuration,
    required this.player,
  });
  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {
  bool isSeeking = false;
  double currentPositionValue = 0.0;
  bool _wasPlaying = false;
  late StreamSubscription<Duration> _positionSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPosition();
  }

  @override
  void didUpdateWidget(covariant VoiceNote oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioPath != widget.audioPath ||
        oldWidget.player != widget.player) {
      _positionSubscription.cancel();
      currentPositionValue = 0;
      _listenToPosition();
    }
  }

  void _listenToPosition() {
    _positionSubscription = widget.player
        .getPositionStream(widget.audioPath)
        .listen((position) {
          if (!isSeeking) {
            setState(
              () => currentPositionValue = position.inMilliseconds.toDouble(),
            );
          }
        });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying =
        // ignore: deprecated_member_use
        widget.player.getPlaybackStateSignal(widget.audioPath).watch(context) ==
        AudioPlaybackState.playing;
    final totalMilliseconds = widget.totalDuration.inMilliseconds.toDouble();
    final sliderMax = totalMilliseconds > 0 ? totalMilliseconds : 1.0;
    final sliderValue = currentPositionValue.clamp(0.0, sliderMax);

    return Row(
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: isPlaying
              ? () => widget.player.pause(widget.audioPath)
              : () => widget.player.playOrResume(widget.audioPath),
        ),
        Expanded(
          child: Slider(
            value: sliderValue,
            max: sliderMax,
            onChangeStart: (value) {
              _wasPlaying = isPlaying;
              if (_wasPlaying) widget.player.pause(widget.audioPath);
              setState(() => isSeeking = true);
            },
            onChanged: (value) => setState(() => currentPositionValue = value),
            onChangeEnd: (value) {
              setState(() => isSeeking = false);
              widget.player.seek(
                widget.audioPath,
                Duration(milliseconds: value.toInt()),
              );
              if (_wasPlaying) widget.player.playOrResume(widget.audioPath);
            },
          ),
        ),
        VoiceNoteDuration(
          totalDuration: widget.totalDuration,
          currentPosition: Duration(milliseconds: sliderValue.round()),
          isPaused: !isPlaying,
        ),
      ],
    );
  }
}

class VoiceNoteDuration extends StatelessWidget {
  final Duration totalDuration;
  final Duration currentPosition;
  final bool isPaused;

  const VoiceNoteDuration({
    super.key,
    required this.totalDuration,
    required this.currentPosition,
    required this.isPaused,
  });

  static const _textStyle = TextStyle(
    fontSize: 11,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    final minuteDigits = _minuteDigits(totalDuration);
    final duration = isPaused ? totalDuration : currentPosition;
    final formattedDuration = _formatDuration(duration, minuteDigits);
    final widthReference = '${''.padLeft(minuteDigits, '0')}:00';

    return Stack(
      children: [
        ExcludeSemantics(
          child: Opacity(
            opacity: 0,
            child: Text(widthReference, style: _textStyle),
          ),
        ),
        Positioned.fill(
          child: Text(
            formattedDuration,
            style: _textStyle,
            textAlign: TextAlign.right,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  static int _minuteDigits(Duration duration) {
    final minutes = _nonNegativeSeconds(duration) ~/ Duration.secondsPerMinute;
    final digits = minutes.toString().length;
    return digits < 2 ? 2 : digits;
  }

  static String _formatDuration(Duration duration, int minuteDigits) {
    final totalSeconds = _nonNegativeSeconds(duration);
    final minutes = totalSeconds ~/ Duration.secondsPerMinute;
    final seconds = totalSeconds % Duration.secondsPerMinute;

    return '${minutes.toString().padLeft(minuteDigits, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  static int _nonNegativeSeconds(Duration duration) {
    return duration.isNegative ? 0 : duration.inSeconds;
  }
}
