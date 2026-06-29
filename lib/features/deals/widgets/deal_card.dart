import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/deal_with_items.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/product_image_widget.dart';
import '../providers/deals_provider.dart';

class DealCard extends ConsumerWidget {
  const DealCard({
    super.key,
    required this.deal,
    required this.onEdit,
    required this.onDelete,
  });

  final DealWithItems deal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 120,
            child: deal.imagePath != null
                ? ProductImageWidget(
                    imagePath: deal.imagePath,
                    productName: deal.name,
                    placeholderColor: AppColors.accent,
                    size: 120,
                    borderRadius: 0,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.local_offer_outlined,
                      color: AppColors.textPrimary,
                      size: AppSizes.xxl,
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.name,
                    style: AppTextStyles.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text('Included:', style: AppTextStyles.caption),
                  const SizedBox(height: AppSizes.xs),
                  Wrap(
                    spacing: AppSizes.xs,
                    runSpacing: AppSizes.xs,
                    children: [
                      for (final item in deal.items)
                        Chip(
                          label: Text(
                            item.quantity > 1
                                ? '${item.displayName} x${item.quantity}'
                                : item.displayName,
                            style: AppTextStyles.caption,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(deal.priceInPaisa),
                        style: AppTextStyles.price,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        'Was: ${CurrencyFormatter.format(deal.originalTotalInPaisa)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      Text('Available', style: AppTextStyles.bodySmall),
                      const Spacer(),
                      Switch(
                        value: deal.isAvailable,
                        onChanged: (_) => ref
                            .read(dealsNotifierProvider.notifier)
                            .toggleAvailability(deal.id),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: onDelete,
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
          ),
        ],
      ),
    );
  }
}
