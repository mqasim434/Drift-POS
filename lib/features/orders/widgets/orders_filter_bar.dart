import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/orders_date_range.dart';
import '../providers/orders_provider.dart';

class OrdersFilterBar extends ConsumerWidget {
  const OrdersFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(ordersFilterProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.sm,
      ),
      child: Wrap(
        spacing: AppSizes.sm,
        runSpacing: AppSizes.sm,
        children: [
          for (final filter in QuickFilter.values)
            _FilterPill(
              label: switch (filter) {
                QuickFilter.today => 'Today',
                QuickFilter.yesterday => 'Yesterday',
                QuickFilter.thisWeek => 'This Week',
                QuickFilter.thisMonth => 'This Month',
                QuickFilter.custom => 'Custom',
              },
              isActive: current.quickFilter == filter,
              onTap: () async {
                if (filter == QuickFilter.custom) {
                  await _pickCustomRange(context, ref);
                  return;
                }
                setOrdersQuickFilter(ref, filter);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: ref.read(ordersFilterProvider).from,
        end: ref.read(ordersFilterProvider).to.subtract(const Duration(days: 1)),
      ),
    );
    if (range == null) return;
    setOrdersCustomRange(ref, range.start, range.end);
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
