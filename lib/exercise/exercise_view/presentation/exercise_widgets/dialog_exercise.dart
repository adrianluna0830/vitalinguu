import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/next_exercise_button.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/answer_result.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_keys.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_feedback.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_prompt_display.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/translation_display.dart';
import 'package:vitalinguu/core/data/implementations/global_audio_player.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/voice_note.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

sealed class DialogMessage {}

class AudioData {
  final String audioFilePath;
  final Duration duration;
  AudioData({required this.audioFilePath, required this.duration});
}

class Bot extends DialogMessage {
  final String name;
  final String message;
  final AudioData? audioData;
  final AnswerResult? dialogOverResult;

  Bot({
    required this.name,
    required this.message,
    required this.audioData,
    required this.dialogOverResult,
  });
}

sealed class DialogUserMessageFeedback {}

class BadFeedback extends DialogUserMessageFeedback {
  final String message;
  BadFeedback({required this.message});
}

class PartialFeedback extends DialogUserMessageFeedback {
  final String message;
  PartialFeedback({required this.message});
}

class GoodFeedback extends DialogUserMessageFeedback {}

class User extends DialogMessage {
  final String message;
  final DialogUserMessageFeedback? feedback;
  User({required this.message, required this.feedback});
}

class DialogExercise extends StatefulWidget {
  final ExerciseTask exerciseTask;
  final List<DialogMessage> messages;
  final ValueChanged<String> onUserMessageSubmitted;
  final VoidCallback onDialogEndedAbruptly;
  final bool isTyping;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const DialogExercise({
    super.key,
    required this.exerciseTask,
    required this.messages,
    required this.onUserMessageSubmitted,
    required this.onDialogEndedAbruptly,
    required this.isTyping,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<DialogExercise> createState() => _DialogExerciseState();
}

class _DialogExerciseState extends State<DialogExercise> {
  bool _isDialogOver = false;
  bool _wasEndedAbruptly = false;

  void _onDialogOver() {
    if (_isDialogOver) return;
    setState(() => _isDialogOver = true);
  }

  void _onDialogEndedAbruptly() {
    if (_isDialogOver) return;
    setState(() {
      _isDialogOver = true;
      _wasEndedAbruptly = true;
    });
    widget.onDialogEndedAbruptly();
  }

  @override
  void didUpdateWidget(DialogExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.isEmpty && oldWidget.messages.isNotEmpty) {
      _isDialogOver = false;
      _wasEndedAbruptly = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: DialogMessageList(
              exerciseTask: widget.exerciseTask,
              messages: widget.messages,
              isTyping: widget.isTyping,
              wasEndedAbruptly: _wasEndedAbruptly,
              onDialogOver: _onDialogOver,
              onNextExercise: widget.onNextExercise,
              translations: widget.translations,
              onTranslate: widget.onTranslate,
            ),
          ),
          if (!_isDialogOver) ...[
            const SizedBox(height: 8),
            DialogMessageInput(
              onSubmitted: widget.onUserMessageSubmitted,
              onDialogEndedAbruptly: _onDialogEndedAbruptly,
              isEnabled: !widget.isTyping,
            ),
          ],
        ],
      ),
    );
  }
}

class DialogMessageList extends StatefulWidget {
  final ExerciseTask exerciseTask;
  final List<DialogMessage> messages;
  final bool isTyping;
  final bool wasEndedAbruptly;
  final VoidCallback onDialogOver;
  final VoidCallback onNextExercise;
  final Map<String, TranslationState> translations;
  final TranslateText onTranslate;

  const DialogMessageList({
    super.key,
    required this.exerciseTask,
    required this.messages,
    required this.isTyping,
    required this.wasEndedAbruptly,
    required this.onDialogOver,
    required this.onNextExercise,
    required this.translations,
    required this.onTranslate,
  });

  @override
  State<DialogMessageList> createState() => _DialogMessageListState();
}

class _DialogMessageListState extends State<DialogMessageList> {
  bool _didNotifyDialogOver = false;

  AnswerResult? get _answerResult {
    if (widget.wasEndedAbruptly) {
      return IncorrectAnswerResult(t.exercise.abruptChatFeedback);
    }
    if (widget.messages.isEmpty) return null;
    return switch (widget.messages.last) {
      Bot(:final dialogOverResult) => dialogOverResult,
      User() => null,
    };
  }

  @override
  void initState() {
    super.initState();
    _notifyIfDialogOver();
  }

  @override
  void didUpdateWidget(DialogMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_answerResult == null) _didNotifyDialogOver = false;
    _notifyIfDialogOver();
  }

  void _notifyIfDialogOver() {
    if (_answerResult == null || _didNotifyDialogOver) return;
    _didNotifyDialogOver = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onDialogOver();
    });
  }

  Widget _answerWidget(AnswerResult result) => switch (result) {
    CorrectAnswerResult() => const CorrectAnswer(),
    PartiallyCorrectAnswerResult(:final explanation) => PartialAnswer(
      text: explanation,
    ),
    IncorrectAnswerResult(:final explanation) => IncorrectAnswer(
      text: explanation,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final answerResult = _answerResult;
    final showTyping = widget.isTyping && answerResult == null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExercisePromptDisplay(
            exerciseContent: null,
            exerciseTask: widget.exerciseTask,
            contentTranslationState: null,
            onContentTranslationRequested: () {},
            taskTranslationState: widget.translations[TranslationKeys.task],
            onTaskTranslationRequested: () {
              widget.onTranslate(
                TranslationKeys.task,
                widget.exerciseTask.exerciseTask,
              );
            },
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < widget.messages.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: DialogMessageWidget(
                key: ValueKey(TranslationKeys.dialogMessage(index)),
                message: widget.messages[index],
                translationState:
                    widget.translations[TranslationKeys.dialogMessage(index)],
                onTranslationRequested: () {
                  final message = widget.messages[index];
                  if (message is Bot) {
                    widget.onTranslate(
                      TranslationKeys.dialogMessage(index),
                      message.message,
                    );
                  }
                },
              ),
            ),
          if (answerResult != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _answerWidget(answerResult),
            ),
          if (answerResult != null)
            NextExerciseButton(onPressed: widget.onNextExercise),
          if (showTyping) const BotTypingMessage(),
        ],
      ),
    );
  }
}

class BotTypingMessage extends StatelessWidget {
  const BotTypingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: MessageBubble(
        backgroundColor: colors.secondaryContainer,
        textColor: colors.onSecondaryContainer,
        child: SizedBox(
          width: 40,
          height: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              3,
              (_) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.onSecondaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogMessageWidget extends StatelessWidget {
  final DialogMessage message;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const DialogMessageWidget({
    super.key,
    required this.message,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  Widget build(BuildContext context) {
    return switch (message) {
      Bot(:final name, :final message, audioData: final audioData?) =>
        BotAudioMessage(
          name: name,
          message: message,
          translationState: translationState,
          audioData: audioData,
          onTranslationRequested: onTranslationRequested,
        ),
      Bot(:final name, :final message) => BotTextMessage(
        name: name,
        message: message,
        translationState: translationState,
        onTranslationRequested: onTranslationRequested,
      ),
      User(:final message, :final feedback) => UserTextMessage(
        message: message,
        feedback: feedback,
      ),
    };
  }
}

class BotAudioMessage extends StatefulWidget {
  final String name;
  final String message;
  final TranslationState? translationState;
  final AudioData audioData;
  final VoidCallback onTranslationRequested;

  const BotAudioMessage({
    super.key,
    required this.name,
    required this.message,
    required this.translationState,
    required this.audioData,
    required this.onTranslationRequested,
  });

  @override
  State<BotAudioMessage> createState() => _BotAudioMessageState();
}

class _BotAudioMessageState extends State<BotAudioMessage> {
  late final GlobalAudioPlayer _audioPlayer;
  bool _isTranscriptionVisible = false;
  bool _isTranslationVisible = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = getIt<GlobalAudioPlayer>();
  }

  @override
  void didUpdateWidget(BotAudioMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.translationState is TranslationFailure &&
        oldWidget.translationState is! TranslationFailure) {
      _isTranslationVisible = false;
    }
  }

  void _toggleTranslation() {
    final isTranslationVisible = !_isTranslationVisible;
    setState(() => _isTranslationVisible = isTranslationVisible);
    if (isTranslationVisible) widget.onTranslationRequested();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: MessageBubble(
        backgroundColor: colors.secondaryContainer,
        textColor: colors.onSecondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 260,
              child: VoiceNote(
                audioPath: widget.audioData.audioFilePath,
                totalDuration: widget.audioData.duration,
                player: _audioPlayer,
              ),
            ),
            if (_isTranscriptionVisible)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(widget.message),
              ),
            if (_isTranslationVisible)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TranslationDisplay(
                  translationState: widget.translationState,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _messageActionButton(
                    colors: colors,
                    icon: Icons.subtitles_outlined,
                    onPressed: () => setState(
                      () => _isTranscriptionVisible = !_isTranscriptionVisible,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _messageActionButton(
                    colors: colors,
                    icon: Icons.translate,
                    onPressed: _toggleTranslation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageActionButton({
    required ColorScheme colors,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 24, height: 24),
      padding: EdgeInsets.zero,
      iconSize: 16,
      style: IconButton.styleFrom(
        backgroundColor: colors.secondary,
        foregroundColor: colors.onSecondary,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class BotTextMessage extends StatefulWidget {
  final String name;
  final String message;
  final TranslationState? translationState;
  final VoidCallback onTranslationRequested;

  const BotTextMessage({
    super.key,
    required this.name,
    required this.message,
    required this.translationState,
    required this.onTranslationRequested,
  });

  @override
  State<BotTextMessage> createState() => _BotTextMessageState();
}

class _BotTextMessageState extends State<BotTextMessage> {
  bool _isTranslationVisible = false;

  @override
  void didUpdateWidget(BotTextMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.translationState is TranslationFailure &&
        oldWidget.translationState is! TranslationFailure) {
      _isTranslationVisible = false;
    }
  }

  void _toggleTranslation() {
    final isTranslationVisible = !_isTranslationVisible;
    setState(() => _isTranslationVisible = isTranslationVisible);
    if (isTranslationVisible) widget.onTranslationRequested();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: MessageBubble(
        backgroundColor: colors.secondaryContainer,
        textColor: colors.onSecondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(widget.message),
            if (_isTranslationVisible)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TranslationDisplay(
                  translationState: widget.translationState,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 24,
                ),
                padding: EdgeInsets.zero,
                iconSize: 16,
                style: IconButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.onSecondary,
                ),
                onPressed: _toggleTranslation,
                icon: const Icon(Icons.translate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTextMessage extends StatefulWidget {
  final String message;
  final DialogUserMessageFeedback? feedback;

  const UserTextMessage({
    super.key,
    required this.message,
    required this.feedback,
  });

  @override
  State<UserTextMessage> createState() => _UserTextMessageState();
}

class _UserTextMessageState extends State<UserTextMessage> {
  bool _isFeedbackVisible = false;

  String? get _feedbackText => switch (widget.feedback) {
    BadFeedback(:final message) => message,
    PartialFeedback(:final message) => message,
    GoodFeedback() => null,
    null => null,
  };

  IconData get _feedbackIcon => switch (widget.feedback) {
    BadFeedback() => Icons.cancel,
    PartialFeedback() => Icons.warning_amber_rounded,
    GoodFeedback() => Icons.check_circle,
    null => Icons.feedback_outlined,
  };

  Color _feedbackBackgroundColor(ColorScheme colors) =>
      switch (widget.feedback) {
        BadFeedback() => colors.error,
        PartialFeedback() => Colors.orange,
        GoodFeedback() => Colors.green,
        null => colors.surfaceContainerHighest,
      };

  Color _feedbackForegroundColor(ColorScheme colors) =>
      switch (widget.feedback) {
        BadFeedback() => colors.onError,
        PartialFeedback() => Colors.black,
        GoodFeedback() => Colors.white,
        null => colors.onSurfaceVariant.withValues(alpha: 0.5),
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final feedbackText = _feedbackText;
    final isCorrect = widget.feedback is GoodFeedback;

    return Align(
      alignment: Alignment.centerRight,
      child: MessageBubble(
        backgroundColor: colors.primary,
        textColor: colors.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message),
            if (_isFeedbackVisible && feedbackText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  feedbackText,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: isCorrect
                  ? SizedBox.square(
                      dimension: 24,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _feedbackIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  : IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: 24,
                        height: 24,
                      ),
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      style: IconButton.styleFrom(
                        backgroundColor: _feedbackBackgroundColor(colors),
                        foregroundColor: _feedbackForegroundColor(colors),
                        disabledBackgroundColor: _feedbackBackgroundColor(
                          colors,
                        ),
                        disabledForegroundColor: _feedbackForegroundColor(
                          colors,
                        ),
                      ),
                      onPressed: widget.feedback == null
                          ? null
                          : () => setState(
                              () => _isFeedbackVisible = !_isFeedbackVisible,
                            ),
                      icon: Icon(_feedbackIcon),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color textColor;

  const MessageBubble({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.textColor,
  });

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
        child: DefaultTextStyle.merge(
          style: TextStyle(color: textColor),
          child: child,
        ),
      ),
    );
  }
}

class DialogMessageInput extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final VoidCallback onDialogEndedAbruptly;
  final bool isEnabled;

  const DialogMessageInput({
    super.key,
    required this.onSubmitted,
    required this.onDialogEndedAbruptly,
    required this.isEnabled,
  });

  @override
  State<DialogMessageInput> createState() => _DialogMessageInputState();
}

class _DialogMessageInputState extends State<DialogMessageInput> {
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

  Future<void> _showAbruptEndConfirmation() async {
    final shouldEndDialog = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.exercise.endChatTitle),
        content: Text(context.t.exercise.endChatMessage),
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
    if (!mounted || shouldEndDialog != true) return;
    widget.onDialogEndedAbruptly();
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
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
        IconButton.filled(
          onPressed: _showAbruptEndConfirmation,
          style: IconButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
          ),
          icon: const Icon(Icons.stop_rounded),
        ),
      ],
    );
  }
}
