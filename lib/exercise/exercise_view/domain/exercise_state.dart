import 'package:vitalinguu/exercise/exercise_view/domain/answer_result.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_input.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/translation_state.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/dialog_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';

sealed class ExerciseState<T extends ExerciseInput> {
  final T input;
  final int currentIndex;
  final Map<String, TranslationState> translations;

  int get exerciseNumber => currentIndex + 1;
  String get exerciseTopicName => input.topicTitle;

  ExerciseState({
    required this.input,
    required this.currentIndex,
    this.translations = const {},
  });
}

class DialogExerciseState extends ExerciseState<DialogInput> {
  final bool isTyping;
  final List<DialogMessage> messages;

  DialogExerciseState({
    required super.currentIndex,
    required super.input,
    super.translations,
    required this.isTyping,
    required this.messages,
  });

  DialogExerciseState copyWith({
    bool? isTyping,
    List<DialogMessage>? messages,
    Map<String, TranslationState>? translations,
  }) {
    return DialogExerciseState(
      currentIndex: currentIndex,
      input: input,
      translations: translations ?? this.translations,
      isTyping: isTyping ?? this.isTyping,
      messages: messages ?? this.messages,
    );
  }
}

class FillTheBlankExerciseState extends ExerciseState<FillTheBlankInput> {
  final List<BinaryAnswerResult>? answerResult;

  FillTheBlankExerciseState({
    required super.input,
    this.answerResult,
    required super.currentIndex,
    super.translations,
  });

  FillTheBlankExerciseState copyWith({
    List<BinaryAnswerResult>? answerResult,
    Map<String, TranslationState>? translations,
  }) {
    return FillTheBlankExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}

class MatchElementsExerciseState extends ExerciseState<MatchElementsInput> {
  final List<MatchFeedback>? answerResult;

  MatchElementsExerciseState({
    required super.input,
    this.answerResult,
    required super.currentIndex,
    super.translations,
  });

  MatchElementsExerciseState copyWith({
    List<MatchFeedback>? answerResult,
    Map<String, TranslationState>? translations,
  }) {
    return MatchElementsExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}

class MultipleChoiceExerciseState extends ExerciseState<MultipleChoiceInput> {
  MultipleChoiceExerciseState({
    required super.input,
    required super.currentIndex,
    super.translations,
  });

  MultipleChoiceExerciseState copyWith({
    Map<String, TranslationState>? translations,
  }) {
    return MultipleChoiceExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
    );
  }
}

class MultipleChoiceListExerciseState
    extends ExerciseState<MultipleChoiceListInput> {
  MultipleChoiceListExerciseState({
    required super.input,
    required super.currentIndex,
    super.translations,
  });

  MultipleChoiceListExerciseState copyWith({
    Map<String, TranslationState>? translations,
  }) {
    return MultipleChoiceListExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
    );
  }
}

class SelectAllThatApplyExerciseState
    extends ExerciseState<SelectAllThatApplyInput> {
  SelectAllThatApplyExerciseState({
    required super.input,
    required super.currentIndex,
    super.translations,
  });

  SelectAllThatApplyExerciseState copyWith({
    Map<String, TranslationState>? translations,
  }) {
    return SelectAllThatApplyExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
    );
  }
}

class WriteListExerciseState extends ExerciseState<WriteListInput> {
  final List<AnswerResult>? answerResult;

  WriteListExerciseState({
    required super.input,
    this.answerResult,
    required super.currentIndex,
    super.translations,
  });

  WriteListExerciseState copyWith({
    List<AnswerResult>? answerResult,
    Map<String, TranslationState>? translations,
  }) {
    return WriteListExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}

class WordOrderingExerciseState extends ExerciseState<WordOrderingInput> {
  final BinaryAnswerResult? answerResult;

  WordOrderingExerciseState({
    required super.input,
    this.answerResult,
    required super.currentIndex,
    super.translations,
  });

  WordOrderingExerciseState copyWith({
    BinaryAnswerResult? answerResult,
    Map<String, TranslationState>? translations,
  }) {
    return WordOrderingExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}

class WriteExerciseState extends ExerciseState<WriteInput> {
  final AnswerResult? answerResult;

  WriteExerciseState({
    required super.input,
    this.answerResult,
    required super.currentIndex,
    super.translations,
  });

  WriteExerciseState copyWith({
    AnswerResult? answerResult,
    Map<String, TranslationState>? translations,
  }) {
    return WriteExerciseState(
      input: input,
      currentIndex: currentIndex,
      translations: translations ?? this.translations,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}
