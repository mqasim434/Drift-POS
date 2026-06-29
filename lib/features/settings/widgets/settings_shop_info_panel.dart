import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/models/shop_settings.dart';
import '../../../core/providers/shop_settings_provider.dart';
import 'settings_section.dart';

class SettingsShopInfoPanel extends ConsumerStatefulWidget {
  const SettingsShopInfoPanel({super.key, required this.settings});

  final ShopSettings settings;

  @override
  ConsumerState<SettingsShopInfoPanel> createState() =>
      _SettingsShopInfoPanelState();
}

class _SettingsShopInfoPanelState extends ConsumerState<SettingsShopInfoPanel> {
  late final TextEditingController _shopNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _currencyController;

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController(text: widget.settings.shopName);
    _addressController = TextEditingController(text: widget.settings.address);
    _phoneController = TextEditingController(text: widget.settings.phone);
    _currencyController =
        TextEditingController(text: widget.settings.currencySymbol);
  }

  @override
  void didUpdateWidget(covariant SettingsShopInfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _shopNameController.text = widget.settings.shopName;
      _addressController.text = widget.settings.address;
      _phoneController.text = widget.settings.phone;
      _currencyController.text = widget.settings.currencySymbol;
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(shopSettingsNotifierProvider.notifier).patch(
          (current) => current.copyWith(
            shopName: _shopNameController.text.trim(),
            address: _addressController.text.trim(),
            phone: _phoneController.text.trim(),
            currencySymbol: _currencyController.text.trim().isEmpty
                ? 'PKR'
                : _currencyController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Shop Information',
      subtitle: 'Shown at the top of printed receipts.',
      child: Column(
        children: [
          TextField(
            controller: _shopNameController,
            decoration: const InputDecoration(labelText: 'Shop name'),
            onSubmitted: (_) => _save(),
            onTapOutside: (_) => _save(),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
            onSubmitted: (_) => _save(),
            onTapOutside: (_) => _save(),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone number'),
            onSubmitted: (_) => _save(),
            onTapOutside: (_) => _save(),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _currencyController,
            decoration: const InputDecoration(
              labelText: 'Currency symbol',
              hintText: 'PKR',
            ),
            onSubmitted: (_) => _save(),
            onTapOutside: (_) => _save(),
          ),
        ],
      ),
    );
  }
}
