import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class EditTopicWidget extends StatefulWidget {
  const EditTopicWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onChanged,
  });

  final String title;
  final String content;
  final ValueChanged<TopicInput> onChanged;

  @override
  State<EditTopicWidget> createState() => _EditTopicWidgetState();
}

class _EditTopicWidgetState extends State<EditTopicWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get _canConfirm =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title)
      ..addListener(_onTextChanged);
    _contentController = TextEditingController(text: widget.content)
      ..addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  void _confirm() {
    widget.onChanged(
      TopicInput(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      ),
    );
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
      mainAxisSize: MainAxisSize.min,
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
