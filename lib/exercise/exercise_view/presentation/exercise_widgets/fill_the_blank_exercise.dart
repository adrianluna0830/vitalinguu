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

enum FillTheBlankType { visibleText, answer, hint }

class FillTheBlank {
  final String text;
  final FillTheBlankType fillTheBlankType;

  const FillTheBlank({required this.text, required this.fillTheBlankType});
}

class FillTheBlankAnswerFeedback extends StatelessWidget {
  final int number;
  final BinaryAnswerResult result;

  const FillTheBlankAnswerFeedback({
    super.key,
    required this.number,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final (isCorrect, text) = switch (result) {
      CorrectBinaryAnswerResult() => (true, null),
      IncorrectBinaryAnswerResult(:final explanation) => (false, explanation),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnswerStatusIcon(isCorrect: isCorrect),
        const SizedBox(width: 6),
        Text('$number.'),
        if (text != null) ...[
          const SizedBox(width: 4),
          Flexible(child: Text(text, textAlign: TextAlign.center)),
        ],
      ],
    );
  }
}

class FillTheBlankExercise extends StatefulWidget {
  final ExerciseTask exerciseTask;
  final List<FillTheBlank> fillTheBlanks;
  final ValueChanged<List<String>> onAnswerSubmitted;
  final List<BinaryAnswerResult>? answerResult;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const FillTheBlankExercise({
    super.key,
    required this.exerciseTask,
    required this.fillTheBlanks,
    required this.onAnswerSubmitted,
    this.answerResult,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<FillTheBlankExercise> createState() => _FillTheBlankExerciseState();
}

class _FillTheBlankExerciseState extends State<FillTheBlankExercise> {
  late List<TextEditingController> _controllers;
  bool _isSubmitted = false;

  bool get _canSubmit =>
      !_isSubmitted &&
      _controllers.isNotEmpty &&
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    _createControllers();
  }

  @override
  void didUpdateWidget(FillTheBlankExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fillTheBlanks != widget.fillTheBlanks) {
      _disposeControllers();
      _createControllers();
      _isSubmitted = false;
    }
  }

  void _createControllers() {
    _controllers = [
      for (final blank in widget.fillTheBlanks)
        if (blank.fillTheBlankType == FillTheBlankType.answer)
          TextEditingController(),
    ];
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  void _submit() {
    if (!_canSubmit) return;
    final answers = _controllers.map((controller) => controller.text).toList();
    setState(() => _isSubmitted = true);
    widget.onAnswerSubmitted(answers);
  }

  String _inlineText(String text) => text.replaceAll(RegExp(r'\s+'), ' ');

  double _answerFieldWidth(BuildContext context, String answer) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _inlineText(answer).trim(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    return (textPainter.width + 36).clamp(80, 200).toDouble();
  }

  Widget _answerWidget(
    BuildContext context, {
    required FillTheBlank answer,
    required TextEditingController controller,
    FillTheBlank? hint,
  }) {
    final answerField = SizedBox(
      width: _answerFieldWidth(context, answer.text),
      height: 42,
      child: TextField(
        controller: controller,
        enabled: !_isSubmitted,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(),
        ),
      ),
    );

    if (hint == null) return answerField;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        answerField,
        Text(
          '(${_inlineText(hint.text).trim()})',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  List<Widget> _fillTheBlankWidgets(BuildContext context) {
    var controllerIndex = 0;
    final widgets = <Widget>[];

    for (var index = 0; index < widget.fillTheBlanks.length; index++) {
      final blank = widget.fillTheBlanks[index];
      switch (blank.fillTheBlankType) {
        case FillTheBlankType.answer:
          final hint =
              index + 1 < widget.fillTheBlanks.length &&
                  widget.fillTheBlanks[index + 1].fillTheBlankType ==
                      FillTheBlankType.hint
              ? widget.fillTheBlanks[index + 1]
              : null;
          final answerWidget = _answerWidget(
            context,
            answer: blank,
            controller: _controllers[controllerIndex++],
            hint: hint,
          );
          if (hint == null) {
            widgets.add(answerWidget);
          } else {
            final hintIndex = index + 1;
            final translationKey = TranslationKeys.fragment(hintIndex);
            widgets.add(
              _TranslatableFillFragment(
                key: ValueKey(translationKey),
                translationState: widget.translations[translationKey],
                onTranslationRequested: () {
                  widget.onTranslate(translationKey, hint.text);
                },
                child: answerWidget,
              ),
            );
            index++;
          }
        case FillTheBlankType.hint:
          final hintTranslationKey = TranslationKeys.fragment(index);
          widgets.add(
            _TranslatableFillFragment(
              key: ValueKey(hintTranslationKey),
              translationState: widget.translations[hintTranslationKey],
              onTranslationRequested: () {
                widget.onTranslate(hintTranslationKey, blank.text);
              },
              child: Text('(${_inlineText(blank.text).trim()})'),
            ),
          );
        case FillTheBlankType.visibleText:
          final visibleTranslationKey = TranslationKeys.fragment(index);
          widgets.add(
            _TranslatableFillFragment(
              key: ValueKey(visibleTranslationKey),
              translationState: widget.translations[visibleTranslationKey],
              onTranslationRequested: () {
                widget.onTranslate(visibleTranslationKey, blank.text);
              },
              child: Text(
                _inlineText(blank.text),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
      }
    }

    return widgets;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
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
                  ExercisePromptDisplay(
                    exerciseContent: null,
                    exerciseTask: widget.exerciseTask,
                    contentTranslationState: null,
                    onContentTranslationRequested: () {},
                    taskTranslationState:
                        widget.translations[TranslationKeys.task],
                    onTaskTranslationRequested: () {
                      widget.onTranslate(
                        TranslationKeys.task,
                        widget.exerciseTask.exerciseTask,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 6,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _fillTheBlankWidgets(context),
                  ),
                  if (widget.answerResult case final results?) ...[
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        for (var index = 0; index < results.length; index++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FillTheBlankAnswerFeedback(
                              number: index + 1,
                              result: results[index],
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (!_isSubmitted) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _canSubmit ? _submit : null,
                      child: Text(context.t.exercise.confirmAnswers),
                    ),
                  ],
                  const SizedBox(height: 8),
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

class _TranslatableFillFragment extends StatefulWidget {
  final Widget child;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableFillFragment({
    super.key,
    required this.child,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<_TranslatableFillFragment> createState() =>
      _TranslatableFillFragmentState();
}

class _TranslatableFillFragmentState extends State<_TranslatableFillFragment> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableFillFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              padding: EdgeInsets.zero,
              iconSize: 16,
              onPressed: _toggleTranslation,
              icon: const Icon(Icons.translate),
            ),
            const SizedBox(width: 4),
            Flexible(child: widget.child),
          ],
        ),
        if (_isTranslationActive) ...[
          const SizedBox(height: 4),
          TranslationDisplay(
            translationState: widget.translationState,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }
}
