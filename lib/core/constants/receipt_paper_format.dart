import 'package:pdf/pdf.dart';

/// Thermal POS receipt paper sizes for 58mm and 80mm roll printers.
///
/// Width matches the physical paper roll; height is infinite so the PDF engine
/// auto-sizes to receipt content (continuous roll, not A4/Letter).
class ReceiptPaperFormat {
  ReceiptPaperFormat._();

  /// Standard 80mm thermal roll used by most POS receipt printers.
  static const PdfPageFormat thermal80 = PdfPageFormat(
    80 * PdfPageFormat.mm,
    double.infinity,
    marginLeft: 4 * PdfPageFormat.mm,
    marginRight: 4 * PdfPageFormat.mm,
    marginTop: 2 * PdfPageFormat.mm,
    marginBottom: 4 * PdfPageFormat.mm,
  );

  /// Compact 58mm thermal roll (smaller POS printers).
  static const PdfPageFormat thermal58 = PdfPageFormat(
    58 * PdfPageFormat.mm,
    double.infinity,
    marginLeft: 3 * PdfPageFormat.mm,
    marginRight: 3 * PdfPageFormat.mm,
    marginTop: 2 * PdfPageFormat.mm,
    marginBottom: 4 * PdfPageFormat.mm,
  );

  static const PdfPageFormat defaultFormat = thermal80;

  static const Map<String, PdfPageFormat> previewFormats = {
    '80mm Thermal': thermal80,
    '58mm Thermal': thermal58,
  };
}
