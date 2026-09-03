import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

class NativeLanguageSetupViewModel {
  final SettingsService _settingsService;

  const NativeLanguageSetupViewModel({required SettingsService settingsService})
    : _settingsService = settingsService;

  Future<void> updateNativeLanguage(LanguageLocale value) {
    return _settingsService.saveNativeLanguage(value);
  }
}
