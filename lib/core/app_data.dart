import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/asset_res.dart';
import 'package:music_player_app_ui/core/models/category_model.dart';
import 'package:music_player_app_ui/core/models/playlist_model.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';

class AppData {
  static const albumSongs = [
    SongModel(
      id: 'al_1',
      title: 'Wake Your Mind',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.songThumbWakeYourMind,
      isFavorite: true,
    ),
    SongModel(
      id: 'al_2',
      title: 'This Must be heaven',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.songThumbHeaven,
    ),
    SongModel(
      id: 'al_3',
      title: 'Honesty Pays',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.songThumbHonesty,
    ),
  ];

  static const recentlyPlayed = [
    SongModel(
      id: 'rp_1',
      title: 'Wake Your Mind',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.wakeYourMindBanner,
    ),
    SongModel(
      id: 'rp_2',
      title: 'In Every Way',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.inEveryWayBanner,
    ),
    SongModel(
      id: 'rp_3',
      title: 'Hello Summer',
      artist: 'Mind fresh piano',
      coverAsset: AssetRes.helloSummerBanner,
    ),
  ];

  static const popularPlaylists = [
    PlaylistModel(
      id: 'pl_1',
      title: 'Across The Sky',
      artist: 'David Ruthle',
      coverAsset: AssetRes.playlistAcrossTheSky,
      songs: albumSongs,
    ),
    PlaylistModel(
      id: 'pl_2',
      title: 'Cruel Summer',
      artist: 'Jazz Day Internation',
      coverAsset: AssetRes.playlistCruelSummer,
    ),
    PlaylistModel(
      id: 'pl_3',
      title: 'At All Costs',
      artist: 'Taylor Swift',
      coverAsset: AssetRes.playlistAtAllCosts,
    ),
  ];

  static const categories = [
    CategoryModel(
      label: StringConst.categoryMusic,
      iconAsset: AssetRes.icCategoryMusic,
      isSelected: true,
    ),
    CategoryModel(
      label: StringConst.categoryPodcast,
      iconAsset: AssetRes.icCategoryPodcast,
    ),
    CategoryModel(
      label: StringConst.categoryMovie,
      iconAsset: AssetRes.icCategoryMovie,
    ),
    CategoryModel(
      label: StringConst.categorySinger,
      iconAsset: AssetRes.icCategorySinger,
    ),
  ];

  static const featuredAlbum = PlaylistModel(
    id: 'album_1',
    title: 'Across The Sky',
    artist: 'Ted Sheeran',
    coverAsset: AssetRes.playlistAcrossTheSky,
    songs: albumSongs,
  );

  static const nowPlayingSong = SongModel(
    id: 'np_1',
    title: 'Thinking out Loud',
    artist: 'Across The Sky',
    coverAsset: AssetRes.nowPlayingCover,
    duration: '04:36',
    currentPosition: '03:24',
    lyrics: [
      'Take me into your loving arms',
      'Kiss me under the light of a thousand stars',
      'Place your head on my beating heart',
    ],
    isFavorite: true,
  );

  static const miniPlayerSong = SongModel(
    id: 'mp_1',
    title: 'Wake Your Mind',
    artist: 'Mind fresh piano',
    coverAsset: AssetRes.songThumbWakeYourMind,
  );
}
