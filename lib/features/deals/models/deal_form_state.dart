import 'package:equatable/equatable.dart';

import '../../../core/database/app_database.dart';

class DealItemDraft extends Equatable {
  const DealItemDraft({
    required this.key,
    required this.product,
    this.variants = const [],
    this.variantId,
    this.quantity = 1,
  });

  final String key;
  final Product product;
  final List<ProductVariant> variants;
  final int? variantId;
  final int quantity;

  bool get requiresVariant => variants.isNotEmpty;

  int get unitPriceInPaisa {
    if (variantId != null) {
      for (final variant in variants) {
        if (variant.id == variantId) return variant.priceInPaisa;
      }
    }
    return product.priceInPaisa;
  }

  String get displayName {
    if (variantId != null) {
      for (final variant in variants) {
        if (variant.id == variantId) {
          return '${product.name} (${variant.name})';
        }
      }
    }
    return product.name;
  }

  DealItemDraft copyWith({
    String? key,
    Product? product,
    List<ProductVariant>? variants,
    int? variantId,
    bool clearVariantId = false,
    int? quantity,
  }) {
    return DealItemDraft(
      key: key ?? this.key,
      product: product ?? this.product,
      variants: variants ?? this.variants,
      variantId: clearVariantId ? null : (variantId ?? this.variantId),
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [key, product.id, variantId, quantity];
}

class DealFormState extends Equatable {
  const DealFormState({
    this.dealId,
    this.name = '',
    this.description = '',
    this.imagePath,
    this.priceInPaisa = 0,
    this.isAvailable = true,
    this.items = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.isLoaded = false,
  });

  final int? dealId;
  final String name;
  final String description;
  final String? imagePath;
  final int priceInPaisa;
  final bool isAvailable;
  final List<DealItemDraft> items;
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;

  bool get isEditing => dealId != null;

  int get originalTotalInPaisa => items.fold(
        0,
        (sum, item) => sum + item.unitPriceInPaisa * item.quantity,
      );

  int get savingsInPaisa => originalTotalInPaisa - priceInPaisa;

  DealFormState copyWith({
    int? dealId,
    String? name,
    String? description,
    String? imagePath,
    int? priceInPaisa,
    bool? isAvailable,
    List<DealItemDraft>? items,
    bool? isLoading,
    bool? isSaving,
    bool? isLoaded,
    bool clearImage = false,
  }) {
    return DealFormState(
      dealId: dealId ?? this.dealId,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      priceInPaisa: priceInPaisa ?? this.priceInPaisa,
      isAvailable: isAvailable ?? this.isAvailable,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [
        dealId,
        name,
        description,
        imagePath,
        priceInPaisa,
        isAvailable,
        items,
        isLoading,
        isSaving,
        isLoaded,
      ];
}

class DealAddProductInput {
  const DealAddProductInput({
    required this.product,
    required this.variants,
    this.variantId,
    this.quantity = 1,
  });

  final Product product;
  final List<ProductVariant> variants;
  final int? variantId;
  final int quantity;
}
