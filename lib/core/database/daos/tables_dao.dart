import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/restaurant_tables.dart';

part 'tables_dao.g.dart';

@DriftAccessor(tables: [RestaurantTables])
class TablesDao extends DatabaseAccessor<AppDatabase> with _$TablesDaoMixin {
  TablesDao(super.db);

  Stream<List<RestaurantTable>> watchAllTables() {
    return (select(restaurantTables)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<int> insertTable(RestaurantTablesCompanion table) {
    return into(restaurantTables).insert(table);
  }

  Future<bool> updateTable(RestaurantTable table) {
    return update(restaurantTables).replace(table);
  }

  Future<int> toggleActive(int id) async {
    final table = await (select(restaurantTables)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (table == null) return 0;
    return (update(restaurantTables)..where((t) => t.id.equals(id))).write(
      RestaurantTablesCompanion(isActive: Value(!table.isActive)),
    );
  }

  Future<bool> isTableOccupied(int id) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final occupiedOrders = await db.ordersDao.getActiveOrdersForTable(
      tableId: id,
      from: start,
      to: end,
    );
    return occupiedOrders.isNotEmpty;
  }

  Future<bool> nameExists(String name, {int? excludeId}) async {
    final trimmed = name.trim();
    final results = await (select(restaurantTables)
          ..where((t) => t.name.equals(trimmed)))
        .get();
    if (excludeId == null) return results.isNotEmpty;
    return results.any((table) => table.id != excludeId);
  }

  Future<int> deleteTable(int id) {
    return (delete(restaurantTables)..where((t) => t.id.equals(id))).go();
  }
}
