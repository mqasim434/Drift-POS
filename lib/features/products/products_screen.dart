import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/database/app_database.dart';
import '../../core/models/product_filter.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/debounced_search_field.dart';
import '../../shared/widgets/empty_state.dart';
import '../categories/providers/categories_provider.dart';
import 'providers/products_provider.dart';
import 'widgets/product_form_sheet.dart';
import 'widgets/products_grid_view.dart';
import 'widgets/products_table_view.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final viewMode = ref.watch(productsViewModeProvider);
    final sheetProduct = ref.watch(productFormOpenProvider);
    final isAdding = ref.watch(productFormAddingProvider);
    final isSheetOpen = isAdding || sheetProduct != null;
    final limit = ref.watch(productsLimitProvider);

    return Stack(
      children: [
        FeatureScaffold(
          title: 'Products',
          actions: [
            ElevatedButton.icon(
              onPressed: () => openProductForm(ref),
              icon: const Icon(Icons.add, size: AppSizes.md),
              label: const Text('Add Product'),
            ),
          ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProductsToolbar(),
              Expanded(
                child: productsAsync.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const EmptyState(
                        message: 'No products found',
                        icon: Icons.inventory_2_outlined,
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: viewMode == ProductsViewMode.table
                              ? ProductsTableView(
                                  items: items,
                                  onEdit: (product) =>
                                      openProductForm(ref, product: product),
                                  onDelete: (product) =>
                                      _confirmDelete(context, ref, product),
                                )
                              : ProductsGridView(
                                  items: items,
                                  onEdit: (product) =>
                                      openProductForm(ref, product: product),
                                  onDelete: (product) =>
                                      _confirmDelete(context, ref, product),
                                ),
                        ),
                        if (items.length >= limit)
                          Padding(
                            padding: const EdgeInsets.all(AppSizes.md),
                            child: OutlinedButton(
                              onPressed: () {
                                ref
                                    .read(productsLimitProvider.notifier)
                                    .state = limit + 50;
                              },
                              child: const Text('Load more'),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isSheetOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => closeProductForm(ref),
              child: Container(color: Colors.black54),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          top: 0,
          bottom: 0,
          right: isSheetOpen ? 0 : -400,
          width: 400,
          child: isSheetOpen
              ? ProductFormSheet(
                  product: sheetProduct,
                  onClose: () => closeProductForm(ref),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete "${product.name}"?',
      confirmLabel: 'Delete',
    );

    if (confirmed == true) {
      await ref.read(productsNotifierProvider.notifier).deleteProduct(
            product.id,
          );
    }
  }
}

class _ProductsToolbar extends ConsumerWidget {
  const _ProductsToolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(productsViewModeProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Wrap(
        spacing: AppSizes.md,
        runSpacing: AppSizes.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DebouncedSearchField(
            onChanged: (query) {
              ref.read(productsFilterProvider.notifier).state = ref
                  .read(productsFilterProvider)
                  .copyWith(searchQuery: query);
              ref.read(productsLimitProvider.notifier).state = 50;
            },
          ),
          SizedBox(
            width: 200,
            child: _CategoryFilterDropdown(),
          ),
          _ViewModeToggle(viewMode: viewMode),
        ],
      ),
    );
  }
}

class _CategoryFilterDropdown extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(productsFilterProvider).categoryId;

    return categoriesAsync.when(
      data: (categories) {
        return DropdownButtonFormField<int?>(
          value: selectedCategoryId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Category',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('All categories'),
            ),
            for (final category in categories)
              DropdownMenuItem<int?>(
                value: category.id,
                child: Text(category.name),
              ),
          ],
          onChanged: (value) => setProductsCategoryFilter(ref, value),
        );
      },
      loading: () => const SizedBox(
        height: AppSizes.controlHeight,
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (error, _) => Text(error.toString()),
    );
  }
}

class _ViewModeToggle extends ConsumerWidget {
  const _ViewModeToggle({required this.viewMode});

  final ProductsViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<ProductsViewMode>(
      segments: const [
        ButtonSegment(
          value: ProductsViewMode.table,
          icon: Icon(Icons.table_rows_outlined),
          label: Text('Table'),
        ),
        ButtonSegment(
          value: ProductsViewMode.grid,
          icon: Icon(Icons.grid_view_outlined),
          label: Text('Grid'),
        ),
      ],
      selected: {viewMode},
      onSelectionChanged: (selection) {
        ref.read(productsViewModeProvider.notifier).state = selection.first;
      },
    );
  }
}
