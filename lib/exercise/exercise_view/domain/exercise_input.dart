import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/fill_the_blank_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_list_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/select_all_that_apply_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';

sealed class ExerciseInput {
  final String topicId;
  final String topicTitle;
  final String topicContent;

  ExerciseInput({
    required this.topicId,
    required this.topicTitle,
    required this.topicContent,
  });
}

class DialogInput extends ExerciseInput {
  final PromptConfiguration promptConfiguration;
  final ExerciseTask exerciseTask;
  final List<String> participantNames;
  final bool startWithTyping;
  final double speechSpeed;

  DialogInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.promptConfiguration,
    required this.exerciseTask,
    required this.participantNames,
    required this.startWithTyping,
    required this.speechSpeed,
  });
}

class FillTheBlankInput extends ExerciseInput {
  final ExerciseTask exerciseTask;
  final List<FillTheBlank> fillTheBlanks;

  FillTheBlankInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exerciseTask,
    required this.fillTheBlanks,
  });
}

class MatchElementsInput extends ExerciseInput {
  final ExerciseTask exerciseTask;
  final List<Match> matches;

  MatchElementsInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exerciseTask,
    required this.matches,
  });
}

class MultipleChoiceInput extends ExerciseInput {
  final ExercisePromptData exercisePromptData;
  final CorrectOption correctOption;
  final IncorrectOption incorrectOption1;
  final IncorrectOption incorrectOption2;
  final IncorrectOption incorrectOption3;

  MultipleChoiceInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exercisePromptData,
    required this.correctOption,
    required this.incorrectOption1,
    required this.incorrectOption2,
    required this.incorrectOption3,
  });
}

class MultipleChoiceListInput extends ExerciseInput {
  final ExercisePromptData exercisePromptData;
  final List<MultipleChoiceOptions> options;

  MultipleChoiceListInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exercisePromptData,
    required this.options,
  });
}

class SelectAllThatApplyInput extends ExerciseInput {
  final ExercisePromptData exercisePromptData;
  final List<SelectAllThatApplyExerciseOption> options;

  SelectAllThatApplyInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exercisePromptData,
    required this.options,
  });
}

class WordOrderingInput extends ExerciseInput {
  final ExerciseTask exerciseTask;
  final List<String> wordsInOrder;

  WordOrderingInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exerciseTask,
    required this.wordsInOrder,
  });
}

class WriteInput extends ExerciseInput {
  final ExercisePromptData exercisePromptData;

  WriteInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exercisePromptData,
  });
}

class WriteListInput extends ExerciseInput {
  final ExercisePromptData exercisePromptData;
  final List<String> prompts;

  WriteListInput({
    required super.topicId,
    required super.topicTitle,
    required super.topicContent,
    required this.exercisePromptData,
    required this.prompts,
  });
}
