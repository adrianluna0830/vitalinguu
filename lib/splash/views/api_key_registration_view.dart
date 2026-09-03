import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/presentation/nano_gpt_api_link.dart';
import 'package:vitalinguu/splash/view_models/api_key_registration_view_model.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class ApiKeyRegistrationView extends StatefulWidget {
  const ApiKeyRegistrationView({super.key});

  @override
  State<ApiKeyRegistrationView> createState() => _ApiKeyRegistrationViewState();
}

class _ApiKeyRegistrationViewState extends State<ApiKeyRegistrationView> {
  late final ApiKeyRegistrationViewModel _viewModel;
  late final TextEditingController _controller;
  late final StreamSubscription<ApiKeyRegistrationViewModelState>
  _registrationSubscription;
  bool _obscureText = true;
  bool _isValidationInProgress = false;
  String? _errorText;

  bool get _canContinue =>
      _controller.text.trim().isNotEmpty && !_isValidationInProgress;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ApiKeyRegistrationViewModel>();
    _controller = TextEditingController(text: _viewModel.savedApiKey)
      ..addListener(_onTextChanged);
    _registrationSubscription = _viewModel.apiKeyRegistered.listen(
      _onRegistrationStateChanged,
    );
  }

  void _onTextChanged() {
    _viewModel.restartState();
    setState(() => _errorText = null);
  }

  void _restoreSavedApiKey() {
    final savedApiKey = _viewModel.savedApiKey;
    if (savedApiKey != null) {
      _controller.text = savedApiKey;
    }
  }

  void _onRegistrationStateChanged(ApiKeyRegistrationViewModelState state) {
    if (!mounted) return;

    switch (state) {
      case ValidApiKeyState():
        _isValidationInProgress = false;
        context.router.pop();
      case InvalidApiKeyState():
        setState(() {
          _isValidationInProgress = false;
          _errorText = context.t.onboarding.invalidApiKey;
        });
      case UnavailableApiKeyState():
        setState(() {
          _isValidationInProgress = false;
          _errorText = context.t.onboarding.unavailableApiKey;
        });
      case VoidApiKeyState():
        setState(() => _isValidationInProgress = false);
      case InProgressApiKeyState():
        setState(() => _isValidationInProgress = true);
    }
  }

  @override
  void dispose() {
    unawaited(_registrationSubscription.cancel());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.onboarding.apiKeyTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      enabled: !_isValidationInProgress,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: context.t.onboarding.apiKeyLabel,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        errorText: _errorText,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    const NanoGptApiLink(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_viewModel.savedApiKey != null)
                          OutlinedButton(
                            onPressed: _restoreSavedApiKey,
                            child: Text(context.t.onboarding.useSavedApiKey),
                          ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _canContinue
                              ? () => unawaited(
                                  _viewModel.saveRegisterApiKey(
                                    _controller.text.trim(),
                                  ),
                                )
                              : null,
                          child: _isValidationInProgress
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.t.common.kContinue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
