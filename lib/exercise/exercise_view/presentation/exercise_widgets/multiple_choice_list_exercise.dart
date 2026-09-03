import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_feedback.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';

typedef _AnswerOptionData = ({
  String translationKey,
  String text,
  bool isCorrect,
  String? explanation,
});

class MultipleChoiceOptions {
  final String text;
  final CorrectOption correctOption;
  final IncorrectOption incorrectOption1;
  final IncorrectOption incorrectOption2;
  final IncorrectOption incorrectOption3;

  MultipleChoiceOptions({
    required this.text,
    required this.correctOption,
    required this.incorrectOption1,
    required this.incorrectOption2,
    required this.incorrectOption3,
  });
}

class IncorrectSelectedOption {
  final String text;
  final String selectedOption;

  IncorrectSelectedOption({required this.text, required this.selectedOption});
}

class MultipleChoiceListExercise extends StatefulWidget {
  final ExercisePromptData exercisePromptData;
  final List<MultipleChoiceOptions> options;
  final ValueChanged<String> onWrongAnswer;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const MultipleChoiceListExercise({
    super.key,
    required this.exercisePromptData,
    required this.options,
    required this.onWrongAnswer,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<MultipleChoiceListExercise> createState() =>
      _MultipleChoiceListExerciseState();
}

class _MultipleChoiceListExerciseState
    extends State<MultipleChoiceListExercise> {
  late List<List<_AnswerOptionData>> _shuffledOptions;
  late List<_AnswerOptionData?> _selectedOptions;
  bool _isConfirmed = false;

  bool get _allAnswered =>
      _selectedOptions.isNotEmpty &&
      _selectedOptions.every((option) => option != null);

  @override
  void initState() {
    super.initState();
    _resetOptions();
  }

  @override
  void didUpdateWidget(MultipleChoiceListExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) _resetOptions();
  }

  void _resetOptions() {
    _isConfirmed = false;
    _selectedOptions = List.filled(widget.options.length, null);
    _shuffledOptions = [
      for (var itemIndex = 0; itemIndex < widget.options.length; itemIndex++)
        [
          (
            translationKey: TranslationKeys.listOption(itemIndex, 0),
            text: widget.options[itemIndex].correctOption.text,
            isCorrect: true,
            explanation: null,
          ),
          (
            translationKey: TranslationKeys.listOption(itemIndex, 1),
            text: widget.options[itemIndex].incorrectOption1.text,
            isCorrect: false,
            explanation: widget.options[itemIndex].incorrectOption1.explanation,
          ),
          (
            translationKey: TranslationKeys.listOption(itemIndex, 2),
            text: widget.options[itemIndex].incorrectOption2.text,
            isCorrect: false,
            explanation: widget.options[itemIndex].incorrectOption2.explanation,
          ),
          (
            translationKey: TranslationKeys.listOption(itemIndex, 3),
            text: widget.options[itemIndex].incorrectOption3.text,
            isCorrect: false,
            explanation: widget.options[itemIndex].incorrectOption3.explanation,
          ),
        ]..shuffle(),
    ];
  }

  void _selectOption(int index, _AnswerOptionData option) {
    if (_isConfirmed) return;
    setState(() => _selectedOptions[index] = option);
  }

  void _confirm() {
    if (!_allAnswered) return;
    setState(() => _isConfirmed = true);
    for (final option in _selectedOptions) {
      if (!option!.isCorrect) widget.onWrongAnswer(option.text);
    }
  }

  Widget _option(
    int index,
    _AnswerOptionData option, {
    bool feedbackBelow = false,
  }) {
    final isSelectedByUser = _selectedOptions[index] == option;
    final feedback = option.isCorrect
        ? const CorrectAnswer()
        : IncorrectAnswer(text: option.explanation!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isConfirmed && !feedbackBelow) ...[
          feedback,
          const SizedBox(height: 8),
        ],
        _TranslatableListAnswerOption(
          key: ValueKey(option.translationKey),
          hasUserSelected: _isConfirmed,
          isSelectedByUser: isSelectedByUser,
          text: option.text,
          onClick: () => _selectOption(index, option),
          selectedColor: option.isCorrect ? Colors.green : Colors.red,
          translationState: widget.translations[option.translationKey],
          onTranslationRequested: () {
            widget.onTranslate(option.translationKey, option.text);
          },
        ),
        if (_isConfirmed && feedbackBelow) ...[
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
                  for (
                    var index = 0;
                    index < widget.options.length;
                    index++
                  ) ...[
                    SizedBox(height: index == 0 ? 16 : 32),
                    _TranslatableListItem(
                      key: ValueKey(TranslationKeys.listPrompt(index)),
                      text: widget.options[index].text,
                      translationState: widget
                          .translations[TranslationKeys.listPrompt(index)],
                      onTranslationRequested: () {
                        widget.onTranslate(
                          TranslationKeys.listPrompt(index),
                          widget.options[index].text,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _option(index, _shuffledOptions[index][0]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _option(index, _shuffledOptions[index][1]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _option(
                            index,
                            _shuffledOptions[index][2],
                            feedbackBelow: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _option(
                            index,
                            _shuffledOptions[index][3],
                            feedbackBelow: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (!_isConfirmed) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _allAnswered ? _confirm : null,
                      child: Text(context.t.exercise.confirmAnswers),
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (_isConfirmed)
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

class _TranslatableListItem extends StatefulWidget {
  final String text;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableListItem({
    super.key,
    required this.text,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<_TranslatableListItem> createState() => _TranslatableListItemState();
}

class _TranslatableListItemState extends State<_TranslatableListItem> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableListItem oldWidget) {
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              padding: EdgeInsets.zero,
              iconSize: 16,
              onPressed: _toggleTranslation,
              icon: const Icon(Icons.translate),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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

class _TranslatableListAnswerOption extends StatefulWidget {
  final bool hasUserSelected;
  final bool isSelectedByUser;
  final String text;
  final VoidCallback onClick;
  final Color selectedColor;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableListAnswerOption({
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
  State<_TranslatableListAnswerOption> createState() =>
      _TranslatableListAnswerOptionState();
}

class _TranslatableListAnswerOptionState
    extends State<_TranslatableListAnswerOption> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableListAnswerOption oldWidget) {
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
