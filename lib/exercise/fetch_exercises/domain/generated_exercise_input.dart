import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/fill_the_blank_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_list_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/select_all_that_apply_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';

class GeneratedDialogInput {
  final String exerciseTask;
  final List<String> participantNames;

  GeneratedDialogInput({
    required this.exerciseTask,
    required this.participantNames,
  });
}

class GeneratedFillTheBlankInput {
  final String exerciseTask;
  final List<FillTheBlank> fillTheBlanks;

  GeneratedFillTheBlankInput({
    required this.exerciseTask,
    required this.fillTheBlanks,
  });
}

class GeneratedMatchElementsInput {
  final String exerciseTask;
  final List<Match> matches;

  GeneratedMatchElementsInput({
    required this.exerciseTask,
    required this.matches,
  });
}

class GeneratedMultipleChoiceInput {
  final String exerciseContent;
  final String exerciseTask;
  final CorrectOption correctOption;
  final IncorrectOption incorrectOption1;
  final IncorrectOption incorrectOption2;
  final IncorrectOption incorrectOption3;

  GeneratedMultipleChoiceInput({
    required this.exerciseContent,
    required this.exerciseTask,
    required this.correctOption,
    required this.incorrectOption1,
    required this.incorrectOption2,
    required this.incorrectOption3,
  });
}

class GeneratedMultipleChoiceListInput {
  final String exerciseContent;
  final List<MultipleChoiceOptions> options;

  GeneratedMultipleChoiceListInput({
    required this.exerciseContent,
    required this.options,
  });
}

class GeneratedSelectAllThatApplyInput {
  final String exerciseContent;
  final String exerciseTask;
  final List<SelectAllThatApplyExerciseOption> options;

  GeneratedSelectAllThatApplyInput({
    required this.exerciseContent,
    required this.exerciseTask,
    required this.options,
  });
}

class GeneratedWordOrderingInput {
  final String exerciseTask;
  final List<String> wordsInOrder;

  GeneratedWordOrderingInput({
    required this.exerciseTask,
    required this.wordsInOrder,
  });
}

class GeneratedWriteInput {
  final String exerciseContent;
  final String exerciseTask;

  GeneratedWriteInput({
    required this.exerciseContent,
    required this.exerciseTask,
  });
}

class GeneratedWriteListInput {
  final String exerciseContent;
  final List<String> prompts;

  GeneratedWriteListInput({
    required this.exerciseContent,
    required this.prompts,
  });
}
