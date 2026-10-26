import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player_app_ui/constants/number_constant.dart';
import 'package:music_player_app_ui/core/asset_res.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onTap;
  final double size;
  final bool useNowPlayingAsset;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    this.onTap,
    this.size = NumberConstant.playIconSize,
    this.useNowPlayingAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    final asset = useNowPlayingAsset
        ? (isPlaying ? AssetRes.icPauseCircle : AssetRes.icNowPlayingPlay)
        : (isPlaying ? AssetRes.icPauseCircle : AssetRes.icPlayCircle);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: NumberConstant.animFast),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: SvgPicture.asset(
          asset,
          key: ValueKey(asset),
          width: size,
          height: size,
        ),
      ),
    );
  }
}
