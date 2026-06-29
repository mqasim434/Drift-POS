import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../constants/receipt_paper_format.dart';
import '../database/app_database.dart';
import '../models/order_models.dart';
import '../models/order_type.dart';
import '../models/shop_settings.dart';
import '../utils/date_formatter.dart';
import 'receipt_test_order.dart';

class ReceiptService {
  const ReceiptService();

  Future<Uint8List> generateReceiptPdf(
    OrderWithItems order,
    ShopSettings settings, {
    PdfPageFormat pageFormat = ReceiptPaperFormat.defaultFormat,
  }) async {
    final font = pw.Font.courier();
    final fontBold = pw.Font.courierBold();
    final doc = pw.Document();
    final orderType = OrderType.fromDbValue(order.order.orderType);
    final thermalFormat = _thermalPageFormat(pageFormat);
    final ruleCount = _ruleCharacterCount(thermalFormat);

    doc.addPage(
      pw.Page(
        pageFormat: thermalFormat,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildHeader(settings, font, fontBold, ruleCount),
              _ruleLine(font, ruleCount, heavy: true),
              ..._buildOrderMeta(order, settings, orderType, font, fontBold),
              _ruleLine(font, ruleCount),
              ..._buildLineItems(order, settings, font, fontBold),
              _ruleLine(font, ruleCount),
              ..._buildTotals(order, settings, font, fontBold),
              _ruleLine(font, ruleCount, heavy: true),
              pw.SizedBox(height: 10),
              pw.Text(
                settings.thankYouMessage,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                settings.shopName,
                style: pw.TextStyle(font: font, fontSize: 9),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  PdfPageFormat _thermalPageFormat(PdfPageFormat format) {
    if (format.width <= 58 * PdfPageFormat.mm + 1) {
      return ReceiptPaperFormat.thermal58;
    }
    return ReceiptPaperFormat.defaultFormat;
  }

  int _ruleCharacterCount(PdfPageFormat format) {
    final printableMm = format.availableWidth / PdfPageFormat.mm;
    if (printableMm <= 52) return 22;
    return 36;
  }

  Future<void> printReceipt(
    OrderWithItems order,
    ShopSettings settings,
  ) async {
    await _printPdf(
      settings: settings,
      name: 'Receipt ${order.order.orderNumber}',
      onLayout: (_) => generateReceiptPdf(order, settings),
    );
  }

  Future<void> printTestReceipt(ShopSettings settings) async {
    final sample = buildTestReceiptOrder(settings);
    await _printPdf(
      settings: settings,
      name: 'Test Receipt',
      onLayout: (_) => generateReceiptPdf(sample, settings),
    );
  }

  Future<void> _printPdf({
    required ShopSettings settings,
    required String name,
    required LayoutCallback onLayout,
  }) async {
    final printer = await _resolveDefaultPrinter(settings);

    if (printer != null) {
      await Printing.directPrintPdf(
        printer: printer,
        name: name,
        format: ReceiptPaperFormat.defaultFormat,
        dynamicLayout: true,
        usePrinterSettings: false,
        onLayout: onLayout,
      );
      return;
    }

    await Printing.layoutPdf(
      name: name,
      format: ReceiptPaperFormat.defaultFormat,
      dynamicLayout: true,
      usePrinterSettings: false,
      onLayout: onLayout,
    );
  }

  Future<Printer?> _resolveDefaultPrinter(ShopSettings settings) async {
    final url = settings.defaultPrinterUrl;
    if (url == null || url.isEmpty) return null;

    final info = await Printing.info();
    if (!info.canListPrinters) return null;

    final printers = await Printing.listPrinters();
    for (final printer in printers) {
      if (printer.url == url && printer.isAvailable) return printer;
    }
    return null;
  }

  Future<void> showPreview(
    BuildContext context,
    OrderWithItems order,
    ShopSettings settings,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 420,
          height: 640,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Receipt Preview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PdfPreview(
                  initialPageFormat: ReceiptPaperFormat.defaultFormat,
                  pageFormats: ReceiptPaperFormat.previewFormats,
                  maxPageWidth: ReceiptPaperFormat.defaultFormat.width,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  allowPrinting: true,
                  allowSharing: true,
                  dynamicLayout: true,
                  pdfFileName: 'receipt-${order.order.orderNumber}.pdf',
                  build: (format) =>
                      generateReceiptPdf(order, settings, pageFormat: format),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pw.Widget _buildHeader(
    ShopSettings settings,
    pw.Font font,
    pw.Font fontBold,
    int ruleCount,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.SizedBox(height: 4),
        pw.Text(
          settings.shopName.toUpperCase(),
          style: pw.TextStyle(font: fontBold, fontSize: 20),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 6),
        if (settings.address.trim().isNotEmpty)
          pw.Text(
            settings.address.trim(),
            style: pw.TextStyle(font: font, fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
        if (settings.phone.trim().isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            'Tel: ${settings.phone.trim()}',
            style: pw.TextStyle(font: fontBold, fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
        ],
        pw.SizedBox(height: 8),
      ],
    );
  }

  List<pw.Widget> _buildOrderMeta(
    OrderWithItems order,
    ShopSettings settings,
    OrderType? orderType,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final widgets = <pw.Widget>[
      pw.Text(
        order.order.orderNumber,
        style: pw.TextStyle(font: fontBold, fontSize: 13),
        textAlign: pw.TextAlign.center,
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        DateFormatter.formatDateTime(order.order.createdAt),
        style: pw.TextStyle(font: font, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    ];

    if (settings.showOrderTypeOnReceipt && orderType != null) {
      final buffer = StringBuffer(orderType.label.toUpperCase());
      if (settings.showTableOnReceipt &&
          orderType == OrderType.dineIn &&
          order.tableName != null) {
        buffer.write('  •  TABLE ${order.tableName!.toUpperCase()}');
      }
      widgets.addAll([
        pw.SizedBox(height: 4),
        pw.Text(
          buffer.toString(),
          style: pw.TextStyle(font: fontBold, fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),
      ]);
    }

    if (orderType == OrderType.delivery) {
      final customerName = order.order.customerName?.trim();
      final customerContact = order.order.customerContact?.trim();
      final deliveryAddress = order.order.deliveryAddress?.trim();

      widgets.add(pw.SizedBox(height: 6));
      if (customerName != null && customerName.isNotEmpty) {
        widgets.add(_metaLine('Customer', customerName, font, fontBold));
      }
      if (customerContact != null && customerContact.isNotEmpty) {
        widgets.add(_metaLine('Contact', customerContact, font, fontBold));
      }
      if (deliveryAddress != null && deliveryAddress.isNotEmpty) {
        widgets.add(_metaLine('Address', deliveryAddress, font, fontBold));
      }
    }

    return widgets;
  }

  pw.Widget _metaLine(
    String label,
    String value,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(font: fontBold, fontSize: 9),
            ),
            pw.TextSpan(
              text: value,
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  List<pw.Widget> _buildLineItems(
    OrderWithItems order,
    ShopSettings settings,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return [
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('ITEM', style: pw.TextStyle(font: fontBold, fontSize: 9)),
            pw.Text('AMOUNT', style: pw.TextStyle(font: fontBold, fontSize: 9)),
          ],
        ),
      ),
      for (final item in order.items) ...[
        if (item.isDeal) ...[
          _itemRow(
            'Deal: ${item.itemName} x${item.quantity}',
            item.totalPriceInPaisa,
            settings,
            fontBold,
          ),
          if (_dealComponents(item).isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
              child: pw.Text(
                '∟ ${_dealComponents(item).join(', ')}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 8,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
        ] else
          _itemRow(
            '${item.itemName} x${item.quantity}',
            item.totalPriceInPaisa,
            settings,
            font,
          ),
        pw.SizedBox(height: 4),
      ],
    ];
  }

  pw.Widget _itemRow(
    String label,
    int amountInPaisa,
    ShopSettings settings,
    pw.Font font,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          _formatMoney(amountInPaisa, settings),
          style: pw.TextStyle(font: font, fontSize: 10),
        ),
      ],
    );
  }

  List<pw.Widget> _buildTotals(
    OrderWithItems order,
    ShopSettings settings,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final taxPercent = settings.taxRatePercent.toStringAsFixed(
      settings.taxRatePercent.truncateToDouble() == settings.taxRatePercent
          ? 0
          : 1,
    );

    return [
      _totalLine('Subtotal', order.order.subtotalInPaisa, settings, font),
      _totalLine(
        '${settings.taxLabel} ($taxPercent%)',
        order.order.taxInPaisa,
        settings,
        font,
      ),
      if (order.order.discountInPaisa > 0)
        _totalLine('Discount', order.order.discountInPaisa, settings, font),
      pw.SizedBox(height: 6),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1.5),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TOTAL',
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
            pw.Text(
              _formatMoney(order.order.totalInPaisa, settings),
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ],
        ),
      ),
    ];
  }

  pw.Widget _totalLine(
    String label,
    int amountInPaisa,
    ShopSettings settings,
    pw.Font font,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10)),
          pw.Text(
            _formatMoney(amountInPaisa, settings),
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _ruleLine(pw.Font font, int count, {bool heavy = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: heavy ? 10 : 8),
      child: pw.Text(
        heavy ? '=' * count : '-' * count,
        style: pw.TextStyle(font: font, fontSize: heavy ? 10 : 9),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  List<String> _dealComponents(OrderItem item) {
    final details = item.lineDetails?.trim();
    if (details == null || details.isEmpty) return [];
    return details.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  String _formatMoney(int paisa, ShopSettings settings) {
    final rupees = paisa / 100;
    final formatted = NumberFormat('#,##0').format(rupees);
    return '${settings.currencySymbol} $formatted';
  }
}

final receiptServiceProvider = Provider((ref) => const ReceiptService());
