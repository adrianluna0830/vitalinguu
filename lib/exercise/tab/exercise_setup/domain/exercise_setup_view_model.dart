import 'dart:async';

import 'package:signals/signals.dart';
import 'package:vitalinguu/core/domain/credit/credit_balance_store.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_input.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_prompt_data.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/multiple_option_models.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/fill_the_blank_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/match_elements_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/multiple_choice_list_exercise.dart';
import 'package:vitalinguu/exercise/exercise_view/presentation/exercise_widgets/select_all_that_apply_exercise.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/core/domain/localized_topic_repository.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';

class ExerciseSetupViewModel {
  final LocalizedTopicRepository _topicRepository;
  final SessionManager _sessionManager;
  final CreditBalanceStore _creditBalanceStore;

  final Signal<List<Topic>> _topics = signal([]);
  late final StreamSubscription<List<Topic>> _topicsSubscription;

  late final ReadonlySignal<List<Topic>> topics = _topics.readonly();
  ReadonlySignal<CreditBalanceState> get creditBalanceState =>
      _creditBalanceStore.creditBalanceState;

  ExerciseSetupViewModel({
    required LocalizedTopicRepository topicRepository,
    required SessionManager sessionManager,
    required CreditBalanceStore creditBalanceStore,
  }) : _topicRepository = topicRepository,
       _sessionManager = sessionManager,
       _creditBalanceStore = creditBalanceStore {
    _topicsSubscription = _topicRepository.watchTopics().listen(
      (topics) => _topics.value = topics,
    );
  }

  Future<void> registerFetchExercisesViewModel(
    ExerciseConfiguration exerciseConfiguration,
  ) => _sessionManager.registerFetchExercisesViewModel(exerciseConfiguration);

  // Future<void> registerHardcodedExerciseViewModel(
  //   ExerciseConfiguration exerciseConfiguration,
  // ) => _sessionManager.registerExerciseViewModelForCurrentLanguages(
  //   _hardcodedPresentSimpleExercises,
  //   exerciseConfiguration.cefr,
  // );

  Future<void> dispose() => _topicsSubscription.cancel();
}

// const _topicId = 'hardcoded-present-simple';
// const _topicTitle = 'Present simple';
// const _topicContent =
//     'Use the present simple for routines, habits, facts, and repeated actions. '
//     'Use -s or -es with he, she, and it, and use do or does in questions and '
//     'negative sentences.';

// List<ExerciseInput> get _hardcodedPresentSimpleExercises => [
//   DialogInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     promptConfiguration: TextOnly(),
//     exerciseTask: const ExerciseTask(
//       exerciseTask:
//           'You meet a new classmate. Ask about their daily routine and answer '
//           'their questions using the present simple.',
//     ),
//     participantNames: const ['Emma'],
//     startWithTyping: true,
//     speechSpeed: 1,
//   ),

//   MatchElementsInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exerciseTask: const ExerciseTask(
//       exerciseTask:
//           'Match each subject with the sentence ending that uses the correct '
//           'present simple form.',
//     ),
//     matches: [
//       Match(leftElement: 'I', rightElement: 'work from home on Fridays.'),
//       Match(leftElement: 'She', rightElement: 'takes the bus every morning.'),
//       Match(leftElement: 'They', rightElement: 'play soccer after school.'),
//       Match(leftElement: 'Tom', rightElement: 'watches the news at night.'),
//     ],
//   ),
//   MultipleChoiceInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exercisePromptData: const ContentBasedExerciseTask(
//       exerciseContent: ExerciseContent(
//         exerciseContent:
//             'Daniel starts work at eight o’clock every weekday. He drinks '
//             'coffee before his first meeting.',
//         exerciseContentAudio: null,
//       ),
//       exerciseTask: ExerciseTask(
//         exerciseTask:
//             'Which sentence correctly describes Daniel’s weekday routine?',
//       ),
//     ),
//     correctOption: CorrectOption(text: 'Daniel starts work at eight o’clock.'),
//     incorrectOption1: IncorrectOption(
//       text: 'Daniel start work at eight o’clock.',
//       explanation:
//           'Con “Daniel”, la forma afirmativa del verbo necesita -s: starts.',
//     ),
//     incorrectOption2: IncorrectOption(
//       text: 'Daniel starting work at eight o’clock.',
//       explanation:
//           'Esta oración necesita un verbo conjugado; “starting” no puede '
//           'funcionar solo como verbo principal.',
//     ),
//     incorrectOption3: IncorrectOption(
//       text: 'Daniel do starts work at eight o’clock.',
//       explanation: 'En una afirmación no se usa “do” antes de “starts”.',
//     ),
//   ),
//   MultipleChoiceListInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exercisePromptData: const StandaloneExerciseTask(
//       exerciseTask: ExerciseTask(
//         exerciseTask:
//             'Choose the correct present simple verb for each sentence.',
//       ),
//     ),
//     options: [
//       MultipleChoiceOptions(
//         text: 'My sister ___ breakfast at 7:00 every day.',
//         correctOption: CorrectOption(text: 'eats'),
//         incorrectOption1: IncorrectOption(
//           text: 'eat',
//           explanation: '“My sister” es tercera persona singular: eats.',
//         ),
//         incorrectOption2: IncorrectOption(
//           text: 'eating',
//           explanation: 'Se necesita el verbo conjugado “eats”.',
//         ),
//         incorrectOption3: IncorrectOption(
//           text: 'do eat',
//           explanation: 'La afirmación simple no necesita el auxiliar “do”.',
//         ),
//       ),
//       MultipleChoiceOptions(
//         text: 'They ___ English after class.',
//         correctOption: CorrectOption(text: 'study'),
//         incorrectOption1: IncorrectOption(
//           text: 'studies',
//           explanation: 'Con “they” se usa la forma base: study.',
//         ),
//         incorrectOption2: IncorrectOption(
//           text: 'studys',
//           explanation: '“Studys” no es una forma verbal correcta.',
//         ),
//         incorrectOption3: IncorrectOption(
//           text: 'does study',
//           explanation: '“Does” corresponde a he, she o it, no a “they”.',
//         ),
//       ),
//       MultipleChoiceOptions(
//         text: 'The store ___ at nine o’clock.',
//         correctOption: CorrectOption(text: 'opens'),
//         incorrectOption1: IncorrectOption(
//           text: 'open',
//           explanation: '“The store” es singular y requiere “opens”.',
//         ),
//         incorrectOption2: IncorrectOption(
//           text: 'opening',
//           explanation: 'La oración requiere el verbo conjugado “opens”.',
//         ),
//         incorrectOption3: IncorrectOption(
//           text: 'do open',
//           explanation: 'Una afirmación con sujeto singular no usa “do open”.',
//         ),
//       ),
//     ],
//   ),
//   SelectAllThatApplyInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exercisePromptData: const StandaloneExerciseTask(
//       exerciseTask: ExerciseTask(
//         exerciseTask:
//             'Select all the sentences that use the present simple correctly.',
//       ),
//     ),
//     options: [
//       SelectAllThatApplyCorrectOption(option: 'He works at a bank.'),
//       SelectAllThatApplyCorrectOption(option: 'I do not drink coffee.'),
//       SelectAllThatApplyCorrectOption(option: 'We watch movies on Fridays.'),
//       SelectAllThatApplyIncorrectOption(
//         option: 'They plays tennis after school.',
//         explanation: 'Con “they” se usa “play”, sin -s.',
//       ),
//       SelectAllThatApplyIncorrectOption(
//         option: 'Does she lives near here?',
//         explanation: 'Después de “does” se usa la forma base “live”.',
//       ),
//       SelectAllThatApplyIncorrectOption(
//         option: 'Maria don’t like cold weather.',
//         explanation: 'Con “Maria” se usa “doesn’t”, no “don’t”.',
//       ),
//     ],
//   ),
//   WordOrderingInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exerciseTask: const ExerciseTask(
//       exerciseTask: 'Put the words in order to make a present simple sentence.',
//     ),
//     wordsInOrder: const [
//       'My',
//       'brother',
//       'plays',
//       'soccer',
//       'after',
//       'school.',
//     ],
//   ),
//   WriteInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exercisePromptData: const StandaloneExerciseTask(
//       exerciseTask: ExerciseTask(
//         exerciseTask:
//             'Write five sentences about your weekday routine. Use at least '
//             'one negative sentence and one frequency adverb.',
//       ),
//     ),
//   ),
//   WriteListInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exercisePromptData: const ContentBasedExerciseTask(
//       exerciseContent: ExerciseContent(
//         exerciseContent:
//             'Sofia lives near her university. She walks to class, studies in '
//             'the library, and cooks dinner with her roommate.',
//         exerciseContentAudio: null,
//       ),
//       exerciseTask: ExerciseTask(
//         exerciseTask:
//             'Answer each request with a complete present simple sentence.',
//       ),
//     ),
//     prompts: const [
//       'Write where Sofia lives.',
//       'Describe how Sofia goes to class.',
//       'Write what she does in the library.',
//       'Write who cooks dinner with Sofia.',
//     ],
//   ),

//     FillTheBlankInput(
//     topicId: _topicId,
//     topicTitle: _topicTitle,
//     topicContent: _topicContent,
//     exerciseTask: const ExerciseTask(
//       exerciseTask:
//           'Complete the sentences with the correct present simple form of '
//           'the verbs.',
//     ),
//     fillTheBlanks: const [
//       FillTheBlank(
//         text: 'Every morning, Maya ',
//         fillTheBlankType: FillTheBlankType.visibleText,
//       ),
//       FillTheBlank(text: 'walks', fillTheBlankType: FillTheBlankType.answer),
//       FillTheBlank(text: 'walk', fillTheBlankType: FillTheBlankType.hint),
//       FillTheBlank(
//         text: ' to school and ',
//         fillTheBlankType: FillTheBlankType.visibleText,
//       ),
//       FillTheBlank(text: 'studies', fillTheBlankType: FillTheBlankType.answer),
//       FillTheBlank(text: 'study', fillTheBlankType: FillTheBlankType.hint),
//       FillTheBlank(
//         text: ' English in the afternoon.',
//         fillTheBlankType: FillTheBlankType.visibleText,
//       ),
//     ],
//   ),
// ];
