import 'package:go_router/go_router.dart';
import 'package:music_player_app_ui/presentation/screens/album_screen.dart';
import 'package:music_player_app_ui/presentation/screens/home_screen.dart';
import 'package:music_player_app_ui/presentation/screens/now_playing_screen.dart';

GoRouter router = GoRouter(
  initialLocation: NamedRoutes.home.routeName,
  routes: [
    GoRoute(path: NamedRoutes.home.routeName, builder: (ctx, state)=> const HomeScreen()),
    GoRoute(path: NamedRoutes.album.routeName, builder: (ctx, state)=> const AlbumScreen()),
    GoRoute(path: NamedRoutes.nowPlaying.routeName, builder: (ctx, state)=> const NowPlayingScreen()),
  ],
);

enum NamedRoutes {
  home('/home'),
  album('/album'),
  nowPlaying('/now-playing');

  final String routeName;
  const NamedRoutes(this.routeName);
}
