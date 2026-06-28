import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/category_presets.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/category_icons.dart';
import '../../../core/utils/color_utils.dart';
import '../providers/categories_provider.dart';

class CategoryFormDialog extends ConsumerStatefulWidget {
  const CategoryFormDialog({super.key, this.category});

  final Category? category;

  static Future<void> show(
    BuildContext context, {
    Category? category,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => CategoryFormDialog(category: category),
    );
  }

  @override
  ConsumerState<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _sortOrderController;
  late String _selectedColor;
  late String _selectedIcon;
  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name ?? '');
    _sortOrderController = TextEditingController(
      text: '${category?.sortOrder ?? 0}',
    );
    _selectedColor = category?.color ?? CategoryPresets.colors.first;
    _selectedIcon = category?.icon ?? CategoryPresets.icons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final sortOrder = int.tryParse(_sortOrderController.text.trim()) ?? 0;
      final notifier = ref.read(categoriesNotifierProvider.notifier);

      if (_isEditing) {
        final existing = widget.category!;
        await notifier.updateCategory(
          existing.copyWith(
            name: _nameController.text.trim(),
            color: _selectedColor,
            icon: _selectedIcon,
            sortOrder: sortOrder,
          ),
        );
      } else {
        await notifier.addCategory(
          CategoriesCompanion.insert(
            name: _nameController.text.trim(),
            color: Value(_selectedColor),
            icon: Value(_selectedIcon),
            sortOrder: Value(sortOrder),
          ),
        );
      }

      if (mounted) Navigator.of(context).pop();
    } on CategoryException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Category' : 'Add Category'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text('Color', style: AppTextStyles.label),
                const SizedBox(height: AppSizes.sm),
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    for (final colorHex in CategoryPresets.colors)
                      _ColorSwatch(
                        colorHex: colorHex,
                        isSelected: _selectedColor == colorHex,
                        onTap: () => setState(() => _selectedColor = colorHex),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                Text('Icon', style: AppTextStyles.label),
                const SizedBox(height: AppSizes.sm),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: AppSizes.sm,
                    crossAxisSpacing: AppSizes.sm,
                  ),
                  itemCount: CategoryPresets.icons.length,
                  itemBuilder: (context, index) {
                    final iconName = CategoryPresets.icons[index];
                    final isSelected = _selectedIcon == iconName;
                    return InkWell(
                      onTap: () => setState(() => _selectedIcon = iconName),
                      borderRadius:
                          BorderRadius.circular(AppSizes.buttonRadius),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentBg
                              : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppSizes.buttonRadius),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.border,
                          ),
                        ),
                        child: Icon(
                          CategoryIcons.fromName(iconName),
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _sortOrderController,
                  decoration: const InputDecoration(labelText: 'Sort order'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: AppSizes.md,
                  height: AppSizes.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.colorHex,
    required this.isSelected,
    required this.onTap,
  });

  final String colorHex;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.lg,
        height: AppSizes.lg,
        decoration: BoxDecoration(
          color: ColorUtils.fromHex(colorHex),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
