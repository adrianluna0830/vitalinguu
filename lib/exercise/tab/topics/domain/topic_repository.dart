import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';

abstract class TopicRepository {
  Future<void> putTopic(Topic topic);
  Future<void> putTopics(List<Topic> topics);
  Future<List<Topic>> getTopics(LanguageLocale language);
  Stream<List<Topic>> watchTopics(LanguageLocale language);
  Future<Topic?> getTopic(String topicId);
  Future<void> deleteTopic(String topicId);
}
