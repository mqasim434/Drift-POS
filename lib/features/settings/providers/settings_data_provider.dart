import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/order_models.dart';
import '../../../core/models/orders_date_range.dart';
import '../../../core/providers/database_provider.dart';
import '../../orders/providers/orders_provider.dart';

final settingsDataProvider =
    Provider<SettingsDataService>((ref) => SettingsDataService(ref));

class SettingsDataService {
  SettingsDataService(this.ref);

  final Ref ref;

  Future<List<OrderWithItems>> loadOrdersForExport(
    OrdersDateRange range,
  ) async {
    final db = ref.read(databaseProvider);
    final orders = await db.ordersDao.getOrdersInRange(range.from, range.to);
    final results = <OrderWithItems>[];

    for (final order in orders) {
      final detail = await loadOrderWithItems(db, order.id);
      if (detail != null) results.add(detail);
    }

    return results;
  }
}
