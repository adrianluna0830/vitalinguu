import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/interfaces/i_structured_output.dart';
import 'package:vitalinguu/core/domain/one_of.dart';

class NanoGptAI implements IAI {
  static const String _model = 'inception/mercury-2.5-preview';
  static const _timeout = Duration(seconds: 60);
  static final _endpoint = Uri.parse(
    'https://nano-gpt.com/api/v1/chat/completions',
  );
  static final _structuredOutput = NanoGptStructuredOutput(
    name: 'structured_response',
    strict: true,
  );

  final String apiKey;
  final Logger _logger;

  NanoGptAI({required this.apiKey, required Logger logger}) : _logger = logger;

  @override
  Future<OneOf2<String, AIError>> generateResponse(
    String prompt,
    String? systemInstruction,
  ) {
    return generateChatResponse(prompt, const [], systemInstruction);
  }

  @override
  Future<OneOf2<String, AIError>> generateChatResponse(
    String prompt,
    List<AIMessage> messages,
    String? systemInstruction,
  ) {
    return _generateContent(
      prompt: prompt,
      messages: messages,
      systemInstruction: systemInstruction,
    );
  }

  @override
  Future<OneOf2<T, AIError>> generateStructuredResponse<T>(
    String prompt,
    AISchema<T> schema,
    String? systemInstruction,
  ) async {
    final result = await generateStructuredChatResponse(
      prompt,
      const [],
      schema,
      systemInstruction,
    );
    return result;
  }

  @override
  Future<OneOf2<T, AIError>> generateStructuredChatResponse<T>(
    String prompt,
    List<AIMessage> messages,
    AISchema<T> schema,
    String? systemInstruction,
  ) async {
    _logger.d('Preparing a structured response of type ${T.toString()}.');

    final ISchema outputSchema;
    try {
      outputSchema = schema.schema;
    } on Object catch (error, stackTrace) {
      final failure = RequestConfigurationError(
        message: 'Could not obtain the structured-output schema: $error',
      );
      _logger.e(
        'Failed to obtain the schema for structured response type '
        '${T.toString()}.',
        error: error,
        stackTrace: stackTrace,
      );
      return OneOf2.second(failure);
    }

    final response = await _generateContent(
      prompt: prompt,
      messages: messages,
      systemInstruction: systemInstruction,
      schema: outputSchema,
    );

    return response.when<OneOf2<T, AIError>>(
      first: (content) =>
          _decodeStructuredContent(content, schema, outputSchema),
      second: OneOf2<T, AIError>.second,
    );
  }

  String _formatElapsed(Duration elapsed) {
    final totalHundredths = elapsed.inMilliseconds ~/ 10;
    final seconds = totalHundredths ~/ 100;
    final hundredths = (totalHundredths % 100).toString().padLeft(2, '0');
    return '$seconds.$hundredths';
  }

  Future<OneOf2<String, AIError>> _generateContent({
    required String prompt,
    required List<AIMessage> messages,
    required String? systemInstruction,
    ISchema? schema,
  }) async {
    final stopwatch = Stopwatch()..start();
    final expectsStructuredOutput = schema != null;
    _logger.d(
      'Preparing NanoGPT request. '
      'Model: $_model; structured response: $expectsStructuredOutput; '
      'previous messages: ${messages.length}.',
    );

    if (apiKey.trim().isEmpty) {
      const failure = AuthenticationError(
        message: 'A NanoGPT API key is required.',
      );
      _logRequestFailure(failure, stopwatch.elapsed);
      return OneOf2.second(failure);
    }

    Map<String, dynamic>? responseFormat;
    if (schema != null) {
      try {
        final value = jsonDecode(_structuredOutput.getResponseFormat(schema));
        if (value is! Map<String, dynamic>) {
          throw const FormatException(
            'The response format root must be a JSON object.',
          );
        }
        responseFormat = value;
      } on Object catch (error, stackTrace) {
        final failure = RequestConfigurationError(
          message: 'Could not create the NanoGPT response format: $error',
        );
        _logger.e(
          'Failed to build the NanoGPT response format.',
          error: error,
          stackTrace: stackTrace,
        );
        return OneOf2.second(failure);
      }
    }

    final requestMessages = <Map<String, String>>[
      if (systemInstruction != null)
        {'role': 'system', 'content': systemInstruction},
      for (final message in messages)
        {
          'role': message.isUser ? 'user' : 'assistant',
          'content': message.content,
        },
      {'role': 'user', 'content': prompt},
    ];
    final request = <String, Object>{
      'model': _model,
      'messages': requestMessages,
      'stream': false,
    };
    if (responseFormat != null) {
      request['response_format'] = responseFormat;
    }

    try {
      _logger.d(
        'Sending NanoGPT request with ${requestMessages.length} messages.',
      );
      final response = await http
          .post(
            _endpoint,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request),
          )
          .timeout(_timeout);

      final requestId = _requestIdFromHeaders(response.headers);
      _logger.t(
        'Received NanoGPT HTTP response. '
        'Status: ${response.statusCode}; bytes: ${response.bodyBytes.length}; '
        'requestId: ${requestId ?? 'unavailable'}; '
        'duration: ${_formatElapsed(stopwatch.elapsed)}s.',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final failure = _classifyProviderError(
          response.statusCode,
          response.body,
          expectsStructuredOutput: expectsStructuredOutput,
          requestId: requestId,
        );
        _logRequestFailure(
          failure,
          stopwatch.elapsed,
          statusCode: response.statusCode,
        );
        return OneOf2.second(failure);
      }

      final result = _readResponseContent(
        response,
        expectsStructuredOutput: expectsStructuredOutput,
      );
      result.when<void>(
        first: (_) => _logger.i(
          'NanoGPT request completed successfully in '
          '${_formatElapsed(stopwatch.elapsed)}s.',
        ),
        second: (failure) => _logRequestFailure(
          failure,
          stopwatch.elapsed,
          statusCode: response.statusCode,
        ),
      );
      return result;
    } on TimeoutException catch (error, stackTrace) {
      final failure = UnavailableError(
        message: 'The NanoGPT request timed out: $error',
      );
      _logger.w(
        'NanoGPT request timed out after '
        '${_formatElapsed(stopwatch.elapsed)}s.',
        error: error,
        stackTrace: stackTrace,
      );
      return OneOf2.second(failure);
    } on http.ClientException catch (error, stackTrace) {
      final failure = UnavailableError(
        message: 'Could not connect to the NanoGPT API: $error',
      );
      _logger.e(
        'Failed to connect to NanoGPT after '
        '${_formatElapsed(stopwatch.elapsed)}s.',
        error: error,
        stackTrace: stackTrace,
      );
      return OneOf2.second(failure);
    } on Object catch (error, stackTrace) {
      final failure = UnknownError(
        message: 'Unexpected NanoGPT client error: $error',
      );
      _logger.e(
        'Unexpected NanoGPT client error after '
        '${_formatElapsed(stopwatch.elapsed)}s.',
        error: error,
        stackTrace: stackTrace,
      );
      return OneOf2.second(failure);
    }
  }

  void _logRequestFailure(
    AIError failure,
    Duration elapsed, {
    int? statusCode,
  }) {
    final message =
        'NanoGPT request ended with ${failure.runtimeType} after '
        '${_formatElapsed(elapsed)}s'
        '${statusCode == null ? '' : ' (HTTP $statusCode)'}: '
        '${failure.message}';

    switch (failure) {
      case AuthenticationError() ||
          UsageLimitError() ||
          UnavailableError() ||
          RejectedError():
        _logger.w(message);
      case RequestConfigurationError() ||
          SchemaValidationError() ||
          UnknownError():
        _logger.e(message);
    }
  }

  OneOf2<String, AIError> _readResponseContent(
    http.Response httpResponse, {
    required bool expectsStructuredOutput,
  }) {
    final body = httpResponse.body;
    final Map<String, dynamic> responseData;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('The response root is not a JSON object.');
      }
      responseData = decoded;
    } on Object catch (error) {
      return OneOf2.second(
        UnknownError(message: 'NanoGPT returned an invalid response: $error'),
      );
    }

    if (responseData.containsKey('error')) {
      return OneOf2.second(
        _classifyProviderError(
          httpResponse.statusCode,
          body,
          expectsStructuredOutput: expectsStructuredOutput,
          requestId: _requestIdFromHeaders(httpResponse.headers),
        ),
      );
    }

    final choices = responseData['choices'];
    if (choices is! List || choices.isEmpty || choices.first is! Map) {
      return OneOf2.second(
        const UnknownError(
          message: 'NanoGPT returned no chat completion choice.',
        ),
      );
    }

    final choice = Map<String, dynamic>.from(choices.first as Map);
    final finishReason = choice['finish_reason']?.toString().toLowerCase();
    if (finishReason == 'content_filter' || finishReason == 'safety') {
      return OneOf2.second(
        const RejectedError(message: 'NanoGPT rejected the generated content.'),
      );
    }

    final rawMessage = choice['message'];
    if (rawMessage is! Map) {
      return OneOf2.second(
        const UnknownError(
          message: 'NanoGPT returned a chat choice without a message.',
        ),
      );
    }
    final message = Map<String, dynamic>.from(rawMessage);
    final refusal = message['refusal'];
    if (refusal is String && refusal.isNotEmpty) {
      return OneOf2.second(RejectedError(message: refusal));
    }

    final content = message['content'];
    if (content is! String) {
      return OneOf2.second(
        const UnknownError(
          message: 'NanoGPT returned a message without text content.',
        ),
      );
    }
    return OneOf2.first(content);
  }

  OneOf2<T, AIError> _decodeStructuredContent<T>(
    String content,
    AISchema<T> schema,
    ISchema outputSchema,
  ) {
    _logger.t('Decoding ${content.length} characters as ${T.toString()}.');
    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'The structured response root must be a JSON object.',
        );
      }
      final violations = const SchemaValidator(
        acceptNullForOptionalFields: true,
      ).validate(outputSchema, decoded);
      if (violations.isNotEmpty) {
        final details = violations.take(5).join('; ');
        final remaining = violations.length - 5;
        final failure = SchemaValidationError(
          message:
              'The structured NanoGPT response does not match the schema: '
              '$details${remaining > 0 ? '; and $remaining more' : ''}.',
        );
        _logger.w(
          'Structured response does not match the ${T.toString()} schema. '
          'Violations: ${violations.length}. Details: ${failure.message}',
        );
        return OneOf2.second(failure);
      }

      final result = schema
          .fromJson(decoded)
          .when(
            first: OneOf2<T, AIError>.first,
            second: OneOf2<T, AIError>.second,
          );
      result.when<void>(
        first: (_) => _logger.i(
          'Structured response converted to ${T.toString()} successfully.',
        ),
        second: (failure) => _logger.w(
          'Failed to convert the structured response to ${T.toString()}: '
          '${failure.message}',
        ),
      );
      return result;
    } on Object catch (error, stackTrace) {
      final failure = SchemaValidationError(
        message: 'The structured NanoGPT response is invalid: $error',
      );
      _logger.e(
        'The ${T.toString()} structured response is not valid JSON.',
        error: error,
        stackTrace: stackTrace,
      );
      return OneOf2.second(failure);
    }
  }

  AIError _classifyProviderError(
    int statusCode,
    String body, {
    required bool expectsStructuredOutput,
    String? requestId,
  }) {
    final details = _readProviderError(body, statusCode, requestId: requestId);
    final message = _providerErrorMessage(details, statusCode);
    final fingerprint = '${details.type} ${details.code} ${details.message}'
        .toLowerCase();

    if (statusCode == 401 ||
        fingerprint.contains('authentication_error') ||
        fingerprint.contains('missing_api_key') ||
        fingerprint.contains('invalid_api_key') ||
        fingerprint.contains('api_key_origin_not_allowed') ||
        fingerprint.contains('revoked api key') ||
        fingerprint.contains('expired api key')) {
      return AuthenticationError(message: message);
    }

    if (statusCode == 402 ||
        statusCode == 429 ||
        fingerprint.contains('rate_limit') ||
        fingerprint.contains('insufficient_quota') ||
        fingerprint.contains('insufficient balance') ||
        fingerprint.contains('balance_required') ||
        fingerprint.contains('daily_rpd_limit') ||
        fingerprint.contains('daily_usd_limit') ||
        fingerprint.contains('credit')) {
      return UsageLimitError(message: message);
    }

    if (fingerprint.contains('content_policy_violation') ||
        fingerprint.contains('permission_denied_error') ||
        fingerprint.contains('permission_error') ||
        fingerprint.contains('model_not_allowed') ||
        fingerprint.contains('content_filter')) {
      return RejectedError(message: message);
    }

    if (statusCode == 408 ||
        statusCode == 504 ||
        statusCode >= 500 ||
        fingerprint.contains('service_unavailable') ||
        fingerprint.contains('model_not_available') ||
        fingerprint.contains('all_fallbacks_failed') ||
        fingerprint.contains('no_fallback_available') ||
        fingerprint.contains('timeout')) {
      return UnavailableError(message: message);
    }

    if (fingerprint.contains('empty_response')) {
      return expectsStructuredOutput
          ? SchemaValidationError(message: message)
          : UnknownError(message: message);
    }

    if (statusCode == 403 || statusCode == 451) {
      return RejectedError(message: message);
    }

    if (statusCode == 400 ||
        statusCode == 404 ||
        statusCode == 405 ||
        statusCode == 409 ||
        statusCode == 413 ||
        statusCode == 415 ||
        statusCode == 422 ||
        fingerprint.contains('invalid_request_error') ||
        fingerprint.contains('invalid_parameter') ||
        fingerprint.contains('invalid_json_schema') ||
        fingerprint.contains('model_not_found') ||
        fingerprint.contains('context_length_exceeded')) {
      return RequestConfigurationError(message: message);
    }

    return UnknownError(message: message);
  }

  String _providerErrorMessage(_ProviderErrorDetails details, int statusCode) {
    return [
      details.message,
      '',
      'HTTP status: $statusCode',
      if (details.type != null) 'error.type: ${details.type}',
      if (details.code != null) 'error.code: ${details.code}',
      if (details.requestId != null) 'X-Request-ID: ${details.requestId}',
    ].join('\n');
  }

  _ProviderErrorDetails _readProviderError(
    String body,
    int statusCode, {
    String? requestId,
  }) {
    String? message;
    String? type;
    String? code;

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final response = Map<String, dynamic>.from(decoded);
        final error = response['error'];
        if (error is Map) {
          final errorData = Map<String, dynamic>.from(error);
          message = errorData['message']?.toString();
          type = errorData['type']?.toString();
          code = errorData['code']?.toString();
          requestId ??= errorData['request_id']?.toString();
        } else if (error != null) {
          message = error.toString();
        }
        message ??= response['message']?.toString();
        type ??= response['type']?.toString();
        code ??= response['code']?.toString();
        requestId ??= response['request_id']?.toString();
      } else if (decoded != null) {
        message = decoded.toString();
      }
    } on FormatException {
      final trimmedBody = body.trim();
      if (trimmedBody.isNotEmpty) message = trimmedBody;
    }

    message ??= 'NanoGPT request failed with HTTP $statusCode.';
    if (message.length > 1000) {
      message = '${message.substring(0, 1000)}…';
    }
    return _ProviderErrorDetails(
      message: message,
      type: type,
      code: code,
      requestId: requestId,
    );
  }

  String? _requestIdFromHeaders(Map<String, String> headers) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == 'x-request-id') {
        final value = entry.value.trim();
        return value.isEmpty ? null : value;
      }
    }
    return null;
  }
}

final class _ProviderErrorDetails {
  final String message;
  final String? type;
  final String? code;
  final String? requestId;

  const _ProviderErrorDetails({
    required this.message,
    required this.type,
    required this.code,
    required this.requestId,
  });
}
