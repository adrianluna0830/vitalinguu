import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class NextExerciseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const NextExerciseButton({super.key, required this.onPressed});

  @override
  State<NextExerciseButton> createState() => _NextExerciseButtonState();
}

class _NextExerciseButtonState extends State<NextExerciseButton> {
  bool _wasPressed = false;

  void _handlePressed() {
    if (_wasPressed) return;

    setState(() => _wasPressed = true);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _wasPressed ? null : _handlePressed,
      child: Text(context.t.exercise.next),
    );
  }
}
