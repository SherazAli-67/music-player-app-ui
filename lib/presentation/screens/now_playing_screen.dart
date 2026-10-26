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
                          onBack: ()=> context.pop(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: NumberConstant.sectionGap,
                              children: [
                                _buildCover(song),
                                _buildSongInfo(song),
                                _buildLyrics(song),
                                _buildProgress(song),
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

  Widget _buildCover(SongModel song) {
    return Container(
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
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return Column(
      spacing: NumberConstant.tinyGap,
      children: [
        Text(song.title, style: AppTextStyles.songTitle, textAlign: .center,),
        Text(song.artist, style: AppTextStyles.songArtist, textAlign: .center,),
      ],
    );
  }

  Widget _buildLyrics(SongModel song) {
    if (song.lyrics.isEmpty) return const SizedBox.shrink();
    final activeIndex = song.lyrics.length ~/ 2;
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
            Text(
              song.lyrics[i],
              textAlign: .center,
              style: i == activeIndex ? AppTextStyles.lyricsActive : AppTextStyles.lyricsInactive,
            ),
        ],
      ),
    );
  }

  Widget _buildProgress(SongModel song) {
    final progress = _progressValue(song.currentPosition, song.duration);
    return Column(
      spacing: NumberConstant.smallGap,
      children: [
        ClipRRect(
          borderRadius: .circular(NumberConstant.progressActiveHeight),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: NumberConstant.progressActiveHeight,
            backgroundColor: AppColors.primary60.withValues(alpha: 0.25),
            color: AppColors.primary,
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(song.currentPosition, style: AppTextStyles.timeLabel,),
            Text(song.duration, style: AppTextStyles.timeLabel,),
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
            _buildControlIcon(AssetRes.icPrevMusic, size: NumberConstant.skipIconSize),
            _buildControlIcon(AssetRes.icPrev15s, size: NumberConstant.seekIconSize, color: AppColors.primary60),
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
            _buildControlIcon(AssetRes.icNext15s, size: NumberConstant.seekIconSize, color: AppColors.primary60),
            _buildControlIcon(AssetRes.icNextMusic, size: NumberConstant.skipIconSize),
          ],
        ),
      ],
    );
  }

  Widget _buildControlIcon(String asset, {required double size, Color color = AppColors.primary}) {
    return Padding(
      padding: .all(NumberConstant.controlIconPadding),
      child: SvgPicture.asset(asset, width: size, height: size, colorFilter: .mode(color, .srcIn),),
    );
  }

  Widget _buildBottomActions(SongModel song) {
    return SizedBox(
      height: NumberConstant.bottomActionBarHeight,
      width: double.infinity,
      child: Stack(
        alignment: .bottomCenter,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(AssetRes.icBottomCurve, fit: .fill,),
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
    );
  }

  double _progressValue(String current, String total) {
    final currentSeconds = _toSeconds(current);
    final totalSeconds = _toSeconds(total);
    if (totalSeconds <= 0) return 0;
    return (currentSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  int _toSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }
}
