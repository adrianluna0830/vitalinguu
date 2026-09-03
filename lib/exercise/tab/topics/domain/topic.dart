import 'package:vitalinguu/core/domain/models/language_locale.dart';

class Topic {
  final String title;
  final String content;
  final LanguageLocale language;
  final String id;

  Topic({
    required String title,
    required String content,
    required this.language,
    required this.id,
  }) : title = title.trim(),
       content = content.trim() {
    if (this.title.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Must not be empty.');
    }
    if (this.content.isEmpty) {
      throw ArgumentError.value(content, 'content', 'Must not be empty.');
    }
  }

  Topic copyWith({String? title, String? content}) {
    return Topic(
      title: title ?? this.title,
      content: content ?? this.content,
      language: language,
      id: id,
    );
  }
}
