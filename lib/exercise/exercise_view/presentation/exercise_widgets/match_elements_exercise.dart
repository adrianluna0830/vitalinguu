import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_status_icon.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';

class Match {
  final String leftElement;
  final String rightElement;
  Match({required this.leftElement, required this.rightElement});
}

class MatchFeedback {
  final Match match;
  final String? explanation;
  MatchFeedback({required this.match, required this.explanation});
}

typedef _RightElementData = ({int originalIndex, String text});

class MatchElementsExercise extends StatefulWidget {
  final ExerciseTask exerciseTask;
  final List<Match> matches;
  final ValueChanged<List<Match>> onAnswerSubmitted;
  final List<MatchFeedback>? answerResult;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const MatchElementsExercise({
    super.key,
    required this.exerciseTask,
    required this.matches,
    required this.onAnswerSubmitted,
    this.answerResult,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<MatchElementsExercise> createState() => _MatchElementsExerciseState();
}

class _MatchElementsExerciseState extends State<MatchElementsExercise> {
  late bool _isSubmitted;
  late List<_RightElementData> _rightElements;
  late Map<int, GlobalKey<_MatchElementCardState>> _rightElementKeys;

  @override
  void initState() {
    super.initState();
    _isSubmitted = widget.answerResult != null;
    _resetRightElements();
  }

  @override
  void didUpdateWidget(MatchElementsExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.matches != widget.matches) {
      _isSubmitted = widget.answerResult != null;
      _resetRightElements();
    } else if (widget.answerResult != null) {
      _isSubmitted = true;
    }
  }

  void _resetRightElements() {
    _rightElementKeys = {
      for (var index = 0; index < widget.matches.length; index++)
        index: GlobalKey<_MatchElementCardState>(),
    };
    _rightElements = [
      for (var index = 0; index < widget.matches.length; index++)
        (originalIndex: index, text: widget.matches[index].rightElement),
    ]..shuffle();
  }

  void _swapRightElements(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    setState(() {
      final element = _rightElements[fromIndex];
      _rightElements[fromIndex] = _rightElements[toIndex];
      _rightElements[toIndex] = element;
    });
  }

  void _submit() {
    if (_isSubmitted) return;
    final answers = List.generate(
      widget.matches.length,
      (index) => Match(
        leftElement: widget.matches[index].leftElement,
        rightElement: _rightElements[index].text,
      ),
    );
    setState(() => _isSubmitted = true);
    widget.onAnswerSubmitted(answers);
  }

  Widget _rightElement(int index, ColorScheme colors) {
    final element = _rightElements[index];
    final translationKey = TranslationKeys.matchRight(element.originalIndex);
    final elementKey = _rightElementKeys[element.originalIndex]!;
    final card = _MatchElementCard(
      key: elementKey,
      text: element.text,
      backgroundColor: colors.secondaryContainer,
      borderColor: colors.outline,
      translationState: widget.translations[translationKey],
      onTranslationRequested: () {
        widget.onTranslate(translationKey, element.text);
      },
    );
    if (_isSubmitted) return card;

    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        _swapRightElements(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final draggableCard = _MatchElementCard(
          key: elementKey,
          text: element.text,
          backgroundColor: candidateData.isEmpty
              ? colors.secondaryContainer
              : colors.primaryContainer,
          borderColor: colors.outline,
          translationState: widget.translations[translationKey],
          onTranslationRequested: () {
            widget.onTranslate(translationKey, element.text);
          },
        );

        return Draggable<int>(
          data: index,
          feedback: Material(
            elevation: 4,
            child: SizedBox(
              width: 160,
              child: _MatchElementCard(
                text: element.text,
                backgroundColor: colors.secondaryContainer,
                borderColor: colors.outline,
                translationState: widget.translations[translationKey],
                onTranslationRequested: () {
                  widget.onTranslate(translationKey, element.text);
                },
              ),
            ),
          ),
          childWhenDragging: _MatchElementCard(
            key: elementKey,
            text: element.text,
            backgroundColor: colors.surfaceContainerHighest,
            borderColor: colors.outlineVariant,
            translationState: widget.translations[translationKey],
            onTranslationRequested: () {
              widget.onTranslate(translationKey, element.text);
            },
            isPlaceholder: true,
          ),
          child: draggableCard,
        );
      },
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
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      for (
                        var index = 0;
                        index < widget.matches.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _MatchElementCard(
                                key: ValueKey(TranslationKeys.matchLeft(index)),
                                text: widget.matches[index].leftElement,
                                backgroundColor: colors.surfaceContainerHighest,
                                borderColor: colors.outlineVariant,
                                translationState:
                                    widget
                                        .translations[TranslationKeys.matchLeft(
                                      index,
                                    )],
                                onTranslationRequested: () {
                                  widget.onTranslate(
                                    TranslationKeys.matchLeft(index),
                                    widget.matches[index].leftElement,
                                  );
                                },
                                index: index + 1,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward),
                            ),
                            Expanded(child: _rightElement(index, colors)),
                          ],
                        ),
                      ],
                    ],
                  ),
                  if (widget.answerResult case final results?) ...[
                    const SizedBox(height: 16),
                    _MatchAnswersFeedback(results: results),
                  ],
                  if (!_isSubmitted) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(context.t.exercise.confirmAnswers),
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

class _MatchAnswersFeedback extends StatelessWidget {
  final List<MatchFeedback> results;

  const _MatchAnswersFeedback({required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var index = 0; index < results.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          _MatchAnswerFeedback(index: index + 1, feedback: results[index]),
        ],
      ],
    );
  }
}

class _MatchAnswerFeedback extends StatelessWidget {
  final int index;
  final MatchFeedback feedback;

  const _MatchAnswerFeedback({required this.index, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final explanation = feedback.explanation;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: AnswerStatusIcon(isCorrect: feedback.explanation == null),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$index. ${feedback.match.leftElement} → '
            '${feedback.match.rightElement}'
            '${explanation == null ? '' : ' — $explanation'}',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _MatchElementCard extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;
  final int? index;
  final bool isPlaceholder;

  const _MatchElementCard({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.translationState,
    required this.onTranslationRequested,
    this.index,
    this.isPlaceholder = false,
  });

  @override
  State<_MatchElementCard> createState() => _MatchElementCardState();
}

class _MatchElementCardState extends State<_MatchElementCard> {
  bool _isTranslationActive = false;

  @override
  void didUpdateWidget(_MatchElementCard oldWidget) {
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
    if (widget.isPlaceholder) {
      return Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: widget.index == null ? 0 : 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    Expanded(
                      child: Text(
                        widget.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
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
          if (widget.index case final index?)
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}
