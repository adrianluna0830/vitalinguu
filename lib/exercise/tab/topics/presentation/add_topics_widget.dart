import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class AddTopicsWidget extends StatefulWidget {
  const AddTopicsWidget({super.key, required this.onChanged});

  final ValueChanged<List<TopicInput>> onChanged;

  @override
  State<AddTopicsWidget> createState() => _AddTopicsWidgetState();
}

class _AddTopicsWidgetState extends State<AddTopicsWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _showValidationError = false;

  List<TopicInput>? _parseTopics() {
    final text = _controller.text.trim();
    final matches = RegExp(r'~([^~^]+)\^([^~^]+)(?=~|$)').allMatches(text);
    final topics = <TopicInput>[];
    var parsedUntil = 0;

    for (final match in matches) {
      final title = match.group(1)!.trim();
      final content = match.group(2)!.trim();

      if (match.start != parsedUntil || title.isEmpty || content.isEmpty) {
        return null;
      }

      topics.add(TopicInput(title: title, content: content));
      parsedUntil = match.end;
    }

    return topics.isNotEmpty && parsedUntil == text.length ? topics : null;
  }

  bool get _canConfirm => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() => _showValidationError = false);
  }

  void _confirm() {
    final topics = _parseTopics();
    if (topics == null) {
      setState(() => _showValidationError = true);
      return;
    }

    widget.onChanged(topics);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 8),
              Expanded(child: Text(context.t.topics.multipleInstructions)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 8,
          scrollPadding: const EdgeInsets.only(bottom: 80),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_showValidationError) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.t.topics.invalidMultiple,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        ElevatedButton(
          onPressed: _canConfirm ? _confirm : null,
          child: Text(context.t.common.confirm),
        ),
      ],
    );
  }
}
