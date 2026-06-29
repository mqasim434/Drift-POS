import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/deal_with_items.dart';
import '../../../core/providers/database_provider.dart';
import '../models/deal_form_state.dart';
import '../../menu/providers/menu_catalog_provider.dart';

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
  int _nextItemKey = 0;

  @override
  DealFormState build() => const DealFormState();

  String _newItemKey() => 'item_${_nextItemKey++}';

  Future<void> initializeForCreate() async {
    _nextItemKey = 0;
    state = const DealFormState(isLoaded: true);
  }

  Future<void> loadDeal(int dealId) async {
    state = state.copyWith(isLoading: true);
    _nextItemKey = 0;

    final db = ref.read(databaseProvider);
    final deal = await db.dealsDao.getDealWithItems(dealId);
    if (deal == null) {
      state = const DealFormState(isLoaded: true);
      return;
    }

    final variantsByProduct =
        await db.productVariantsDao.getAllVariantsGrouped();

    state = DealFormState(
      dealId: deal.id,
      name: deal.name,
      description: deal.description ?? '',
      imagePath: deal.imagePath,
      priceInPaisa: deal.priceInPaisa,
      isAvailable: deal.isAvailable,
      items: [
        for (final item in deal.items)
          DealItemDraft(
            key: _newItemKey(),
            product: item.product,
            variants: variantsByProduct[item.product.id] ?? const [],
            variantId: item.variant?.id,
            quantity: item.quantity,
          ),
      ],
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

  void addProduct(DealAddProductInput input) {
    var variantId = input.variantId;
    if (input.variants.isNotEmpty && variantId == null) {
      variantId = input.variants.first.id;
    }

    state = state.copyWith(
      items: [
        ...state.items,
        DealItemDraft(
          key: _newItemKey(),
          product: input.product,
          variants: input.variants,
          variantId: variantId,
          quantity: input.quantity.clamp(1, 99),
        ),
      ],
    );
  }

  void removeItem(String key) {
    state = state.copyWith(
      items: state.items.where((item) => item.key != key).toList(),
    );
  }

  void setItemVariant(String key, int? variantId) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.key == key) item.copyWith(variantId: variantId) else item,
      ],
    );
  }

  void setItemQuantity(String key, int quantity) {
    final safeQuantity = quantity.clamp(1, 99);
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.key == key) item.copyWith(quantity: safeQuantity) else item,
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
    if (state.items.isEmpty) {
      throw DealException('Add at least 1 product to this deal.');
    }

    for (final item in state.items) {
      if (item.requiresVariant && item.variantId == null) {
        throw DealException('Select a variant for ${item.product.name}.');
      }
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
          for (final item in state.items)
            (
              productId: item.product.id,
              quantity: item.quantity,
              variantId: item.variantId,
            ),
        ],
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
    ref.invalidate(menuCatalogProvider);
  }
}

final dealsNotifierProvider =
    AsyncNotifierProvider<DealsNotifier, void>(DealsNotifier.new);

class DealsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggleAvailability(int id) async {
    await ref.read(databaseProvider).dealsDao.toggleAvailability(id);
    ref.invalidate(menuCatalogProvider);
  }

  Future<void> deleteDeal(int id) async {
    await ref.read(databaseProvider).dealsDao.deleteDeal(id);
    ref.invalidate(menuCatalogProvider);
  }
}
