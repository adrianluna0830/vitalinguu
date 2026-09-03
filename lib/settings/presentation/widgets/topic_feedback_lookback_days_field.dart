import 'package:flutter/material.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class TopicFeedbackLookbackDaysField extends StatefulWidget {
  const TopicFeedbackLookbackDaysField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  State<TopicFeedbackLookbackDaysField> createState() =>
      _TopicFeedbackLookbackDaysFieldState();
}

class _TopicFeedbackLookbackDaysFieldState
    extends State<TopicFeedbackLookbackDaysField> {
  late int _value = _normalizedValue(widget.initialValue);

  @override
  void didUpdateWidget(TopicFeedbackLookbackDaysField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = _normalizedValue(widget.initialValue);
    }
  }

  int _normalizedValue(int value) {
    return value.clamp(
      SettingsLimits.minTopicFeedbackLookbackDays,
      SettingsLimits.maxTopicFeedbackLookbackDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    final min = SettingsLimits.minTopicFeedbackLookbackDays;
    final max = SettingsLimits.maxTopicFeedbackLookbackDays;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(context.t.settings.feedbackLookback)),
            Text(context.t.settings.days(count: _value)),
          ],
        ),
        Slider(
          value: _value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: context.t.settings.days(count: _value),
          onChanged: (value) => setState(() => _value = value.round()),
          onChangeEnd: (_) => widget.onChanged(_value),
        ),
      ],
    );
  }
}
