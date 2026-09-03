import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class AddTopicWidget extends StatefulWidget {
  const AddTopicWidget({super.key, required this.onChanged});

  final ValueChanged<TopicInput> onChanged;

  @override
  State<AddTopicWidget> createState() => _AddTopicWidgetState();
}

class _AddTopicWidgetState extends State<AddTopicWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool get _canConfirm =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  void _confirm() {
    widget.onChanged(
      TopicInput(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      ),
    );
    _titleController.clear();
    _contentController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: context.t.topics.titleHint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: context.t.topics.contentHint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _canConfirm ? _confirm : null,
          child: Text(context.t.common.confirm),
        ),
      ],
    );
  }
}
