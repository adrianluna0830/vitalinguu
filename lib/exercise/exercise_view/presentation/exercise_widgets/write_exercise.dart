import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/answer_result.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_status_icon.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class WriteExercise extends StatefulWidget {
  final ExercisePromptData exercisePromptData;
  final ValueChanged<String> onAnswerSubmitted;
  final AnswerResult? answerResult;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const WriteExercise({
    super.key,
    required this.exercisePromptData,
    required this.onAnswerSubmitted,
    required this.answerResult,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<WriteExercise> createState() => _WriteExerciseState();
}

class _WriteExerciseState extends State<WriteExercise> {
  final _controller = TextEditingController();
  bool _isSubmitted = false;

  bool get _canSubmit => !_isSubmitted && _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _isSubmitted = widget.answerResult != null;
  }

  @override
  void didUpdateWidget(WriteExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercisePromptData != widget.exercisePromptData) {
      _controller.clear();
      _isSubmitted = widget.answerResult != null;
    } else if (widget.answerResult != null) {
      _isSubmitted = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) return;
    setState(() => _isSubmitted = true);
    widget.onAnswerSubmitted(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExercisePromptDisplay.fromPromptData(
                    exercisePromptData: widget.exercisePromptData,
                    contentTranslationState:
                        widget.translations[TranslationKeys.content],
                    onContentTranslationRequested: () {
                      final content =
                          widget.exercisePromptData.exerciseContentOrNull;
                      if (content != null) {
                        widget.onTranslate(
                          TranslationKeys.content,
                          content.exerciseContent,
                        );
                      }
                    },
                    taskTranslationState:
                        widget.translations[TranslationKeys.task],
                    onTaskTranslationRequested: () {
                      widget.onTranslate(
                        TranslationKeys.task,
                        widget.exercisePromptData.exerciseTask.exerciseTask,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    enabled: !_isSubmitted,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  if (!_isSubmitted) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _canSubmit ? _submit : null,
                      child: Text(context.t.exercise.confirmAnswer),
                    ),
                  ],
                  if (widget.answerResult case final result?) ...[
                    const SizedBox(height: 16),
                    _WriteAnswerFeedback(result: result),
                  ],
                  if (widget.answerResult != null && _isSubmitted)
                    NextExerciseButton(onPressed: widget.onNextExercise)
                  else
                    FilledButton(
                      onPressed: null,
                      child: Text(context.t.exercise.next),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WriteAnswerFeedback extends StatelessWidget {
  final AnswerResult result;

  const _WriteAnswerFeedback({required this.result});

  @override
  Widget build(BuildContext context) {
    final (icon, explanation) = switch (result) {
      CorrectAnswerResult() => (const AnswerStatusIcon(isCorrect: true), null),
      PartiallyCorrectAnswerResult(:final explanation) => (
        const AnswerStatusIcon.partial(),
        explanation,
      ),
      IncorrectAnswerResult(:final explanation) => (
        const AnswerStatusIcon(isCorrect: false),
        explanation,
      ),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: icon),
        if (explanation != null) ...[
          const SizedBox(width: 6),
          Flexible(child: Text(explanation, textAlign: TextAlign.center)),
        ],
      ],
    );
  }
}
