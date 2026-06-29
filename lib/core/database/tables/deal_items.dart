import 'package:drift/drift.dart';

import 'deals.dart';
import 'product_variants.dart';
import 'products.dart';

class DealItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dealId => integer().references(Deals, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId => integer().nullable().references(
        ProductVariants,
        #id,
        onDelete: KeyAction.setNull,
      )();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
