import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment.dart';

abstract class TopicAssessmentRepository {
  Future<void> putAssessment(TopicAssessment assessment);

  Future<List<TopicAssessment>> getAssessments(String topicId);

  Future<void> deleteAssessmentsForTopic(String topicId);
}
