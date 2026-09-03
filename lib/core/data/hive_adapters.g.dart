// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final typeId = 0;

  @override
  Topic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Topic(
      title: fields[0] as String,
      content: fields[1] as String,
      language: fields[2] as LanguageLocale,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicAssessmentAdapter extends TypeAdapter<TopicAssessment> {
  @override
  final typeId = 1;

  @override
  TopicAssessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopicAssessment(
      topicId: fields[0] as String,
      timestamp: fields[1] as DateTime,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TopicAssessment obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.topicId)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageLocaleAdapter extends TypeAdapter<LanguageLocale> {
  @override
  final typeId = 2;

  @override
  LanguageLocale read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LanguageLocale.en;
      case 1:
        return LanguageLocale.es;
      case 2:
        return LanguageLocale.de;
      case 3:
        return LanguageLocale.pt;
      case 4:
        return LanguageLocale.fr;
      case 5:
        return LanguageLocale.it;
      default:
        return LanguageLocale.en;
    }
  }

  @override
  void write(BinaryWriter writer, LanguageLocale obj) {
    switch (obj) {
      case LanguageLocale.en:
        writer.writeByte(0);
      case LanguageLocale.es:
        writer.writeByte(1);
      case LanguageLocale.de:
        writer.writeByte(2);
      case LanguageLocale.pt:
        writer.writeByte(3);
      case LanguageLocale.fr:
        writer.writeByte(4);
      case LanguageLocale.it:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageLocaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
