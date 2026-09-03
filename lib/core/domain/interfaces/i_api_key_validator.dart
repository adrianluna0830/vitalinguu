

abstract interface class IApiKeyValidator {
  Future<ApiKeyValidationResult> validateApiKey(String apiKey);
}

sealed class ApiKeyValidationResult {
  const ApiKeyValidationResult();
}

final class ApiKeyValid extends ApiKeyValidationResult {
  const ApiKeyValid();
}

final class ApiKeyInvalid extends ApiKeyValidationResult {
  const ApiKeyInvalid();
}

final class ApiKeyValidationUnavailable extends ApiKeyValidationResult {
  const ApiKeyValidationUnavailable();
}
