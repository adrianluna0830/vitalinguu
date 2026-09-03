import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/answer_status_icon.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class CorrectAnswer extends StatelessWidget {
  const CorrectAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    return _AnswerFeedback(
      text: context.t.exercise.correctAnswer,
      icon: const AnswerStatusIcon(isCorrect: true),
    );
  }
}

class PartialAnswer extends StatelessWidget {
  const PartialAnswer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _AnswerFeedback(text: text, icon: const AnswerStatusIcon.partial());
  }
}

class IncorrectAnswer extends StatelessWidget {
  const IncorrectAnswer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _AnswerFeedback(
      text: text,
      icon: const AnswerStatusIcon(isCorrect: false),
    );
  }
}

class _AnswerFeedback extends StatelessWidget {
  const _AnswerFeedback({required this.text, required this.icon});

  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: icon,
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
