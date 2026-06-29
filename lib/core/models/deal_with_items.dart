import '../database/app_database.dart';

class DealItemDetail {
  const DealItemDetail({
    required this.quantity,
    required this.product,
    this.variant,
  });

  final int quantity;
  final Product product;
  final ProductVariant? variant;

  String get displayName =>
      variant != null ? '${product.name} (${variant!.name})' : product.name;

  int get unitPriceInPaisa => variant?.priceInPaisa ?? product.priceInPaisa;
}

class DealWithItems {
  const DealWithItems({
    required this.id,
    required this.name,
    required this.priceInPaisa,
    required this.items,
    this.description,
    this.imagePath,
    this.isAvailable = true,
  });

  final int id;
  final String name;
  final String? description;
  final int priceInPaisa;
  final List<DealItemDetail> items;
  final String? imagePath;
  final bool isAvailable;

  int get originalTotalInPaisa => items.fold(
        0,
        (sum, item) => sum + item.unitPriceInPaisa * item.quantity,
      );

  int get savingsInPaisa => originalTotalInPaisa - priceInPaisa;
}
