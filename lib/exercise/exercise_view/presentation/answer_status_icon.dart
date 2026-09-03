import 'package:flutter/material.dart';

class AnswerStatusIcon extends StatelessWidget {
  final bool isCorrect;
  final bool isPartial;

  const AnswerStatusIcon({super.key, required this.isCorrect})
    : isPartial = false;

  const AnswerStatusIcon.partial({super.key})
    : isCorrect = false,
      isPartial = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isPartial
            ? Colors.orange
            : (isCorrect ? Colors.green : Colors.red),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPartial ? Icons.remove : (isCorrect ? Icons.check : Icons.close),
        color: Colors.white,
        size: 12,
      ),
    );
  }
}
