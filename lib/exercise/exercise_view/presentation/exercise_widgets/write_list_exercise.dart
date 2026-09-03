import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/answer_result.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_status_icon.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';

class WriteListExercise extends StatefulWidget {
  final ExercisePromptData exercisePromptData;
  final List<String> prompts;
  final ValueChanged<List<String>> onAnswerSubmitted;
  final List<AnswerResult>? answerResult;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const WriteListExercise({
    super.key,
    required this.exercisePromptData,
    required this.prompts,
    required this.onAnswerSubmitted,
    this.answerResult,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<WriteListExercise> createState() => _WriteListExerciseState();
}

class _WriteListExerciseState extends State<WriteListExercise> {
  late List<TextEditingController> _controllers;
  bool _isSubmitted = false;

  bool get _canSubmit =>
      !_isSubmitted &&
      _controllers.isNotEmpty &&
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    _isSubmitted = widget.answerResult != null;
    _createControllers();
  }

  @override
  void didUpdateWidget(WriteListExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prompts != widget.prompts) {
      _disposeControllers();
      _createControllers();
      _isSubmitted = widget.answerResult != null;
    } else if (widget.answerResult != null) {
      _isSubmitted = true;
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _createControllers() {
    _controllers = List.generate(
      widget.prompts.length,
      (_) => TextEditingController(),
    );
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  void _submit() {
    if (!_canSubmit) return;
    setState(() => _isSubmitted = true);
    widget.onAnswerSubmitted(
      _controllers.map((controller) => controller.text.trim()).toList(),
    );
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
                  for (
                    var index = 0;
                    index < widget.prompts.length;
                    index++
                  ) ...[
                    if (index > 0) const SizedBox(height: 12),
                    _TranslatableWritePrompt(
                      key: ValueKey(TranslationKeys.listPrompt(index)),
                      index: index + 1,
                      text: widget.prompts[index],
                      translationState: widget
                          .translations[TranslationKeys.listPrompt(index)],
                      onTranslationRequested: () {
                        widget.onTranslate(
                          TranslationKeys.listPrompt(index),
                          widget.prompts[index],
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controllers[index],
                      enabled: !_isSubmitted,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: null,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                  if (!_isSubmitted) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _canSubmit ? _submit : null,
                      child: Text(context.t.exercise.confirmAnswers),
                    ),
                  ],
                  if (widget.answerResult case final results?) ...[
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        for (
                          var index = 0;
                          index < results.length;
                          index++
                        ) ...[
                          if (index > 0) const SizedBox(height: 8),
                          _WriteListAnswerFeedback(
                            number: index + 1,
                            result: results[index],
                          ),
                        ],
                      ],
                    ),
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

class _TranslatableWritePrompt extends StatefulWidget {
  final int index;
  final String text;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableWritePrompt({
    super.key,
    required this.index,
    required this.text,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<_TranslatableWritePrompt> createState() =>
      _TranslatableWritePromptState();
}

class _TranslatableWritePromptState extends State<_TranslatableWritePrompt> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableWritePrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _isTranslationActive = false;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('${widget.index}.'),
            const SizedBox(width: 4),
            IconButton(
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              padding: EdgeInsets.zero,
              iconSize: 16,
              onPressed: _toggleTranslation,
              icon: const Icon(Icons.translate),
            ),
            const SizedBox(width: 4),
            Expanded(child: Text(widget.text)),
          ],
        ),
        if (_isTranslationActive) ...[
          const SizedBox(height: 4),
          TranslationDisplay(
            translationState: widget.translationState,
            textAlign: TextAlign.start,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }
}

class _WriteListAnswerFeedback extends StatelessWidget {
  final int number;
  final AnswerResult result;

  const _WriteListAnswerFeedback({required this.number, required this.result});

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
        const SizedBox(width: 6),
        Text('$number.'),
        if (explanation != null) ...[
          const SizedBox(width: 4),
          Flexible(child: Text(explanation, textAlign: TextAlign.center)),
        ],
      ],
    );
  }
}
