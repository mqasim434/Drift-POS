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

  Future<int> insertDeal(DealsCompanion deal) {
    return into(deals).insert(deal);
  }

  Future<int> insertDealItem(DealItemsCompanion item) {
    return into(dealItems).insert(item);
  }

  Future<bool> updateDeal(Deal deal) {
    return update(deals).replace(deal);
  }

  Future<int> deleteDeal(int id) async {
    await (delete(dealItems)..where((d) => d.dealId.equals(id))).go();
    return (delete(deals)..where((d) => d.id.equals(id))).go();
  }
}
