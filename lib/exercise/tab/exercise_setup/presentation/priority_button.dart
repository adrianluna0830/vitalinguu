import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';

class PriorityButton extends StatelessWidget {
  const PriorityButton({
    super.key,
    required this.priority,
    required this.onChanged,
  });

  final Priority priority;
  final ValueChanged<Priority> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => onChanged(_nextPriority),
        child: Text(_symbol, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }

  Priority get _nextPriority => switch (priority) {
    Priority.medium => Priority.high,
    Priority.high => Priority.low,
    Priority.low => Priority.medium,
  };

  String get _symbol => switch (priority) {
    Priority.low => '↓',
    Priority.medium => '—',
    Priority.high => '↑',
  };
}
