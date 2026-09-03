import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_button.dart';

class PrioritySelectionTile extends StatelessWidget {
  const PrioritySelectionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.priority,
    required this.onTap,
    required this.onPriorityChanged,
    this.enabled = true,
  });

  static const height = 44.0;

  final String label;
  final bool selected;
  final bool enabled;
  final Priority priority;
  final VoidCallback onTap;
  final ValueChanged<Priority> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Opacity(
            opacity: enabled ? 1 : 0.45,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selected)
                    PriorityButton(
                      priority: priority,
                      onChanged: onPriorityChanged,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
