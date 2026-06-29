import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../categories/providers/categories_provider.dart';
import '../providers/menu_catalog_provider.dart';

class CategoryTabs extends ConsumerWidget {
  const CategoryTabs({
    super.key,
    required this.productCounts,
    required this.dealCount,
  });

  final Map<int, int> productCounts;
  final int dealCount;

  int _tabCount({
    required int categoryId,
    required int? dealsCategoryId,
  }) {
    final productCount = productCounts[categoryId] ?? 0;
    if (dealsCategoryId != null &&
        categoryId == dealsCategoryId &&
        dealCount > 0) {
      return productCount + dealCount;
    }
    return productCount;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(menuCategoryFilterProvider);
    final productTotal =
        productCounts.values.fold(0, (sum, count) => sum + count);
    final allCount = productTotal + dealCount;

    return categoriesAsync.when(
      data: (categories) {
        final activeCategories =
            categories.where((category) => category.isActive).toList();
        final dealsCategoryId = findDealsCategoryId(activeCategories);
        final showSyntheticDealsTab = dealCount > 0 && dealsCategoryId == null;

        return SizedBox(
          height: AppSizes.controlHeightLg,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            children: [
              _CategoryTab(
                label: 'All',
                count: allCount,
                isActive: selectedCategoryId == null,
                onTap: () =>
                    ref.read(menuCategoryFilterProvider.notifier).state = null,
              ),
              if (showSyntheticDealsTab)
                _CategoryTab(
                  label: 'Deals',
                  count: dealCount,
                  isActive: selectedCategoryId == menuDealsCategoryFilter,
                  onTap: () => ref
                      .read(menuCategoryFilterProvider.notifier)
                      .state = menuDealsCategoryFilter,
                ),
              for (final category in activeCategories)
                _CategoryTab(
                  label: category.name,
                  count: _tabCount(
                    categoryId: category.id,
                    dealsCategoryId: dealsCategoryId,
                  ),
                  isActive: selectedCategoryId == category.id,
                  onTap: () => ref
                      .read(menuCategoryFilterProvider.notifier)
                      .state = category.id,
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: AppSizes.controlHeightLg),
      error: (error, _) => Text(error.toString()),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accent : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(label, style: AppTextStyles.subtitle.copyWith(color: color)),
              const SizedBox(width: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accentBg : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.badgeRadius),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.caption.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
