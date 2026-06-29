import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/debounced_search_field.dart';
import '../models/deal_form_state.dart';

Future<DealAddProductInput?> showDealAddProductDialog(
  BuildContext context,
  WidgetRef ref,
) {
  return showDialog<DealAddProductInput>(
    context: context,
    builder: (context) => const _DealAddProductDialog(),
  );
}

class _DealAddProductDialog extends ConsumerStatefulWidget {
  const _DealAddProductDialog();

  @override
  ConsumerState<_DealAddProductDialog> createState() =>
      _DealAddProductDialogState();
}

class _DealAddProductDialogState extends ConsumerState<_DealAddProductDialog> {
  List<Product> _products = [];
  Map<int, List<ProductVariant>> _variantsByProduct = {};
  bool _isLoading = true;
  String _searchQuery = '';
  Product? _selectedProduct;
  int? _selectedVariantId;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    final db = ref.read(databaseProvider);
    final products = await db.productsDao.watchAllProducts().first;
    final variantsByProduct =
        await db.productVariantsDao.getAllVariantsGrouped();
    if (!mounted) return;
    setState(() {
      _products = products.where((p) => p.isAvailable).toList();
      _variantsByProduct = variantsByProduct;
      _isLoading = false;
    });
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    final query = _searchQuery.toLowerCase();
    return _products
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();
  }

  List<ProductVariant> get _selectedVariants {
    final product = _selectedProduct;
    if (product == null) return const [];
    return _variantsByProduct[product.id] ?? const [];
  }

  int get _previewPriceInPaisa {
    final product = _selectedProduct;
    if (product == null) return 0;
    if (_selectedVariantId != null) {
      for (final variant in _selectedVariants) {
        if (variant.id == _selectedVariantId) return variant.priceInPaisa;
      }
    }
    return product.priceInPaisa;
  }

  void _selectProduct(Product product) {
    final variants = _variantsByProduct[product.id] ?? const [];
    setState(() {
      _selectedProduct = product;
      _selectedVariantId = variants.isNotEmpty ? variants.first.id : null;
      _quantity = 1;
    });
  }

  void _submit() {
    final product = _selectedProduct;
    if (product == null) return;

    final variants = _selectedVariants;
    if (variants.isNotEmpty && _selectedVariantId == null) return;

    Navigator.of(context).pop(
      DealAddProductInput(
        product: product,
        variants: variants,
        variantId: _selectedVariantId,
        quantity: _quantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSizes.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.md,
                AppSizes.sm,
                AppSizes.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Add Product', style: AppTextStyles.title),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: DebouncedSearchField(
                hintText: 'Search products...',
                width: double.infinity,
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products found.',
                            style: AppTextStyles.bodySmall,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                          ),
                          itemCount: _filteredProducts.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            final isSelected =
                                _selectedProduct?.id == product.id;
                            final variants =
                                _variantsByProduct[product.id] ?? const [];
                            final priceLabel = variants.isEmpty
                                ? CurrencyFormatter.format(
                                    product.priceInPaisa,
                                  )
                                : 'From ${CurrencyFormatter.format(product.priceInPaisa)}';

                            return ListTile(
                              selected: isSelected,
                              selectedTileColor:
                                  AppColors.accentBg.withValues(alpha: 0.5),
                              title: Text(
                                product.name,
                                style: AppTextStyles.body,
                              ),
                              subtitle: Text(
                                priceLabel,
                                style: AppTextStyles.caption,
                              ),
                              onTap: () => _selectProduct(product),
                            );
                          },
                        ),
            ),
            if (_selectedProduct != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _selectedProduct!.name,
                      style: AppTextStyles.subtitle,
                    ),
                    if (_selectedVariants.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.sm),
                      DropdownButtonFormField<int>(
                        value: _selectedVariantId ??
                            _selectedVariants.first.id,
                        decoration: const InputDecoration(
                          labelText: 'Size / variant',
                          isDense: true,
                        ),
                        items: [
                          for (final variant in _selectedVariants)
                            DropdownMenuItem(
                              value: variant.id,
                              child: Text(
                                '${variant.name} — '
                                '${CurrencyFormatter.format(variant.priceInPaisa)}',
                              ),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedVariantId = value),
                      ),
                    ],
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Text('Quantity', style: AppTextStyles.bodySmall),
                        const Spacer(),
                        IconButton(
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$_quantity', style: AppTextStyles.body),
                        IconButton(
                          onPressed: _quantity < 99
                              ? () => setState(() => _quantity++)
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          CurrencyFormatter.format(
                            _previewPriceInPaisa * _quantity,
                          ),
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add),
                      label: const Text('Add to Deal'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
