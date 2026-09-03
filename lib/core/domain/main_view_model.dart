import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

class MainViewModel {
  final SessionManager _sessionManager;
  final SettingsService _settingsService;

  const MainViewModel({
    required SessionManager sessionManager,
    required SettingsService settingsService,
  }) : _sessionManager = sessionManager,
       _settingsService = settingsService;

  Future<void> init() async {
    final apiKey = _settingsService.aiApiKey.value;
    if (apiKey == null) {
      throw StateError(
        'AI router dependencies cannot be registered before the API key is '
        'configured.',
      );
    }

    await _sessionManager.registerAIRouterDependencies(apiKey);

    final nativeLanguage = _settingsService.nativeLanguage.value;
    final learningLanguage = _settingsService.learningLanguage.value;

    if (nativeLanguage == null || learningLanguage == null) {
      throw StateError(
        'Language dependencies cannot be registered before both languages '
        'are configured.',
      );
    }

    await _sessionManager.registerLanguageDependencies(
      nativeLanguage,
      learningLanguage,
    );

    await _sessionManager.registerCreditBalanceStore();
    await _sessionManager.unregisterFetchTopicsFeedbackViewModel();
    await _sessionManager.unregisterExerciseViewModel();
    await _sessionManager.unregisterFetchExercisesViewModel();
  }
}
