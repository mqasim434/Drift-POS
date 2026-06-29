import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/utils/currency_formatter.dart';

class AnalyticsTopProductsCharts extends StatelessWidget {
  const AnalyticsTopProductsCharts({
    super.key,
    required this.byQuantity,
    required this.byRevenue,
  });

  final List<ProductSalesCount> byQuantity;
  final List<ProductSalesCount> byRevenue;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth >= AppSizes.breakpointMd;

        if (sideBySide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProductChartPanel(
                  title: 'By quantity',
                  products: byQuantity,
                  valueLabel: (product) => '${product.quantity} sold',
                  valueForBar: (product) => product.quantity.toDouble(),
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _ProductChartPanel(
                  title: 'By revenue',
                  products: byRevenue,
                  valueLabel: (product) =>
                      CurrencyFormatter.format(product.revenueInPaisa),
                  valueForBar: (product) =>
                      CurrencyFormatter.paisaToRupees(product.revenueInPaisa),
                  color: AppColors.accent,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _ProductChartPanel(
              title: 'By quantity',
              products: byQuantity,
              valueLabel: (product) => '${product.quantity} sold',
              valueForBar: (product) => product.quantity.toDouble(),
              color: AppColors.info,
            ),
            const SizedBox(height: AppSizes.md),
            _ProductChartPanel(
              title: 'By revenue',
              products: byRevenue,
              valueLabel: (product) =>
                  CurrencyFormatter.format(product.revenueInPaisa),
              valueForBar: (product) =>
                  CurrencyFormatter.paisaToRupees(product.revenueInPaisa),
              color: AppColors.accent,
            ),
          ],
        );
      },
    );
  }
}

class _ProductChartPanel extends StatelessWidget {
  const _ProductChartPanel({
    required this.title,
    required this.products,
    required this.valueLabel,
    required this.valueForBar,
    required this.color,
  });

  final String title;
  final List<ProductSalesCount> products;
  final String Function(ProductSalesCount product) valueLabel;
  final double Function(ProductSalesCount product) valueForBar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.subtitle),
            const SizedBox(height: AppSizes.lg),
            Text('No product data', style: AppTextStyles.bodySmall),
          ],
        ),
      );
    }

    final maxValue = products
        .map(valueForBar)
        .fold<double>(0, (max, value) => value > max ? value : max);

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSizes.md),
          for (final product in products)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _HorizontalBarRow(
                label: _truncate(product.productName),
                valueLabel: valueLabel(product),
                fraction: maxValue == 0 ? 0 : valueForBar(product) / maxValue,
                color: color,
              ),
            ),
        ],
      ),
    );
  }

  String _truncate(String value) =>
      value.length <= 20 ? value : '${value.substring(0, 17)}...';
}

class _HorizontalBarRow extends StatelessWidget {
  const _HorizontalBarRow({
    required this.label,
    required this.valueLabel,
    required this.fraction,
    required this.color,
  });

  final String label;
  final String valueLabel;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
            Text(valueLabel, style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: AppColors.border,
            color: color,
          ),
        ),
      ],
    );
  }
}
