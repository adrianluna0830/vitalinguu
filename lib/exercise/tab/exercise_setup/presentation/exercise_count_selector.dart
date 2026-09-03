import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ExerciseCountSelector extends StatefulWidget {
  const ExerciseCountSelector({
    super.key,
    required this.onChanged,
    this.minCount = 1,
    this.maxCount = 15,
  }) : assert(minCount <= maxCount);

  final ValueChanged<int> onChanged;
  final int minCount;
  final int maxCount;

  @override
  State<ExerciseCountSelector> createState() => _ExerciseCountSelectorState();
}

class _ExerciseCountSelectorState extends State<ExerciseCountSelector> {
  late int _exerciseCount = widget.minCount;

  void _changeCount(double value) {
    final count = value.round();
    if (count == _exerciseCount) return;

    setState(() => _exerciseCount = count);
    widget.onChanged(count);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final range = widget.maxCount - widget.minCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(context.t.exerciseSetup.exerciseCount)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$_exerciseCount'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            min: widget.minCount.toDouble(),
            max: widget.maxCount.toDouble(),
            divisions: range > 0 ? range : null,
            value: _exerciseCount.toDouble(),
            label: '$_exerciseCount',
            onChanged: range > 0 ? _changeCount : null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('${widget.minCount}'), Text('${widget.maxCount}')],
          ),
        ],
      ),
    );
  }
}
