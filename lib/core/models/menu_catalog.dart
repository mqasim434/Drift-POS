import 'deal_with_items.dart';

class MenuProduct {
  const MenuProduct({
    required this.id,
    required this.name,
    required this.priceInPaisa,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    this.imagePath,
  });

  final int id;
  final String name;
  final int priceInPaisa;
  final int categoryId;
  final String categoryName;
  final String categoryColor;
  final String? imagePath;
}

class MenuCatalog {
  const MenuCatalog({
    required this.products,
    required this.deals,
  });

  final List<MenuProduct> products;
  final List<DealWithItems> deals;

  static const empty = MenuCatalog(products: [], deals: []);
}
