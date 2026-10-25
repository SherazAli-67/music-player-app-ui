class CategoryModel {
  final String label;
  final String iconAsset;
  final bool isSelected;

  const CategoryModel({
    required this.label,
    required this.iconAsset,
    this.isSelected = false,
  });
}
