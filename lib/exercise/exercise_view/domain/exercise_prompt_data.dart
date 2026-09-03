import 'package:vitalinguu/exercise/exercise_view/domain/exercise_audio_args.dart';

class ExerciseContent {
  final String exerciseContent;
  final ExerciseAudioArgs? exerciseContentAudio;

  const ExerciseContent({
    required this.exerciseContent,
    required this.exerciseContentAudio,
  });
}

class ExerciseTask {
  final String exerciseTask;

  const ExerciseTask({required this.exerciseTask});
}

sealed class ExercisePromptData {
  const ExercisePromptData();
}

final class StandaloneExerciseTask extends ExercisePromptData {
  final ExerciseTask exerciseTask;

  const StandaloneExerciseTask({required this.exerciseTask});
}

final class ContentBasedExerciseTask extends ExercisePromptData {
  final ExerciseContent exerciseContent;
  final ExerciseTask exerciseTask;

  const ContentBasedExerciseTask({
    required this.exerciseContent,
    required this.exerciseTask,
  });
}

extension ExercisePromptDataValues on ExercisePromptData {
  ExerciseTask get exerciseTask => switch (this) {
    StandaloneExerciseTask(:final exerciseTask) => exerciseTask,
    ContentBasedExerciseTask(:final exerciseTask) => exerciseTask,
  };

  ExerciseContent? get exerciseContentOrNull => switch (this) {
    StandaloneExerciseTask() => null,
    ContentBasedExerciseTask(:final exerciseContent) => exerciseContent,
  };
}
