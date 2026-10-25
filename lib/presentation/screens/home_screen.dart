import 'package:flutter/material.dart';
import 'package:music_player_app_ui/presentation/providers/home_category_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> HomeCategoryProvider(),
      child: const Scaffold(
        body: Center(child: Text('Home screen'),),
      ),
    );
  }
}
