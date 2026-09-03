import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';
import 'package:vitalinguu/core/data/implementations/nano_gpt/nano_gpt_api_key_validator.dart';

final class NanoGptCreditBalanceProvider implements ICreditBalanceProvider {
  static final Uri _endpoint = Uri.parse(
    'https://nano-gpt.com/api/check-balance',
  );

  final http.Client? _client;

  const NanoGptCreditBalanceProvider({http.Client? client}) : _client = client;

  @override
  Future<CreditBalanceResult> getRemainingCredits(String apiKey) {
    return _fetchRemainingCreditsSafely(requireApiKey(apiKey));
  }

  Future<CreditBalanceResult> _fetchRemainingCreditsSafely(
    String apiKey,
  ) async {
    try {
      return await _fetchRemainingCredits(apiKey);
    } on Exception {
      return const CreditBalanceUnavailable();
    }
  }

  Future<CreditBalanceResult> _fetchRemainingCredits(String apiKey) async {
    final http.Response response;
    try {
      response = await _post(apiKey);
    } on http.ClientException {
      return const CreditBalanceUnavailable();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      return const CreditBalanceUnauthorized();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return const CreditBalanceUnavailable();
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        return const CreditBalanceUnavailable();
      }

      final rawBalance = decoded['usd_balance'];
      if (rawBalance is! String) {
        return const CreditBalanceUnavailable();
      }

      return CreditBalanceAvailable(Decimal.parse(rawBalance));
    } on FormatException {
      return const CreditBalanceUnavailable();
    }
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
