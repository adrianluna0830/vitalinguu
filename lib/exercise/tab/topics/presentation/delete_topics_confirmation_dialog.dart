import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class DeleteTopicsConfirmationDialog extends StatelessWidget {
  const DeleteTopicsConfirmationDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(context.t.topics.deleteConfirmation),
      actions: [
        TextButton(onPressed: onCancel, child: Text(context.t.common.cancel)),
        TextButton(onPressed: onConfirm, child: Text(context.t.common.confirm)),
      ],
    );
  }
}
