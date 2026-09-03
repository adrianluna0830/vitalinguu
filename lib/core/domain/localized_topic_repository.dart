import 'package:uuid/uuid.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_input.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_repository.dart';

class LocalizedTopicRepository {
  static const Uuid _uuid = Uuid();

  final TopicRepository topicRepository;
  final LanguageLocale language;

  const LocalizedTopicRepository({
    required this.topicRepository,
    required this.language,
  });

  Future<void> putTopic(TopicInput topic) =>
      topicRepository.putTopic(_createTopic(topic));

  Future<void> putTopics(List<TopicInput> topics) {
    return topicRepository.putTopics(
      topics.map(_createTopic).toList(growable: false),
    );
  }

  Future<void> updateTopic(String topicId, TopicInput update) async {
    final topic = await topicRepository.getTopic(topicId);
    if (topic == null) {
      throw StateError('No existe el topic $topicId.');
    }

    await topicRepository.putTopic(
      topic.copyWith(title: update.title, content: update.content),
    );
  }

  Future<List<Topic>> getTopics() => topicRepository.getTopics(language);

  Stream<List<Topic>> watchTopics() => topicRepository.watchTopics(language);

  Future<Topic?> getTopic(String topicId) => topicRepository.getTopic(topicId);

  Future<void> deleteTopics(List<String> topicIds) async {
    await Future.wait(topicIds.map(topicRepository.deleteTopic));
  }

  Topic _createTopic(TopicInput topic) {
    return Topic(
      title: topic.title,
      content: topic.content,
      language: language,
      id: _uuid.v4(),
    );
  }
}
