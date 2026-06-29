import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

final systemPrintersProvider = FutureProvider<List<Printer>>((ref) async {
  final info = await Printing.info();
  if (!info.canListPrinters) return [];
  return Printing.listPrinters();
});
