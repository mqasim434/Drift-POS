import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/utils/currency_formatter.dart';

class AnalyticsSummaryTable extends StatelessWidget {
  const AnalyticsSummaryTable({
    super.key,
    required this.rows,
  });

  final List<DailyAnalyticsSummary> rows;

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.reversed.toList();

    if (visibleRows.every((row) => row.orderCount == 0)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Text('No orders in this period', style: AppTextStyles.bodySmall),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width - AppSizes.lg * 2,
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.surfaceElevated),
          dataRowMinHeight: AppSizes.controlHeight,
          dataRowMaxHeight: AppSizes.controlHeightLg,
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Orders')),
            DataColumn(label: Text('Revenue')),
            DataColumn(label: Text('Avg Order')),
            DataColumn(label: Text('Dine In')),
            DataColumn(label: Text('Take Away')),
            DataColumn(label: Text('Delivery')),
          ],
          rows: [
            for (final row in visibleRows)
              if (row.orderCount > 0)
                DataRow(
                  cells: [
                    DataCell(Text(DateFormat('d MMM yyyy').format(row.date))),
                    DataCell(Text('${row.orderCount}')),
                    DataCell(Text(CurrencyFormatter.format(row.revenueInPaisa))),
                    DataCell(Text(CurrencyFormatter.format(row.avgOrderInPaisa))),
                    DataCell(Text('${row.dineInCount}')),
                    DataCell(Text('${row.takeawayCount}')),
                    DataCell(Text('${row.deliveryCount}')),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
