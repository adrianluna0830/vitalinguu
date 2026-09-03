import 'dart:async';
import 'dart:math';

import 'package:signals/signals_core.dart';
import 'package:vitalinguu/core/domain/ai_error_retry_mixin.dart';
import 'package:vitalinguu/core/domain/interfaces/i_structured_output.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_input.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/domain/one_of.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment_repository.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/fill_the_blank_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_list_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/select_all_that_apply_exercise.dart';
import 'package:vitalinguu/core/domain/get_path.dart';
import 'package:vitalinguu/core/domain/interfaces/i_audio_player.dart';
import 'package:vitalinguu/core/domain/interfaces/i_text_to_speech.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_audio_args.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

part 'exercise_planner_mixin.dart';
part 'exercise_generators/exercise_generator_support.dart';
part 'exercise_generators/dialog/dialog_exercise_schema.dart';
part 'exercise_generators/dialog/dialog_exercise_generator_mixin.dart';
part 'exercise_generators/dialog/dialog_exercise_prompt.dart';
part 'exercise_generators/dialog/dialog_exercise_model.dart';
part 'exercise_generators/fill_the_blank/fill_the_blank_exercise_schema.dart';
part 'exercise_generators/fill_the_blank/fill_the_blank_exercise_generator_mixin.dart';
part 'exercise_generators/fill_the_blank/fill_the_blank_exercise_prompt.dart';
part 'exercise_generators/fill_the_blank/fill_the_blank_exercise_model.dart';
part 'exercise_generators/match_elements/match_elements_exercise_schema.dart';
part 'exercise_generators/match_elements/match_elements_exercise_generator_mixin.dart';
part 'exercise_generators/match_elements/match_elements_exercise_prompt.dart';
part 'exercise_generators/match_elements/match_elements_exercise_model.dart';
part 'exercise_generators/multiple_choice/multiple_choice_exercise_schema.dart';
part 'exercise_generators/multiple_choice/multiple_choice_exercise_generator_mixin.dart';
part 'exercise_generators/multiple_choice/multiple_choice_exercise_prompt.dart';
part 'exercise_generators/multiple_choice/multiple_choice_exercise_model.dart';
part 'exercise_generators/multiple_choice_list/multiple_choice_list_exercise_schema.dart';
part 'exercise_generators/multiple_choice_list/multiple_choice_list_exercise_generator_mixin.dart';
part 'exercise_generators/multiple_choice_list/multiple_choice_list_exercise_prompt.dart';
part 'exercise_generators/multiple_choice_list/multiple_choice_list_exercise_model.dart';
part 'exercise_generators/select_all_that_apply/select_all_that_apply_exercise_schema.dart';
part 'exercise_generators/select_all_that_apply/select_all_that_apply_exercise_generator_mixin.dart';
part 'exercise_generators/select_all_that_apply/select_all_that_apply_exercise_prompt.dart';
part 'exercise_generators/select_all_that_apply/select_all_that_apply_exercise_model.dart';
part 'exercise_generators/word_ordering/word_ordering_exercise_schema.dart';
part 'exercise_generators/word_ordering/word_ordering_exercise_generator_mixin.dart';
part 'exercise_generators/word_ordering/word_ordering_exercise_prompt.dart';
part 'exercise_generators/word_ordering/word_ordering_exercise_model.dart';
part 'exercise_generators/write/write_exercise_schema.dart';
part 'exercise_generators/write/write_exercise_generator_mixin.dart';
part 'exercise_generators/write/write_exercise_prompt.dart';
part 'exercise_generators/write/write_exercise_model.dart';
part 'exercise_generators/write_list/write_list_exercise_schema.dart';
part 'exercise_generators/write_list/write_list_exercise_generator_mixin.dart';
part 'exercise_generators/write_list/write_list_exercise_prompt.dart';
part 'exercise_generators/write_list/write_list_exercise_model.dart';

mixin FetchExercisesViewModelDependenciesMixin {
  late final IAI _ai;
  late final IAudioPlayer _audioPlayer;
  late final ITextToSpeech _textToSpeech;
  late final SessionManager _sessionManager;
  late final ExerciseConfiguration _exerciseConfiguration;
  late final LanguageLocale _learningLanguage;
  late final LanguageLocale _nativeLanguage;
}

class FetchExercisesViewModel
    with
        AIErrorRetryMixin,
        TextToSpeechErrorRetryMixin,
        FetchExercisesViewModelDependenciesMixin,
        ExercisePlannerMixin,
        DialogExerciseGeneratorMixin,
        FillTheBlankExerciseGeneratorMixin,
        MatchElementsExerciseGeneratorMixin,
        MultipleChoiceExerciseGeneratorMixin,
        MultipleChoiceListExerciseGeneratorMixin,
        SelectAllThatApplyExerciseGeneratorMixin,
        WordOrderingExerciseGeneratorMixin,
        WriteExerciseGeneratorMixin,
        WriteListExerciseGeneratorMixin {
  final StreamController<void> _exercisesFetchedController =
      StreamController<void>.broadcast();
  final TopicAssessmentRepository _topicAssessmentRepository;
  final SettingsService _settingsService;
  final Random _random = Random();

  FetchExercisesViewModel({
    required IAI ai,
    required IAudioPlayer audioPlayer,
    required ITextToSpeech textToSpeech,
    required SessionManager sessionManager,
    required TopicAssessmentRepository topicAssessmentRepository,
    required SettingsService settingsService,
    required ExerciseConfiguration exerciseConfiguration,
    required LanguageLocale learningLanguage,
    required LanguageLocale nativeLanguage,
  }) : _topicAssessmentRepository = topicAssessmentRepository,
       _settingsService = settingsService {
    _ai = ai;
    _audioPlayer = audioPlayer;
    _textToSpeech = textToSpeech;
    _sessionManager = sessionManager;
    _exerciseConfiguration = exerciseConfiguration;
    _learningLanguage = learningLanguage;
    _nativeLanguage = nativeLanguage;
  }

  int get exerciseCount => _exerciseConfiguration.exerciseCount + 1;

  final _exerciseFetchCountSignal = signal(0);
  ReadonlySignal<int> get exerciseFetchCount =>
      _exerciseFetchCountSignal.readonly();

  Stream<void> get exercisesFetched => _exercisesFetchedController.stream;

  Future<void> fetchExercises() async {
    _exerciseFetchCountSignal.value = 0;
    try {
      final exerciseGroups = _getExercises(
        _exerciseConfiguration.topics,
        _exerciseConfiguration.exerciseTypes,
        _exerciseConfiguration.exerciseCount,
      );
      final exercises = <ExerciseInput>[];
      final plannedExercisesWithTopics =
          <({PlannedExercise exercise, Topic topic})>[];
      final feedbackWindowEnd = DateTime.now();
      final feedbackWindowStart = feedbackWindowEnd.subtract(
        Duration(days: _settingsService.topicFeedbackLookbackDays.value),
      );

      for (final group in exerciseGroups) {
        final previousFeedback = await _getPreviousFeedback(
          group.topic.id,
          from: feedbackWindowStart,
          through: feedbackWindowEnd,
        );
        final plannedExercises = await _planExercises(
          group.topic.title,
          group.topic.content,
          _exerciseConfiguration.cefr,
          group.exercises,
          previousFeedback,
        );

        for (final plannedExercise in plannedExercises) {
          plannedExercisesWithTopics.add((
            exercise: plannedExercise,
            topic: group.topic,
          ));
        }
      }
      _exerciseFetchCountSignal.value++;

      for (final plannedExerciseWithTopic in plannedExercisesWithTopics) {
        exercises.add(
          await _generateExerciseInput(
            plannedExerciseWithTopic.exercise,
            plannedExerciseWithTopic.topic,
          ),
        );
        _exerciseFetchCountSignal.value++;
      }

      await _sessionManager.unregisterExerciseViewModel();
      _sessionManager.registerExerciseViewModel(
        exercises,
        _exerciseConfiguration.cefr,
        _nativeLanguage,
        _learningLanguage,
      );

      _exercisesFetchedController.add(null);
    } on StopExecution {
      return;
    }
  }

  Future<List<String>> _getPreviousFeedback(
    String topicId, {
    required DateTime from,
    required DateTime through,
  }) async {
    final assessments = await _topicAssessmentRepository.getAssessments(
      topicId,
    );
    final recentAssessments =
        assessments.where((assessment) {
          return !assessment.timestamp.isBefore(from) &&
              !assessment.timestamp.isAfter(through);
        }).toList()..sort(
          (first, second) => first.timestamp.compareTo(second.timestamp),
        );

    final notes = <String>[];
    for (final assessment in recentAssessments) {
      final note = assessment.notes?.trim();
      if (note != null && note.isNotEmpty) {
        notes.add(note);
      }
    }

    return notes;
  }

  Future<ExerciseInput> _generateExerciseInput(
    PlannedExercise plannedExercise,
    Topic topic,
  ) {
    final prompt = plannedExercise.exercisePrompt;
    final topicId = topic.id;
    final title = topic.title;
    final content = topic.content;
    final level = _exerciseConfiguration.cefr;
    final audioGenerationConfiguration = ExerciseAudioGenerationConfiguration(
      isAudio:
          plannedExercise.exerciseType.supportsAudio &&
          plannedExercise.exerciseType != ExerciseType.dialog &&
          _shouldGenerateAudio(_exerciseConfiguration.promptConfiguration),
      speechSpeed: _settingsService.speechGenerationSpeed.value,
    );

    return switch (plannedExercise.exerciseType) {
      ExerciseType.dialog => _generateDialogExercise(
        prompt,
        topicId,
        title,
        content,
        _exerciseConfiguration.promptConfiguration,
        audioGenerationConfiguration.speechSpeed,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.fillTheBlank => _generateFillTheBlankExercise(
        prompt,
        topicId,
        title,
        content,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.matchElements => _generateMatchElementsExercise(
        prompt,
        topicId,
        title,
        content,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.multipleChoice => _generateMultipleChoiceExercise(
        prompt,
        topicId,
        title,
        content,
        audioGenerationConfiguration,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.multipleChoiceList => _generateMultipleChoiceListExercise(
        prompt,
        topicId,
        title,
        content,
        audioGenerationConfiguration,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.selectAllThatApply => _generateSelectAllThatApplyExercise(
        prompt,
        topicId,
        title,
        content,
        audioGenerationConfiguration,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.wordOrdering => _generateWordOrderingExercise(
        prompt,
        topicId,
        title,
        content,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.write => _generateWriteExercise(
        prompt,
        topicId,
        title,
        content,
        audioGenerationConfiguration,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
      ExerciseType.writeList => _generateWriteListExercise(
        prompt,
        topicId,
        title,
        content,
        audioGenerationConfiguration,
        _learningLanguage,
        _nativeLanguage,
        level,
      ),
    };
  }

  bool _shouldGenerateAudio(PromptConfiguration configuration) {
    return switch (configuration) {
      TextOnly() => false,
      AudioOnly() => true,
      TextAndAudio(:final textPriority, :final audioPriority) => () {
        final textWeight = _getWeightedPriority(textPriority);
        final audioWeight = _getWeightedPriority(audioPriority);
        return _random.nextInt(textWeight + audioWeight) >= textWeight;
      }(),
    };
  }

  Set<ExerciseGenerationGroup> _getExercises(
    Set<TopicConfiguration> topicConfig,
    Set<ExerciseTypeConfiguration> configuration,
    int exerciseCount,
  ) {
    if (exerciseCount <= 0 || topicConfig.isEmpty || configuration.isEmpty) {
      return {};
    }

    final topics = topicConfig.toList(growable: false);
    final exerciseTypes = configuration.toList(growable: false);

    final exercisesByTopic = <String, ExerciseGenerationGroup>{};

    for (var index = 0; index < exerciseCount; index++) {
      final selectedTopic = _selectWeighted(
        topics,
        (topic) => _getWeightedPriority(topic.priority),
      );
      final selectedExerciseType = _selectWeighted(
        exerciseTypes,
        (exerciseType) => _getWeightedPriority(exerciseType.priority),
      ).exerciseType;

      exercisesByTopic.update(
        selectedTopic.topic.id,
        (group) => group.withExercise(selectedExerciseType),
        ifAbsent: () => ExerciseGenerationGroup(
          topic: selectedTopic.topic,
          exercises: [selectedExerciseType],
        ),
      );
    }

    return exercisesByTopic.values.toSet();
  }

  T _selectWeighted<T>(List<T> candidates, int Function(T candidate) weightOf) {
    final totalWeight = candidates.fold<int>(
      0,
      (total, candidate) => total + weightOf(candidate),
    );
    var selectedWeight = _random.nextInt(totalWeight);

    for (final candidate in candidates) {
      selectedWeight -= weightOf(candidate);
      if (selectedWeight < 0) return candidate;
    }

    throw StateError('No weighted candidate could be selected.');
  }

  int _getWeightedPriority(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.high:
        return 4;
    }
  }
}

class ExerciseGenerationGroup {
  final Topic topic;
  final List<ExerciseType> exercises;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseGenerationGroup && other.topic.id == topic.id;

  @override
  int get hashCode => topic.id.hashCode;

  ExerciseGenerationGroup({required this.topic, required this.exercises});

  ExerciseGenerationGroup withExercise(ExerciseType exerciseType) {
    return ExerciseGenerationGroup(
      topic: topic,
      exercises: [...exercises, exerciseType],
    );
  }
}
