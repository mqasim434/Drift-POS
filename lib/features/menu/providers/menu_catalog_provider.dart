import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/deal_with_items.dart';
import '../../../core/models/menu_catalog.dart';
import '../../../core/providers/database_provider.dart';

/// Sentinel category id — selecting this tab shows deals only.
const menuDealsCategoryFilter = -1;

final menuCatalogProvider =
    AsyncNotifierProvider<MenuCatalogNotifier, MenuCatalog>(
  MenuCatalogNotifier.new,
);

class MenuCatalogNotifier extends AsyncNotifier<MenuCatalog> {
  StreamSubscription<List<Product>>? _productsSub;
  StreamSubscription<List<Deal>>? _dealsSub;
  StreamSubscription<List<DealItem>>? _dealItemsSub;
  StreamSubscription<List<ProductVariant>>? _variantsSub;

  @override
  Future<MenuCatalog> build() async {
    final db = ref.read(databaseProvider);

    _productsSub?.cancel();
    _dealsSub?.cancel();
    _dealItemsSub?.cancel();
    _variantsSub?.cancel();

    _productsSub = db.productsDao.watchAllProducts().listen((_) {
      unawaited(_refresh(db));
    });
    _dealsSub = db.dealsDao.watchAllDeals().listen((_) {
      unawaited(_refresh(db));
    });
    _dealItemsSub = db.select(db.dealItems).watch().listen((_) {
      unawaited(_refresh(db));
    });
    _variantsSub = db.productVariantsDao.watchAllVariants().listen((_) {
      unawaited(_refresh(db));
    });

    ref.onDispose(() {
      _productsSub?.cancel();
      _dealsSub?.cancel();
      _dealItemsSub?.cancel();
      _variantsSub?.cancel();
    });

    return _loadCatalog(db);
  }

  Future<void> _refresh(AppDatabase db) async {
    state = AsyncData(await _loadCatalog(db));
  }

  Future<MenuCatalog> _loadCatalog(AppDatabase db) async {
    final products = await db.productsDao.getAllAvailableForMenu();
    final deals = await db.dealsDao.getAllAvailableWithItems();
    return MenuCatalog(products: products, deals: deals);
  }
}

final menuCategoryFilterProvider = StateProvider<int?>((ref) => null);

final menuSearchProvider = StateProvider<String>((ref) => '');

final menuSearchInputProvider = StateProvider<String>((ref) => '');

final activeTablesProvider = StreamProvider<List<RestaurantTable>>((ref) {
  return ref.watch(databaseProvider).tablesDao.watchAllTables().map(
        (tables) => tables.where((table) => table.isActive).toList(),
      );
});

typedef MenuGridEntry = ({bool isDeal, MenuProduct? product, DealWithItems? deal});

const menuDealsCategoryName = 'Deals';

bool isDealsCategoryName(String name) =>
    name.trim().toLowerCase() == menuDealsCategoryName.toLowerCase();

int? findDealsCategoryId(Iterable<Category> categories) {
  for (final category in categories) {
    if (category.isActive && isDealsCategoryName(category.name)) {
      return category.id;
    }
  }
  return null;
}

List<MenuGridEntry> filterMenuEntries({
  required MenuCatalog catalog,
  required int? categoryId,
  required String searchQuery,
  int? dealsCategoryId,
}) {
  final query = searchQuery.trim().toLowerCase();

  bool matchesDeal(DealWithItems deal) =>
      query.isEmpty || deal.name.toLowerCase().contains(query);

  bool matchesProduct(MenuProduct product) =>
      query.isEmpty || product.name.toLowerCase().contains(query);

  if (categoryId == menuDealsCategoryFilter) {
    return [
      for (final deal in catalog.deals)
        if (matchesDeal(deal)) (isDeal: true, product: null, deal: deal),
    ];
  }

  final showDeals = categoryId == null ||
      (dealsCategoryId != null && categoryId == dealsCategoryId);

  final entries = <MenuGridEntry>[];

  if (showDeals) {
    for (final deal in catalog.deals) {
      if (matchesDeal(deal)) {
        entries.add((isDeal: true, product: null, deal: deal));
      }
    }
  }

  for (final product in catalog.products) {
    if (categoryId != null && product.categoryId != categoryId) continue;
    if (!matchesProduct(product)) continue;
    entries.add((isDeal: false, product: product, deal: null));
  }

  return entries;
}

Map<int, int> categoryProductCounts(MenuCatalog catalog) {
  final counts = <int, int>{};
  for (final product in catalog.products) {
    counts[product.categoryId] = (counts[product.categoryId] ?? 0) + 1;
  }
  return counts;
}
