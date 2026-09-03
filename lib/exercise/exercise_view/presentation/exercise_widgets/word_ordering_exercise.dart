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

typedef _WordData = ({int originalIndex, String text});

class WordOrderingExercise extends StatefulWidget {
  final ExerciseTask exerciseTask;
  final List<String> wordsInOrder;
  final ValueChanged<List<String>> onAnswerSubmitted;
  final BinaryAnswerResult? answerResult;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const WordOrderingExercise({
    super.key,
    required this.exerciseTask,
    required this.wordsInOrder,
    required this.onAnswerSubmitted,
    this.answerResult,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<WordOrderingExercise> createState() => _WordOrderingExerciseState();
}

class _WordOrderingExerciseState extends State<WordOrderingExercise> {
  late List<_WordData> _words;
  bool _isSubmitted = false;

  bool get _canSubmit => !_isSubmitted && _words.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _isSubmitted = widget.answerResult != null;
    _resetWords();
  }

  @override
  void didUpdateWidget(WordOrderingExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wordsInOrder != widget.wordsInOrder) {
      _isSubmitted = widget.answerResult != null;
      _resetWords();
    } else if (widget.answerResult != null) {
      _isSubmitted = true;
    }
  }

  void _resetWords() {
    _words = [
      for (var index = 0; index < widget.wordsInOrder.length; index++)
        (originalIndex: index, text: widget.wordsInOrder[index]),
    ]..shuffle();
    if (_words.length > 1 && _hasSameOrder(_words, widget.wordsInOrder)) {
      _words.add(_words.removeAt(0));
    }
  }

  bool _hasSameOrder(List<_WordData> first, List<String> second) {
    for (var index = 0; index < first.length; index++) {
      if (first[index].text != second[index]) return false;
    }
    return true;
  }

  void _swapWords(int fromIndex, int toIndex) {
    if (_isSubmitted || fromIndex == toIndex) return;
    setState(() {
      final word = _words[fromIndex];
      _words[fromIndex] = _words[toIndex];
      _words[toIndex] = word;
    });
  }

  void _submit() {
    if (!_canSubmit) return;
    setState(() => _isSubmitted = true);
    widget.onAnswerSubmitted(_words.map((word) => word.text).toList());
  }

  Widget _word(int index, ColorScheme colors) {
    final word = _words[index];
    final translationKey = TranslationKeys.fragment(word.originalIndex);
    final card = _WordCard(
      key: ValueKey(translationKey),
      text: word.text,
      backgroundColor: colors.secondaryContainer,
      borderColor: colors.outline,
      translationState: widget.translations[translationKey],
      onTranslationRequested: () {
        widget.onTranslate(translationKey, word.text);
      },
    );
    if (_isSubmitted) {
      return KeyedSubtree(key: ValueKey(translationKey), child: card);
    }

    return KeyedSubtree(
      key: ValueKey(translationKey),
      child: DragTarget<int>(
        onAcceptWithDetails: (details) => _swapWords(details.data, index),
        builder: (context, candidateData, rejectedData) {
          final draggableCard = _WordCard(
            key: ValueKey(translationKey),
            text: word.text,
            backgroundColor: candidateData.isEmpty
                ? colors.secondaryContainer
                : colors.primaryContainer,
            borderColor: colors.outline,
            translationState: widget.translations[translationKey],
            onTranslationRequested: () {
              widget.onTranslate(translationKey, word.text);
            },
          );

          return Draggable<int>(
            data: index,
            feedback: Material(elevation: 4, child: draggableCard),
            childWhenDragging: _WordCard(
              key: ValueKey(translationKey),
              text: word.text,
              backgroundColor: colors.secondaryContainer,
              borderColor: colors.outline,
              translationState: widget.translations[translationKey],
              onTranslationRequested: () {
                widget.onTranslate(translationKey, word.text);
              },
              opacity: 0.25,
            ),
            child: draggableCard,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var index = 0; index < _words.length; index++)
                        _word(index, colors),
                    ],
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
                    _WordOrderingFeedback(
                      result: result,
                      wordsInOrder: widget.wordsInOrder,
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

class _WordCard extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;
  final double opacity;

  const _WordCard({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.translationState,
    required this.onTranslationRequested,
    this.opacity = 1,
  });

  @override
  State<_WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<_WordCard> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_WordCard oldWidget) {
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
    return Opacity(
      opacity: widget.opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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
                Flexible(child: Text(widget.text)),
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
        ),
      ),
    );
  }
}

class _WordOrderingFeedback extends StatelessWidget {
  final BinaryAnswerResult result;
  final List<String> wordsInOrder;

  const _WordOrderingFeedback({
    required this.result,
    required this.wordsInOrder,
  });

  @override
  Widget build(BuildContext context) {
    final explanation = switch (result) {
      CorrectBinaryAnswerResult() => null,
      IncorrectBinaryAnswerResult(:final explanation) => explanation,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnswerStatusIcon(isCorrect: explanation == null),
        if (explanation != null) ...[
          const SizedBox(height: 8),
          Text(wordsInOrder.join(' '), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(explanation, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}
