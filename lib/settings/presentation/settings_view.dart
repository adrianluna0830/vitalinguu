import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/presentation/nano_gpt_api_link.dart';
import 'package:vitalinguu/settings/presentation/widgets/api_key_field.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/settings/domain/settings_view_model.dart';
import 'package:vitalinguu/settings/presentation/widgets/credit_balance_text.dart';
import 'package:vitalinguu/settings/presentation/widgets/language_locale_dropdown.dart';
import 'package:vitalinguu/settings/presentation/widgets/speech_generation_speed_field.dart';
import 'package:vitalinguu/settings/presentation/widgets/topic_feedback_lookback_days_field.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<SettingsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SignalBuilder(
            builder: (context) => SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            context.t.settings.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CreditBalanceText(
                                    state: _viewModel.creditBalanceState.value,
                                  ),
                                  const SizedBox(width: 4),
                                  _RefreshCreditBalanceButton(
                                    state: _viewModel
                                        .creditBalanceRefreshState
                                        .value,
                                    onPressed: () => unawaited(
                                      _viewModel.refreshCreditBalance(),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                context.t.settings.minimumCredit(
                                  amount: CreditBalanceLimits
                                      .minimumBalanceToContinueInUsd,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SettingsSection(
                        title: context.t.settings.configuration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ApiKeyField(
                              currentApiKey: _viewModel.aiApiKey.value,
                              onRegistrationRequested: () => context.router.root
                                  .push(const ApiKeyRegistrationRoute()),
                            ),
                            const NanoGptApiLink(),
                            const SizedBox(height: 12),
                            LanguageLocaleDropdown(
                              label: context.t.onboarding.nativeLanguageLabel,
                              value: _viewModel.nativeLanguage.value,
                              onChanged: _updateNativeLanguage,
                            ),
                            const SizedBox(height: 12),
                            LanguageLocaleDropdown(
                              label: context.t.onboarding.learningLanguageLabel,
                              value: _viewModel.learningLanguage.value,
                              onChanged: _updateLearningLanguage,
                            ),
                            const SizedBox(height: 12),
                            TopicFeedbackLookbackDaysField(
                              initialValue:
                                  _viewModel.topicFeedbackLookbackDays.value,
                              onChanged: (value) => unawaited(
                                _viewModel.updateTopicFeedbackLookbackDays(
                                  value,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SpeechGenerationSpeedField(
                              initialValue:
                                  _viewModel.speechGenerationSpeed.value,
                              onChanged: (value) => unawaited(
                                _viewModel.updateSpeechGenerationSpeed(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateNativeLanguage(LanguageLocale value) async {
    await _viewModel.updateNativeLanguage(value);
    if (mounted) context.router.root.replace(const SplashRoute());
  }

  Future<void> _updateLearningLanguage(LanguageLocale value) async {
    await _viewModel.updateLearningLanguage(value);
    if (mounted) context.router.root.replace(const SplashRoute());
  }
}

class _RefreshCreditBalanceButton extends StatelessWidget {
  const _RefreshCreditBalanceButton({
    required this.state,
    required this.onPressed,
  });

  final CreditBalanceRefreshState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isRefreshInProgress = state is CreditBalanceRefreshInProgress;

    return IconButton(
      tooltip: context.t.settings.credit.refresh,
      onPressed: isRefreshInProgress ? null : onPressed,
      icon: isRefreshInProgress
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
