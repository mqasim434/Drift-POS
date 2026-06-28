import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/product_filter.dart';
import '../../../core/models/product_with_category.dart';
import '../../../core/providers/database_provider.dart';

final productsFilterProvider =
    StateProvider<ProductFilter>((ref) => ProductFilter.all());

final productsViewModeProvider =
    StateProvider<ProductsViewMode>((ref) => ProductsViewMode.table);

final productsLimitProvider = StateProvider<int>((ref) => 50);

final productFormOpenProvider = StateProvider<Product?>((ref) => null);

final productFormAddingProvider = StateProvider<bool>((ref) => false);

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

  Future<void> addProduct(ProductsCompanion product) async {
    await ref.read(databaseProvider).productsDao.insertProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await ref.read(databaseProvider).productsDao.updateProduct(product);
  }

  Future<void> deleteProduct(int id) async {
    await ref.read(databaseProvider).productsDao.deleteProduct(id);
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
