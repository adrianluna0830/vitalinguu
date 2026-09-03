import 'package:http/http.dart' as http;
import 'package:vitalinguu/core/domain/interfaces/i_api_key_validator.dart';

final class NanoGptApiKeyValidator implements IApiKeyValidator {
  static final Uri _endpoint = Uri.parse(
    'https://nano-gpt.com/api/check-balance',
  );

  final http.Client? _client;

  const NanoGptApiKeyValidator({http.Client? client}) : _client = client;

  @override
  Future<ApiKeyValidationResult> validateApiKey(String apiKey) async {
    final normalizedApiKey = requireApiKey(apiKey);
    final http.Response response;
    try {
      response = await _post(normalizedApiKey);
    } on http.ClientException {
      return const ApiKeyValidationUnavailable();
    }

    return switch (response.statusCode) {
      >= 200 && < 300 => const ApiKeyValid(),
      401 || 403 => const ApiKeyInvalid(),
      _ => const ApiKeyValidationUnavailable(),
    };
  }

  Future<http.Response> _post(String apiKey) async {
    final client = _client ?? http.Client();
    try {
      return await client.post(_endpoint, headers: {'x-api-key': apiKey});
    } finally {
      if (_client == null) client.close();
    }
  }
}

String requireApiKey(String value, {String parameterName = 'apiKey'}) {
  final apiKey = value.trim();
  if (apiKey.isEmpty) {
    throw ArgumentError.value(
      value,
      parameterName,
      'API keys must not be empty.',
    );
  }
  return apiKey;
}
