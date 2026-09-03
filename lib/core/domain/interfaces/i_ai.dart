import 'package:vitalinguu/core/domain/api_failure.dart';
import 'package:vitalinguu/core/domain/interfaces/i_structured_output.dart';
import 'package:vitalinguu/core/domain/one_of.dart';

abstract interface class IAI {
  Future<OneOf2<String, AIError>> generateResponse(
    String prompt,
    String? systemInstruction,
  );

  Future<OneOf2<T, AIError>> generateStructuredResponse<T>(
    String prompt,
    AISchema<T> schema,
    String? systemInstruction,
  );

  Future<OneOf2<String, AIError>> generateChatResponse(
    String prompt,
    List<AIMessage> messages,
    String? systemInstruction,
  );

  Future<OneOf2<T, AIError>> generateStructuredChatResponse<T>(
    String prompt,
    List<AIMessage> messages,
    AISchema<T> schema,
    String? systemInstruction,
  );
}

class AIMessage {
  final bool isUser;
  final String content;

  AIMessage(this.isUser, this.content);
}

class AISchema<T> {
  final ISchema schema;
  final OneOf2<T, SchemaValidationError> Function(Map<String, dynamic> data)
  fromJson;

  const AISchema(this.schema, this.fromJson);
}

sealed class AIError {
  final String? message;

  const AIError({required this.message});
}

class AuthenticationError extends AIError {
  const AuthenticationError({required super.message});
}

class RequestConfigurationError extends AIError {
  const RequestConfigurationError({required super.message});
}

class UsageLimitError extends AIError {
  const UsageLimitError({required super.message});
}

class UnavailableError extends AIError {
  const UnavailableError({required super.message});
}

class SchemaValidationError extends AIError {
  const SchemaValidationError({required super.message});
}

class RejectedError extends AIError {
  const RejectedError({required super.message});
}

class UnknownError extends AIError {
  const UnknownError({required super.message});
}



ApiFailure mapAIErrorToApiFailure(AIError error) {
  return switch (error) {
    AuthenticationError(:final message) => AuthenticationFailure(
      details: message,
    ),
    UsageLimitError(:final message) => UsageLimitFailure(details: message),
    UnavailableError(:final message) ||
    SchemaValidationError(:final message) => TemporaryFailure(details: message),
    RequestConfigurationError(:final message) ||
    RejectedError(:final message) ||
    UnknownError(:final message) => RequestFailure(details: message),
  };
}
