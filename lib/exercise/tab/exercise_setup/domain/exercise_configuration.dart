import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';

enum Priority { low, medium, high }

enum ExerciseType {
  dialog(supportsAudio: true),
  fillTheBlank(supportsAudio: false),
  matchElements(supportsAudio: false),
  multipleChoice(supportsAudio: true),
  multipleChoiceList(supportsAudio: true),
  selectAllThatApply(supportsAudio: true),
  wordOrdering(supportsAudio: false),
  write(supportsAudio: true),
  writeList(supportsAudio: true);

  final bool supportsAudio;

  const ExerciseType({required this.supportsAudio});
}

class ExerciseTypeConfiguration {
  final ExerciseType exerciseType;
  final Priority priority;

  const ExerciseTypeConfiguration({
    required this.exerciseType,
    required this.priority,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeConfiguration && other.exerciseType == exerciseType;

  @override
  int get hashCode => exerciseType.hashCode;
}

sealed class PromptConfiguration {}

class TextOnly extends PromptConfiguration {
  final Priority priority;

  TextOnly({this.priority = Priority.medium});
}

class AudioOnly extends PromptConfiguration {
  final Priority priority;

  AudioOnly({this.priority = Priority.medium});
}

class TextAndAudio extends PromptConfiguration {
  final Priority textPriority;
  final Priority audioPriority;

  TextAndAudio({required this.textPriority, required this.audioPriority});
}

class ExerciseAudioGenerationConfiguration {
  final bool isAudio;
  final double speechSpeed;

  const ExerciseAudioGenerationConfiguration({
    required this.isAudio,
    required this.speechSpeed,
  });
}

enum CEFR {
  a1(isDefault: true),
  a2(),
  b1(),
  b2(),
  c1(),
  c2();

  final bool isDefault;

  const CEFR({this.isDefault = false});

  static CEFR get defaultValue => values.singleWhere((cefr) => cefr.isDefault);
}

class TopicConfiguration {
  final Topic topic;
  final Priority priority;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicConfiguration && other.topic.id == topic.id;

  @override
  int get hashCode => topic.id.hashCode;

  const TopicConfiguration({required this.topic, required this.priority});
}

class ExerciseConfiguration {
  final Set<ExerciseTypeConfiguration> exerciseTypes;
  final PromptConfiguration promptConfiguration;
  final Set<TopicConfiguration> topics;
  final int exerciseCount;
  final CEFR cefr;

  ExerciseConfiguration({
    required this.exerciseTypes,
    required this.promptConfiguration,
    required this.exerciseCount,
    required this.cefr,
    required this.topics,
  });
}
