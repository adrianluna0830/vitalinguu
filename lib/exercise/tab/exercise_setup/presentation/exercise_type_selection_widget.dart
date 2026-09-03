import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_button.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_selection_tile.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ExerciseTypeSelectionWidget extends StatefulWidget {
  const ExerciseTypeSelectionWidget({
    super.key,
    required this.isAudioOnly,
    required this.onChanged,
  });

  final bool isAudioOnly;
  final ValueChanged<Set<ExerciseTypeConfiguration>> onChanged;

  @override
  State<ExerciseTypeSelectionWidget> createState() =>
      _ExerciseTypeSelectionWidgetState();
}

class _ExerciseTypeSelectionWidgetState
    extends State<ExerciseTypeSelectionWidget> {
  final Set<ExerciseType> _selectedTypes = {};
  final Map<ExerciseType, Priority> _priorities = {};

  @override
  void didUpdateWidget(ExerciseTypeSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isAudioOnly) return;

    final previousLength = _selectedTypes.length;
    _selectedTypes.removeWhere((type) => !type.supportsAudio);
    _priorities.removeWhere((type, _) => !type.supportsAudio);

    if (_selectedTypes.length != previousLength) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _notifyChanged();
      });
    }
  }

  void _toggleType(ExerciseType exerciseType) {
    setState(() {
      if (!_selectedTypes.add(exerciseType)) {
        _selectedTypes.remove(exerciseType);
      }
    });
    _notifyChanged();
  }

  void _changePriority(ExerciseType exerciseType, Priority priority) {
    setState(() => _priorities[exerciseType] = priority);
    _notifyChanged();
  }

  void _selectAllTypes() {
    setState(
      () => _selectedTypes.addAll(
        ExerciseType.values.where(
          (type) => !widget.isAudioOnly || type.supportsAudio,
        ),
      ),
    );
    _notifyChanged();
  }

  void _deselectAllTypes() {
    setState(_selectedTypes.clear);
    _notifyChanged();
  }

  void _changeSelectedPriorities(Priority priority) {
    if (_selectedTypes.isEmpty) return;

    setState(() {
      for (final type in _selectedTypes) {
        _priorities[type] = priority;
      }
    });
    _notifyChanged();
  }

  Priority _priorityOf(ExerciseType exerciseType) =>
      _priorities[exerciseType] ?? Priority.medium;

  String _exerciseTypeLabel(
    ExerciseType exerciseType,
    Translations translations,
  ) {
    return switch (exerciseType) {
      ExerciseType.dialog => translations.exerciseSetup.types.dialog,
      ExerciseType.fillTheBlank =>
        translations.exerciseSetup.types.fillTheBlank,
      ExerciseType.matchElements =>
        translations.exerciseSetup.types.matchElements,
      ExerciseType.multipleChoice =>
        translations.exerciseSetup.types.multipleChoice,
      ExerciseType.multipleChoiceList =>
        translations.exerciseSetup.types.multipleChoiceList,
      ExerciseType.selectAllThatApply =>
        translations.exerciseSetup.types.selectAllThatApply,
      ExerciseType.wordOrdering =>
        translations.exerciseSetup.types.wordOrdering,
      ExerciseType.write => translations.exerciseSetup.types.write,
      ExerciseType.writeList => translations.exerciseSetup.types.writeList,
    };
  }

  void _notifyChanged() {
    widget.onChanged(
      _selectedTypes
          .map(
            (exerciseType) => ExerciseTypeConfiguration(
              exerciseType: exerciseType,
              priority: _priorityOf(exerciseType),
            ),
          )
          .toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.t.exerciseSetup.exerciseTypes),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: _selectedTypes.isEmpty
                          ? null
                          : _deselectAllTypes,
                      child: Text(context.t.exerciseSetup.deselectAll),
                    ),
                    TextButton(
                      onPressed: _selectAllTypes,
                      child: Text(context.t.exerciseSetup.selectAll),
                    ),
                  ],
                ),
              ),
              PriorityButton(
                priority: Priority.low,
                onChanged: (_) => _changeSelectedPriorities(Priority.low),
              ),
              PriorityButton(
                priority: Priority.medium,
                onChanged: (_) => _changeSelectedPriorities(Priority.medium),
              ),
              PriorityButton(
                priority: Priority.high,
                onChanged: (_) => _changeSelectedPriorities(Priority.high),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = switch (constraints.maxWidth) {
                >= 840 => 3,
                >= 560 => 2,
                _ => 1,
              };
              const spacing = 4.0;

              return GridView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ExerciseType.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  mainAxisExtent: PrioritySelectionTile.height,
                ),
                itemBuilder: (_, index) =>
                    _exerciseTypeTile(ExerciseType.values[index], context.t),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _exerciseTypeTile(
    ExerciseType exerciseType,
    Translations translations,
  ) {
    final isSelected = _selectedTypes.contains(exerciseType);
    final isEnabled = !widget.isAudioOnly || exerciseType.supportsAudio;

    return PrioritySelectionTile(
      label: _exerciseTypeLabel(exerciseType, translations),
      selected: isSelected,
      enabled: isEnabled,
      priority: _priorityOf(exerciseType),
      onTap: () => _toggleType(exerciseType),
      onPriorityChanged: (priority) => _changePriority(exerciseType, priority),
    );
  }
}
