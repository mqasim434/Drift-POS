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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: ProductImageWidget(
              imagePath: product.imagePath,
              productName: product.name,
              placeholderColor: categoryColor,
              size: 120,
              borderRadius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(item.categoryName, style: AppTextStyles.caption),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.format(product.priceInPaisa),
                      style: AppTextStyles.price,
                    ),
                    const Spacer(),
                    Switch(
                      value: product.isAvailable,
                      onChanged: (_) => ref
                          .read(productsNotifierProvider.notifier)
                          .toggleAvailability(product.id),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => onEdit(product),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => onDelete(product),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        final columns = constraints.maxWidth >= AppSizes.breakpointLg ? 4 : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSizes.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSizes.md,
            mainAxisSpacing: AppSizes.md,
            childAspectRatio: 0.78,
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
