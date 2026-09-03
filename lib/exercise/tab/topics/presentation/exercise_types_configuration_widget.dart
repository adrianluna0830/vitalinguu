import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_selection_tile.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ExerciseTypesConfigurationWidget extends StatefulWidget {
  const ExerciseTypesConfigurationWidget({
    super.key,
    required this.topics,
    required this.onChanged,
  });

  final List<Topic> topics;
  final ValueChanged<Set<TopicConfiguration>> onChanged;

  @override
  State<ExerciseTypesConfigurationWidget> createState() =>
      _ExerciseTypesConfigurationWidgetState();
}

class _ExerciseTypesConfigurationWidgetState
    extends State<ExerciseTypesConfigurationWidget> {
  final Set<String> _selectedTopicIds = {};
  final Map<String, Priority> _priorities = {};

  @override
  void didUpdateWidget(ExerciseTypesConfigurationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final availableTopicIds = widget.topics.map((topic) => topic.id).toSet();
    _selectedTopicIds.retainWhere(availableTopicIds.contains);
    _priorities.removeWhere(
      (topicId, _) => !availableTopicIds.contains(topicId),
    );
  }

  void _toggleTopic(Topic topic) {
    setState(() {
      if (!_selectedTopicIds.add(topic.id)) {
        _selectedTopicIds.remove(topic.id);
      }
    });
    _notifyChanged();
  }

  void _changePriority(Topic topic, Priority priority) {
    setState(() {
      _priorities[topic.id] = priority;
    });
    _notifyChanged();
  }

  Priority _priorityOf(Topic topic) => _priorities[topic.id] ?? Priority.medium;

  void _notifyChanged() {
    widget.onChanged(
      widget.topics
          .where((topic) => _selectedTopicIds.contains(topic.id))
          .map(
            (topic) =>
                TopicConfiguration(topic: topic, priority: _priorityOf(topic)),
          )
          .toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTopics = [
      ...widget.topics.where((topic) => _selectedTopicIds.contains(topic.id)),
      ...widget.topics.where((topic) => !_selectedTopicIds.contains(topic.id)),
    ];

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
          Text(context.t.exerciseSetup.availableTopics),
          const SizedBox(height: 12),
          if (widget.topics.isEmpty)
            Text(context.t.exerciseSetup.noAvailableTopics)
          else
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleTopics.length,
              itemBuilder: (context, index) {
                final topic = visibleTopics[index];
                final isSelected = _selectedTopicIds.contains(topic.id);
                final priority = _priorityOf(topic);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: PrioritySelectionTile(
                    label: topic.title,
                    selected: isSelected,
                    priority: priority,
                    onTap: () => _toggleTopic(topic),
                    onPriorityChanged: (priority) =>
                        _changePriority(topic, priority),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
