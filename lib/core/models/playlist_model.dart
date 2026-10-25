import 'package:music_player_app_ui/core/models/song_model.dart';

class PlaylistModel {
  final String id;
  final String title;
  final String artist;
  final String coverAsset;
  final List<SongModel> songs;

  const PlaylistModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverAsset,
    this.songs = const [],
  });
}
