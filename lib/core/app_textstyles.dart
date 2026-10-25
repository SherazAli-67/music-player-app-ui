import 'package:flutter/material.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_colors.dart';

class AppTextStyles {
  static const _font = StringConst.appFontFamily;

  static const greeting = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 21,
    color: AppColors.white,
  );

  static const greetingSubtitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 14,
    color: AppColors.white,
  );

  static const searchPlaceholder = TextStyle(
    fontFamily: _font,
    fontWeight: .w500,
    fontSize: 14,
    height: 1.3,
    color: AppColors.white,
  );

  static const sectionTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 18,
    color: AppColors.black,
  );

  static const sectionTitleWhite = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 18,
    color: AppColors.white,
  );

  static const seeMore = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const seeMoreWhite = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.white,
  );

  static const cardTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 16,
    color: AppColors.white,
  );

  static const cardSubtitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.cardSubtitleLight,
  );

  static const playlistTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w500,
    fontSize: 14,
    color: AppColors.black,
  );

  static const playlistArtist = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 10,
    color: AppColors.textGrey,
  );

  static const categoryLabel = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.white,
  );

  static const categoryLabelInactive = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.black,
  );

  static const screenTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 16,
    color: AppColors.primary,
  );

  static const songTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 22,
    color: AppColors.primary,
  );

  static const songArtist = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 14,
    color: AppColors.primary,
  );

  static const songListTitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 16,
    color: AppColors.primary,
  );

  static const songListSubtitle = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.primary,
  );

  static const lyricsActive = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 13,
    letterSpacing: 0.26,
    color: AppColors.primary,
  );

  static const lyricsInactive = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 13,
    color: AppColors.lyricsInactive,
  );

  static const timeLabel = TextStyle(
    fontFamily: _font,
    fontWeight: .w400,
    fontSize: 12,
    color: AppColors.timeText,
  );

  static const subscribe = TextStyle(
    fontFamily: _font,
    fontWeight: .w600,
    fontSize: 16,
    color: AppColors.white,
  );
}
