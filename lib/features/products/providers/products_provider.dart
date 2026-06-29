import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/product_filter.dart';
import '../../../core/models/product_variant_input.dart';
import '../../../core/models/product_with_category.dart';
import '../../../core/providers/database_provider.dart';

final productsFilterProvider =
    StateProvider<ProductFilter>((ref) => ProductFilter.all());

final productsViewModeProvider =
    StateProvider<ProductsViewMode>((ref) => ProductsViewMode.table);

final productsLimitProvider = StateProvider<int>((ref) => 50);

final productFormOpenProvider = StateProvider<Product?>((ref) => null);

final productFormAddingProvider = StateProvider<bool>((ref) => false);

final productVariantsProvider =
    FutureProvider.family<List<ProductVariant>, int>((ref, productId) {
  return ref
      .watch(databaseProvider)
      .productVariantsDao
      .getVariantsForProduct(productId);
});

final filteredProductsProvider =
    StreamProvider<List<ProductWithCategory>>((ref) {
  final filter = ref.watch(productsFilterProvider);
  final limit = ref.watch(productsLimitProvider);
  final db = ref.watch(databaseProvider);
  return db.productsDao.watchFilteredProducts(filter, limit: limit);
});

final productsNotifierProvider =
    AsyncNotifierProvider<ProductsNotifier, void>(ProductsNotifier.new);

class ProductsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addProduct(
    ProductsCompanion product, {
    List<ProductVariantInput> variants = const [],
  }) async {
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      final productId = await db.productsDao.insertProduct(product);
      await _saveVariants(db, productId, variants);
    });
  }

  Future<void> updateProduct(
    Product product, {
    List<ProductVariantInput> variants = const [],
  }) async {
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      await db.productsDao.updateProduct(product);
      await _saveVariants(db, product.id, variants);
    });
  }

  Future<void> _saveVariants(
    AppDatabase db,
    int productId,
    List<ProductVariantInput> variants,
  ) async {
    final validVariants = variants
        .where(
          (variant) =>
              variant.name.trim().isNotEmpty && variant.priceInPaisa > 0,
        )
        .toList();

    await db.productVariantsDao.replaceVariantsForProduct(
      productId,
      [
        for (var i = 0; i < validVariants.length; i++)
          ProductVariantsCompanion.insert(
            productId: productId,
            name: validVariants[i].name.trim(),
            priceInPaisa: validVariants[i].priceInPaisa,
            sortOrder: Value(
              validVariants[i].sortOrder == 0 ? i : validVariants[i].sortOrder,
            ),
          ),
      ],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = ref.read(databaseProvider);
    await db.productsDao.deleteProduct(id);
  }

  Future<void> toggleAvailability(int id) async {
    await ref.read(databaseProvider).productsDao.toggleAvailability(id);
  }
}

void setProductsCategoryFilter(WidgetRef ref, int? categoryId) {
  ref.read(productsFilterProvider.notifier).state = ref
      .read(productsFilterProvider)
      .copyWith(categoryId: categoryId, clearCategory: categoryId == null);
  ref.read(productsLimitProvider.notifier).state = 50;
}

void openProductForm(WidgetRef ref, {Product? product}) {
  ref.read(productFormAddingProvider.notifier).state = product == null;
  ref.read(productFormOpenProvider.notifier).state = product;
}

void closeProductForm(WidgetRef ref) {
  ref.read(productFormAddingProvider.notifier).state = false;
  ref.read(productFormOpenProvider.notifier).state = null;
}
