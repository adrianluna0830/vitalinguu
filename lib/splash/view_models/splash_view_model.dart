import 'package:vitalinguu/settings/domain/settings_service.dart';

class SplashViewModel {
  final SettingsService _settingsService;

  SplashViewModel({required SettingsService settingsService})
    : _settingsService = settingsService;

  bool isApiKeyNull() => _settingsService.aiApiKey.value == null;

  bool isNativeLanguageNull() => _settingsService.nativeLanguage.value == null;

  bool isLearningLanguageNull() =>
      _settingsService.learningLanguage.value == null;
}
