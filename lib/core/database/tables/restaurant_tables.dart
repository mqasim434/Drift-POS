import 'package:drift/drift.dart';

class RestaurantTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
  IntColumn get capacity => integer().withDefault(const Constant(4))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
