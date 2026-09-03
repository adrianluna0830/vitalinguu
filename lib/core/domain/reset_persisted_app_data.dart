import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vitalinguu/exercise/tab/topics/data/hive_topic_assessment_repository.dart';
import 'package:vitalinguu/exercise/tab/topics/data/hive_topic_repository.dart';

Future<void> resetPersistedAppData() async {
  await const FlutterSecureStorage().deleteAll();

  await Hive.initFlutter();
  await Future.wait([
    Hive.deleteBoxFromDisk(HiveTopicRepository.boxName),
    Hive.deleteBoxFromDisk(HiveTopicAssessmentRepository.boxName),
  ]);
}
