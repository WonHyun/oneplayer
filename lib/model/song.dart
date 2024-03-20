import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as p;

class Song {
  String filePath;
  late String fileName;
  late String extension;
  bool favorite = false;
  Metadata? metadata;

  Song(this.filePath) {
    fileName = p.basenameWithoutExtension(filePath);
    extension = p.extension(filePath);
  }

  void setAudioMetadata(Metadata metadata) {
    this.metadata = metadata;
  }
}
