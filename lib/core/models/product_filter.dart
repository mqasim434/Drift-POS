import 'package:equatable/equatable.dart';

class ProductFilter extends Equatable {
  const ProductFilter({
    this.searchQuery = '',
    this.categoryId,
  });

  final String searchQuery;
  final int? categoryId;

  factory ProductFilter.all() => const ProductFilter();

  ProductFilter copyWith({
    String? searchQuery,
    int? categoryId,
    bool clearCategory = false,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
    );
  }

  @override
  List<Object?> get props => [searchQuery, categoryId];
}

enum ProductsViewMode { table, grid }
