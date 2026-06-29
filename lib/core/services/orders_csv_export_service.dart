import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../models/order_models.dart';
import '../models/order_type.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

class OrdersCsvExportService {
  OrdersCsvExportService._();

  static Future<String?> exportOrders({
    required List<OrderWithItems> orders,
    required DateTime from,
    required DateTime to,
  }) async {
    if (orders.isEmpty) return null;

    final csv = _buildCsv(orders);
    final fromLabel = DateFormat('yyyyMMdd').format(from);
    final toLabel = DateFormat('yyyyMMdd').format(to.subtract(const Duration(days: 1)));
    final fileName = 'orders_${fromLabel}_$toLabel.csv';

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export Orders CSV',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['csv'],
      bytes: utf8.encode(csv),
    );

    return path;
  }

  static String _buildCsv(List<OrderWithItems> orders) {
    final buffer = StringBuffer()
      ..writeln(
        'Order Number,Date,Time,Type,Table,Customer,Contact,Address,'
        'Subtotal,Tax,Discount,Total,Status,Items,Notes',
      );

    for (final entry in orders) {
      final order = entry.order;
      final orderType = OrderType.fromDbValue(order.orderType);
      buffer.writeln([
        _cell(order.orderNumber),
        _cell(DateFormatter.formatDate(order.createdAt)),
        _cell(DateFormatter.formatTime(order.createdAt)),
        _cell(orderType?.label ?? order.orderType),
        _cell(entry.tableName ?? ''),
        _cell(order.customerName ?? ''),
        _cell(order.customerContact ?? ''),
        _cell(order.deliveryAddress ?? ''),
        _cell(CurrencyFormatter.format(order.subtotalInPaisa)),
        _cell(CurrencyFormatter.format(order.taxInPaisa)),
        _cell(CurrencyFormatter.format(order.discountInPaisa)),
        _cell(CurrencyFormatter.format(order.totalInPaisa)),
        _cell(order.status),
        _cell(_formatItems(entry.items)),
        _cell(order.notes ?? ''),
      ].join(','));
    }

    return buffer.toString();
  }

  static String _formatItems(List<OrderItem> items) {
    return items
        .map((item) => '${item.quantity}x ${item.itemName}')
        .join('; ');
  }

  static String _cell(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
