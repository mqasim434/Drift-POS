import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/image_storage_service.dart';
import '../../../shared/widgets/currency_input_field.dart';
import '../../../shared/widgets/product_image_widget.dart';
import '../../categories/providers/categories_provider.dart';
import '../../../core/models/product_variant_input.dart';
import '../providers/products_provider.dart';
import 'product_variants_editor.dart';

class ProductFormSheet extends ConsumerStatefulWidget {
  const ProductFormSheet({
    super.key,
    required this.product,
    required this.onClose,
  });

  final Product? product;
  final VoidCallback onClose;

  @override
  ConsumerState<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends ConsumerState<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceFieldKey = GlobalKey<FormFieldState<int>>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortOrderController;

  int? _categoryId;
  String? _imagePath;
  bool _isAvailable = true;
  bool _isSaving = false;
  List<ProductVariantInput> _variants = [];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController =
        TextEditingController(text: product?.description ?? '');
    _sortOrderController =
        TextEditingController(text: '${product?.sortOrder ?? 0}');
    _categoryId = product?.categoryId;
    _imagePath = product?.imagePath;
    _isAvailable = product?.isAvailable ?? true;

    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadVariants());
    }
  }

  Future<void> _loadVariants() async {
    final variants = await ref
        .read(productVariantsProvider(widget.product!.id).future);
    if (!mounted) return;
    setState(() {
      _variants = [
        for (final variant in variants)
          ProductVariantInput(
            id: variant.id,
            name: variant.name,
            priceInPaisa: variant.priceInPaisa,
            sortOrder: variant.sortOrder,
          ),
      ];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageStorageService.pickAndSaveProductImage();
    if (path != null && mounted) {
      setState(() => _imagePath = path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final priceInPaisa = _priceFieldKey.currentState?.value ?? 0;
    if (priceInPaisa <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    final categoryId = _resolvedCategoryId(
      ref.read(categoriesProvider).valueOrNull ?? [],
    );
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    for (final variant in _variants) {
      final hasName = variant.name.trim().isNotEmpty;
      final hasPrice = variant.priceInPaisa > 0;
      if (hasName != hasPrice) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Each variant needs both a name and a price'),
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final sortOrder = int.tryParse(_sortOrderController.text.trim()) ?? 0;
      final notifier = ref.read(productsNotifierProvider.notifier);

      if (_isEditing) {
        await notifier.updateProduct(
          widget.product!.copyWith(
            name: _nameController.text.trim(),
            description: Value(_descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim()),
            categoryId: categoryId,
            priceInPaisa: priceInPaisa,
            imagePath: Value(_imagePath),
            isAvailable: _isAvailable,
            sortOrder: sortOrder,
            updatedAt: DateTime.now(),
          ),
          variants: _variants,
        );
      } else {
        await notifier.addProduct(
          ProductsCompanion.insert(
            name: _nameController.text.trim(),
            description: Value(
              _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
            ),
            categoryId: categoryId,
            priceInPaisa: priceInPaisa,
            imagePath: Value(_imagePath),
            isAvailable: Value(_isAvailable),
            sortOrder: Value(sortOrder),
          ),
          variants: _variants,
        );
      }

      widget.onClose();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  int? _resolvedCategoryId(List<Category> categories) {
    if (_categoryId != null &&
        categories.any((category) => category.id == _categoryId)) {
      return _categoryId;
    }
    if (categories.isEmpty) return null;
    return categories.first.id;
  }

  Widget _buildCategoryField(List<Category> categories) {
    final selectedId = _resolvedCategoryId(categories);

    return DropdownButtonFormField<int>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Category'),
      items: [
        for (final category in categories)
          DropdownMenuItem(
            value: category.id,
            child: Text(category.name),
          ),
      ],
      onChanged: categories.isEmpty
          ? null
          : (value) => setState(() => _categoryId = value),
      validator: (value) => value == null ? 'Category is required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Material(
      elevation: 8,
      color: AppColors.surfaceElevated,
      child: SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? 'Edit Product' : 'Add Product',
                      style: AppTextStyles.title,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ProductImageWidget(
                          imagePath: _imagePath,
                          productName: _nameController.text.isEmpty
                              ? 'Product'
                              : _nameController.text,
                          size: 96,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Choose Image'),
                      ),
                      const SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),
                      categoriesAsync.when(
                        data: _buildCategoryField,
                        loading: () =>
                            const LinearProgressIndicator(minHeight: 2),
                        error: (error, _) => Text(error.toString()),
                      ),
                      const SizedBox(height: AppSizes.md),
                      CurrencyInputField(
                        key: _priceFieldKey,
                        initialPaisa: widget.product?.priceInPaisa ?? 0,
                      ),
                      const SizedBox(height: AppSizes.md),
                      ProductVariantsEditor(
                        variants: _variants,
                        onChanged: (variants) =>
                            setState(() => _variants = variants),
                      ),
                      const SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _sortOrderController,
                        decoration:
                            const InputDecoration(labelText: 'Sort order'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSizes.md),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Available'),
                        value: _isAvailable,
                        onChanged: (value) =>
                            setState(() => _isAvailable = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : widget.onClose,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: AppSizes.md,
                              height: AppSizes.md,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Save' : 'Add'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
