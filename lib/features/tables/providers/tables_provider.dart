import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

class TableException implements Exception {
  TableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TableViewModel {
  const TableViewModel({
    required this.table,
    required this.isOccupied,
  });

  final RestaurantTable table;
  final bool isOccupied;
}

final tablesWithStatusProvider =
    AsyncNotifierProvider<TablesStatusNotifier, List<TableViewModel>>(
  TablesStatusNotifier.new,
);

class TablesStatusNotifier extends AsyncNotifier<List<TableViewModel>> {
  StreamSubscription<List<RestaurantTable>>? _tablesSub;
  StreamSubscription<List<Order>>? _ordersSub;

  @override
  Future<List<TableViewModel>> build() async {
    final db = ref.read(databaseProvider);
    final from = _todayStart();
    final to = from.add(const Duration(days: 1));

    _tablesSub?.cancel();
    _ordersSub?.cancel();

    _tablesSub = db.tablesDao.watchAllTables().listen((_) async {
      state = AsyncData(await _load(db));
    });
    _ordersSub = db.ordersDao.watchOrdersByDateRange(from, to).listen((_) async {
      state = AsyncData(await _load(db));
    });

    ref.onDispose(() {
      _tablesSub?.cancel();
      _ordersSub?.cancel();
    });

    return _load(db);
  }

  DateTime _todayStart() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  Future<List<TableViewModel>> _load(AppDatabase db) async {
    final tables = await db.tablesDao.watchAllTables().first;
    final occupiedIds = await db.ordersDao.getOccupiedTableIdsForToday();
    return tables
        .map(
          (table) => TableViewModel(
            table: table,
            isOccupied: occupiedIds.contains(table.id),
          ),
        )
        .toList();
  }
}

final tablesNotifierProvider =
    AsyncNotifierProvider<TablesNotifier, void>(TablesNotifier.new);

class TablesNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addTable(RestaurantTablesCompanion table) async {
    final db = ref.read(databaseProvider);
    final name = table.name.value;
    if (await db.tablesDao.nameExists(name)) {
      throw TableException('A table named "$name" already exists.');
    }
    await db.tablesDao.insertTable(table);
  }

  Future<void> updateTable(RestaurantTable table) async {
    final db = ref.read(databaseProvider);
    if (await db.tablesDao.nameExists(table.name, excludeId: table.id)) {
      throw TableException('A table named "${table.name}" already exists.');
    }
    await db.tablesDao.updateTable(table);
  }

  Future<void> deleteTable(int id) async {
    final db = ref.read(databaseProvider);
    if (await db.tablesDao.isTableOccupied(id)) {
      throw TableException(
        'Cannot delete this table because it has an active order today.',
      );
    }
    await db.tablesDao.deleteTable(id);
  }
}
