import 'package:flutter/material.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/core/app_textstyles.dart';
import 'package:music_player_app_ui/core/asset_res.dart';
import 'package:music_player_app_ui/presentation/widgets/app_header_button.dart';

class AppScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const AppScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        AppHeaderButton(
          iconAsset: AssetRes.icArrowBack,
          onTap: onBack,
          padding: NumberConstant.headerBackPadding,
          iconSize: NumberConstant.headerButtonIconSize,
        ),
        Text(title, style: AppTextStyles.screenTitle,),
        AppHeaderButton(
          iconAsset: AssetRes.icMoreVertical,
          onTap: onMore,
          padding: NumberConstant.headerMorePadding,
          iconSize: NumberConstant.headerMoreIconSize,
        ),
      ],
    );
  }
}
