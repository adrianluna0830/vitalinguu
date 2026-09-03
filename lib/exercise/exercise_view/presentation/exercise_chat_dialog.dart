import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/dialog_exercise.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ChatDialogMessage {
  final bool isUserMessage;
  final String message;

  const ChatDialogMessage({required this.isUserMessage, required this.message});
}

class ExerciseChatDialog extends StatelessWidget {
  static const borderRadius = BorderRadius.all(Radius.circular(28));

  const ExerciseChatDialog({
    super.key,
    required this.messages,
    required this.onUserMessageSubmitted,
    required this.isTyping,
    required this.onNewChat,
    required this.onClose,
  });

  final List<ChatDialogMessage> messages;
  final ValueChanged<String> onUserMessageSubmitted;
  final bool isTyping;
  final VoidCallback onNewChat;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // This container will host the chat interface.
    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: ChatMessageList(messages: messages, isTyping: isTyping),
            ),
            const SizedBox(height: 8),
            ChatMessageInput(
              onSubmitted: onUserMessageSubmitted,
              isEnabled: !isTyping,
              onNewChat: onNewChat,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isTyping,
  });

  final List<ChatDialogMessage> messages;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      children: [
        for (final message in messages)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Align(
              alignment: message.isUserMessage
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ChatMessageBubble(
                text: message.message,
                backgroundColor: message.isUserMessage
                    ? colors.primary
                    : colors.secondaryContainer,
                textColor: message.isUserMessage
                    ? colors.onPrimary
                    : colors.onSecondaryContainer,
              ),
            ),
          ),
        if (isTyping) const BotTypingMessage(),
      ],
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, maxWidth: 300),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}

class ChatMessageInput extends StatefulWidget {
  const ChatMessageInput({
    super.key,
    required this.onSubmitted,
    required this.isEnabled,
    required this.onNewChat,
  });

  final ValueChanged<String> onSubmitted;
  final bool isEnabled;
  final VoidCallback onNewChat;

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  void _submit() {
    if (!widget.isEnabled || _controller.text.trim().isEmpty) return;

    widget.onSubmitted(_controller.text);
    _controller.clear();
  }

  Future<void> _showNewChatConfirmation() async {
    final shouldStartNewChat = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.exercise.newChatTitle),
        content: Text(context.t.exercise.newChatMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.t.common.confirm),
          ),
        ],
      ),
    );
    if (!mounted || shouldStartNewChat != true) return;

    _controller.clear();
    widget.onNewChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.isEnabled,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: ExerciseChatDialog.borderRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: widget.isEnabled && hasText ? _submit : null,
          style: widget.isEnabled && !hasText
              ? IconButton.styleFrom(
                  disabledBackgroundColor: colors.surfaceContainerHighest,
                  disabledForegroundColor: colors.onSurfaceVariant,
                )
              : null,
          icon: const Icon(Icons.send),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: _showNewChatConfirmation,
          icon: const Icon(Icons.add_comment_outlined),
        ),
      ],
    );
  }
}
