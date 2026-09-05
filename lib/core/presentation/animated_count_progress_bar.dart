import 'package:flutter/material.dart';

class AnimatedCountProgressBar extends StatelessWidget {
  const AnimatedCountProgressBar({
    super.key,
    required this.totalCount,
    required this.currentCount,
  });

  final int totalCount;
  final int currentCount;

  @override
  Widget build(BuildContext context) {
    final ratio = totalCount <= 0
        ? 0.0
        : (currentCount / totalCount).clamp(0.0, 1.0);
    final progressColor = ColoredBox(
      color: Theme.of(context).colorScheme.primary,
    );

    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: Colors.grey.shade300),
            if (ratio == 0)
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0,
                child: progressColor,
              )
            else
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, child) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: child,
                ),
                child: progressColor,
              ),
          ],
        ),
      ),
    );
  }
}
