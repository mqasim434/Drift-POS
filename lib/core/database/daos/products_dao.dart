import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/products.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Stream<List<Product>> watchProductsByCategory(int categoryId) {
    return (select(products)
          ..where((p) => p.categoryId.equals(categoryId))
          ..orderBy([
            (p) => OrderingTerm.asc(p.sortOrder),
            (p) => OrderingTerm.asc(p.name),
          ]))
        .watch();
  }

  Stream<List<Product>> watchAllProducts() {
    return (select(products)
          ..orderBy([
            (p) => OrderingTerm.asc(p.sortOrder),
            (p) => OrderingTerm.asc(p.name),
          ]))
        .watch();
  }

  Future<List<Product>> searchProducts(String query) {
    final pattern = '%$query%';
    return (select(products)
          ..where((p) => p.name.like(pattern))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .get();
  }

  Future<Product?> getProductById(int id) {
    return (select(products)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  Future<bool> updateProduct(Product product) {
    return update(products).replace(product);
  }

  Future<int> toggleAvailability(int id) async {
    final product = await getProductById(id);
    if (product == null) return 0;
    return (update(products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(isAvailable: Value(!product.isAvailable)),
    );
  }

  Future<int> deleteProduct(int id) {
    return (delete(products)..where((p) => p.id.equals(id))).go();
  }
}
