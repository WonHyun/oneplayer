import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:oneplayer/model/song.dart';

class AudioPlayerProvider extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  String _currentDirectory = "";
  double _currentPosition = 0.0;
  double _totalDuration = 0.0;
  double _volume = 0.8;
  double _beforeMuteVolume = 0.8;
  double _speed = 1.0;
  bool _isMute = false;

  String get currentDirectory => _currentDirectory;
  double get currentPosition =>
      _currentPosition > _totalDuration ? _totalDuration : _currentPosition;
  double get totalDuration => _totalDuration;
  double get volume => _volume;
  double get speed => _speed;
  bool get isMute => _isMute;

  final _playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  AudioPlayerProvider() {
    _audioPlayer = AudioPlayer();
    setLoopMode(LoopMode.all);
    _audioPlayer.positionStream.listen((position) {
      setCurrentPostition(position.inMilliseconds.toDouble());
    });
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setTotalDuration(duration.inMilliseconds.toDouble());
      }
    });
  }

  void addSong(Song song) {
    _playlist.add(AudioSource.file(
      song.filePath,
      tag: song,
    ));
    notifyListeners();
  }

  int getSongCount() {
    return _playlist.length;
  }

  Song getSongInfo(int index) {
    Song? trackInfo = _audioPlayer.audioSource?.sequence[index].tag;
    if (trackInfo != null) {
      return trackInfo;
    } else {
      return Song("");
    }
  }

  int getCurrentPlayIndex() {
    return _audioPlayer.currentIndex ?? 0;
  }

  Future<void> getAudioFilesFromDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      _currentDirectory = selectedDirectory;
      stop();
      clearPlaylist();
      final dir = Directory(selectedDirectory);

      await for (var entity in dir.list(recursive: false, followLinks: false)) {
        if (entity is File && isAudioFile(entity.path)) {
          Song song = Song(entity.path);
          song.metadata = await MetadataRetriever.fromFile(File(entity.path));
          addSong(song);
        }
      }
      await _audioPlayer.setAudioSource(_playlist);
    }
  }

  bool isAudioFile(String filePath) {
    const audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];
    String extension = filePath.split('.').last.toLowerCase();
    return audioExtensions.contains('.$extension');
  }

  void setCurrentPostition(double newPosition) {
    if (_currentPosition != newPosition) {
      _currentPosition = newPosition;
      if (_currentPosition == _totalDuration) {
        seekToNext();
      }
      notifyListeners();
    }
  }

  void setTotalDuration(double totalDuration) {
    if (_totalDuration != totalDuration) {
      _totalDuration = totalDuration;
      notifyListeners();
    }
  }

  void setPlaySong(int index) async {
    stop();
    await _audioPlayer.seek(
      Duration.zero,
      index: index,
    );
    play();
  }

  bool isPlaying() {
    return _audioPlayer.playing;
  }

  void seek(int duration) {
    _audioPlayer.seek(Duration(milliseconds: duration));
    notifyListeners();
  }

  void play() async {
    await _audioPlayer.play();
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  void stop() async {
    await _audioPlayer.stop();
    seek(0);
    notifyListeners();
  }

  void seekToPrevious() async {
    stop();
    await _audioPlayer.seekToPrevious();
    play();
    notifyListeners();
  }

  void seekToNext() async {
    stop();
    await _audioPlayer.seekToNext();
    play();
    notifyListeners();
  }

  void toggleShuffleMode() async {
    if (_audioPlayer.shuffleModeEnabled) {
      await _audioPlayer.setShuffleModeEnabled(false);
    } else {
      await _audioPlayer.setShuffleModeEnabled(true);
    }
    notifyListeners();
  }

  bool isShuffleEnabled() {
    return _audioPlayer.shuffleModeEnabled;
  }

  void setLoopMode(LoopMode mode) {
    _audioPlayer.setLoopMode(mode);
  }

  LoopMode getLoopMode() {
    return _audioPlayer.loopMode;
  }

  void setVolume(double volume) {
    _volume = volume;
    _audioPlayer.setVolume(volume);
    notifyListeners();
  }

  void toggleMute() {
    if (!isMute) {
      _beforeMuteVolume = _volume;
      _isMute = true;
      setVolume(0.0);
    } else {
      _isMute = false;
      setVolume(_beforeMuteVolume);
    }
  }

  void setSpeed(double speed) async {
    _speed = double.parse(speed.toStringAsFixed(1));
    await _audioPlayer.setSpeed(speed);
    notifyListeners();
  }

  void clearPlaylist() async {
    await _playlist.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
