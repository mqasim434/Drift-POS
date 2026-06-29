import 'deal_with_items.dart';

class MenuProductVariant {
  const MenuProductVariant({
    required this.id,
    required this.name,
    required this.priceInPaisa,
  });

  final int id;
  final String name;
  final int priceInPaisa;
}

class MenuProduct {
  const MenuProduct({
    required this.id,
    required this.name,
    required this.priceInPaisa,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    this.imagePath,
    this.variants = const [],
  });

  final int id;
  final String name;
  final int priceInPaisa;
  final int categoryId;
  final String categoryName;
  final String categoryColor;
  final String? imagePath;
  final List<MenuProductVariant> variants;

  bool get hasVariants => variants.isNotEmpty;

  int get displayPriceInPaisa {
    if (variants.isEmpty) return priceInPaisa;
    return variants.map((v) => v.priceInPaisa).reduce(
          (min, price) => price < min ? price : min,
        );
  }
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
