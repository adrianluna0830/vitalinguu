import 'package:flutter/material.dart';

class CorrectOption extends StatelessWidget {
  const CorrectOption({
    super.key,
    required this.hasUserSelected,
    required this.isSelectedByUser,
    required this.text,
    required this.onClick,
    this.isEnabled,
  });

  final bool hasUserSelected;
  final bool isSelectedByUser;
  final String text;
  final VoidCallback onClick;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return _AnswerOption(
      hasUserSelected: hasUserSelected,
      isSelectedByUser: isSelectedByUser,
      text: text,
      onClick: onClick,
      isEnabled: isEnabled ?? !hasUserSelected,
      selectedColor: Colors.green,
    );
  }
}

class IncorrectOption extends StatelessWidget {
  const IncorrectOption({
    super.key,
    required this.hasUserSelected,
    required this.isSelectedByUser,
    required this.text,
    required this.onClick,
    this.isEnabled,
  });

  final bool hasUserSelected;
  final bool isSelectedByUser;
  final String text;
  final VoidCallback onClick;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return _AnswerOption(
      hasUserSelected: hasUserSelected,
      isSelectedByUser: isSelectedByUser,
      text: text,
      onClick: onClick,
      isEnabled: isEnabled ?? !hasUserSelected,
      selectedColor: Colors.red,
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.hasUserSelected,
    required this.isSelectedByUser,
    required this.text,
    required this.onClick,
    required this.isEnabled,
    required this.selectedColor,
  });

  final bool hasUserSelected;
  final bool isSelectedByUser;
  final String text;
  final VoidCallback onClick;
  final bool isEnabled;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelectedByUser ? Colors.black : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: hasUserSelected ? selectedColor : Colors.grey.shade200,
        child: InkWell(
          onTap: isEnabled ? onClick : null,
          hoverColor: isEnabled ? Colors.grey.shade300 : Colors.transparent,
          child: Padding(padding: const EdgeInsets.all(12), child: Text(text)),
        ),
      ),
    );
  }
}
