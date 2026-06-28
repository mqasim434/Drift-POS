import 'package:drift/drift.dart';

import 'deals.dart';
import 'orders.dart';
import 'products.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId =>
      integer().nullable().references(Products, #id)();
  IntColumn get dealId => integer().nullable().references(Deals, #id)();
  TextColumn get itemName => text()();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceInPaisa => integer()();
  IntColumn get totalPriceInPaisa => integer()();
  BoolColumn get isDeal => boolean().withDefault(const Constant(false))();
}
