import 'package:flutter/material.dart';
import 'package:music_player_app_ui/constants/string_const.dart';
import 'package:music_player_app_ui/core/app_colors.dart';
import 'package:music_player_app_ui/presentation/providers/player_provider.dart';
import 'package:music_player_app_ui/routing/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> PlayerProvider(),
      child: MaterialApp.router(
        title: StringConst.appTitle,
        theme: ThemeData(
          brightness: .light,
          fontFamily: StringConst.appFontFamily,
          scaffoldBackgroundColor: AppColors.secondary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            brightness: .light,
          ),
        ),
        builder: (ctx, child)=> child!,
        routerConfig: router,
      ),
    );
  }
}
