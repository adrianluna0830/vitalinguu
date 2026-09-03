import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_selection_tile.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class PromptConfigurationWidget extends StatefulWidget {
  const PromptConfigurationWidget({super.key, required this.onChanged});

  final ValueChanged<PromptConfiguration> onChanged;

  @override
  State<PromptConfigurationWidget> createState() =>
      _PromptConfigurationWidgetState();
}

class _PromptConfigurationWidgetState extends State<PromptConfigurationWidget> {
  bool _textSelected = false;
  bool _audioSelected = false;
  Priority _textPriority = Priority.medium;
  Priority _audioPriority = Priority.medium;

  void _toggleText() {
    if (_textSelected && !_audioSelected) return;

    setState(() => _textSelected = !_textSelected);
    _notifyChanged();
  }

  void _toggleAudio() {
    if (_audioSelected && !_textSelected) return;

    setState(() => _audioSelected = !_audioSelected);
    _notifyChanged();
  }

  void _changeTextPriority(Priority priority) {
    setState(() => _textPriority = priority);
    _notifyChanged();
  }

  void _changeAudioPriority(Priority priority) {
    setState(() => _audioPriority = priority);
    _notifyChanged();
  }

  void _notifyChanged() {
    if (_textSelected && _audioSelected) {
      widget.onChanged(
        TextAndAudio(
          textPriority: _textPriority,
          audioPriority: _audioPriority,
        ),
      );
    } else if (_textSelected) {
      widget.onChanged(TextOnly(priority: _textPriority));
    } else if (_audioSelected) {
      widget.onChanged(AudioOnly(priority: _audioPriority));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.t.exerciseSetup.promptContent),
          const SizedBox(height: 12),
          _PromptOption(
            label: context.t.exerciseSetup.text,
            selected: _textSelected,
            priority: _textPriority,
            onTap: _toggleText,
            onPriorityChanged: _changeTextPriority,
          ),
          const SizedBox(height: 8),
          _PromptOption(
            label: context.t.exerciseSetup.audio,
            selected: _audioSelected,
            priority: _audioPriority,
            onTap: _toggleAudio,
            onPriorityChanged: _changeAudioPriority,
          ),
        ],
      ),
    );
  }
}

class _PromptOption extends StatelessWidget {
  const _PromptOption({
    required this.label,
    required this.selected,
    required this.priority,
    required this.onTap,
    required this.onPriorityChanged,
  });

  final String label;
  final bool selected;
  final Priority priority;
  final VoidCallback onTap;
  final ValueChanged<Priority> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return PrioritySelectionTile(
      label: label,
      selected: selected,
      priority: priority,
      onTap: onTap,
      onPriorityChanged: onPriorityChanged,
    );
  }
}
