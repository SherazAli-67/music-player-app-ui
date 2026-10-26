import 'package:carousel_slider/carousel_slider.dart';
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
    return SizedBox(
      width: double.infinity,
      height: 465,
      child: Stack(
        // spacing: NumberConstant.contentGap,
        children: [
          Container(
              height: 350,
              decoration: BoxDecoration(
                // color: AppColors.headerPurple,
                borderRadius: .vertical(bottom: .circular(NumberConstant.headerBottomRadius)),
              ),
             /* padding: .fromLTRB(
                NumberConstant.horizontalPadding,
                NumberConstant.contentGap,
                NumberConstant.horizontalPadding,
                NumberConstant.sectionGap,
              ),*/
              child:SafeArea(
                child: Column(
                  spacing: NumberConstant.contentGap,
                  children: [
                    _buildGreetingRow(),
                    _buildSearchBar(),
                    //SectionHeader-recentlyPlayed, isWhite:true
                  ],
                ),
              )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildRecentlyPlayedList(context),)
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
            //userAvatar, avatarSize, fit.cover
            ClipOval(
              child: const SizedBox()
            ),
            Column(
              crossAxisAlignment: .start,
              spacing: NumberConstant.tinyGap,
              children: [
                Row(
                  spacing: NumberConstant.tinyGap,
                  children: [
                    //greetingName, greeting
                    //icWavingHand, wavingHandSized
                  ],
                ),
                //greetingSubtitle, greetingSubtitle
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: .none,
          children: [
           /* AppHeaderButton(
              iconAsset: AssetRes.icNotificationBell,
              iconColor: AppColors.white,
            ),*/
         /*   Positioned(
              right: 0,
              top: 0,
              child: Container(
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
            ),*/
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.overlayWhite30,
        borderRadius: .circular(NumberConstant.searchBarRadius),
      ),
      padding: .symmetric(
        // horizontal: NumberConstant.searchBarPaddingH,
        // vertical: NumberConstant.searchBarPaddingV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: NumberConstant.searchIconGap,
              children: [
                //icSearch
                //searchPlaceHolder, searchPlaceHolder
              ],
            ),
          ),
          //icMic
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedList(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (ctx, player, _) {
        final itemCount = AppData.recentlyPlayed.length;
        return SizedBox(
          height: NumberConstant.recentlyPlayedCardHeight + 30,
          child: CarouselSlider(
            items: List.generate(itemCount, (index) {
              final song = AppData.recentlyPlayed[index];
              return Transform.rotate(
                angle: _recentlyPlayedRotation(index, player.currentIndex, itemCount),
                child: _buildRecentlyPlayedCard(
                  song: song,
                  onPlay: ()=> player.play(song),
                  onTap: ()=> context.push(NamedRoutes.album.routeName, extra: AppData.featuredAlbum),
                ),
              );
            }),
            options: CarouselOptions(
              height: NumberConstant.recentlyPlayedCardHeight + 30,
              viewportFraction: 0.85,
              initialPage: player.currentIndex,
              enableInfiniteScroll: true,
              autoPlay: true,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, _)=> player.onPageChange(index),
              scrollDirection: .horizontal,
            ),
          ),
        );
      },
    );
  }

  double _recentlyPlayedRotation(int index, int currentIndex, int itemCount) {
    if (index == currentIndex || itemCount < 2) return 0.0;
    final forwardSteps = (index - currentIndex + itemCount) % itemCount;
    return forwardSteps <= itemCount ~/ 2
        ? NumberConstant.recentlyPlayedRotation
        : -NumberConstant.recentlyPlayedRotation;
  }

  Widget _buildRecentlyPlayedCard({
    required SongModel song,
    required VoidCallback onPlay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: NumberConstant.recentlyPlayedCardHeight,
        decoration: BoxDecoration(
          // borderRadius: .circular(NumberConstant.recentlyPlayedRadius),
          boxShadow: [
          /*  BoxShadow(
              color: const Color(0x66FF6594),
              offset: const Offset(0, 4),
              blurRadius: 24,
            ),*/
          ],
         /* image: DecorationImage(
            image: AssetImage(song.coverAsset),
            fit: .cover,
          ),*/
        ),
        alignment: .bottomCenter,
        child: Container(
          width: double.infinity,
          padding: .symmetric(
            horizontal: NumberConstant.contentGap,
            vertical: NumberConstant.contentGap,
          ),
          decoration: BoxDecoration(
            // color: AppColors.overlayBlack50,
            // borderRadius: .vertical(bottom: .circular(NumberConstant.recentlyPlayedRadius)),
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
                    //song.title, cardTitle
                    //song.artist, cardSubtitle
                  ],
                ),
              ),
              // PlayPauseButton(isPlaying: false, onTap: onPlay,),
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
          // color: category.isSelected ? AppColors.primary : AppColors.white,
          borderRadius: .circular(NumberConstant.categoryChipRadius),
         /* boxShadow: category.isSelected
              ? [
                  BoxShadow(
                    color: const Color(0x333D2072),
                    offset: const Offset(0, 9),
                    blurRadius: 24,
                  ),
                ]
              : null,*/
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
            //iC -category.iconAsset,
            //category.label, category.isSelected ? AppTextStyles.categoryLabel : AppTextStyles.categoryLabelInactive

          ],
        ),
      ),
    );
  }

  Widget _buildPopularPlaylists(BuildContext context) {
    return Column(
      spacing: NumberConstant.sectionGap,
      children: [
        // const SectionHeader(title: StringConst.popularPlaylist,),
        SizedBox(
          height: NumberConstant.playlistCoverSize + 60,
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
              //image -playlist.coverAsset, fit.cover
              child: const SizedBox()
            ),
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 1,
                    children: [
                      //playList.title, playListTitle,
                      //playList.artist, playListArtist
                    ],
                  ),
                ),
                // SvgPicture.asset(AssetRes.icMoreVertical, width: 2, height: 12,),
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
          onTap: () {
            if (player.currentSong.lyrics.isEmpty) player.setSong(AppData.nowPlayingSong, play: player.isPlaying);
            context.push(NamedRoutes.nowPlaying.routeName);
          },
          child: Container(
            decoration: BoxDecoration(
              // color: AppColors.primary,
              borderRadius: .circular(NumberConstant.miniPlayerRadius),
              boxShadow: [
                /*BoxShadow(
                  color: const Color(0x333D2072),
                  offset: const Offset(0, 9),
                  blurRadius: 24,
                ),*/
              ],
            ),
            padding: .all(NumberConstant.miniPlayerPadding),
            child: Row(
              spacing: NumberConstant.contentGap,
              children: [
                ClipRRect(
                  borderRadius: .circular(NumberConstant.songThumbRadius),
                  //image: song.coverAsset, widthHeight: songThumbSize, fit.cover
                  child: const SizedBox()
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      //song.title, cardTitle,
                      //song.artist, cardSubtitle
                    ],
                  ),
                ),
                /*PlayPauseButton(
                  isPlaying: player.isPlaying,
                  onTap: player.togglePlayPause,
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }
}
