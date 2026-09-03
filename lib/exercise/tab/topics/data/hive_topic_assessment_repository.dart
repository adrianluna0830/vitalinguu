import 'package:hive_ce/hive_ce.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment_repository.dart';

final class HiveTopicAssessmentRepository implements TopicAssessmentRepository {
  static const boxName = 'topic_assessments';

  final Box<TopicAssessment> _box;

  HiveTopicAssessmentRepository._(this._box);

  static Future<HiveTopicAssessmentRepository> open() async {
    final box = await Hive.openBox<TopicAssessment>(boxName);
    return HiveTopicAssessmentRepository._(box);
  }

  @override
  Future<void> putAssessment(TopicAssessment assessment) async {
    await _box.add(assessment);
  }

  @override
  Future<List<TopicAssessment>> getAssessments(String topicId) async {
    return _box.values
        .where((assessment) => assessment.topicId == topicId)
        .toList(growable: false);
  }

  @override
  Future<void> deleteAssessmentsForTopic(String topicId) {
    final assessmentKeys = _box.keys
        .where((key) => _box.get(key)?.topicId == topicId)
        .toList(growable: false);
    return _box.deleteAll(assessmentKeys);
  }
}
