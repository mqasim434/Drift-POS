import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/category_icons.dart';
import '../../../core/utils/color_utils.dart';
import '../providers/categories_provider.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.viewModel,
    required this.onEdit,
    required this.onDelete,
  });

  final CategoryViewModel viewModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final category = viewModel.category;
    final color = ColorUtils.fromHex(category.color);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: AppSizes.sm,
            color: color,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        CategoryIcons.fromName(category.icon),
                        size: AppSizes.xl,
                        color: color,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          category.name,
                          style: AppTextStyles.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    '${viewModel.productCount} product${viewModel.productCount == 1 ? '' : 's'}',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  const Divider(height: 1),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.textSecondary,
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.danger,
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
