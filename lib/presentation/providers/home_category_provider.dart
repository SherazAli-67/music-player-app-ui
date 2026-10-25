import 'package:flutter/foundation.dart';
import 'package:music_player_app_ui/core/app_data.dart';
import 'package:music_player_app_ui/core/models/category_model.dart';

class HomeCategoryProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  List<CategoryModel> get categories => [
    for (var i = 0; i < AppData.categories.length; i++)
      CategoryModel(
        label: AppData.categories[i].label,
        iconAsset: AppData.categories[i].iconAsset,
        isSelected: i == _selectedIndex,
      ),
  ];

  void selectCategory(int index) {
    if (index == _selectedIndex || index < 0 || index >= AppData.categories.length) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
