import 'dart:typed_data';

class AudioMetadata {
  String? trackName;
  List<String>? trackArtistNames;
  String? albumName;
  String? albumArtistName;
  int? trackNumber;
  int? albumLength;
  int? year;
  String? genre;
  String? authorName;
  String? writerName;
  int? discNumber;
  String? mimeType;
  int? trackDuration;
  int? bitrate;
  late Uint8List? albumArt;
}
