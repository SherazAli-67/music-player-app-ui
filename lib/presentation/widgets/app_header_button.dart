import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/core/app_colors.dart';

class AppHeaderButton extends StatelessWidget {
  final String iconAsset;
  final VoidCallback? onTap;
  final double padding;
  final double iconSize;
  final Color? iconColor;

  const AppHeaderButton({
    super.key,
    required this.iconAsset,
    this.onTap,
    this.padding = NumberConstant.headerBackPadding,
    this.iconSize = NumberConstant.headerButtonIconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.overlayWhite30,
          borderRadius: .circular(NumberConstant.headerButtonRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 15),
              blurRadius: 30,
            ),
          ],
        ),
        padding: .all(padding),
        child: SvgPicture.asset(
          iconAsset,
          width: iconSize,
          height: iconSize,
          colorFilter: iconColor == null ? null : .mode(iconColor!, .srcIn),
        ),
      ),
    );
  }
}
