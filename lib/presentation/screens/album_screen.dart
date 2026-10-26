import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_colors.dart';
import 'package:music_player_app_ui/core/app_data.dart';
import 'package:music_player_app_ui/core/app_textstyles.dart';
import 'package:music_player_app_ui/core/asset_res.dart';
import 'package:music_player_app_ui/core/models/playlist_model.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';
import 'package:music_player_app_ui/presentation/providers/player_provider.dart';
import 'package:music_player_app_ui/presentation/widgets/app_screen_header.dart';
import 'package:music_player_app_ui/presentation/widgets/play_pause_button.dart';
import 'package:music_player_app_ui/presentation/widgets/section_header.dart';
import 'package:music_player_app_ui/routing/router.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatelessWidget {
  final PlaylistModel album;

  const AlbumScreen({super.key, required this.album});

  List<SongModel> get _songs => album.songs.isNotEmpty ? album.songs : AppData.albumSongs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: NumberConstant.horizontalPadding),
          child: Column(
            spacing: NumberConstant.sectionGap,
            children: [
              AppScreenHeader(
                title: StringConst.album,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: NumberConstant.sectionGap,
                    children: [
                      _buildAlbumHero(),
                      _buildActionRow(),
                      _buildSongList(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumHero() {
    return Column(
      spacing: NumberConstant.sectionGap,
      children: [
        SizedBox(
          width: NumberConstant.albumCoverWidth + NumberConstant.albumVinylOffset,
          height: NumberConstant.albumCoverHeight,
          child: Stack(
            alignment: .centerLeft,
            children: [
              Positioned(
                right: 0,
                child: Consumer<PlayerProvider>(
                  builder: (context, player, _) => _RotatingVinyl(
                    isPlaying: player.isPlaying,
                  ),
                ),
              ),
              Hero(
                tag: 'album-${album.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: NumberConstant.albumCoverWidth,
                    height: NumberConstant.albumCoverHeight,
                    decoration: BoxDecoration(
                      borderRadius: .circular(NumberConstant.albumCoverRadius),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66FF6594),
                          offset: Offset(0, 4),
                          blurRadius: 24,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(album.coverAsset),
                        fit: .cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          spacing: NumberConstant.tinyGap,
          children: [
            Text(album.title, style: AppTextStyles.songTitle, textAlign: .center),
            Text(album.artist, style: AppTextStyles.songArtist, textAlign: .center),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: .center,
      spacing: NumberConstant.albumActionGap,
      children: [
        _PressableScale(
          onTap: () {},
          child: _buildRoundAction(
            child: SvgPicture.asset(
              AssetRes.icShare,
              width: NumberConstant.albumShareIconSize,
              height: NumberConstant.albumShareIconSize,
              colorFilter: .mode(AppColors.primary, .srcIn),
            ),
          ),
        ),
        Expanded(
          child: _PressableScale(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: .circular(NumberConstant.categoryChipRadius),
              ),
              padding: .symmetric(
                horizontal: NumberConstant.albumActionPaddingH,
                vertical: NumberConstant.albumActionPaddingV,
              ),
              child: Row(
                mainAxisAlignment: .center,
                spacing: NumberConstant.albumSubscribeIconGap,
                children: [
                  SvgPicture.asset(
                    AssetRes.icSubscribeBookmark,
                    width: NumberConstant.albumSubscribeIconSize,
                    height: NumberConstant.albumSubscribeIconSize,
                    colorFilter: .mode(AppColors.white, .srcIn),
                  ),
                  Text(StringConst.subscribe, style: AppTextStyles.subscribe),
                ],
              ),
            ),
          ),
        ),
        _PressableScale(
          onTap: () {},
          child: _buildRoundAction(
            child: SvgPicture.asset(
              AssetRes.icDownload,
              width: NumberConstant.albumDownloadIconSize,
              height: NumberConstant.albumDownloadIconSize,
              colorFilter: .mode(AppColors.primary, .srcIn),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundAction({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: .circle,
      ),
      padding: .symmetric(
        horizontal: NumberConstant.albumActionPaddingH,
        vertical: NumberConstant.albumActionPaddingV,
      ),
      child: child,
    );
  }

  Widget _buildSongList(BuildContext context) {
    return Column(
      spacing: NumberConstant.sectionGap,
      crossAxisAlignment: .start,
      children: [
        const SectionHeader(title: StringConst.songList, showSeeMore: false),
        Consumer<PlayerProvider>(
          builder: (ctx, player, _) => Column(
            spacing: NumberConstant.songListGap,
            children: [
              for (var i = 0; i < _songs.length; i++)
                _buildStaggeredEntrance(
                  index: i,
                  child: _buildSongTile(
                    song: _songs[i],
                    isCurrent: player.currentSong.id == _songs[i].id,
                    isPlaying: player.isPlaying && player.currentSong.id == _songs[i].id,
                    onPlayTap: () {
                      if (player.currentSong.id == _songs[i].id) {
                        player.togglePlayPause();
                      } else {
                        player.play(_songs[i]);
                      }
                    },
                    onTap: () {
                      player.play(_songs[i]);
                      context.push(NamedRoutes.nowPlaying.routeName);
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaggeredEntrance({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(
        milliseconds: NumberConstant.animNormal + (index * NumberConstant.animStaggerMs),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, NumberConstant.animEntranceOffset * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSongTile({
    required SongModel song,
    required bool isCurrent,
    required bool isPlaying,
    required VoidCallback onPlayTap,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: NumberConstant.animFast),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.white,
          borderRadius: .circular(NumberConstant.songListItemRadius),
          border: Border.all(
            color: isCurrent
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            width: NumberConstant.albumPlayingTileBorderWidth,
          ),
        ),
        padding: .all(NumberConstant.songListItemPadding),
        child: Row(
          spacing: NumberConstant.contentGap,
          children: [
            Hero(
              tag: 'cover-${song.id}',
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: .circular(NumberConstant.songThumbRadius),
                  child: Image.asset(
                    song.coverAsset,
                    width: NumberConstant.songThumbSize,
                    height: NumberConstant.songThumbSize,
                    fit: .cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: NumberConstant.tinyGap,
                children: [
                  Text(
                    song.title,
                    style: AppTextStyles.songListTitle,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: AppTextStyles.songListSubtitle,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: .center,
              children: [
                SvgPicture.asset(
                  AssetRes.icFavorite,
                  width: NumberConstant.songActionIconSize,
                  height: NumberConstant.songActionIconSize,
                  colorFilter: .mode(
                    song.isFavorite
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                    .srcIn,
                  ),
                ),
                PlayPauseButton(
                  isPlaying: isPlaying,
                  onTap: onPlayTap,
                  size: isPlaying
                      ? NumberConstant.playIconSize
                      : NumberConstant.nowPlayingPlaySize,
                  useNowPlayingAsset: !isPlaying,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RotatingVinyl extends StatefulWidget {
  final bool isPlaying;

  const _RotatingVinyl({required this.isPlaying});

  @override
  State<_RotatingVinyl> createState() => _RotatingVinylState();
}

class _RotatingVinylState extends State<_RotatingVinyl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: NumberConstant.vinylRotationSeconds),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _RotatingVinyl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying == oldWidget.isPlaying) return;
    if (widget.isPlaying) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(
        AssetRes.icVinyl,
        width: NumberConstant.albumVinylSize,
        height: NumberConstant.albumVinylSize,
      ),
    );
  }
}

class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableScale({
    required this.child,
    required this.onTap,
  });

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? NumberConstant.controlPressScale : 1,
        duration: const Duration(milliseconds: NumberConstant.animFast),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
