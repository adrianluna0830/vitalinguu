typedef TranslateText = Future<void> Function(String key, String text);

sealed class TranslationState {
  const TranslationState();
}

class TranslationLoading extends TranslationState {
  const TranslationLoading();
}

class TranslationSuccess extends TranslationState {
  final String translation;

  const TranslationSuccess(this.translation);
}

class TranslationFailure extends TranslationState {
  final Object error;

  const TranslationFailure(this.error);
}
