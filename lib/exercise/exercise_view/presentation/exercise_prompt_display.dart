import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_audio_prompt.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';

class ExercisePromptDisplay extends StatefulWidget {
  final ExerciseContent? exerciseContent;
  final ExerciseTask? exerciseTask;
  final TranslationState? contentTranslationState;
  final VoidCallback onContentTranslationRequested;
  final TranslationState? taskTranslationState;
  final VoidCallback onTaskTranslationRequested;

  const ExercisePromptDisplay({
    super.key,
    required this.exerciseContent,
    required this.exerciseTask,
    required this.contentTranslationState,
    required this.onContentTranslationRequested,
    required this.taskTranslationState,
    required this.onTaskTranslationRequested,
  });

  factory ExercisePromptDisplay.fromPromptData({
    Key? key,
    required ExercisePromptData exercisePromptData,
    required TranslationState? contentTranslationState,
    required VoidCallback onContentTranslationRequested,
    required TranslationState? taskTranslationState,
    required VoidCallback onTaskTranslationRequested,
  }) {
    return switch (exercisePromptData) {
      StandaloneExerciseTask(:final exerciseTask) => ExercisePromptDisplay(
        key: key,
        exerciseContent: null,
        exerciseTask: exerciseTask,
        contentTranslationState: contentTranslationState,
        onContentTranslationRequested: onContentTranslationRequested,
        taskTranslationState: taskTranslationState,
        onTaskTranslationRequested: onTaskTranslationRequested,
      ),
      ContentBasedExerciseTask(:final exerciseContent, :final exerciseTask) =>
        ExercisePromptDisplay(
          key: key,
          exerciseContent: exerciseContent,
          exerciseTask: exerciseTask,
          contentTranslationState: contentTranslationState,
          onContentTranslationRequested: onContentTranslationRequested,
          taskTranslationState: taskTranslationState,
          onTaskTranslationRequested: onTaskTranslationRequested,
        ),
    };
  }

  @override
  State<ExercisePromptDisplay> createState() => _ExercisePromptDisplayState();
}

class _ExercisePromptDisplayState extends State<ExercisePromptDisplay> {
  bool _showContentTranscription = false;
  bool _isContentTranslationActive = false;
  bool _isTaskTranslationActive = false;

  @override
  void didUpdateWidget(ExercisePromptDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseContent != widget.exerciseContent) {
      _showContentTranscription = false;
      _isContentTranslationActive = false;
    }
    if (widget.contentTranslationState is TranslationFailure &&
        oldWidget.contentTranslationState is! TranslationFailure) {
      _isContentTranslationActive = false;
    }
    if (oldWidget.exerciseTask != widget.exerciseTask) {
      _isTaskTranslationActive = false;
    }
    if (widget.taskTranslationState is TranslationFailure &&
        oldWidget.taskTranslationState is! TranslationFailure) {
      _isTaskTranslationActive = false;
    }
  }

  Widget _contentActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 24, height: 24),
      padding: EdgeInsets.zero,
      iconSize: 16,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }

  Widget _translationButton(VoidCallback onPressed) =>
      _contentActionButton(icon: Icons.translate, onPressed: onPressed);

  void _toggleContentTranslation() {
    final isTranslationActive = !_isContentTranslationActive;
    setState(() => _isContentTranslationActive = isTranslationActive);
    if (isTranslationActive) widget.onContentTranslationRequested();
  }

  void _toggleTaskTranslation() {
    final isTranslationActive = !_isTaskTranslationActive;
    setState(() => _isTaskTranslationActive = isTranslationActive);
    if (isTranslationActive) widget.onTaskTranslationRequested();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.exerciseContent case final content?) ...[
          if (content.exerciseContentAudio case final audio?) ...[
            ExerciseAudioPrompt(
              audioFilePath: audio.audioPath,
              duration: audio.duration,
              translationState: widget.contentTranslationState,
              onTranslationRequested: widget.onContentTranslationRequested,
            ),
            _contentActionButton(
              icon: Icons.subtitles_outlined,
              onPressed: () => setState(
                () => _showContentTranscription = !_showContentTranscription,
              ),
            ),
            if (_showContentTranscription)
              Text(
                content.exerciseContent,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ] else ...[
            Text(
              content.exerciseContent,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _translationButton(_toggleContentTranslation),
            if (_isContentTranslationActive) ...[
              const SizedBox(height: 4),
              TranslationDisplay(
                translationState: widget.contentTranslationState,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
          const SizedBox(height: 16),
        ],
        if (widget.exerciseTask case final task?) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(task.exerciseTask, textAlign: TextAlign.center),
              ),
            ],
          ),
          _translationButton(_toggleTaskTranslation),
          if (_isTaskTranslationActive) ...[
            const SizedBox(height: 4),
            TranslationDisplay(
              translationState: widget.taskTranslationState,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ],
    );
  }
}
