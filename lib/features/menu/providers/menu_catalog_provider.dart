import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/deal_with_items.dart';
import '../../../core/models/menu_catalog.dart';
import '../../../core/providers/database_provider.dart';

final menuCatalogProvider =
    AsyncNotifierProvider<MenuCatalogNotifier, MenuCatalog>(
  MenuCatalogNotifier.new,
);

class MenuCatalogNotifier extends AsyncNotifier<MenuCatalog> {
  StreamSubscription<List<Product>>? _productsSub;
  StreamSubscription<List<Deal>>? _dealsSub;
  StreamSubscription<List<ProductVariant>>? _variantsSub;

  @override
  Future<MenuCatalog> build() async {
    final db = ref.read(databaseProvider);

    _productsSub?.cancel();
    _dealsSub?.cancel();
    _variantsSub?.cancel();

    _productsSub = db.productsDao.watchAllProducts().listen((_) async {
      state = AsyncData(await _loadCatalog(db));
    });
    _dealsSub = db.dealsDao.watchAllDeals().listen((_) async {
      state = AsyncData(await _loadCatalog(db));
    });
    _variantsSub = db.productVariantsDao.watchAllVariants().listen((_) async {
      state = AsyncData(await _loadCatalog(db));
    });

    ref.onDispose(() {
      _productsSub?.cancel();
      _dealsSub?.cancel();
      _variantsSub?.cancel();
    });

    return _loadCatalog(db);
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

List<MenuGridEntry> filterMenuEntries({
  required MenuCatalog catalog,
  required int? categoryId,
  required String searchQuery,
}) {
  final query = searchQuery.trim().toLowerCase();
  final entries = <MenuGridEntry>[];

  for (final product in catalog.products) {
    if (categoryId != null && product.categoryId != categoryId) continue;
    if (query.isNotEmpty && !product.name.toLowerCase().contains(query)) {
      continue;
    }
    entries.add((isDeal: false, product: product, deal: null));
  }

  if (categoryId == null) {
    for (final deal in catalog.deals) {
      if (query.isNotEmpty && !deal.name.toLowerCase().contains(query)) {
        continue;
      }
      entries.add((isDeal: true, product: null, deal: deal));
    }
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
