import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:music_player_app_ui/core/app_data.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';

class PlayerProvider extends ChangeNotifier {
  SongModel _currentSong = AppData.miniPlayerSong;
  bool _isPlaying = true;
  int _currentIndex = 0;
  double _positionSeconds = 0;
  double _durationSeconds = 0;
  Timer? _tickTimer;

  PlayerProvider() {
    _durationSeconds = _toSeconds(_currentSong.duration).toDouble();
    _positionSeconds = _toSeconds(_currentSong.currentPosition).toDouble();
    _syncPlaybackTimer();
  }

  SongModel get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  double get progress {
    if (_durationSeconds <= 0) return 0;
    return (_positionSeconds / _durationSeconds).clamp(0.0, 1.0);
  }

  String get positionLabel => _formatTime(_positionSeconds);
  String get durationLabel => _formatTime(_durationSeconds);

  int get activeLyricIndex {
    final lyrics = _currentSong.lyrics;
    if (lyrics.isEmpty) return 0;
    final index = (progress * lyrics.length).floor();
    return index.clamp(0, lyrics.length - 1);
  }

  void play(SongModel song) {
    _applySong(song, play: true);
  }

  void setSong(SongModel song, {bool play = true}) {
    _applySong(song, play: play);
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    _syncPlaybackTimer();
    notifyListeners();
  }

  void pause() {
    if (!_isPlaying) return;
    _isPlaying = false;
    _syncPlaybackTimer();
    notifyListeners();
  }

  void resume() {
    if (_isPlaying) return;
    _isPlaying = true;
    _syncPlaybackTimer();
    notifyListeners();
  }

  void seekBy(int seconds) {
    _positionSeconds = (_positionSeconds + seconds).clamp(0.0, _durationSeconds);
    notifyListeners();
  }

  void onPageChange(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void _applySong(SongModel song, {required bool play}) {
    final songChanged = song.id != _currentSong.id;
    _currentSong = song;
    _isPlaying = play;
    if (songChanged) {
      _durationSeconds = _toSeconds(song.duration).toDouble();
      _positionSeconds = _toSeconds(song.currentPosition).toDouble();
    }
    _syncPlaybackTimer();
    notifyListeners();
  }

  void _syncPlaybackTimer() {
    if (_isPlaying) {
      _tickTimer ??= Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _onTick(),
      );
    } else {
      _tickTimer?.cancel();
      _tickTimer = null;
    }
  }

  void _onTick() {
    if (_positionSeconds >= _durationSeconds) {
      _positionSeconds = _durationSeconds;
      _isPlaying = false;
      _syncPlaybackTimer();
      notifyListeners();
      return;
    }
    _positionSeconds = (_positionSeconds + 0.25).clamp(0.0, _durationSeconds);
    notifyListeners();
  }

  String _formatTime(double totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int _toSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }
}
