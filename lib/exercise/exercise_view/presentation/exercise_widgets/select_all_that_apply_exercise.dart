import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_status_icon.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

sealed class SelectAllThatApplyExerciseOption {
  final String option;
  SelectAllThatApplyExerciseOption({required this.option});
}

class SelectAllThatApplyIncorrectOption
    extends SelectAllThatApplyExerciseOption {
  final String explanation;

  SelectAllThatApplyIncorrectOption({
    required this.explanation,
    required super.option,
  });
}

class SelectAllThatApplyCorrectOption extends SelectAllThatApplyExerciseOption {
  SelectAllThatApplyCorrectOption({required super.option});
}

class SelectAllThatApplyExercise extends StatefulWidget {
  final ExercisePromptData exercisePromptData;
  final List<SelectAllThatApplyExerciseOption> options;
  final ValueChanged<String> onWrongAnswer;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const SelectAllThatApplyExercise({
    super.key,
    required this.exercisePromptData,
    required this.options,
    required this.onWrongAnswer,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<SelectAllThatApplyExercise> createState() =>
      _SelectAllThatApplyExerciseState();
}

class _SelectAllThatApplyExerciseState
    extends State<SelectAllThatApplyExercise> {
  late List<SelectAllThatApplyExerciseOption> _options;
  final Set<SelectAllThatApplyExerciseOption> _selectedOptions = {};
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _resetOptions();
  }

  @override
  void didUpdateWidget(SelectAllThatApplyExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) _resetOptions();
  }

  void _resetOptions() {
    _options = [...widget.options]..shuffle();
    _selectedOptions.clear();
    _isConfirmed = false;
  }

  void _toggleOption(SelectAllThatApplyExerciseOption option) {
    if (_isConfirmed) return;
    setState(() {
      if (!_selectedOptions.remove(option)) _selectedOptions.add(option);
    });
  }

  void _confirm() {
    setState(() => _isConfirmed = true);
    for (final option in _selectedOptions) {
      if (option is SelectAllThatApplyIncorrectOption) {
        widget.onWrongAnswer(option.option);
      }
    }
  }

  Widget _option(SelectAllThatApplyExerciseOption option) {
    final originalIndex = widget.options.indexOf(option);
    final translationKey = TranslationKeys.option(originalIndex);
    final isSelected = _selectedOptions.contains(option);
    final isCorrect = option is SelectAllThatApplyCorrectOption;
    final explanation = switch (option) {
      SelectAllThatApplyIncorrectOption(:final explanation) => explanation,
      SelectAllThatApplyCorrectOption() => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TranslatableCheckboxOption(
          key: ValueKey(translationKey),
          value: isSelected,
          onChanged: _isConfirmed ? null : (_) => _toggleOption(option),
          text: option.option,
          secondary: _isConfirmed
              ? AnswerStatusIcon(isCorrect: isCorrect)
              : null,
          translationState: widget.translations[translationKey],
          onTranslationRequested: () {
            widget.onTranslate(translationKey, option.option);
          },
        ),
        if (_isConfirmed && explanation != null)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12, bottom: 8),
            child: Text(
              explanation,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
                  for (final option in _options) ...[
                    const SizedBox(height: 8),
                    _option(option),
                  ],
                  if (!_isConfirmed) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _confirm,
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

class _TranslatableCheckboxOption extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String text;
  final Widget? secondary;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const _TranslatableCheckboxOption({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.secondary,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<_TranslatableCheckboxOption> createState() =>
      _TranslatableCheckboxOptionState();
}

class _TranslatableCheckboxOptionState
    extends State<_TranslatableCheckboxOption> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_TranslatableCheckboxOption oldWidget) {
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
    return CheckboxListTile(
      value: widget.value,
      onChanged: widget.onChanged,
      title: Column(
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
              textAlign: TextAlign.start,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
      secondary: widget.secondary,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
