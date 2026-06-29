import 'package:drift/drift.dart';

import 'restaurant_tables.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNumber => text()();
  TextColumn get orderType => text()();
  IntColumn get tableId =>
      integer().nullable().references(RestaurantTables, #id)();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerContact => text().nullable()();
  TextColumn get deliveryAddress => text().nullable()();
  IntColumn get subtotalInPaisa => integer()();
  IntColumn get taxInPaisa => integer().withDefault(const Constant(0))();
  IntColumn get discountInPaisa => integer().withDefault(const Constant(0))();
  IntColumn get totalInPaisa => integer()();
  TextColumn get status =>
      text().withDefault(const Constant('open'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
