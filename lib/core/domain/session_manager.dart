import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vitalinguu/core/data/implementations/audio_players_player.dart';
import 'package:vitalinguu/core/domain/credit/credit_balance_store.dart';
import 'package:vitalinguu/core/data/implementations/global_audio_player.dart';
import 'package:vitalinguu/core/domain/interfaces/i_api_key_validator.dart';
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';
import 'package:vitalinguu/core/domain/interfaces/i_speech_to_text.dart';
import 'package:vitalinguu/core/domain/interfaces/i_text_to_speech.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_speech_to_text.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_text_to_speech.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_api_key_validator.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_credit_balance_provider.dart';
import 'package:vitalinguu/splash/view_models/api_key_registration_view_model.dart';
import 'package:vitalinguu/splash/view_models/learning_language_setup_view_model.dart';
import 'package:vitalinguu/splash/view_models/native_language_setup_view_model.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_input.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_setup_view_model.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/exercise_topics_view_model.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_view_model.dart';
import 'package:vitalinguu/exercise/fetch_exercises/domain/fetch_exercises_view_model.dart';
import 'package:vitalinguu/exercise/fetch_topics_feedback/fetch_topics_feedback_view_model.dart';
import 'package:vitalinguu/core/data/hive_registrar.g.dart';
import 'package:vitalinguu/exercise/tab/topics/data/hive_topic_assessment_repository.dart';
import 'package:vitalinguu/exercise/tab/topics/data/hive_topic_repository.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/domain/main_view_model.dart';
import 'package:vitalinguu/core/domain/localized_topic_repository.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_ai.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';
import 'package:vitalinguu/settings/domain/settings_view_model.dart';
import 'package:vitalinguu/splash/view_models/splash_view_model.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment_repository.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_repository.dart';

final getIt = GetIt.instance;

class SessionManager {
  LanguageLocale? _nativeLanguage;
  LanguageLocale? _learningLanguage;

  SessionManager._();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    // await Hive.deleteBoxFromDisk(HiveTopicRepository.boxName);
    // await Hive.deleteBoxFromDisk(HiveTopicAssessmentRepository.boxName);
    Hive.registerAdapters();

    final sessionManager = SessionManager._();
    getIt.registerSingleton<SessionManager>(sessionManager);
    await sessionManager._registerBaseDependencies();
  }

  Future<void> _registerBaseDependencies() async {
    getIt.registerSingleton<GlobalAudioPlayer>(
      GlobalAudioPlayer(AudioPlayersPlayer()),
    );

    final topicRepository = await HiveTopicRepository.open();
    final topicAssessmentRepository =
        await HiveTopicAssessmentRepository.open();

    getIt.registerSingleton<TopicRepository>(topicRepository);
    getIt.registerSingleton<TopicAssessmentRepository>(
      topicAssessmentRepository,
    );
    final settingsService = await SettingsService.create();
    getIt.registerSingleton<SettingsService>(settingsService);
    getIt.registerLazySingleton<IApiKeyValidator>(
      () => const NanoGptApiKeyValidator(),
    );
    getIt.registerLazySingleton<ICreditBalanceProvider>(
      () => const NanoGptCreditBalanceProvider(),
    );

    getIt.registerFactory<SettingsViewModel>(
      () => SettingsViewModel(
        settingsService: getIt(),
        creditBalanceStore: getIt(),
      ),
    );
    getIt.registerFactory<SplashViewModel>(
      () => SplashViewModel(settingsService: getIt()),
    );
    getIt.registerFactory<MainViewModel>(
      () => MainViewModel(sessionManager: this, settingsService: getIt()),
    );
    getIt.registerFactory<ApiKeyRegistrationViewModel>(
      () => ApiKeyRegistrationViewModel(
        settingsService: getIt(),
        apiKeyValidator: getIt(),
        creditBalanceProvider: getIt(),
      ),
    );
    getIt.registerFactory<NativeLanguageSetupViewModel>(
      () => NativeLanguageSetupViewModel(settingsService: getIt()),
    );
    getIt.registerFactory<LearningLanguageSetupViewModel>(
      () => LearningLanguageSetupViewModel(settingsService: getIt()),
    );
    getIt.registerFactory<ExerciseSetupViewModel>(
      () => ExerciseSetupViewModel(
        topicRepository: getIt(),
        sessionManager: this,
        creditBalanceStore: getIt(),
      ),
    );
    getIt.registerFactory<ExerciseTopicsViewModel>(
      () => ExerciseTopicsViewModel(topicRepository: getIt()),
    );
  }

  Future<void> registerLanguageDependencies(
    LanguageLocale nativeLanguage,
    LanguageLocale learningLanguage,
  ) async {
    _nativeLanguage = nativeLanguage;
    _learningLanguage = learningLanguage;

    if (getIt.isRegistered<LocalizedTopicRepository>()) {
      await getIt.unregister<LocalizedTopicRepository>();
    }

    getIt.registerSingleton<LocalizedTopicRepository>(
      LocalizedTopicRepository(
        topicRepository: getIt(),
        language: learningLanguage,
      ),
    );
  }

  Future<void> registerExerciseViewModel(
    List<ExerciseInput> exercises,
    CEFR level,
    LanguageLocale nativeLanguage,
    LanguageLocale learningLanguage,
  ) async {
    getIt.registerLazySingleton<ExerciseViewModel>(
      () => ExerciseViewModel(
        ai: getIt(),
        audioPlayer: getIt<GlobalAudioPlayer>(),
        textToSpeech: getIt(),
        exercises: exercises,
        sessionManager: this,
        level: level,
        nativeLanguage: nativeLanguage,
        learningLanguage: learningLanguage,
      ),
    );
  }

  Future<void> unregisterExerciseViewModel() async {
    if (getIt.isRegistered<ExerciseViewModel>()) {
      await getIt.unregister<ExerciseViewModel>();
    }
  }

  Future<void> registerExerciseViewModelForCurrentLanguages(
    List<ExerciseInput> exercises,
    CEFR level,
  ) async {
    final nativeLanguage = _nativeLanguage;
    final learningLanguage = _learningLanguage;
    if (nativeLanguage == null || learningLanguage == null) {
      throw StateError('Language dependencies have not been registered.');
    }

    await unregisterExerciseViewModel();
    await registerExerciseViewModel(
      exercises,
      level,
      nativeLanguage,
      learningLanguage,
    );
  }

  Future<void> registerFetchExercisesViewModel(
    ExerciseConfiguration exerciseConfiguration,
  ) async {
    final nativeLanguage = _nativeLanguage;
    final learningLanguage = _learningLanguage;
    if (nativeLanguage == null || learningLanguage == null) {
      throw StateError('Language dependencies have not been registered.');
    }

    await unregisterFetchExercisesViewModel();
    getIt.registerLazySingleton<FetchExercisesViewModel>(
      () => FetchExercisesViewModel(
        ai: getIt(),
        audioPlayer: getIt<GlobalAudioPlayer>(),
        textToSpeech: getIt(),
        sessionManager: this,
        topicAssessmentRepository: getIt(),
        settingsService: getIt(),
        exerciseConfiguration: exerciseConfiguration,
        learningLanguage: learningLanguage,
        nativeLanguage: nativeLanguage,
      ),
    );
  }

  Future<void> unregisterFetchExercisesViewModel() async {
    if (getIt.isRegistered<FetchExercisesViewModel>()) {
      await getIt.unregister<FetchExercisesViewModel>();
    }
  }

  Future<void> registerFetchTopicsFeedbackViewModel(
    Map<TopicData, List<String>> answersByTopic,
    CEFR level,
  ) async {
    final learningLanguage = _learningLanguage;
    if (learningLanguage == null) {
      throw StateError('Language dependencies have not been registered.');
    }

    await unregisterFetchTopicsFeedbackViewModel();
    getIt.registerLazySingleton<FetchTopicsFeedbackViewModel>(
      () => FetchTopicsFeedbackViewModel(
        ai: getIt(),
        answersByTopic: answersByTopic,
        topicAssessmentRepository: getIt(),
        learningLanguage: learningLanguage,
        level: level,
      ),
    );
  }

  Future<void> unregisterFetchTopicsFeedbackViewModel() async {
    if (getIt.isRegistered<FetchTopicsFeedbackViewModel>()) {
      await getIt.unregister<FetchTopicsFeedbackViewModel>();
    }
  }

  Future<void> registerCreditBalanceStore() async {
    if (getIt.isRegistered<CreditBalanceStore>()) {
      await getIt.unregister<CreditBalanceStore>();
    }

    final store = CreditBalanceStore(creditBalanceProvider: getIt());
    getIt.registerSingleton<CreditBalanceStore>(store);

    final apiKey = getIt<SettingsService>().aiApiKey.value;
    if (apiKey != null) {
      unawaited(store.refresh(apiKey));
    }
  }

  Future<void> registerAIRouterDependencies(String apiKey) async {
    if (getIt.isRegistered<IAI>()) {
      await getIt.unregister<IAI>();
    }
    if (getIt.isRegistered<ISpeechToText>()) {
      await getIt.unregister<ISpeechToText>();
    }
    if (getIt.isRegistered<ITextToSpeech>()) {
      await getIt.unregister<ITextToSpeech>();
    }

    getIt.registerLazySingleton<IAI>(() => NanoGptAI(apiKey: apiKey));
    getIt.registerLazySingleton<ISpeechToText>(
      () => NanoGptSpeechToText(apiKey: apiKey),
    );
    getIt.registerLazySingleton<ITextToSpeech>(
      () => NanoGptTextToSpeech(apiKey: apiKey),
    );
  }
}
