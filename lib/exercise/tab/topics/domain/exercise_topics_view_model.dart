import 'dart:async';

import 'package:signals/signals.dart';
import 'package:vitalinguu/core/domain/localized_topic_repository.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';

class ExerciseTopicsViewModel {
  final LocalizedTopicRepository _topicRepository;

  final Signal<List<Topic>> _topics = signal([]);
  late final StreamSubscription<List<Topic>> _topicsSubscription;

  late final ReadonlySignal<List<Topic>> topics = _topics.readonly();

  ExerciseTopicsViewModel({required LocalizedTopicRepository topicRepository})
    : _topicRepository = topicRepository {
    _topicsSubscription = _topicRepository.watchTopics().listen(
      (topics) => _topics.value = topics,
    );
  }

  Future<void> addTopic(TopicInput topic) => _topicRepository.putTopic(topic);

  Future<void> addTopics(List<TopicInput> topics) => _topicRepository.putTopics(topics);

  Future<void> updateTopic(String topicId, TopicInput update) =>
      _topicRepository.updateTopic(topicId, update);

  Future<void> dispose() => _topicsSubscription.cancel();

  Future<void> deleteTopics(List<String> topicIds) =>
      _topicRepository.deleteTopics(topicIds);
}
