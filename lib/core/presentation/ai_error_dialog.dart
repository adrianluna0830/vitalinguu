import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/ai_error_retry_mixin.dart';
import 'package:vitalinguu/core/domain/api_failure.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

Future<void> showAIErrorDialog(
  BuildContext context,
  ApiFailure error,
  VoidCallback onRetry,
  VoidCallback onLeave,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AIErrorDialog(
      error,
      onRetry: () {
        Navigator.pop(dialogContext);
        onRetry();
      },
      onOpenApiKeySetup: () {
        Navigator.pop(dialogContext);
        context.router.replace(const MainRoute(children: [SettingsRoute()]));
      },
      onLeave: () {
        Navigator.pop(dialogContext);
        onLeave();
      },
    ),
  );
}

class AIErrorDialog extends StatelessWidget {
  const AIErrorDialog(
    this.error, {
    super.key,
    required this.onRetry,
    required this.onOpenApiKeySetup,
    required this.onLeave,
  });

  final ApiFailure error;
  final VoidCallback onRetry;
  final VoidCallback onOpenApiKeySetup;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final canRetry = isRetryableApiFailure(error);
    final authenticationError = error is AuthenticationFailure;

    return AlertDialog(
      content: Text(_message(context.t)),
      actions: [
        if (canRetry)
          TextButton(onPressed: onRetry, child: Text(context.t.common.retry)),
        if (authenticationError)
          TextButton(
            onPressed: onOpenApiKeySetup,
            child: Text(context.t.errors.configureApiKey),
          ),
        TextButton(
          onPressed: onLeave,
          child: Text(
            canRetry || authenticationError
                ? context.t.common.cancel
                : context.t.common.back,
          ),
        ),
      ],
    );
  }

  String _message(Translations translations) => switch (error) {
    AuthenticationFailure() => translations.errors.authentication,
    UsageLimitFailure() => translations.errors.usageLimit,
    TemporaryFailure() => translations.errors.temporary,
    RequestFailure() => translations.errors.request,
  };
}
