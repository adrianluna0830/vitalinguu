import 'package:hive_ce/hive_ce.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/topic_assessment.dart';

@GenerateAdapters([
  AdapterSpec<Topic>(),
  AdapterSpec<TopicAssessment>(),
  AdapterSpec<LanguageLocale>(),
])
part 'hive_adapters.g.dart';
