import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/product_variants.dart';

part 'product_variants_dao.g.dart';

@DriftAccessor(tables: [ProductVariants])
class ProductVariantsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductVariantsDaoMixin {
  ProductVariantsDao(super.db);

  Stream<List<ProductVariant>> watchAllVariants() {
    return select(productVariants).watch();
  }

  Future<List<ProductVariant>> getVariantsForProduct(int productId) {
    return (select(productVariants)
          ..where((v) => v.productId.equals(productId))
          ..orderBy([
            (v) => OrderingTerm.asc(v.sortOrder),
            (v) => OrderingTerm.asc(v.name),
          ]))
        .get();
  }

  Future<Map<int, List<ProductVariant>>> getAllVariantsGrouped() async {
    final rows = await (select(productVariants)
          ..orderBy([
            (v) => OrderingTerm.asc(v.sortOrder),
            (v) => OrderingTerm.asc(v.name),
          ]))
        .get();

    final grouped = <int, List<ProductVariant>>{};
    for (final variant in rows) {
      grouped.putIfAbsent(variant.productId, () => []).add(variant);
    }
    return grouped;
  }

  Future<void> replaceVariantsForProduct(
    int productId,
    List<ProductVariantsCompanion> variants,
  ) async {
    await (delete(productVariants)..where((v) => v.productId.equals(productId)))
        .go();
    if (variants.isEmpty) return;
    await batch((batch) {
      batch.insertAll(productVariants, variants);
    });
  }

  Future<int> deleteVariantsForProduct(int productId) {
    return (delete(productVariants)..where((v) => v.productId.equals(productId)))
        .go();
  }
}
