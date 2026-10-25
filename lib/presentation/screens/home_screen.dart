import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_colors.dart';
import 'package:music_player_app_ui/core/app_data.dart';
import 'package:music_player_app_ui/core/app_textstyles.dart';
import 'package:music_player_app_ui/core/asset_res.dart';
import 'package:music_player_app_ui/core/models/category_model.dart';
import 'package:music_player_app_ui/core/models/playlist_model.dart';
import 'package:music_player_app_ui/core/models/song_model.dart';
import 'package:music_player_app_ui/presentation/providers/home_category_provider.dart';
import 'package:music_player_app_ui/presentation/providers/player_provider.dart';
import 'package:music_player_app_ui/presentation/widgets/app_header_button.dart';
import 'package:music_player_app_ui/presentation/widgets/play_pause_button.dart';
import 'package:music_player_app_ui/presentation/widgets/section_header.dart';
import 'package:music_player_app_ui/routing/router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> HomeCategoryProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: .only(bottom: NumberConstant.homeBottomContentPadding),
            child: Column(
              spacing: NumberConstant.sectionGap,
              children: [
                _buildPurpleHeader(context),
                Padding(
                  padding: .symmetric(horizontal: NumberConstant.horizontalPadding),
                  child: Column(
                    spacing: NumberConstant.sectionGap,
                    children: [
                      _buildCategories(context),
                      _buildPopularPlaylists(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: NumberConstant.horizontalPadding,
            right: NumberConstant.horizontalPadding,
            bottom: NumberConstant.miniPlayerBottom,
            child: _buildMiniPlayer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPurpleHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.headerPurple,
        borderRadius: .vertical(bottom: .circular(NumberConstant.headerBottomRadius)),
      ),
      clipBehavior: .hardEdge,
      child: Stack(
        children: [
          Positioned(
            left: -58,
            top: -50,
            child: SvgPicture.asset(AssetRes.icHeaderGlow, width: NumberConstant.headerGlowSize, height: NumberConstant.headerGlowSize,),
          ),
          Positioned(
            right: -58,
            top: 130,
            child: SvgPicture.asset(AssetRes.icHeaderGlow, width: NumberConstant.headerGlowSize, height: NumberConstant.headerGlowSize,),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: .fromLTRB(
                NumberConstant.horizontalPadding,
                NumberConstant.contentGap,
                NumberConstant.horizontalPadding,
                NumberConstant.sectionGap,
              ),
              child: Column(
                spacing: NumberConstant.contentGap,
                children: [
                  _buildGreetingRow(),
                  _buildSearchBar(),
                  const SectionHeader(title: StringConst.recentlyPlayed, isWhite: true,),
                  _buildRecentlyPlayedList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          spacing: NumberConstant.greetingAvatarGap,
          children: [
            ClipOval(
              child: Image.asset(AssetRes.userAvatar, width: NumberConstant.avatarSize, height: NumberConstant.avatarSize, fit: .cover,),
            ),
            Column(
              crossAxisAlignment: .start,
              spacing: NumberConstant.tinyGap,
              children: [
                Row(
                  spacing: NumberConstant.tinyGap,
                  children: [
                    Text(StringConst.greetingName, style: AppTextStyles.greeting,),
                    SvgPicture.asset(AssetRes.icWavingHand, width: NumberConstant.wavingHandSize, height: NumberConstant.wavingHandSize,),
                  ],
                ),
                Text(StringConst.greetingSubtitle, style: AppTextStyles.greetingSubtitle,),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: .none,
          children: [
            AppHeaderButton(
              iconAsset: AssetRes.icNotificationBell,
              iconColor: AppColors.white,
              iconSize: 19,
              padding: 9.5,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: NumberConstant.notificationBadgeSize,
                height: NumberConstant.notificationBadgeSize,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: .circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.overlayWhite30,
        borderRadius: .circular(NumberConstant.searchBarRadius),
      ),
      padding: .symmetric(
        horizontal: NumberConstant.searchBarPaddingH,
        vertical: NumberConstant.searchBarPaddingV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: NumberConstant.searchIconGap,
              children: [
                SvgPicture.asset(AssetRes.icSearch, width: NumberConstant.searchIconSize, height: NumberConstant.searchIconSize, colorFilter: .mode(AppColors.white, .srcIn),),
                Text(StringConst.searchPlaceholder, style: AppTextStyles.searchPlaceholder,),
              ],
            ),
          ),
          SvgPicture.asset(AssetRes.icMic, width: NumberConstant.micIconSize, height: NumberConstant.micIconSize, colorFilter: .mode(AppColors.white, .srcIn),),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedList(BuildContext context) {
    final player = context.read<PlayerProvider>();
    return SizedBox(
      height: NumberConstant.recentlyPlayedCardHeight + 30,
      child: ListView.separated(
        scrollDirection: .horizontal,
        clipBehavior: .none,
        itemCount: AppData.recentlyPlayed.length,
        separatorBuilder: (_, _)=> const SizedBox(width: NumberConstant.recentlyPlayedCardGap),
        itemBuilder: (ctx, index) {
          final song = AppData.recentlyPlayed[index];
          final isFeatured = index == 1;
          final rotation = index == 0
              ? -NumberConstant.recentlyPlayedRotation
              : (index == 2 ? NumberConstant.recentlyPlayedRotation : 0.0);
          return Transform.rotate(
            angle: rotation,
            child: _buildRecentlyPlayedCard(
              song: song,
              isFeatured: isFeatured,
              onPlay: ()=> player.play(song),
              onTap: ()=> context.push(NamedRoutes.album.routeName, extra: AppData.featuredAlbum),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentlyPlayedCard({
    required SongModel song,
    required bool isFeatured,
    required VoidCallback onPlay,
    required VoidCallback onTap,
  }) {
    final width = isFeatured
        ? NumberConstant.recentlyPlayedFeaturedWidth
        : NumberConstant.recentlyPlayedCardWidth;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: NumberConstant.recentlyPlayedCardHeight,
        decoration: BoxDecoration(
          borderRadius: .circular(NumberConstant.recentlyPlayedRadius),
          boxShadow: isFeatured
              ? [
                  BoxShadow(
                    color: const Color(0x66FF6594),
                    offset: const Offset(0, 4),
                    blurRadius: 24,
                  ),
                ]
              : null,
          image: DecorationImage(
            image: AssetImage(song.coverAsset),
            fit: .cover,
          ),
        ),
        alignment: .bottomCenter,
        child: Container(
          width: double.infinity,
          padding: .symmetric(
            horizontal: isFeatured ? 16 : NumberConstant.contentGap,
            vertical: NumberConstant.contentGap,
          ),
          decoration: BoxDecoration(
            color: AppColors.overlayBlack50,
            borderRadius: .vertical(bottom: .circular(NumberConstant.recentlyPlayedRadius)),
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .end,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  spacing: 2,
                  children: [
                    Text(song.title, style: AppTextStyles.cardTitle, maxLines: 1, overflow: .ellipsis,),
                    Text(song.artist, style: AppTextStyles.cardSubtitle, maxLines: 1, overflow: .ellipsis,),
                  ],
                ),
              ),
              PlayPauseButton(isPlaying: false, onTap: onPlay,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Consumer<HomeCategoryProvider>(
      builder: (ctx, provider, _)=> SingleChildScrollView(
        scrollDirection: .horizontal,
        child: Row(
          spacing: NumberConstant.chipGap,
          children: [
            for (var i = 0; i < provider.categories.length; i++)
              _buildCategoryChip(
                category: provider.categories[i],
                onTap: ()=> provider.selectCategory(i),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({required CategoryModel category, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: category.isSelected ? AppColors.primary : AppColors.white,
          borderRadius: .circular(NumberConstant.categoryChipRadius),
          boxShadow: category.isSelected
              ? [
                  BoxShadow(
                    color: const Color(0x333D2072),
                    offset: const Offset(0, 9),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        padding: .only(
          left: NumberConstant.categoryChipPaddingV,
          right: NumberConstant.categoryChipPaddingH,
          top: NumberConstant.categoryChipPaddingV,
          bottom: NumberConstant.categoryChipPaddingV,
        ),
        child: Row(
          spacing: NumberConstant.categoryIconGap,
          children: [
            SvgPicture.asset(category.iconAsset, width: NumberConstant.categoryIconSize, height: NumberConstant.categoryIconSize,),
            Text(
              category.label,
              style: category.isSelected ? AppTextStyles.categoryLabel : AppTextStyles.categoryLabelInactive,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularPlaylists(BuildContext context) {
    return Column(
      spacing: NumberConstant.sectionGap,
      children: [
        const SectionHeader(title: StringConst.popularPlaylist,),
        SizedBox(
          height: NumberConstant.playlistCoverSize + 40,
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: AppData.popularPlaylists.length,
            separatorBuilder: (_, _)=> const SizedBox(width: NumberConstant.playlistCardGap),
            itemBuilder: (ctx, index)=> _buildPlaylistCard(
              playlist: AppData.popularPlaylists[index],
              onTap: ()=> context.push(NamedRoutes.album.routeName, extra: AppData.popularPlaylists[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistCard({required PlaylistModel playlist, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: NumberConstant.playlistCoverSize,
        child: Column(
          spacing: NumberConstant.smallGap,
          crossAxisAlignment: .start,
          children: [
            ClipRRect(
              borderRadius: .circular(NumberConstant.playlistCoverRadius),
              child: Image.asset(
                playlist.coverAsset,
                width: NumberConstant.playlistCoverSize,
                height: NumberConstant.playlistCoverSize,
                fit: .cover,
              ),
            ),
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 1,
                    children: [
                      Text(playlist.title, style: AppTextStyles.playlistTitle, maxLines: 1, overflow: .ellipsis,),
                      Text(playlist.artist, style: AppTextStyles.playlistArtist, maxLines: 1, overflow: .ellipsis,),
                    ],
                  ),
                ),
                SvgPicture.asset(AssetRes.icMoreVertical, width: 2, height: 12,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (ctx, player, _) {
        final song = player.currentSong;
        return GestureDetector(
          onTap: ()=> context.push(NamedRoutes.nowPlaying.routeName),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: .circular(NumberConstant.miniPlayerRadius),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x333D2072),
                  offset: const Offset(0, 9),
                  blurRadius: 24,
                ),
              ],
            ),
            padding: .all(NumberConstant.miniPlayerPadding),
            child: Row(
              spacing: NumberConstant.contentGap,
              children: [
                ClipRRect(
                  borderRadius: .circular(NumberConstant.songThumbRadius),
                  child: Image.asset(
                    song.coverAsset,
                    width: NumberConstant.songThumbSize,
                    height: NumberConstant.songThumbSize,
                    fit: .cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      Text(song.title, style: AppTextStyles.cardTitle, maxLines: 1, overflow: .ellipsis,),
                      Text(song.artist, style: AppTextStyles.cardSubtitle, maxLines: 1, overflow: .ellipsis,),
                    ],
                  ),
                ),
                PlayPauseButton(
                  isPlaying: player.isPlaying,
                  onTap: player.togglePlayPause,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
