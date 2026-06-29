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
import '../../shared/widgets/debounced_search_field.dart';
import '../../shared/widgets/product_image_widget.dart';
import 'models/deal_form_state.dart';
import 'providers/deals_provider.dart';

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
                onAvailableChanged:
                    ref.read(dealFormProvider.notifier).setAvailable,
                onPaisaChanged:
                    ref.read(dealFormProvider.notifier).setPriceInPaisa,
              ),
              const SizedBox(height: AppSizes.lg),
              _ProductSelectorSection(
                items: form.filteredItems,
                onSearch: ref.read(dealFormProvider.notifier).setSearchQuery,
                onToggle: ref.read(dealFormProvider.notifier).toggleProduct,
                onQuantityChanged:
                    ref.read(dealFormProvider.notifier).setQuantity,
              ),
              const SizedBox(height: AppSizes.lg),
              _DealSummarySection(
                selectedItems: form.selectedItems,
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

class _ProductSelectorSection extends StatelessWidget {
  const _ProductSelectorSection({
    required this.items,
    required this.onSearch,
    required this.onToggle,
    required this.onQuantityChanged,
  });

  final List<DealItemDraft> items;
  final ValueChanged<String> onSearch;
  final void Function(int productId, bool selected) onToggle;
  final void Function(int productId, int quantity) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Products', style: AppTextStyles.title),
            const SizedBox(height: AppSizes.md),
            DebouncedSearchField(
              hintText: 'Search products...',
              width: double.infinity,
              onChanged: onSearch,
            ),
            const SizedBox(height: AppSizes.md),
            if (items.isEmpty)
              Text('No products match your search.', style: AppTextStyles.bodySmall)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: item.selected,
                    onChanged: (value) =>
                        onToggle(item.product.id, value ?? false),
                    title: Text(item.product.name, style: AppTextStyles.body),
                    subtitle: Text(
                      CurrencyFormatter.format(item.product.priceInPaisa),
                      style: AppTextStyles.caption,
                    ),
                    secondary: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: item.selected && item.quantity > 1
                                ? () => onQuantityChanged(
                                      item.product.id,
                                      item.quantity - 1,
                                    )
                                : null,
                          ),
                          Text('${item.quantity}', style: AppTextStyles.body),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: item.selected
                                ? () => onQuantityChanged(
                                      item.product.id,
                                      item.quantity + 1,
                                    )
                                : null,
                          ),
                        ],
                      ),
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
    required this.selectedItems,
    required this.dealPriceInPaisa,
    required this.originalTotalInPaisa,
    required this.savingsInPaisa,
  });

  final List<DealItemDraft> selectedItems;
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
            if (selectedItems.isEmpty)
              Text(
                'Select at least 2 products.',
                style: AppTextStyles.bodySmall,
              )
            else
              Column(
                children: [
                  for (final item in selectedItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.name} x${item.quantity}',
                              style: AppTextStyles.body,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              item.product.priceInPaisa * item.quantity,
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
