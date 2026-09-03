import 'package:hive_ce/hive_ce.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_repository.dart';

final class HiveTopicRepository implements TopicRepository {
  static const boxName = 'topics';

  final Box<Topic> _box;

  HiveTopicRepository._(this._box);

  static Future<HiveTopicRepository> open() async {
    final box = await Hive.openBox<Topic>(boxName);
    return HiveTopicRepository._(box);
  }

  @override
  Future<void> putTopic(Topic topic) {
    return _box.put(topic.id, topic);
  }

  @override
  Future<void> putTopics(List<Topic> topics) {
    return _box.putAll({for (final topic in topics) topic.id: topic});
  }

  @override
  Future<List<Topic>> getTopics(LanguageLocale language) async {
    return _topicsByLanguage(language);
  }

  @override
  Stream<List<Topic>> watchTopics(LanguageLocale language) async* {
    yield _topicsByLanguage(language);

    await for (final _ in _box.watch()) {
      yield _topicsByLanguage(language);
    }
  }

  @override
  Future<Topic?> getTopic(String topicId) async {
    return _box.get(topicId);
  }

  @override
  Future<void> deleteTopic(String topicId) {
    return _box.delete(topicId);
  }

  List<Topic> _topicsByLanguage(LanguageLocale language) {
    return _box.values
        .where((topic) => topic.language == language)
        .toList(growable: false);
  }
}
