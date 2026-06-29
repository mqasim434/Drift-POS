import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/deal_with_items.dart';
import '../../../core/providers/database_provider.dart';
import '../models/deal_form_state.dart';

class DealException implements Exception {
  DealException(this.message);

  final String message;

  @override
  String toString() => message;
}

final dealsWithItemsProvider =
    StreamProvider<List<DealWithItems>>((ref) async* {
  final db = ref.watch(databaseProvider);
  await for (final deals in db.dealsDao.watchAllDeals()) {
    final loaded = <DealWithItems>[];
    for (final deal in deals) {
      final withItems = await db.dealsDao.getDealWithItems(deal.id);
      if (withItems != null) loaded.add(withItems);
    }
    yield loaded;
  }
});

final dealFormProvider =
    NotifierProvider<DealFormNotifier, DealFormState>(DealFormNotifier.new);

class DealFormNotifier extends Notifier<DealFormState> {
  @override
  DealFormState build() => const DealFormState();

  Future<void> initializeForCreate() async {
    state = const DealFormState(isLoading: true);
    final products =
        await ref.read(databaseProvider).productsDao.watchAllProducts().first;
    state = DealFormState(
      items: products
          .map((product) => DealItemDraft(product: product))
          .toList(),
      isLoaded: true,
    );
  }

  Future<void> loadDeal(int dealId) async {
    state = state.copyWith(isLoading: true);
    final db = ref.read(databaseProvider);
    final deal = await db.dealsDao.getDealWithItems(dealId);
    if (deal == null) {
      state = const DealFormState(isLoaded: true);
      return;
    }

    final allProducts = await db.productsDao.watchAllProducts().first;
    final selectedIds = {
      for (final item in deal.items) item.product.id: item.quantity,
    };

    state = DealFormState(
      dealId: deal.id,
      name: deal.name,
      description: deal.description ?? '',
      imagePath: deal.imagePath,
      priceInPaisa: deal.priceInPaisa,
      isAvailable: deal.isAvailable,
      items: allProducts
          .map(
            (product) => DealItemDraft(
              product: product,
              selected: selectedIds.containsKey(product.id),
              quantity: selectedIds[product.id] ?? 1,
            ),
          )
          .toList(),
      isLoaded: true,
    );
  }

  void setName(String value) => state = state.copyWith(name: value);

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void setImagePath(String? path) =>
      state = state.copyWith(imagePath: path, clearImage: path == null);

  void setPriceInPaisa(int paisa) =>
      state = state.copyWith(priceInPaisa: paisa);

  void setAvailable(bool value) => state = state.copyWith(isAvailable: value);

  void setSearchQuery(String value) =>
      state = state.copyWith(searchQuery: value);

  void toggleProduct(int productId, bool selected) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(selected: selected, quantity: selected ? item.quantity : 1)
          else
            item,
      ],
    );
  }

  void setQuantity(int productId, int quantity) {
    final safeQuantity = quantity.clamp(1, 99);
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(quantity: safeQuantity, selected: true)
          else
            item,
      ],
    );
  }

  Future<void> save() async {
    final name = state.name.trim();
    if (name.isEmpty) {
      throw DealException('Deal name is required.');
    }
    if (state.priceInPaisa <= 0) {
      throw DealException('Deal price must be greater than zero.');
    }
    if (state.selectedItems.length < 2) {
      throw DealException('Select at least 2 products for this deal.');
    }

    final db = ref.read(databaseProvider);
    if (await db.dealsDao.nameExists(name, excludeId: state.dealId)) {
      throw DealException('A deal named "$name" already exists.');
    }

    state = state.copyWith(isSaving: true);
    try {
      await db.dealsDao.saveDealWithItems(
        dealId: state.dealId,
        name: name,
        description:
            state.description.trim().isEmpty ? null : state.description.trim(),
        priceInPaisa: state.priceInPaisa,
        imagePath: state.imagePath,
        isAvailable: state.isAvailable,
        items: [
          for (final item in state.selectedItems)
            (productId: item.product.id, quantity: item.quantity),
        ],
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final dealsNotifierProvider =
    AsyncNotifierProvider<DealsNotifier, void>(DealsNotifier.new);

class DealsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggleAvailability(int id) async {
    await ref.read(databaseProvider).dealsDao.toggleAvailability(id);
  }

  Future<void> deleteDeal(int id) async {
    await ref.read(databaseProvider).dealsDao.deleteDeal(id);
  }
}
