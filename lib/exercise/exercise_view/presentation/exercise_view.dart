import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/presentation/ai_error_stream_listener_mixin.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_input.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_state.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_view_model.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_chat_dialog.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/dialog_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/fill_the_blank_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_list_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/select_all_that_apply_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/word_ordering_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/write_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/write_list_exercise.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';

@RoutePage()
class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with AIErrorStreamListenerMixin {
  late final ExerciseViewModel viewModel;
  late final StreamSubscription<void> _exercisesFinishedSubscription;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<ExerciseViewModel>();
    _exercisesFinishedSubscription = viewModel.exercisesFinished.listen((_) {
      if (mounted) {
        unawaited(context.router.replace(const FetchTopicsFeedbackRoute()));
      }
    });
    listenToAIErrorStream(
      errorHandler: viewModel,
      onLeave: () {
        context.router.pop();
      },
    );
    final initialState = viewModel.exerciseState.value;
    if (initialState is DialogExerciseState &&
        initialState.input.startWithTyping) {
      unawaited(viewModel.setInitialMessage());
    }
  }

  @override
  void dispose() {
    unawaited(_exercisesFinishedSubscription.cancel());
    super.dispose();
  }

  void _showExerciseChatDialog() {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => SignalBuilder(
          builder: (context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(24),
              shape: const RoundedRectangleBorder(
                borderRadius: ExerciseChatDialog.borderRadius,
              ),
              child: ExerciseChatDialog(
                messages: viewModel.messages.value,
                onUserMessageSubmitted: viewModel.sendMessage,
                isTyping: viewModel.isTyping.value,
                onNewChat: viewModel.newChat,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final state = viewModel.exerciseState.value;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.exerciseTopicName,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${state.exerciseNumber} / '
                              '${viewModel.exerciseCount}',
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showExerciseChatDialog,
                        icon: const Icon(Icons.question_answer_outlined),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildExercise(state, viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExercise(
    ExerciseState<ExerciseInput> state,
    ExerciseViewModel viewModel,
  ) {
    void onWrongAnswer(String answer) {
      viewModel.addIncorrectAnswer(state.input, answer);
    }

    return switch (state) {
      DialogExerciseState() => DialogExercise(
        key: ValueKey(state.currentIndex),
        exerciseTask: state.input.exerciseTask,
        messages: state.messages,
        onUserMessageSubmitted: viewModel.sendDialogMessage,
        onDialogEndedAbruptly: viewModel.endDialogAbruptly,
        onNextExercise: viewModel.nextExercise,
        isTyping: state.isTyping,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      FillTheBlankExerciseState() => FillTheBlankExercise(
        key: ValueKey(state.currentIndex),
        exerciseTask: state.input.exerciseTask,
        fillTheBlanks: state.input.fillTheBlanks,
        onAnswerSubmitted: viewModel.evaluateFillTheBlankExercise,
        answerResult: state.answerResult,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      MatchElementsExerciseState() => MatchElementsExercise(
        key: ValueKey(state.currentIndex),
        exerciseTask: state.input.exerciseTask,
        matches: state.input.matches,
        onAnswerSubmitted: viewModel.evaluateMatchElementsExercise,
        answerResult: state.answerResult,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      MultipleChoiceExerciseState() => MultipleChoiceExercise(
        key: ValueKey(state.currentIndex),
        exercisePromptData: state.input.exercisePromptData,
        correctOption: state.input.correctOption,
        incorrectOption1: state.input.incorrectOption1,
        incorrectOption2: state.input.incorrectOption2,
        incorrectOption3: state.input.incorrectOption3,
        onWrongAnswer: onWrongAnswer,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      MultipleChoiceListExerciseState() => MultipleChoiceListExercise(
        key: ValueKey(state.currentIndex),
        exercisePromptData: state.input.exercisePromptData,
        options: state.input.options,
        onWrongAnswer: onWrongAnswer,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      SelectAllThatApplyExerciseState() => SelectAllThatApplyExercise(
        key: ValueKey(state.currentIndex),
        exercisePromptData: state.input.exercisePromptData,
        options: state.input.options,
        onWrongAnswer: onWrongAnswer,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      WordOrderingExerciseState() => WordOrderingExercise(
        key: ValueKey(state.currentIndex),
        exerciseTask: state.input.exerciseTask,
        wordsInOrder: state.input.wordsInOrder,
        onAnswerSubmitted: viewModel.evaluateWordOrderingExercise,
        answerResult: state.answerResult,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      WriteExerciseState() => WriteExercise(
        key: ValueKey(state.currentIndex),
        exercisePromptData: state.input.exercisePromptData,
        onAnswerSubmitted: viewModel.evaluateWriteExercise,
        answerResult: state.answerResult,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
      WriteListExerciseState() => WriteListExercise(
        key: ValueKey(state.currentIndex),
        exercisePromptData: state.input.exercisePromptData,
        prompts: state.input.prompts,
        onAnswerSubmitted: viewModel.evaluateWriteListExercise,
        answerResult: state.answerResult,
        onNextExercise: viewModel.nextExercise,
        translations: state.translations,
        onTranslate: viewModel.translate,
      ),
    };
  }
}
