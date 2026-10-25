import 'package:flutter/material.dart';
import 'package:music_player_app_ui/constants/string_const.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(StringConst.album),),
    );
  }
}
