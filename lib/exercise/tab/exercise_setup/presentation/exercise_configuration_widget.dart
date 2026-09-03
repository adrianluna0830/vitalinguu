import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/credit/credit_balance_store.dart';
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/cefr_dropdown.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/exercise_count_selector.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/exercise_type_selection_widget.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/exercise_types_configuration_widget.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/prompt_configuration_widget.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ExerciseConfigurationWidget extends StatefulWidget {
  const ExerciseConfigurationWidget({
    super.key,
    required this.topics,
    required this.creditBalanceState,
    required this.onChanged,
  });

  final List<Topic> topics;
  final CreditBalanceState creditBalanceState;
  final ValueChanged<ExerciseConfiguration> onChanged;

  @override
  State<ExerciseConfigurationWidget> createState() =>
      _ExerciseConfigurationWidgetState();
}

class _ExerciseConfigurationWidgetState
    extends State<ExerciseConfigurationWidget> {
  CEFR _cefr = CEFR.defaultValue;
  int _exerciseCount = 1;
  PromptConfiguration? _promptConfiguration;
  Set<TopicConfiguration> _topics = {};
  Set<ExerciseTypeConfiguration> _exerciseTypes = {};

  bool get _hasSufficientCredit => switch (widget.creditBalanceState) {
    CreditBalanceStateAvailable(:final balanceInUsd) =>
      balanceInUsd > CreditBalanceLimits.minimumBalanceToContinueInUsd,
    CreditBalanceNotStarted() ||
    CreditBalanceInProgress() ||
    CreditBalanceStateUnauthorized() ||
    CreditBalanceStateUnavailable() => false,
  };

  bool get _hasInsufficientCredit => switch (widget.creditBalanceState) {
    CreditBalanceStateAvailable(:final balanceInUsd) =>
      balanceInUsd <= CreditBalanceLimits.minimumBalanceToContinueInUsd,
    CreditBalanceNotStarted() ||
    CreditBalanceInProgress() ||
    CreditBalanceStateUnauthorized() ||
    CreditBalanceStateUnavailable() => false,
  };

  bool get _canContinue =>
      _hasSufficientCredit &&
      _promptConfiguration != null &&
      _topics.isNotEmpty &&
      _exerciseTypes.isNotEmpty;

  @override
  void didUpdateWidget(ExerciseConfigurationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final availableTopicIds = widget.topics.map((topic) => topic.id).toSet();
    _topics = _topics
        .where(
          (configuration) => availableTopicIds.contains(configuration.topic.id),
        )
        .toSet();
  }

  void _continue() {
    if (!_canContinue) return;

    widget.onChanged(
      ExerciseConfiguration(
        exerciseTypes: _exerciseTypes,
        promptConfiguration: _promptConfiguration!,
        exerciseCount: _exerciseCount,
        cefr: _cefr,
        topics: _topics,
      ),
    );
  }

  void _changePromptConfiguration(PromptConfiguration configuration) {
    setState(() {
      _promptConfiguration = configuration;
      if (configuration is AudioOnly) {
        _exerciseTypes = _exerciseTypes
            .where((configuration) => configuration.exerciseType.supportsAudio)
            .toSet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CefrDropdown(onChanged: (cefr) => setState(() => _cefr = cefr)),
        const SizedBox(height: 8),
        ExerciseCountSelector(
          onChanged: (count) => setState(() => _exerciseCount = count),
        ),
        const SizedBox(height: 8),
        PromptConfigurationWidget(onChanged: _changePromptConfiguration),
        const SizedBox(height: 8),
        ExerciseTypeSelectionWidget(
          isAudioOnly: _promptConfiguration is AudioOnly,
          onChanged: (exerciseTypes) =>
              setState(() => _exerciseTypes = exerciseTypes),
        ),
        const SizedBox(height: 8),
        ExerciseTypesConfigurationWidget(
          topics: widget.topics,
          onChanged: (topics) => setState(() => _topics = topics),
        ),
        const SizedBox(height: 8),
        if (_hasInsufficientCredit) ...[
          Text(
            context.t.exerciseSetup.minimumCredit(
              amount: CreditBalanceLimits.minimumBalanceToContinueInUsd,
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _canContinue ? _continue : null,
            child: Text(context.t.common.kContinue),
          ),
        ),
      ],
    );
  }
}
