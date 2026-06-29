import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/models/shop_settings.dart';
import '../../../core/providers/shop_settings_provider.dart';
import '../../../core/services/receipt_service.dart';
import '../providers/printers_provider.dart';
import 'settings_section.dart';

class SettingsPrinterPanel extends ConsumerWidget {
  const SettingsPrinterPanel({super.key, required this.settings});

  final ShopSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printersAsync = ref.watch(systemPrintersProvider);

    return SettingsSection(
      title: 'Printer',
      subtitle: 'Select the default thermal printer for receipts.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          printersAsync.when(
            data: (printers) {
              if (printers.isEmpty) {
                return Text(
                  'No printers found. Use Test Print to open the system print dialog.',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }

              final selectedUrl = settings.defaultPrinterUrl;
              return DropdownButtonFormField<String?>(
                value: printers.any((p) => p.url == selectedUrl)
                    ? selectedUrl
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Default printer',
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('System default (ask each time)'),
                  ),
                  for (final printer in printers)
                    DropdownMenuItem<String?>(
                      value: printer.url,
                      child: Text(
                        printer.isDefault
                            ? '${printer.name} (default)'
                            : printer.name,
                      ),
                    ),
                ],
                onChanged: (url) {
                  ref.read(shopSettingsNotifierProvider.notifier).patch(
                        (current) => url == null
                            ? current.copyWith(clearDefaultPrinterUrl: true)
                            : current.copyWith(defaultPrinterUrl: url),
                      );
                },
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text(error.toString()),
          ),
          const SizedBox(height: AppSizes.lg),
          OutlinedButton.icon(
            onPressed: () async {
              await ref
                  .read(receiptServiceProvider)
                  .printTestReceipt(settings);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test receipt sent to printer')),
                );
              }
            },
            icon: const Icon(Icons.print_outlined),
            label: const Text('Test Print'),
          ),
        ],
      ),
    );
  }
}
