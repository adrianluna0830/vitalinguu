import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:vitalinguu/core/domain/ai_error_retry_mixin.dart';
import 'package:vitalinguu/core/domain/api_failure.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/core/presentation/ai_error_dialog.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

mixin AIErrorStreamListenerMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<ApiFailure>? _apiFailureSubscription;

  void listenToAIErrorStream({
    required AIErrorRetryMixin errorHandler,
    required VoidCallback onLeave,
  }) {
    if (_apiFailureSubscription != null) {
      throw StateError('The API failure stream is already being listened to.');
    }
    _apiFailureSubscription = errorHandler.errorStream.listen(
      (failure) => unawaited(_handleFailure(failure, errorHandler, onLeave)),
    );
  }

  Future<void> _handleFailure(
    ApiFailure failure,
    AIErrorRetryMixin errorHandler,
    VoidCallback onLeave,
  ) async {
    if (!mounted) return;

    if (failure is AuthenticationFailure) {
      await getIt<SettingsService>().saveAiApiKey(null);
      if (!mounted) return;

      await context.router.root.replaceAll([const SplashRoute()]);
      return;
    }

    await showAIErrorDialog(
      context,
      failure,
      () => errorHandler.relayUserRetryDecision(true),
      () {
        if (isRetryableApiFailure(failure)) {
          errorHandler.relayUserRetryDecision(false);
        }
        onLeave();
      },
    );
  }

  @override
  void dispose() {
    final subscription = _apiFailureSubscription;
    if (subscription != null) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}
