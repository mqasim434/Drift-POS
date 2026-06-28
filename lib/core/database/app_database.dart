import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/categories_dao.dart';
import 'daos/deals_dao.dart';
import 'daos/orders_dao.dart';
import 'daos/products_dao.dart';
import 'daos/tables_dao.dart';
import 'tables/categories.dart';
import 'tables/deal_items.dart';
import 'tables/deals.dart';
import 'tables/order_items.dart';
import 'tables/orders.dart';
import 'tables/products.dart';
import 'tables/restaurant_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Products,
    Deals,
    DealItems,
    RestaurantTables,
    Orders,
    OrderItems,
  ],
  daos: [
    CategoriesDao,
    ProductsDao,
    DealsDao,
    OrdersDao,
    TablesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX idx_orders_created_at ON orders(created_at);',
          );
          await customStatement(
            'CREATE INDEX idx_order_items_order_id ON order_items(order_id);',
          );
          await customStatement(
            'CREATE INDEX idx_products_category_id ON products(category_id);',
          );
          await customStatement(
            'CREATE INDEX idx_orders_order_type ON orders(order_type);',
          );
          await customStatement('PRAGMA journal_mode=WAL;');
          await customStatement('PRAGMA synchronous=NORMAL;');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pos.db'));
    return NativeDatabase.createInBackground(file);
  });
}
