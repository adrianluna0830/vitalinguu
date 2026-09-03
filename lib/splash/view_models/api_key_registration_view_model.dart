import 'dart:async';

import 'package:vitalinguu/core/domain/interfaces/i_api_key_validator.dart';
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

sealed class ApiKeyRegistrationViewModelState {}

class InvalidApiKeyState extends ApiKeyRegistrationViewModelState {}

class ValidApiKeyState extends ApiKeyRegistrationViewModelState {}

class VoidApiKeyState extends ApiKeyRegistrationViewModelState {}

class UnavailableApiKeyState extends ApiKeyRegistrationViewModelState {}

class InProgressApiKeyState extends ApiKeyRegistrationViewModelState {}

class ApiKeyRegistrationViewModel {
  final SettingsService _settingsService;
  final IApiKeyValidator _apiKeyValidator;
  final ICreditBalanceProvider _creditBalanceProvider;
  final String? _savedApiKey;
  int _validationId = 0;

  String? get savedApiKey => _savedApiKey;

  final StreamController<ApiKeyRegistrationViewModelState>
  _apiKeyRegisteredController =
      StreamController<ApiKeyRegistrationViewModelState>.broadcast();
  Stream<ApiKeyRegistrationViewModelState> get apiKeyRegistered =>
      _apiKeyRegisteredController.stream;

  ApiKeyRegistrationViewModel({
    required SettingsService settingsService,
    required IApiKeyValidator apiKeyValidator,
    required ICreditBalanceProvider creditBalanceProvider,
  }) : _settingsService = settingsService,
       _apiKeyValidator = apiKeyValidator,
       _creditBalanceProvider = creditBalanceProvider,
       _savedApiKey = settingsService.aiApiKey.value;

  void restartState() {
    _validationId++;
    _apiKeyRegisteredController.add(VoidApiKeyState());
  }

  Future<void> saveRegisterApiKey(String apiKey) async {
    final validationId = ++_validationId;
    _apiKeyRegisteredController.add(InProgressApiKeyState());

    final result = await _apiKeyValidator.validateApiKey(apiKey);
    if (validationId != _validationId) return;

    switch (result) {
      case ApiKeyValid():
        await _settingsService.saveAiApiKey(apiKey);
        await _creditBalanceProvider.getRemainingCredits(apiKey);
        _apiKeyRegisteredController.add(ValidApiKeyState());
        break;
      case ApiKeyInvalid():
        _apiKeyRegisteredController.add(InvalidApiKeyState());
        break;
      case ApiKeyValidationUnavailable():
        _apiKeyRegisteredController.add(UnavailableApiKeyState());
    }
  }
}
