import 'package:flutter/material.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_textstyles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isWhite;
  final bool showSeeMore;
  final VoidCallback? onSeeMore;

  const SectionHeader({
    super.key,
    required this.title,
    this.isWhite = false,
    this.showSeeMore = true,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title, style: isWhite ? AppTextStyles.sectionTitleWhite : AppTextStyles.sectionTitle,),
        if (showSeeMore)
          GestureDetector(
            onTap: onSeeMore,
            child: Text(StringConst.seeMore, style: isWhite ? AppTextStyles.seeMoreWhite : AppTextStyles.seeMore,),
          ),
      ],
    );
  }
}
