import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/boolean_circle_indicator.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/delete_topics_confirmation_dialog.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/edit_topic_widget.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

typedef TopicChanged = void Function(String topicId, TopicInput topic);

class TopicsListWidget extends StatefulWidget {
  const TopicsListWidget({
    super.key,
    required this.topics,
    required this.onChanged,
    required this.onDelete,
  });

  final List<Topic> topics;
  final TopicChanged onChanged;
  final ValueChanged<List<String>> onDelete;

  @override
  State<TopicsListWidget> createState() => _TopicsListWidgetState();
}

class _TopicsListWidgetState extends State<TopicsListWidget> {
  bool multiSelectionMode = false;
  final Map<String, bool> _selectedTopics = {};

  List<String> get _selectedTopicIds => _selectedTopics.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList(growable: false);

  void _onTopicPressed(Topic topic) {
    if (multiSelectionMode) {
      setState(() {
        _selectedTopics[topic.id] = !(_selectedTopics[topic.id] ?? false);
      });
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(topic.title), content: Text(topic.content)),
    );
  }

  void _onTopicLongPressed(Topic topic) {
    setState(() {
      if (multiSelectionMode) {
        multiSelectionMode = false;
        _selectedTopics.clear();
        return;
      }

      multiSelectionMode = true;
      _selectedTopics[topic.id] = true;
    });
  }

  void _editTopic(Topic topic) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: EditTopicWidget(
          title: topic.title,
          content: topic.content,
          onChanged: (update) {
            widget.onChanged(topic.id, update);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => DeleteTopicsConfirmationDialog(
        onCancel: () => Navigator.pop(dialogContext),
        onConfirm: () {
          Navigator.pop(dialogContext);
          _deleteSelectedTopics();
        },
      ),
    );
  }

  void _deleteSelectedTopics() {
    widget.onDelete(_selectedTopicIds);
    setState(() {
      multiSelectionMode = false;
      _selectedTopics.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (multiSelectionMode)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _selectedTopicIds.isNotEmpty
                  ? _showDeleteConfirmation
                  : null,
              child: Text(context.t.common.delete),
            ),
          ),
        if (multiSelectionMode) const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: widget.topics.length,
            itemBuilder: (context, index) {
              final topic = widget.topics[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: ListTile(
                  title: Text(topic.title),
                  trailing: multiSelectionMode
                      ? BooleanCircleIndicator(
                          value: _selectedTopics[topic.id] ?? false,
                        )
                      : IconButton(
                          onPressed: () => _editTopic(topic),
                          icon: const Icon(Icons.edit),
                        ),
                  onTap: () => _onTopicPressed(topic),
                  onLongPress: () => _onTopicLongPressed(topic),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
