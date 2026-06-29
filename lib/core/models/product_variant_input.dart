class ProductVariantInput {
  const ProductVariantInput({
    this.id,
    required this.name,
    required this.priceInPaisa,
    this.sortOrder = 0,
  });

  final int? id;
  final String name;
  final int priceInPaisa;
  final int sortOrder;

  ProductVariantInput copyWith({
    int? id,
    String? name,
    int? priceInPaisa,
    int? sortOrder,
  }) {
    return ProductVariantInput(
      id: id ?? this.id,
      name: name ?? this.name,
      priceInPaisa: priceInPaisa ?? this.priceInPaisa,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
