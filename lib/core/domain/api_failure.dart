sealed class ApiFailure {
  const ApiFailure({this.details});

  final String? details;
}

final class AuthenticationFailure extends ApiFailure {
  const AuthenticationFailure({super.details});
}

final class UsageLimitFailure extends ApiFailure {
  const UsageLimitFailure({super.details});
}

final class TemporaryFailure extends ApiFailure {
  const TemporaryFailure({super.details});
}

final class RequestFailure extends ApiFailure {
  const RequestFailure({super.details});
}
