import 'package:signals/signals.dart';
import 'package:vitalinguu/core/domain/credit/credit_balance_store.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

sealed class CreditBalanceRefreshState {
  const CreditBalanceRefreshState();
}

final class CreditBalanceRefreshIdle extends CreditBalanceRefreshState {
  const CreditBalanceRefreshIdle();
}

final class CreditBalanceRefreshInProgress extends CreditBalanceRefreshState {
  const CreditBalanceRefreshInProgress();
}

class SettingsViewModel {
  final SettingsService _settingsService;
  final CreditBalanceStore _creditBalanceStore;
  final Signal<CreditBalanceRefreshState> _creditBalanceRefreshState = signal(
    const CreditBalanceRefreshIdle(),
  );

  late final ReadonlySignal<String> aiApiKey = computed(
    () => _requireValue(_settingsService.aiApiKey.value, 'API key'),
  );
  late final ReadonlySignal<LanguageLocale> nativeLanguage = computed(
    () =>
        _requireValue(_settingsService.nativeLanguage.value, 'native language'),
  );
  late final ReadonlySignal<LanguageLocale> learningLanguage = computed(
    () => _requireValue(
      _settingsService.learningLanguage.value,
      'learning language',
    ),
  );
  late final ReadonlySignal<int> topicFeedbackLookbackDays =
      _settingsService.topicFeedbackLookbackDays;
  late final ReadonlySignal<double> speechGenerationSpeed =
      _settingsService.speechGenerationSpeed;
  late final ReadonlySignal<CreditBalanceRefreshState>
  creditBalanceRefreshState = _creditBalanceRefreshState.readonly();

  ReadonlySignal<CreditBalanceState> get creditBalanceState =>
      _creditBalanceStore.creditBalanceState;

  SettingsViewModel({
    required SettingsService settingsService,
    required CreditBalanceStore creditBalanceStore,
  }) : _settingsService = settingsService,
       _creditBalanceStore = creditBalanceStore;

  Future<void> updateNativeLanguage(LanguageLocale value) {
    return _settingsService.saveNativeLanguage(value);
  }

  Future<void> updateLearningLanguage(LanguageLocale value) {
    return _settingsService.saveLearningLanguage(value);
  }

  Future<void> updateTopicFeedbackLookbackDays(int value) {
    return _settingsService.saveTopicFeedbackLookbackDays(value);
  }

  Future<void> updateSpeechGenerationSpeed(double value) {
    return _settingsService.saveSpeechGenerationSpeed(value);
  }

  Future<void> refreshCreditBalance() async {
    if (_creditBalanceRefreshState.value is CreditBalanceRefreshInProgress) {
      return;
    }

    _creditBalanceRefreshState.value = const CreditBalanceRefreshInProgress();
    try {
      await _creditBalanceStore.refresh(_settingsService.aiApiKey.value);
    } finally {
      _creditBalanceRefreshState.value = const CreditBalanceRefreshIdle();
    }
  }

  T _requireValue<T>(T? value, String settingName) {
    if (value == null) {
      throw StateError(
        '$settingName must be configured before opening settings.',
      );
    }
    return value;
  }
}
