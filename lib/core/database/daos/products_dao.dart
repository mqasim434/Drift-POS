import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories.dart';
import '../tables/products.dart';
import '../../models/menu_catalog.dart';
import '../../models/product_filter.dart';
import '../../models/product_with_category.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products, Categories])
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

  Stream<List<ProductWithCategory>> watchFilteredProducts(
    ProductFilter filter, {
    required int limit,
  }) {
    final query = select(products).join([
      innerJoin(categories, categories.id.equalsExp(products.categoryId)),
    ]);

    Expression<bool>? predicate;
    if (filter.searchQuery.isNotEmpty) {
      predicate = products.name.like('%${filter.searchQuery}%');
    }
    if (filter.categoryId != null) {
      final categoryPredicate =
          products.categoryId.equals(filter.categoryId!);
      predicate =
          predicate == null ? categoryPredicate : predicate & categoryPredicate;
    }
    if (predicate != null) {
      query.where(predicate);
    }

    query
      ..orderBy([
        OrderingTerm.asc(products.sortOrder),
        OrderingTerm.asc(products.name),
      ])
      ..limit(limit);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ProductWithCategory(
                  product: row.readTable(products),
                  categoryName: row.readTable(categories).name,
                  categoryColor: row.readTable(categories).color,
                ),
              )
              .toList(),
        );
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
    return update(products).replace(
      product.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<int> toggleAvailability(int id) async {
    final product = await getProductById(id);
    if (product == null) return 0;
    return (update(products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(
        isAvailable: Value(!product.isAvailable),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteProduct(int id) {
    return (delete(products)..where((p) => p.id.equals(id))).go();
  }

  Future<List<MenuProduct>> getAllAvailableForMenu() async {
    final rows = await (select(products).join([
      innerJoin(categories, categories.id.equalsExp(products.categoryId)),
    ])
          ..where(
            products.isAvailable.equals(true) &
                categories.isActive.equals(true),
          )
          ..orderBy([
            OrderingTerm.asc(products.sortOrder),
            OrderingTerm.asc(products.name),
          ]))
        .get();

    final variantsByProduct =
        await attachedDatabase.productVariantsDao.getAllVariantsGrouped();

    return rows.map((row) {
      final product = row.readTable(products);
      final availableVariants = (variantsByProduct[product.id] ?? [])
          .where((variant) => variant.isAvailable)
          .map(
            (variant) => MenuProductVariant(
              id: variant.id,
              name: variant.name,
              priceInPaisa: variant.priceInPaisa,
            ),
          )
          .toList();

      return MenuProduct(
        id: product.id,
        name: product.name,
        priceInPaisa: product.priceInPaisa,
        categoryId: product.categoryId,
        categoryName: row.readTable(categories).name,
        categoryColor: row.readTable(categories).color,
        imagePath: product.imagePath,
        variants: availableVariants,
      );
    }).toList();
  }
}
