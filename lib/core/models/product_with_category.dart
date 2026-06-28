import '../database/app_database.dart';

class ProductWithCategory {
  const ProductWithCategory({
    required this.product,
    required this.categoryName,
    required this.categoryColor,
  });

  final Product product;
  final String categoryName;
  final String categoryColor;
}
