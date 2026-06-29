import 'package:drift/drift.dart';

import '../../models/deal_with_items.dart';
import '../app_database.dart';
import '../tables/deal_items.dart';
import '../tables/deals.dart';
import '../tables/products.dart';

part 'deals_dao.g.dart';

@DriftAccessor(tables: [Deals, DealItems, Products])
class DealsDao extends DatabaseAccessor<AppDatabase> with _$DealsDaoMixin {
  DealsDao(super.db);

  Stream<List<Deal>> watchAllDeals() {
    return (select(deals)
          ..orderBy([
            (d) => OrderingTerm.desc(d.createdAt),
            (d) => OrderingTerm.asc(d.name),
          ]))
        .watch();
  }

  Future<DealWithItems?> getDealWithItems(int dealId) async {
    final deal =
        await (select(deals)..where((d) => d.id.equals(dealId))).getSingleOrNull();
    if (deal == null) return null;

    final rows = await (select(dealItems).join([
      innerJoin(products, products.id.equalsExp(dealItems.productId)),
    ])
          ..where(dealItems.dealId.equals(dealId)))
        .get();

    final items = rows
        .map(
          (row) => DealItemDetail(
            quantity: row.readTable(dealItems).quantity,
            product: row.readTable(products),
          ),
        )
        .toList();

    return DealWithItems(
      id: deal.id,
      name: deal.name,
      description: deal.description,
      priceInPaisa: deal.priceInPaisa,
      imagePath: deal.imagePath,
      isAvailable: deal.isAvailable,
      items: items,
    );
  }

  Future<bool> nameExists(String name, {int? excludeId}) async {
    final trimmed = name.trim();
    final results = await (select(deals)..where((d) => d.name.equals(trimmed)))
        .get();
    if (excludeId == null) return results.isNotEmpty;
    return results.any((deal) => deal.id != excludeId);
  }

  Future<int> insertDeal(DealsCompanion deal) {
    return into(deals).insert(deal);
  }

  Future<int> insertDealItem(DealItemsCompanion item) {
    return into(dealItems).insert(item);
  }

  Future<bool> updateDeal(Deal deal) {
    return update(deals).replace(deal);
  }

  Future<int> toggleAvailability(int id) async {
    final deal =
        await (select(deals)..where((d) => d.id.equals(id))).getSingleOrNull();
    if (deal == null) return 0;
    return (update(deals)..where((d) => d.id.equals(id))).write(
      DealsCompanion(isAvailable: Value(!deal.isAvailable)),
    );
  }

  Future<void> saveDealWithItems({
    int? dealId,
    required String name,
    String? description,
    required int priceInPaisa,
    String? imagePath,
    required bool isAvailable,
    required List<({int productId, int quantity})> items,
  }) async {
    await transaction(() async {
      late int savedDealId;

      if (dealId == null) {
        savedDealId = await into(deals).insert(
          DealsCompanion.insert(
            name: name,
            description: Value(description),
            priceInPaisa: priceInPaisa,
            imagePath: Value(imagePath),
            isAvailable: Value(isAvailable),
          ),
        );
      } else {
        savedDealId = dealId;
        await (update(deals)..where((d) => d.id.equals(dealId))).write(
          DealsCompanion(
            name: Value(name),
            description: Value(description),
            priceInPaisa: Value(priceInPaisa),
            imagePath: Value(imagePath),
            isAvailable: Value(isAvailable),
          ),
        );
        await (delete(dealItems)..where((d) => d.dealId.equals(savedDealId)))
            .go();
      }

      for (final item in items) {
        await into(dealItems).insert(
          DealItemsCompanion.insert(
            dealId: savedDealId,
            productId: item.productId,
            quantity: Value(item.quantity),
          ),
        );
      }
    });
  }

  Future<int> deleteDeal(int id) async {
    await (delete(dealItems)..where((d) => d.dealId.equals(id))).go();
    return (delete(deals)..where((d) => d.id.equals(id))).go();
  }
}
