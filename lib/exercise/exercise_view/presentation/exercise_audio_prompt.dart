import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/data/implementations/global_audio_player.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/voice_note.dart';

class ExerciseAudioPrompt extends StatefulWidget {
  final String audioFilePath;
  final Duration duration;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const ExerciseAudioPrompt({
    super.key,
    required this.audioFilePath,
    required this.duration,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<ExerciseAudioPrompt> createState() => _ExerciseAudioPromptState();
}

class _ExerciseAudioPromptState extends State<ExerciseAudioPrompt> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(ExerciseAudioPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioFilePath != widget.audioFilePath) {
      _isTranslationActive = false;
    }
    if (widget.translationState is TranslationFailure &&
        oldWidget.translationState is! TranslationFailure) {
      _isTranslationActive = false;
    }
  }

  void _toggleTranslation() {
    final isTranslationActive = !_isTranslationActive;
    setState(() => _isTranslationActive = isTranslationActive);
    if (isTranslationActive) widget.onTranslationRequested();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        children: [
          VoiceNote(
            audioPath: widget.audioFilePath,
            totalDuration: widget.duration,
            player: getIt<GlobalAudioPlayer>(),
          ),
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 24, height: 24),
            padding: EdgeInsets.zero,
            iconSize: 16,
            onPressed: _toggleTranslation,
            icon: const Icon(Icons.translate),
          ),
          if (_isTranslationActive) ...[
            const SizedBox(height: 4),
            TranslationDisplay(
              translationState: widget.translationState,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
