import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories.dart';
import '../tables/products.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories, Products])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.name),
          ]))
        .watch();
  }

  Future<List<Category>> getAllActive() {
    return (select(categories)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.name),
          ]))
        .get();
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<bool> updateCategory(Category category) {
    return update(categories).replace(category);
  }

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<int> getProductCountForCategory(int categoryId) async {
    final countExp = products.id.count();
    final query = selectOnly(products)
      ..addColumns([countExp])
      ..where(products.categoryId.equals(categoryId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<Map<int, int>> getProductCountsForAll() async {
    final rows = await customSelect(
      '''
      SELECT category_id AS category_id, COUNT(*) AS count
      FROM products
      GROUP BY category_id
      ''',
      readsFrom: {products},
    ).get();

    return {
      for (final row in rows)
        row.read<int>('category_id'): row.read<int>('count'),
    };
  }

  Future<bool> nameExists(String name, {int? excludeId}) async {
    final trimmed = name.trim();
    final results = await (select(categories)
          ..where((c) => c.name.equals(trimmed)))
        .get();
    if (excludeId == null) return results.isNotEmpty;
    return results.any((category) => category.id != excludeId);
  }
}
