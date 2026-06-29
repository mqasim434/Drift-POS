import 'package:equatable/equatable.dart';

import '../../../core/database/app_database.dart';

class DealItemDraft extends Equatable {
  const DealItemDraft({
    required this.product,
    this.quantity = 1,
    this.selected = false,
  });

  final Product product;
  final int quantity;
  final bool selected;

  DealItemDraft copyWith({
    Product? product,
    int? quantity,
    bool? selected,
  }) {
    return DealItemDraft(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [product.id, quantity, selected];
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
    this.searchQuery = '',
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
  final String searchQuery;
  final bool isLoading;
  final bool isSaving;
  final bool isLoaded;

  bool get isEditing => dealId != null;

  List<DealItemDraft> get selectedItems =>
      items.where((item) => item.selected && item.quantity > 0).toList();

  List<DealItemDraft> get filteredItems {
    if (searchQuery.isEmpty) return items;
    final query = searchQuery.toLowerCase();
    return items
        .where((item) => item.product.name.toLowerCase().contains(query))
        .toList();
  }

  int get originalTotalInPaisa => selectedItems.fold(
        0,
        (sum, item) => sum + item.product.priceInPaisa * item.quantity,
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
    String? searchQuery,
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
      searchQuery: searchQuery ?? this.searchQuery,
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
        searchQuery,
        isLoading,
        isSaving,
        isLoaded,
      ];
}
