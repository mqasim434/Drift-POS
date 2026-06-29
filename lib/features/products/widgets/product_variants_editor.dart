import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/product_variant_input.dart';
import '../../../shared/widgets/currency_input_field.dart';

class ProductVariantsEditor extends StatefulWidget {
  const ProductVariantsEditor({
    super.key,
    required this.variants,
    required this.onChanged,
  });

  final List<ProductVariantInput> variants;
  final ValueChanged<List<ProductVariantInput>> onChanged;

  @override
  State<ProductVariantsEditor> createState() => _ProductVariantsEditorState();
}

class _ProductVariantsEditorState extends State<ProductVariantsEditor> {
  late List<ProductVariantInput> _variants;

  @override
  void initState() {
    super.initState();
    _variants = List.of(widget.variants);
  }

  @override
  void didUpdateWidget(covariant ProductVariantsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variants != widget.variants) {
      _variants = List.of(widget.variants);
    }
  }

  void _notify() => widget.onChanged(List.of(_variants));

  void _addVariant() {
    setState(() {
      _variants = [
        ..._variants,
        ProductVariantInput(name: '', priceInPaisa: 0, sortOrder: _variants.length),
      ];
    });
    _notify();
  }

  void _removeVariant(int index) {
    setState(() {
      _variants = [
        for (var i = 0; i < _variants.length; i++)
          if (i != index) _variants[i],
      ];
    });
    _notify();
  }

  void _updateVariant(int index, ProductVariantInput variant) {
    setState(() {
      _variants = [
        for (var i = 0; i < _variants.length; i++)
          if (i == index) variant else _variants[i],
      ];
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Variants', style: AppTextStyles.subtitle),
            ),
            TextButton.icon(
              onPressed: _addVariant,
              icon: const Icon(Icons.add, size: AppSizes.md),
              label: const Text('Add variant'),
            ),
          ],
        ),
        Text(
          'Optional sizes or options with their own prices.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSizes.sm),
        if (_variants.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'No variants — customers order at the base price.',
              style: AppTextStyles.bodySmall,
            ),
          )
        else
          for (var i = 0; i < _variants.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _VariantRow(
                key: ValueKey('variant_$i'),
                variant: _variants[i],
                onChanged: (variant) => _updateVariant(i, variant),
                onRemove: () => _removeVariant(i),
              ),
            ),
      ],
    );
  }
}

class _VariantRow extends StatefulWidget {
  const _VariantRow({
    super.key,
    required this.variant,
    required this.onChanged,
    required this.onRemove,
  });

  final ProductVariantInput variant;
  final ValueChanged<ProductVariantInput> onChanged;
  final VoidCallback onRemove;

  @override
  State<_VariantRow> createState() => _VariantRowState();
}

class _VariantRowState extends State<_VariantRow> {
  late final TextEditingController _nameController;
  final _priceFieldKey = GlobalKey<FormFieldState<int>>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.variant.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.inputRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Variant name',
                    hintText: 'e.g. Large',
                    isDense: true,
                  ),
                  onChanged: (value) => widget.onChanged(
                    widget.variant.copyWith(name: value),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remove variant',
                onPressed: widget.onRemove,
                icon: const Icon(Icons.close, color: AppColors.danger),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          CurrencyInputField(
            key: _priceFieldKey,
            initialPaisa: widget.variant.priceInPaisa,
            labelText: 'Variant price',
            onPaisaChanged: (paisa) =>
                widget.onChanged(widget.variant.copyWith(priceInPaisa: paisa)),
          ),
        ],
      ),
    );
  }
}
