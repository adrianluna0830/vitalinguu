import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vitalinguu/core/domain/models/audio_encoding.dart';

Future<String> getAudioPath({
  required Uint8List audioBytes,
  required bool persistent,
  required AudioEncoding audioEncoding,
  String? name,
}) async {
  final pathName = name ?? DateTime.now().millisecondsSinceEpoch.toString();
  Directory dir = persistent
      ? await getApplicationDocumentsDirectory()
      : await getTemporaryDirectory();
  final String filePath = p.join(
    dir.path,
    "user_audio_${pathName}${audioEncoding.extension}",
  );
  final File file = File(filePath);
  await file.writeAsBytes(audioBytes);
  return filePath;
}
