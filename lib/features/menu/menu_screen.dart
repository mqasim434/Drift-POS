import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/models/menu_catalog.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/debounced_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/models/cart_totals.dart';
import '../../core/providers/cart_totals_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_catalog_provider.dart';
import 'widgets/cart_panel.dart';
import 'widgets/category_tabs.dart';
import 'widgets/product_menu_card.dart';
import 'widgets/product_variant_picker_dialog.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  Future<void> _addProductToCart(
    BuildContext context,
    WidgetRef ref,
    MenuProduct product,
  ) async {
    if (product.hasVariants) {
      final variant = await showProductVariantPicker(context, product);
      if (variant == null) return;
      ref.read(cartProvider.notifier).addProduct(product, variant: variant);
      return;
    }

    ref.read(cartProvider.notifier).addProduct(product);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(menuCatalogProvider);
    final categoryId = ref.watch(menuCategoryFilterProvider);
    final searchQuery = ref.watch(menuSearchProvider);
    final shopSettings = ref.watch(currentShopSettingsProvider);

    return FeatureScaffold(
      title: 'Menu',
      body: catalogAsync.when(
        data: (catalog) {
          final entries = filterMenuEntries(
            catalog: catalog,
            categoryId: categoryId,
            searchQuery: searchQuery,
          );
          final counts = categoryProductCounts(catalog);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CategoryTabs(productCounts: counts),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.sm,
                        AppSizes.lg,
                        AppSizes.md,
                      ),
                      child: DebouncedSearchField(
                        hintText: 'Search menu...',
                        width: 300,
                        onChanged: (query) =>
                            ref.read(menuSearchProvider.notifier).state = query,
                      ),
                    ),
                    Expanded(
                      child: entries.isEmpty
                          ? const EmptyState(
                              message: 'No items match your search',
                              icon: Icons.restaurant_menu,
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final columns = width >= 700 ? 5 : 3;

                                return GridView.builder(
                                  padding: const EdgeInsets.all(AppSizes.lg),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: AppSizes.sm,
                                    mainAxisSpacing: AppSizes.sm,
                                    childAspectRatio: 0.82,
                                  ),
                                  itemCount: entries.length,
                                  itemBuilder: (context, index) {
                                    final entry = entries[index];
                                    if (entry.isDeal) {
                                      final deal = entry.deal!;
                                      return ProductMenuCard(
                                        deal: deal,
                                        displayPriceInPaisa: shopSettings
                                            .priceWithOptionalTax(deal.priceInPaisa),
                                        onAdd: () => ref
                                            .read(cartProvider.notifier)
                                            .addDeal(deal),
                                      );
                                    }

                                    final product = entry.product!;
                                    return ProductMenuCard(
                                      product: product,
                                      displayPriceInPaisa: shopSettings
                                          .priceWithOptionalTax(
                                            product.displayPriceInPaisa,
                                          ),
                                      onAdd: () => _addProductToCart(
                                        context,
                                        ref,
                                        product,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              const CartPanel(),
            ],
          );
        },
        loading: () => const Center(child: Text('Loading menu...')),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }
}
