import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/order_type.dart';
import '../../../core/providers/cart_totals_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../models/cart_item.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/shop_settings_provider.dart';
import '../../../core/services/receipt_service.dart';
import '../../orders/providers/orders_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_catalog_provider.dart';

class CartPanel extends ConsumerStatefulWidget {
  const CartPanel({super.key});

  @override
  ConsumerState<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends ConsumerState<CartPanel> {
  late final TextEditingController _customerNameController;
  late final TextEditingController _customerContactController;
  late final TextEditingController _deliveryAddressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    _customerContactController = TextEditingController();
    _deliveryAddressController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerContactController.dispose();
    _deliveryAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _clearCart() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Clear Cart',
      message: 'Remove all items from the cart?',
      confirmLabel: 'Clear',
    );
    if (confirmed == true) {
      ref.read(cartProvider.notifier).clearCart();
    }
  }

  Future<void> _placeOrder() async {
    final notifier = ref.read(cartProvider.notifier);
    notifier.setCustomerName(_customerNameController.text);
    notifier.setCustomerContact(_customerContactController.text);
    notifier.setDeliveryAddress(_deliveryAddressController.text);
    notifier.setNotes(_notesController.text);

    try {
      final result = await notifier.placeOrder();
      if (!mounted) return;

      final db = ref.read(databaseProvider);
      final settings = await ref.read(shopSettingsProvider.future);
      final order = await loadOrderWithItems(db, result.orderId);
      final receiptService = ref.read(receiptServiceProvider);

      if (order != null) {
        if (settings.autoPrintAfterOrder) {
          await receiptService.printReceipt(order, settings);
        } else if (mounted) {
          await receiptService.showPreview(context, order, settings);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order ${result.orderNumber} placed successfully')),
      );
    } on CartException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final totals = ref.watch(cartTotalsProvider);
    final tablesAsync = ref.watch(activeTablesProvider);
    final taxPercent = totals.taxRatePercent.toStringAsFixed(
      totals.taxRatePercent.truncateToDouble() == totals.taxRatePercent ? 0 : 1,
    );

    return Container(
      width: AppSizes.cartPanelWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cart (${cart.itemCount} items)',
                    style: AppTextStyles.title,
                  ),
                ),
                TextButton(
                  onPressed: cart.isEmpty ? null : _clearCart,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      'No items yet',
                      style: AppTextStyles.bodySmall,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.sm),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartLineItem(
                        item: item,
                        onIncrement: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(
                              item.id,
                              item.isDeal,
                              item.quantity + 1,
                              variantId: item.variantId,
                            ),
                        onDecrement: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(
                              item.id,
                              item.isDeal,
                              item.quantity - 1,
                              variantId: item.variantId,
                            ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<OrderType>(
                  segments: [
                    for (final type in OrderType.values)
                      ButtonSegment(
                        value: type,
                        label: Text(type.label),
                      ),
                  ],
                  selected: {cart.orderType},
                  onSelectionChanged: (selection) => ref
                      .read(cartProvider.notifier)
                      .setOrderType(selection.first),
                ),
                const SizedBox(height: AppSizes.md),
                if (cart.orderType == OrderType.dineIn)
                  tablesAsync.when(
                    data: (tables) {
                      return DropdownButtonFormField<int?>(
                        value: cart.selectedTableId,
                        decoration: const InputDecoration(
                          labelText: 'Table',
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('No table selected'),
                          ),
                          for (final table in tables)
                            DropdownMenuItem<int?>(
                              value: table.id,
                              child: Text(table.name),
                            ),
                        ],
                        onChanged: ref.read(cartProvider.notifier).setTable,
                      );
                    },
                    loading: () => const SizedBox(height: AppSizes.controlHeight),
                    error: (error, _) => Text(error.toString()),
                  ),
                if (cart.orderType == OrderType.delivery) ...[
                  TextField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer name',
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  TextField(
                    controller: _customerContactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact number',
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  TextField(
                    controller: _deliveryAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery address',
                    ),
                    maxLines: 2,
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                _totalRow('Subtotal', CurrencyFormatter.format(totals.subtotalInPaisa)),
                _totalRow(
                  '${totals.taxLabel} ($taxPercent%)',
                  CurrencyFormatter.format(totals.taxInPaisa),
                ),
                const Divider(height: AppSizes.lg),
                _totalRow(
                  'Total',
                  CurrencyFormatter.format(totals.totalInPaisa),
                  emphasize: true,
                ),
                const SizedBox(height: AppSizes.md),
                ElevatedButton(
                  onPressed: cart.isEmpty || cart.isPlacingOrder
                      ? null
                      : _placeOrder,
                  child: cart.isPlacingOrder
                      ? const SizedBox(
                          width: AppSizes.md,
                          height: AppSizes.md,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            value,
            style: emphasize ? AppTextStyles.price : AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}

class _CartLineItem extends StatelessWidget {
  const _CartLineItem({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.body),
                  if (item.isDeal && item.dealItemNames != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSizes.sm,
                        top: AppSizes.xs,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final name in item.dealItemNames!)
                            Text('• $name', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onDecrement,
                ),
                Text('${item.quantity}', style: AppTextStyles.body),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onIncrement,
                ),
              ],
            ),
            Text(
              CurrencyFormatter.format(item.lineTotalInPaisa),
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ],
    );
  }
}
