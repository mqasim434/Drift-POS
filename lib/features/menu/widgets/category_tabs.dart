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
  });

  final Map<int, int> productCounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(menuCategoryFilterProvider);
    final totalCount = productCounts.values.fold(0, (sum, count) => sum + count);

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: AppSizes.controlHeightLg,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            children: [
              _CategoryTab(
                label: 'All',
                count: totalCount,
                isActive: selectedCategoryId == null,
                onTap: () =>
                    ref.read(menuCategoryFilterProvider.notifier).state = null,
              ),
              for (final category in categories.where((c) => c.isActive))
                _CategoryTab(
                  label: category.name,
                  count: productCounts[category.id] ?? 0,
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
