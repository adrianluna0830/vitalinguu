part of '../../exercise_view_model.dart';

enum _DialogUserFeedbackVerdict { good, partial, bad }

enum _DialogFinalVerdict { correct, partiallyCorrect, incorrect }

class _GeneratedDialogUserFeedback {
  final _DialogUserFeedbackVerdict verdict;
  final String? explanation;

  const _GeneratedDialogUserFeedback({
    required this.verdict,
    required this.explanation,
  });
}

class _GeneratedDialogFinalResult {
  final _DialogFinalVerdict verdict;
  final String? explanation;

  const _GeneratedDialogFinalResult({
    required this.verdict,
    required this.explanation,
  });
}

class _GeneratedDialogBotMessage {
  final String name;
  final String message;
  final _GeneratedDialogFinalResult? dialogOverResult;

  const _GeneratedDialogBotMessage({
    required this.name,
    required this.message,
    required this.dialogOverResult,
  });
}

class _GeneratedDialogTurn {
  final _GeneratedDialogUserFeedback? userFeedback;
  final List<_GeneratedDialogBotMessage> botMessages;

  const _GeneratedDialogTurn({
    required this.userFeedback,
    required this.botMessages,
  });
}

DialogUserMessageFeedback _toDialogUserFeedback(
  _GeneratedDialogUserFeedback generated,
) {
  return switch (generated.verdict) {
    _DialogUserFeedbackVerdict.good => GoodFeedback(),
    _DialogUserFeedbackVerdict.partial => PartialFeedback(
      message: generated.explanation!,
    ),
    _DialogUserFeedbackVerdict.bad => BadFeedback(
      message: generated.explanation!,
    ),
  };
}

AnswerResult? _toDialogFinalResult(_GeneratedDialogFinalResult? generated) {
  if (generated == null) return null;
  return switch (generated.verdict) {
    _DialogFinalVerdict.correct => CorrectAnswerResult(),
    _DialogFinalVerdict.partiallyCorrect => PartiallyCorrectAnswerResult(
      generated.explanation!,
    ),
    _DialogFinalVerdict.incorrect => IncorrectAnswerResult(
      generated.explanation!,
    ),
  };
}
