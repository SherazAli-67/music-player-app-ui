import 'package:flutter/foundation.dart';
import 'package:music_player_app_ui/core/app_data.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';

class PlayerProvider extends ChangeNotifier {
  SongModel _currentSong = AppData.miniPlayerSong;
  bool _isPlaying = true;
  int _currentIndex = 0;

  SongModel get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;


  void play(SongModel song) {
    _currentSong = song;
    _isPlaying = true;
    notifyListeners();
  }

  void setSong(SongModel song, {bool play = true}) {
    _currentSong = song;
    _isPlaying = play;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void pause() {
    if (!_isPlaying) return;
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();
  }

  void onPageChange(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
