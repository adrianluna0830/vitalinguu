import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

class LearningLanguageSetupViewModel {
  final SettingsService _settingsService;

  const LearningLanguageSetupViewModel({
    required SettingsService settingsService,
  }) : _settingsService = settingsService;

  Future<void> updateLearningLanguage(LanguageLocale value) {
    return _settingsService.saveLearningLanguage(value);
  }
}
