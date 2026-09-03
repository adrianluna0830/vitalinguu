import 'dart:async';
import 'dart:convert';

import 'package:signals/signals_core.dart';
import 'package:vitalinguu/core/domain/ai_error_retry_mixin.dart';
import 'package:vitalinguu/core/domain/interfaces/i_ai.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/exercise/exercise_view/domain/exercise_view_model.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment_repository.dart';

const _topicsFeedbackSystemInstruction =
    'You are a language-learning specialist who identifies useful pedagogical '
    'patterns from completed practice. Return only concise plain-text notes in '
    'English, without JSON, headings, or meta-commentary.';

class FetchTopicsFeedbackViewModel with AIErrorRetryMixin {
  final IAI _ai;
  final Map<TopicData, List<String>> _answersByTopic;
  final TopicAssessmentRepository _topicAssessmentRepository;
  final LanguageLocale _learningLanguage;
  final CEFR _level;
  final StreamController<void> _feedbackFetchedController =
      StreamController<void>.broadcast();

  FetchTopicsFeedbackViewModel({
    required IAI ai,
    required Map<TopicData, List<String>> answersByTopic,
    required TopicAssessmentRepository topicAssessmentRepository,
    required LanguageLocale learningLanguage,
    required CEFR level,
  }) : _ai = ai,
       _answersByTopic = answersByTopic,
       _topicAssessmentRepository = topicAssessmentRepository,
       _learningLanguage = learningLanguage,
       _level = level;

  int get feedbackCount => _answersByTopic.length;

  final _feedbackFetchCountSignal = signal(0);
  ReadonlySignal<int> get feedbackFetchCount =>
      _feedbackFetchCountSignal.readonly();

  Stream<void> get feedbackFetched => _feedbackFetchedController.stream;

  Future<void> fetchFeedback() async {
    _feedbackFetchCountSignal.value = 0;
    try {
      for (final entry in _answersByTopic.entries) {
        String? notes;
        if (entry.value.isNotEmpty) {
          final generatedResult = await generateResponse(
            _ai,
            _buildTopicFeedbackPrompt(
              topicData: entry.key,
              learnerPerformanceNotes: entry.value,
              learningLanguage: _learningLanguage,
              level: _level,
            ),
            _topicsFeedbackSystemInstruction,
          );
          notes = generatedResult.when(
            first: (value) => value.trim(),
            second: (stopExecution) => throw stopExecution,
          );
        }

        await _topicAssessmentRepository.putAssessment(
          TopicAssessment(
            topicId: entry.key.topicId,
            timestamp: DateTime.now(),
            notes: notes,
          ),
        );
        _feedbackFetchCountSignal.value++;
      }

      _feedbackFetchedController.add(null);
    } on StopExecution {
      return;
    }
  }
}

String _buildTopicFeedbackPrompt({
  required TopicData topicData,
  required List<String> learnerPerformanceNotes,
  required LanguageLocale learningLanguage,
  required CEFR level,
}) {
  return '''
Generate pedagogical notes for one practiced language-learning topic.

Topic ID: ${jsonEncode(topicData.topicId)}
Topic title: ${jsonEncode(topicData.topicTitle)}
Topic content and learning objective: ${jsonEncode(topicData.topicContent)}
Learning language: ${learningLanguage.fullName} (${learningLanguage.bcp47})
CEFR level: ${level.name.toUpperCase()}
Learner performance evidence from incorrect, partial, or interrupted exercises:
${jsonEncode(learnerPerformanceNotes)}

Write the notes entirely in English, regardless of the learning language. You
may include short corrections or examples in
${learningLanguage.fullName} when pedagogically useful, but explain them in
English.

Return one non-empty plain-text string of notes. Synthesize the underlying
skills, recurring patterns, or task types that the learner should reinforce.
Use the topic objective and the ${level.name.toUpperCase()} expectations to
prioritize what matters. Avoid overly specific references to isolated exercise
numbers, individual blanks, option positions, or incidental wording. Generalize
carefully without claiming that a pattern is recurring when the evidence does
not support that claim. Do not invent mistakes, successes, attempts, or scores.
Explain what to improve, why it matters, and a practical way to practice it.
''';
}
