class SongModel {
  final String id;
  final String title;
  final String artist;
  final String coverAsset;
  final String duration;
  final String currentPosition;
  final List<String> lyrics;
  final bool isFavorite;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverAsset,
    this.duration = '04:36',
    this.currentPosition = '00:00',
    this.lyrics = const [],
    this.isFavorite = false,
  });
}
