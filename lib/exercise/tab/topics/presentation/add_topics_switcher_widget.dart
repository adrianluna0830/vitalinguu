import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/add_topic_widget.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/add_topics_widget.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

enum AddTopicsMode { single, multiple }

class AddTopicsSwitcherWidget extends StatefulWidget {
  const AddTopicsSwitcherWidget({
    super.key,
    required this.onTopicChanged,
    required this.onTopicsChanged,
  });

  final ValueChanged<TopicInput> onTopicChanged;
  final ValueChanged<List<TopicInput>> onTopicsChanged;

  @override
  State<AddTopicsSwitcherWidget> createState() =>
      _AddTopicsSwitcherWidgetState();
}

class _AddTopicsSwitcherWidgetState extends State<AddTopicsSwitcherWidget> {
  AddTopicsMode _mode = AddTopicsMode.single;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton<AddTopicsMode>(
          segments: [
            ButtonSegment(
              value: AddTopicsMode.single,
              label: Text(context.t.topics.single),
            ),
            ButtonSegment(
              value: AddTopicsMode.multiple,
              label: Text(context.t.topics.multiple),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (selection) {
            setState(() => _mode = selection.first);
          },
        ),
        const SizedBox(height: 8),
        switch (_mode) {
          AddTopicsMode.single => AddTopicWidget(
            onChanged: widget.onTopicChanged,
          ),
          AddTopicsMode.multiple => AddTopicsWidget(
            onChanged: widget.onTopicsChanged,
          ),
        },
      ],
    );
  }
}
