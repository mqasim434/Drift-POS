import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/models/product_with_category.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/product_image_widget.dart';
import '../providers/products_provider.dart';

class ProductsTableView extends ConsumerWidget {
  const ProductsTableView({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProductWithCategory> items;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(72),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1),
              4: FixedColumnWidth(100),
              5: FixedColumnWidth(120),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(color: AppColors.surfaceElevated),
                children: [
                  _headerCell('Image'),
                  _headerCell('Name'),
                  _headerCell('Category'),
                  _headerCell('Price'),
                  _headerCell('Available'),
                  _headerCell('Actions'),
                ],
              ),
              for (final item in items)
                TableRow(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      child: ProductImageWidget(
                        imagePath: item.product.imagePath,
                        productName: item.product.name,
                        placeholderColor:
                            ColorUtils.fromHex(item.categoryColor),
                        size: AppSizes.controlHeight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Text(item.product.name, style: AppTextStyles.body),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Text(
                        item.categoryName,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Text(
                        CurrencyFormatter.format(item.product.priceInPaisa),
                        style: AppTextStyles.price,
                      ),
                    ),
                    Switch(
                      value: item.product.isAvailable,
                      onChanged: (_) => ref
                          .read(productsNotifierProvider.notifier)
                          .toggleAvailability(item.product.id),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () => onEdit(item.product),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => onDelete(item.product),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Text(label, style: AppTextStyles.label),
    );
  }
}
