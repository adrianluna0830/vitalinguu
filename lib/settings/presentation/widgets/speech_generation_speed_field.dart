import 'package:flutter/material.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class SpeechGenerationSpeedField extends StatefulWidget {
  const SpeechGenerationSpeedField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final double initialValue;
  final ValueChanged<double> onChanged;

  @override
  State<SpeechGenerationSpeedField> createState() =>
      _SpeechGenerationSpeedFieldState();
}

class _SpeechGenerationSpeedFieldState
    extends State<SpeechGenerationSpeedField> {
  static const int _stepsPerUnit = 10;

  late double _value = _normalizedValue(widget.initialValue);

  @override
  void didUpdateWidget(SpeechGenerationSpeedField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = _normalizedValue(widget.initialValue);
    }
  }

  double _normalizedValue(double value) {
    final clamped = value.clamp(
      SettingsLimits.minSpeechGenerationSpeed,
      SettingsLimits.maxSpeechGenerationSpeed,
    );
    return (clamped * _stepsPerUnit).round() / _stepsPerUnit;
  }

  @override
  Widget build(BuildContext context) {
    final min = SettingsLimits.minSpeechGenerationSpeed;
    final max = SettingsLimits.maxSpeechGenerationSpeed;
    final divisions = ((max - min) * _stepsPerUnit).round();
    final formattedValue = _value.toStringAsFixed(1);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(context.t.settings.voiceSpeed)),
            Text('${formattedValue}x'),
          ],
        ),
        Slider(
          value: _value,
          min: min,
          max: max,
          divisions: divisions,
          label: '${formattedValue}x',
          onChanged: (value) =>
              setState(() => _value = _normalizedValue(value)),
          onChangeEnd: (_) => widget.onChanged(_value),
        ),
      ],
    );
  }
}
