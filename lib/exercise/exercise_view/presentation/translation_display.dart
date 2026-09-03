import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';

class TranslationDisplay extends StatelessWidget {
  final TranslationState? translationState;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslationDisplay({
    super.key,
    required this.translationState,
    this.textAlign = TextAlign.center,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    switch (translationState) {
      case TranslationSuccess(:final translation):
        return Text(
          translation,
          textAlign: textAlign,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        );
      case TranslationFailure():
        return const SizedBox.shrink();
      case TranslationLoading() || null:
        break;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final loadingAlignment = switch (textAlign) {
      TextAlign.left => Alignment.centerLeft,
      TextAlign.right => Alignment.centerRight,
      TextAlign.start => AlignmentDirectional.centerStart,
      TextAlign.end => AlignmentDirectional.centerEnd,
      TextAlign.center || TextAlign.justify => Alignment.center,
    };
    return Align(
      alignment: loadingAlignment,
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
        highlightColor: isDarkMode
            ? Colors.grey.shade500
            : Colors.grey.shade200,
        child: SizedBox(
          width: 160,
          height: 16,
          child: Center(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
