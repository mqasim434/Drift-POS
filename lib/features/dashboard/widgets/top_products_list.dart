import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/dashboard_stats.dart';
import '../../../core/utils/currency_formatter.dart';

class TopProductsList extends StatelessWidget {
  const TopProductsList({
    super.key,
    required this.products,
  });

  final List<TopProductStat> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _EmptyList(
        icon: Icons.emoji_events_outlined,
        message: 'No sales yet today',
      );
    }

    final maxRevenue = products
        .map((product) => product.revenueInPaisa)
        .fold<int>(0, (max, value) => value > max ? value : max);

    return Column(
      children: [
        for (var i = 0; i < products.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == products.length - 1 ? 0 : AppSizes.md,
            ),
            child: _TopProductRow(
              rank: i + 1,
              product: products[i],
              maxRevenueInPaisa: maxRevenue,
            ),
          ),
      ],
    );
  }
}

class _TopProductRow extends StatelessWidget {
  const _TopProductRow({
    required this.rank,
    required this.product,
    required this.maxRevenueInPaisa,
  });

  final int rank;
  final TopProductStat product;
  final int maxRevenueInPaisa;

  @override
  Widget build(BuildContext context) {
    final progress = maxRevenueInPaisa == 0
        ? 0.0
        : product.revenueInPaisa / maxRevenueInPaisa;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _RankBadge(rank: rank),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  product.productName,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CurrencyFormatter.format(product.revenueInPaisa),
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.border,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                '${product.quantity} sold',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final color = switch (rank) {
      1 => AppColors.accent,
      2 => AppColors.textSecondary,
      3 => const Color(0xFFCD7F32),
      _ => AppColors.textMuted,
    };

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textMuted),
          const SizedBox(height: AppSizes.sm),
          Text(message, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
