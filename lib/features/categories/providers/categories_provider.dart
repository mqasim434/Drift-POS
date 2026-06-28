import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

class CategoryException implements Exception {
  CategoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CategoryViewModel {
  const CategoryViewModel({
    required this.category,
    required this.productCount,
  });

  final Category category;
  final int productCount;
}

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(databaseProvider).categoriesDao.watchAllCategories();
});

final categoriesWithCountProvider =
    StreamProvider<List<CategoryViewModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  await for (final categories in db.categoriesDao.watchAllCategories()) {
    final counts = await db.categoriesDao.getProductCountsForAll();
    yield categories
        .map(
          (category) => CategoryViewModel(
            category: category,
            productCount: counts[category.id] ?? 0,
          ),
        )
        .toList();
  }
});

final categoriesNotifierProvider =
    AsyncNotifierProvider<CategoriesNotifier, void>(CategoriesNotifier.new);

class CategoriesNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCategory(CategoriesCompanion category) async {
    final db = ref.read(databaseProvider);
    final name = category.name.value;
    if (await db.categoriesDao.nameExists(name)) {
      throw CategoryException('A category named "$name" already exists.');
    }
    await db.categoriesDao.insertCategory(category);
  }

  Future<void> updateCategory(Category category) async {
    final db = ref.read(databaseProvider);
    if (await db.categoriesDao.nameExists(
      category.name,
      excludeId: category.id,
    )) {
      throw CategoryException(
        'A category named "${category.name}" already exists.',
      );
    }
    await db.categoriesDao.updateCategory(category);
  }

  Future<void> deleteCategory(int id) async {
    final db = ref.read(databaseProvider);
    final productCount = await db.categoriesDao.getProductCountForCategory(id);
    if (productCount > 0) {
      throw CategoryException(
        'Cannot delete this category because it has $productCount assigned '
        'product${productCount == 1 ? '' : 's'}.',
      );
    }
    await db.categoriesDao.deleteCategory(id);
  }
}
