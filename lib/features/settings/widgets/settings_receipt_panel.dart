import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/models/shop_settings.dart';
import '../../../core/providers/shop_settings_provider.dart';
import 'settings_section.dart';

class SettingsReceiptPanel extends ConsumerStatefulWidget {
  const SettingsReceiptPanel({super.key, required this.settings});

  final ShopSettings settings;

  @override
  ConsumerState<SettingsReceiptPanel> createState() =>
      _SettingsReceiptPanelState();
}

class _SettingsReceiptPanelState extends ConsumerState<SettingsReceiptPanel> {
  late final TextEditingController _thankYouController;

  @override
  void initState() {
    super.initState();
    _thankYouController =
        TextEditingController(text: widget.settings.thankYouMessage);
  }

  @override
  void didUpdateWidget(covariant SettingsReceiptPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.thankYouMessage != widget.settings.thankYouMessage) {
      _thankYouController.text = widget.settings.thankYouMessage;
    }
  }

  @override
  void dispose() {
    _thankYouController.dispose();
    super.dispose();
  }

  Future<void> _patch(ShopSettings Function(ShopSettings) update) async {
    await ref.read(shopSettingsNotifierProvider.notifier).patch(update);
  }

  Future<void> _saveThankYou() async {
    await _patch(
      (current) => current.copyWith(
        thankYouMessage: _thankYouController.text.trim().isEmpty
            ? ShopSettings.defaults.thankYouMessage
            : _thankYouController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Receipt Options',
      subtitle: 'Control receipt printing behaviour and footer content.',
      child: Column(
        children: [
          SettingsSwitchTile(
            title: 'Auto-print after order',
            subtitle: 'Print receipt automatically when an order is placed.',
            value: widget.settings.autoPrintAfterOrder,
            onChanged: (value) =>
                _patch((current) => current.copyWith(autoPrintAfterOrder: value)),
          ),
          SettingsSwitchTile(
            title: 'Show order type on receipt',
            value: widget.settings.showOrderTypeOnReceipt,
            onChanged: (value) => _patch(
              (current) => current.copyWith(showOrderTypeOnReceipt: value),
            ),
          ),
          SettingsSwitchTile(
            title: 'Show table number on receipt',
            value: widget.settings.showTableOnReceipt,
            onChanged: (value) =>
                _patch((current) => current.copyWith(showTableOnReceipt: value)),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _thankYouController,
            decoration: const InputDecoration(
              labelText: 'Thank-you message',
            ),
            maxLines: 2,
            onSubmitted: (_) => _saveThankYou(),
            onTapOutside: (_) => _saveThankYou(),
          ),
        ],
      ),
    );
  }
}
