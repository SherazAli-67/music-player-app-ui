import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_colors.dart';
import 'package:music_player_app_ui/core/app_textstyles.dart';
import 'package:music_player_app_ui/core/asset_res.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';
import 'package:music_player_app_ui/presentation/providers/player_provider.dart';
import 'package:music_player_app_ui/presentation/widgets/app_screen_header.dart';
import 'package:music_player_app_ui/presentation/widgets/play_pause_button.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Consumer<PlayerProvider>(
        builder: (ctx, player, _) {
          final song = player.currentSong;
          return Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: .symmetric(horizontal: NumberConstant.horizontalPadding),
                    child: Column(
                      spacing: NumberConstant.sectionGap,
                      children: [
                        AppScreenHeader(
                          title: StringConst.nowPlaying,
                          onBack: () => context.pop(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: NumberConstant.sectionGap,
                              children: [
                                _buildCover(song, player.isPlaying),
                                _buildSongInfo(song),
                                _buildLyrics(song, player.activeLyricIndex),
                                _buildProgress(player),
                                _buildControls(player),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomActions(song),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCover(SongModel song, bool isPlaying) {
    return AnimatedScale(
      scale: isPlaying ? NumberConstant.coverPlayingScale : NumberConstant.coverPausedScale,
      duration: const Duration(milliseconds: NumberConstant.animNormal),
      curve: Curves.easeOutCubic,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: NumberConstant.animNormal),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: Hero(
          key: ValueKey('now-playing-cover-${song.id}'),
          tag: 'cover-${song.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: NumberConstant.nowPlayingCoverHeight,
              decoration: BoxDecoration(
                borderRadius: .circular(NumberConstant.nowPlayingCoverRadius),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4DFF5D37),
                    offset: const Offset(0, NumberConstant.coverShadowY),
                    blurRadius: NumberConstant.coverShadowBlur,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(song.coverAsset),
                  fit: .cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: NumberConstant.animNormal),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(song.id),
        spacing: NumberConstant.tinyGap,
        children: [
          Text(song.title, style: AppTextStyles.songTitle, textAlign: .center),
          Text(song.artist, style: AppTextStyles.songArtist, textAlign: .center),
        ],
      ),
    );
  }

  Widget _buildLyrics(SongModel song, int activeIndex) {
    if (song.lyrics.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lyricsBox,
        borderRadius: .circular(NumberConstant.lyricsBoxRadius),
      ),
      padding: .symmetric(
        horizontal: NumberConstant.lyricsPaddingH,
        vertical: NumberConstant.lyricsPaddingV,
      ),
      child: Column(
        spacing: NumberConstant.lyricsLineGap,
        children: [
          for (var i = 0; i < song.lyrics.length; i++)
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: NumberConstant.animFast),
              curve: Curves.easeOutCubic,
              style: i == activeIndex ? AppTextStyles.lyricsActive : AppTextStyles.lyricsInactive,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: NumberConstant.animFast),
                opacity: i == activeIndex ? 1 : 0.55,
                child: Text(song.lyrics[i], textAlign: .center),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgress(PlayerProvider player) {
    return Column(
      spacing: NumberConstant.smallGap,
      children: [
        ClipRRect(
          borderRadius: .circular(NumberConstant.progressActiveHeight),
          child: LinearProgressIndicator(
            value: player.progress,
            minHeight: NumberConstant.progressActiveHeight,
            backgroundColor: AppColors.primary60.withValues(alpha: 0.25),
            color: AppColors.primary,
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(player.positionLabel, style: AppTextStyles.timeLabel),
            Text(player.durationLabel, style: AppTextStyles.timeLabel),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(PlayerProvider player) {
    return Row(
      mainAxisAlignment: .center,
      spacing: NumberConstant.nowPlayingControlsGap,
      children: [
        Row(
          spacing: NumberConstant.nowPlayingSideControlsGap,
          children: [
            _PressableControlIcon(
              asset: AssetRes.icPrevMusic,
              size: NumberConstant.skipIconSize,
              onTap: () {},
            ),
            _PressableControlIcon(
              asset: AssetRes.icPrev15s,
              size: NumberConstant.seekIconSize,
              color: AppColors.primary60,
              onTap: () => player.seekBy(-NumberConstant.seekStepSeconds),
            ),
          ],
        ),
        PlayPauseButton(
          isPlaying: player.isPlaying,
          onTap: player.togglePlayPause,
          size: NumberConstant.nowPlayingPlaySize,
          useNowPlayingAsset: true,
        ),
        Row(
          spacing: NumberConstant.nowPlayingSideControlsGap,
          children: [
            _PressableControlIcon(
              asset: AssetRes.icNext15s,
              size: NumberConstant.seekIconSize,
              color: AppColors.primary60,
              onTap: () => player.seekBy(NumberConstant.seekStepSeconds),
            ),
            _PressableControlIcon(
              asset: AssetRes.icNextMusic,
              size: NumberConstant.skipIconSize,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions(SongModel song) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: NumberConstant.animSlow),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, NumberConstant.animEntranceOffset * (1 - value)),
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: NumberConstant.bottomActionBarHeight,
        width: double.infinity,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(AssetRes.icBottomCurve, fit: .fill),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: .symmetric(horizontal: NumberConstant.horizontalPadding * 2),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    SvgPicture.asset(
                      AssetRes.icShare,
                      colorFilter: .mode(AppColors.white, .srcIn),
                    ),
                    SvgPicture.asset(
                      AssetRes.icFavorite,
                      colorFilter: .mode(
                        song.isFavorite ? AppColors.accent : AppColors.white,
                        .srcIn,
                      ),
                    ),
                    SvgPicture.asset(
                      AssetRes.icDownload,
                      colorFilter: .mode(AppColors.white, .srcIn),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PressableControlIcon extends StatefulWidget {
  final String asset;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const _PressableControlIcon({
    required this.asset,
    required this.size,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  State<_PressableControlIcon> createState() => _PressableControlIconState();
}

class _PressableControlIconState extends State<_PressableControlIcon> {
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
        child: Padding(
          padding: .all(NumberConstant.controlIconPadding),
          child: SvgPicture.asset(
            widget.asset,
            width: widget.size,
            height: widget.size,
            colorFilter: .mode(widget.color, .srcIn),
          ),
        ),
      ),
    );
  }
}
