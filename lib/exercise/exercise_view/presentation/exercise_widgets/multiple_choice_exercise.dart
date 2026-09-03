import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_feedback.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

typedef _AnswerOptionData = ({
  String translationKey,
  String text,
  bool isCorrect,
  String? explanation,
});

class MultipleChoiceExercise extends StatefulWidget {
  const MultipleChoiceExercise({
    super.key,
    required this.exercisePromptData,
    required this.correctOption,
    required this.incorrectOption1,
    required this.incorrectOption2,
    required this.incorrectOption3,
    required this.onWrongAnswer,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });
  final ExercisePromptData exercisePromptData;
  final CorrectOption correctOption;
  final IncorrectOption incorrectOption1;
  final IncorrectOption incorrectOption2;
  final IncorrectOption incorrectOption3;
  final ValueChanged<String> onWrongAnswer;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  @override
  State<MultipleChoiceExercise> createState() => _MultipleChoiceExerciseState();
}

class _MultipleChoiceExerciseState extends State<MultipleChoiceExercise> {
  late List<_AnswerOptionData> _options;
  _AnswerOptionData? _selectedOption;

  bool get _hasUserSelected => _selectedOption != null;

  @override
  void initState() {
    super.initState();
    _resetOptions();
  }

  @override
  void didUpdateWidget(MultipleChoiceExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.correctOption != widget.correctOption ||
        oldWidget.incorrectOption1 != widget.incorrectOption1 ||
        oldWidget.incorrectOption2 != widget.incorrectOption2 ||
        oldWidget.incorrectOption3 != widget.incorrectOption3) {
      _resetOptions();
    }
  }

  void _resetOptions() {
    _selectedOption = null;
    _options = [
      (
        translationKey: TranslationKeys.option(0),
        text: widget.correctOption.text,
        isCorrect: true,
        explanation: null,
      ),
      (
        translationKey: TranslationKeys.option(1),
        text: widget.incorrectOption1.text,
        isCorrect: false,
        explanation: widget.incorrectOption1.explanation,
      ),
      (
        translationKey: TranslationKeys.option(2),
        text: widget.incorrectOption2.text,
        isCorrect: false,
        explanation: widget.incorrectOption2.explanation,
      ),
      (
        translationKey: TranslationKeys.option(3),
        text: widget.incorrectOption3.text,
        isCorrect: false,
        explanation: widget.incorrectOption3.explanation,
      ),
    ]..shuffle();
  }

  void _selectOption(_AnswerOptionData option) {
    if (_hasUserSelected) return;
    setState(() => _selectedOption = option);
    if (!option.isCorrect) widget.onWrongAnswer(option.text);
  }

  Widget _option(_AnswerOptionData option, {bool feedbackBelow = false}) {
    final isSelectedByUser = _selectedOption == option;
    final feedback = option.isCorrect
        ? const CorrectAnswer()
        : IncorrectAnswer(text: option.explanation!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasUserSelected && !feedbackBelow) ...[
          feedback,
          const SizedBox(height: 8),
        ],
        _TranslatableAnswerOption(
          key: ValueKey(option.translationKey),
          hasUserSelected: _hasUserSelected,
          isSelectedByUser: isSelectedByUser,
          text: option.text,
          onClick: () => _selectOption(option),
          selectedColor: option.isCorrect ? Colors.green : Colors.red,
          translationState: widget.translations[option.translationKey],
          onTranslationRequested: () {
            widget.onTranslate(option.translationKey, option.text);
          },
        ),
        if (_hasUserSelected && feedbackBelow) ...[
          const SizedBox(height: 8),
          feedback,
        ],
      ],
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _option(_options[0])),
                      const SizedBox(width: 8),
                      Expanded(child: _option(_options[1])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _option(_options[2], feedbackBelow: true),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _option(_options[3], feedbackBelow: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_hasUserSelected)
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

class _TranslatableAnswerOption extends StatefulWidget {
  final bool hasUserSelected;
  final bool isSelectedByUser;
  final String text;
  final VoidCallback onClick;
  final Color selectedColor;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableAnswerOption({
    super.key,
    required this.hasUserSelected,
    required this.isSelectedByUser,
    required this.text,
    required this.onClick,
    required this.selectedColor,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<_TranslatableAnswerOption> createState() =>
      _TranslatableAnswerOptionState();
}

class _TranslatableAnswerOptionState extends State<_TranslatableAnswerOption> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableAnswerOption oldWidget) {
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isSelectedByUser ? Colors.black : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: widget.hasUserSelected
            ? widget.selectedColor
            : Colors.grey.shade200,
        child: InkWell(
          onTap: widget.hasUserSelected ? null : widget.onClick,
          hoverColor: widget.hasUserSelected
              ? Colors.transparent
              : Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: 24,
                        height: 24,
                      ),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
