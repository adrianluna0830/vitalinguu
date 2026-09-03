sealed class AnswerResult {}

class CorrectAnswerResult extends AnswerResult {}

class IncorrectAnswerResult extends AnswerResult {
  final String explanation;
  IncorrectAnswerResult(this.explanation);
}

class PartiallyCorrectAnswerResult extends AnswerResult {
  final String explanation;
  PartiallyCorrectAnswerResult(this.explanation);
}

sealed class BinaryAnswerResult {}

class CorrectBinaryAnswerResult extends BinaryAnswerResult {}

class IncorrectBinaryAnswerResult extends BinaryAnswerResult {
  final String explanation;
  IncorrectBinaryAnswerResult(this.explanation);
}
