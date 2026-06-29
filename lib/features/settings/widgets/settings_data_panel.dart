import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/models/orders_date_range.dart';
import '../../../core/services/database_info_service.dart';
import '../../../core/services/orders_csv_export_service.dart';
import '../providers/settings_data_provider.dart';
import 'settings_section.dart';
import 'settings_sql_console_section.dart';

class SettingsDataPanel extends ConsumerStatefulWidget {
  const SettingsDataPanel({super.key});

  @override
  ConsumerState<SettingsDataPanel> createState() => _SettingsDataPanelState();
}

class _SettingsDataPanelState extends ConsumerState<SettingsDataPanel> {
  DateTimeRange? _exportRange;
  int? _databaseSizeBytes;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadDatabaseSize();
  }

  Future<void> _loadDatabaseSize() async {
    final bytes = await DatabaseInfoService.databaseFileSizeBytes();
    if (mounted) setState(() => _databaseSizeBytes = bytes);
  }

  Future<void> _pickExportRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _exportRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );
    if (picked != null) setState(() => _exportRange = picked);
  }

  Future<void> _exportCsv() async {
    if (_exportRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a date range first')),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final range = OrdersDateRange.custom(
        _exportRange!.start,
        _exportRange!.end,
      );
      final orders =
          await ref.read(settingsDataProvider).loadOrdersForExport(range);

      if (orders.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No orders in selected range')),
          );
        }
        return;
      }

      final path = await OrdersCsvExportService.exportOrders(
        orders: orders,
        from: range.from,
        to: range.to,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            path == null
                ? 'Export cancelled'
                : 'Exported ${orders.length} orders',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  String get _exportRangeLabel {
    if (_exportRange == null) return 'No range selected';
    final fmt = DateFormat('dd MMM yyyy');
    return '${fmt.format(_exportRange!.start)} – ${fmt.format(_exportRange!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final dbSizeLabel = _databaseSizeBytes == null
        ? 'Calculating…'
        : DatabaseInfoService.formatFileSize(_databaseSizeBytes!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSection(
          title: 'Export Orders',
          subtitle: 'Download orders as CSV for the selected date range.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date range'),
                subtitle: Text(_exportRangeLabel),
                trailing: OutlinedButton(
                  onPressed: _pickExportRange,
                  child: const Text('Select'),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              ElevatedButton.icon(
                onPressed: _isExporting ? null : _exportCsv,
                icon: _isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: const Text('Export CSV'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        const SettingsSqlConsoleSection(),
        const SizedBox(height: AppSizes.lg),
        SettingsSection(
          title: 'About',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppInfo.name} v${AppInfo.version}'),
              const SizedBox(height: AppSizes.xs),
              Text('Database size: $dbSizeLabel'),
            ],
          ),
        ),
      ],
    );
  }
}
