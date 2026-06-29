import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/image_storage_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/currency_input_field.dart';
import '../../shared/widgets/product_image_widget.dart';
import 'models/deal_form_state.dart';
import 'providers/deals_provider.dart';
import 'widgets/deal_add_product_dialog.dart';

class DealFormScreen extends ConsumerStatefulWidget {
  const DealFormScreen({super.key, this.dealId});

  final int? dealId;

  @override
  ConsumerState<DealFormScreen> createState() => _DealFormScreenState();
}

class _DealFormScreenState extends ConsumerState<DealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadForm());
  }

  Future<void> _loadForm() async {
    final notifier = ref.read(dealFormProvider.notifier);
    if (widget.dealId == null) {
      await notifier.initializeForCreate();
    } else {
      await notifier.loadDeal(widget.dealId!);
    }
    final form = ref.read(dealFormProvider);
    _nameController.text = form.name;
    _descriptionController.text = form.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageStorageService.pickAndSaveProductImage();
    if (path != null) {
      ref.read(dealFormProvider.notifier).setImagePath(path);
    }
  }

  Future<void> _addProduct() async {
    final input = await showDealAddProductDialog(context, ref);
    if (input == null || !mounted) return;
    ref.read(dealFormProvider.notifier).addProduct(input);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(dealFormProvider.notifier).setName(_nameController.text);
    ref
        .read(dealFormProvider.notifier)
        .setDescription(_descriptionController.text);

    try {
      await ref.read(dealFormProvider.notifier).save();
      if (mounted) context.go('/deals');
    } on DealException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(dealFormProvider);
    final notifier = ref.read(dealFormProvider.notifier);

    if (form.isLoading || !form.isLoaded) {
      return FeatureScaffold(
        title: widget.dealId == null ? 'Create Deal' : 'Edit Deal',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FeatureScaffold(
      title: form.isEditing ? 'Edit Deal' : 'Create Deal',
      actions: [
        OutlinedButton(
          onPressed: form.isSaving ? null : () => context.go('/deals'),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: AppSizes.sm),
        ElevatedButton(
          onPressed: form.isSaving ? null : _save,
          child: form.isSaving
              ? const SizedBox(
                  width: AppSizes.md,
                  height: AppSizes.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(form.isEditing ? 'Save Deal' : 'Create Deal'),
        ),
      ],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DealInfoSection(
                nameController: _nameController,
                descriptionController: _descriptionController,
                imagePath: form.imagePath,
                isAvailable: form.isAvailable,
                priceFieldKey: ValueKey(
                  'deal-price-${form.dealId}-${form.priceInPaisa}-${form.isLoaded}',
                ),
                initialPaisa: form.priceInPaisa,
                onPickImage: _pickImage,
                onAvailableChanged: notifier.setAvailable,
                onPaisaChanged: notifier.setPriceInPaisa,
              ),
              const SizedBox(height: AppSizes.lg),
              _DealItemsSection(
                items: form.items,
                onAddProduct: _addProduct,
                onRemove: notifier.removeItem,
                onQuantityChanged: notifier.setItemQuantity,
                onVariantChanged: notifier.setItemVariant,
              ),
              const SizedBox(height: AppSizes.lg),
              _DealSummarySection(
                items: form.items,
                dealPriceInPaisa: form.priceInPaisa,
                originalTotalInPaisa: form.originalTotalInPaisa,
                savingsInPaisa: form.savingsInPaisa,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DealInfoSection extends StatelessWidget {
  const _DealInfoSection({
    required this.nameController,
    required this.descriptionController,
    required this.imagePath,
    required this.isAvailable,
    required this.priceFieldKey,
    required this.initialPaisa,
    required this.onPickImage,
    required this.onAvailableChanged,
    required this.onPaisaChanged,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? imagePath;
  final bool isAvailable;
  final Key priceFieldKey;
  final int initialPaisa;
  final VoidCallback onPickImage;
  final ValueChanged<bool> onAvailableChanged;
  final ValueChanged<int> onPaisaChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deal Info', style: AppTextStyles.title),
            const SizedBox(height: AppSizes.md),
            Center(
              child: ProductImageWidget(
                imagePath: imagePath,
                productName: nameController.text.isEmpty
                    ? 'Deal'
                    : nameController.text,
                placeholderColor: AppColors.accent,
                size: 96,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton.icon(
                onPressed: onPickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('Choose Image'),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Deal name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.md),
            CurrencyInputField(
              key: priceFieldKey,
              initialPaisa: initialPaisa,
              labelText: 'Deal price',
              onPaisaChanged: onPaisaChanged,
            ),
            const SizedBox(height: AppSizes.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Available on menu'),
              value: isAvailable,
              onChanged: onAvailableChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _DealItemsSection extends StatelessWidget {
  const _DealItemsSection({
    required this.items,
    required this.onAddProduct,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.onVariantChanged,
  });

  final List<DealItemDraft> items;
  final VoidCallback onAddProduct;
  final void Function(String key) onRemove;
  final void Function(String key, int quantity) onQuantityChanged;
  final void Function(String key, int? variantId) onVariantChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Deal Items', style: AppTextStyles.title),
                ),
                OutlinedButton.icon(
                  onPressed: onAddProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            if (items.isEmpty)
              Text(
                'No products added yet. Tap Add Product to build this deal.',
                style: AppTextStyles.bodySmall,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: AppTextStyles.body,
                                  ),
                                  const SizedBox(height: AppSizes.xs),
                                  Text(
                                    CurrencyFormatter.format(
                                      item.unitPriceInPaisa * item.quantity,
                                    ),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Decrease quantity',
                                  icon: const Icon(Icons.remove),
                                  onPressed: item.quantity > 1
                                      ? () => onQuantityChanged(
                                            item.key,
                                            item.quantity - 1,
                                          )
                                      : null,
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: AppTextStyles.body,
                                ),
                                IconButton(
                                  tooltip: 'Increase quantity',
                                  icon: const Icon(Icons.add),
                                  onPressed: item.quantity < 99
                                      ? () => onQuantityChanged(
                                            item.key,
                                            item.quantity + 1,
                                          )
                                      : null,
                                ),
                                IconButton(
                                  tooltip: 'Remove',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.danger,
                                  ),
                                  onPressed: () => onRemove(item.key),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (item.variants.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSizes.sm),
                            child: DropdownButtonFormField<int>(
                              value: item.variantId ?? item.variants.first.id,
                              decoration: const InputDecoration(
                                labelText: 'Size / variant',
                                isDense: true,
                              ),
                              items: [
                                for (final variant in item.variants)
                                  DropdownMenuItem(
                                    value: variant.id,
                                    child: Text(
                                      '${variant.name} — '
                                      '${CurrencyFormatter.format(variant.priceInPaisa)}',
                                    ),
                                  ),
                              ],
                              onChanged: (value) =>
                                  onVariantChanged(item.key, value),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DealSummarySection extends StatelessWidget {
  const _DealSummarySection({
    required this.items,
    required this.dealPriceInPaisa,
    required this.originalTotalInPaisa,
    required this.savingsInPaisa,
  });

  final List<DealItemDraft> items;
  final int dealPriceInPaisa;
  final int originalTotalInPaisa;
  final int savingsInPaisa;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceElevated,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary', style: AppTextStyles.title),
            const SizedBox(height: AppSizes.md),
            if (items.isEmpty)
              Text(
                'Add at least 1 product.',
                style: AppTextStyles.bodySmall,
              )
            else
              Column(
                children: [
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.displayName} x${item.quantity}',
                              style: AppTextStyles.body,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              item.unitPriceInPaisa * item.quantity,
                            ),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const Divider(height: AppSizes.lg),
            _summaryRow(
              'Items total',
              CurrencyFormatter.format(originalTotalInPaisa),
            ),
            _summaryRow(
              'Deal price',
              CurrencyFormatter.format(dealPriceInPaisa),
            ),
            _summaryRow(
              'Customer saves',
              CurrencyFormatter.format(savingsInPaisa.clamp(0, 1 << 31)),
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            value,
            style: highlight ? AppTextStyles.price : AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}
