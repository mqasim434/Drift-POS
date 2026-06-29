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

class ProductGridCard extends ConsumerWidget {
  const ProductGridCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductWithCategory item;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final categoryColor = ColorUtils.fromHex(item.categoryColor);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 13,
            child: ProductImageWidget(
              imagePath: product.imagePath,
              productName: product.name,
              placeholderColor: categoryColor,
              borderRadius: 0,
              fill: true,
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.sm,
                AppSizes.sm,
                AppSizes.sm,
                AppSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.categoryName,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          CurrencyFormatter.format(product.priceInPaisa),
                          style: AppTextStyles.price.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: product.isAvailable,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (_) => ref
                              .read(productsNotifierProvider.notifier)
                              .toggleAvailability(product.id),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionChip(
                        icon: Icons.edit_outlined,
                        tooltip: 'Edit',
                        onPressed: () => onEdit(product),
                      ),
                      const SizedBox(width: AppSizes.xs),
                      _ActionChip(
                        icon: Icons.delete_outline,
                        tooltip: 'Delete',
                        color: AppColors.danger,
                        onPressed: () => onDelete(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.accent,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xs),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProductWithCategory> items;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 5 : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSizes.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
            childAspectRatio: 0.82,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ProductGridCard(
              item: items[index],
              onEdit: onEdit,
              onDelete: onDelete,
            );
          },
        );
      },
    );
  }
}
