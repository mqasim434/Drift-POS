import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/analytics_date_range.dart';
import '../providers/analytics_provider.dart';

class AnalyticsRangeSelector extends ConsumerWidget {
  const AnalyticsRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(analyticsRangeProvider);

    return PopupMenuButton<AnalyticsRangePreset>(
      tooltip: 'Date range',
      onSelected: (preset) async {
        if (preset == AnalyticsRangePreset.custom) {
          await _pickCustomRange(context, ref);
          return;
        }
        setAnalyticsPreset(ref, preset);
      },
      itemBuilder: (context) => [
        for (final preset in AnalyticsRangePreset.values)
          CheckedPopupMenuItem(
            value: preset,
            checked: current.preset == preset,
            child: Text(_presetLabel(preset)),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.date_range_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.sm),
            Text(current.label, style: AppTextStyles.bodySmall),
            const SizedBox(width: AppSizes.xs),
            const Icon(Icons.expand_more, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  String _presetLabel(AnalyticsRangePreset preset) => switch (preset) {
        AnalyticsRangePreset.last7Days => 'Last 7 days',
        AnalyticsRangePreset.last30Days => 'Last 30 days',
        AnalyticsRangePreset.last90Days => 'Last 90 days',
        AnalyticsRangePreset.thisMonth => 'This month',
        AnalyticsRangePreset.lastMonth => 'Last month',
        AnalyticsRangePreset.custom => 'Custom range',
      };

  Future<void> _pickCustomRange(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final current = ref.read(analyticsRangeProvider);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: current.from,
        end: current.to.subtract(const Duration(days: 1)),
      ),
    );
    if (range == null) return;
    setAnalyticsCustomRange(ref, range.start, range.end);
  }
}
