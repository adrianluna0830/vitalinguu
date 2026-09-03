import 'package:flutter/material.dart';

class BooleanCircleIndicator extends StatelessWidget {
  const BooleanCircleIndicator({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: value
          ? const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            )
          : null,
    );
  }
}
