import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signals/signals.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/i18n/app_locale.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

abstract class SettingsLimits {
  static int get minTopicFeedbackLookbackDays => 1;
  static int get maxTopicFeedbackLookbackDays => 60;
  static double get minSpeechGenerationSpeed => 0.6;
  static double get maxSpeechGenerationSpeed => 2.0;
}

class SettingsService {
  static const int _defaultTopicFeedbackLookbackDays = 30;
  static const double _defaultSpeechGenerationSpeed = 1.0;

  static const String _aiApiKeyStorageKey = 'ai_api_key';
  static const String _nativeLanguageStorageKey = 'native_language';
  static const String _learningLanguageStorageKey = 'learning_language';
  static const String _topicFeedbackLookbackDaysStorageKey =
      'topic_feedback_lookback_days';
  static const String _speechGenerationSpeedStorageKey =
      'speech_generation_speed';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Signal<String?> _aiApiKey = signal(null);
  final Signal<LanguageLocale?> _nativeLanguage = signal(null);
  final Signal<LanguageLocale?> _learningLanguage = signal(null);
  final Signal<int> _topicFeedbackLookbackDays = signal(
    _defaultTopicFeedbackLookbackDays,
  );
  final Signal<double> _speechGenerationSpeed = signal(
    _defaultSpeechGenerationSpeed,
  );

  late final ReadonlySignal<String?> aiApiKey = _aiApiKey.readonly();
  late final ReadonlySignal<LanguageLocale?> nativeLanguage = _nativeLanguage
      .readonly();
  late final ReadonlySignal<LanguageLocale?> learningLanguage =
      _learningLanguage.readonly();
  late final ReadonlySignal<int> topicFeedbackLookbackDays =
      _topicFeedbackLookbackDays.readonly();
  late final ReadonlySignal<double> speechGenerationSpeed =
      _speechGenerationSpeed.readonly();

  SettingsService._();

  static Future<SettingsService> create() async {
    final service = SettingsService._();
    await service.load();
    return service;
  }

  Future<void> saveAiApiKey(String? value) async {
    await _secureStorage.write(key: _aiApiKeyStorageKey, value: value);
    _aiApiKey.value = value;
  }

  Future<void> saveNativeLanguage(LanguageLocale? value) async {
    await _secureStorage.write(
      key: _nativeLanguageStorageKey,
      value: value?.name,
    );
    _nativeLanguage.value = value;
    if (value != null) await LocaleSettings.setLocale(value.appLocale);
  }

  Future<void> saveLearningLanguage(LanguageLocale? value) async {
    await _secureStorage.write(
      key: _learningLanguageStorageKey,
      value: value?.name,
    );
    _learningLanguage.value = value;
  }

  Future<void> saveTopicFeedbackLookbackDays(int value) async {
    if (!_isValidTopicFeedbackLookbackDays(value)) {
      throw StateError(
        'Topic feedback lookback days must be between '
        '${SettingsLimits.minTopicFeedbackLookbackDays} and '
        '${SettingsLimits.maxTopicFeedbackLookbackDays}.',
      );
    }

    await _secureStorage.write(
      key: _topicFeedbackLookbackDaysStorageKey,
      value: value.toString(),
    );
    _topicFeedbackLookbackDays.value = value;
  }

  Future<void> saveSpeechGenerationSpeed(double value) async {
    if (!_isValidSpeechGenerationSpeed(value)) {
      throw StateError(
        'Speech generation speed must be between '
        '${SettingsLimits.minSpeechGenerationSpeed} and '
        '${SettingsLimits.maxSpeechGenerationSpeed}.',
      );
    }

    await _secureStorage.write(
      key: _speechGenerationSpeedStorageKey,
      value: value.toString(),
    );
    _speechGenerationSpeed.value = value;
  }

  Future<void> load() async {
    _aiApiKey.value = await _secureStorage.read(key: _aiApiKeyStorageKey);
    final languagesByName = LanguageLocale.values.asNameMap();
    final nativeLanguageName = await _secureStorage.read(
      key: _nativeLanguageStorageKey,
    );
    final learningLanguageName = await _secureStorage.read(
      key: _learningLanguageStorageKey,
    );
    final topicFeedbackLookbackDaysValue = await _secureStorage.read(
      key: _topicFeedbackLookbackDaysStorageKey,
    );
    final speechGenerationSpeedValue = await _secureStorage.read(
      key: _speechGenerationSpeedStorageKey,
    );

    _nativeLanguage.value = languagesByName[nativeLanguageName];
    _learningLanguage.value = languagesByName[learningLanguageName];

    final parsedTopicFeedbackLookbackDays = int.tryParse(
      topicFeedbackLookbackDaysValue ?? '',
    );
    _topicFeedbackLookbackDays.value =
        parsedTopicFeedbackLookbackDays != null &&
            _isValidTopicFeedbackLookbackDays(parsedTopicFeedbackLookbackDays)
        ? parsedTopicFeedbackLookbackDays
        : _defaultTopicFeedbackLookbackDays;

    final parsedSpeechGenerationSpeed = double.tryParse(
      speechGenerationSpeedValue ?? '',
    );
    _speechGenerationSpeed.value =
        parsedSpeechGenerationSpeed != null &&
            _isValidSpeechGenerationSpeed(parsedSpeechGenerationSpeed)
        ? parsedSpeechGenerationSpeed
        : _defaultSpeechGenerationSpeed;
  }

  static bool _isValidTopicFeedbackLookbackDays(int value) {
    return value >= SettingsLimits.minTopicFeedbackLookbackDays &&
        value <= SettingsLimits.maxTopicFeedbackLookbackDays;
  }

  static bool _isValidSpeechGenerationSpeed(double value) {
    return value.isFinite &&
        value >= SettingsLimits.minSpeechGenerationSpeed &&
        value <= SettingsLimits.maxSpeechGenerationSpeed;
  }
}
