import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

class SeedService {
  SeedService._();

  static const _seedKey = 'didSeedData';

  static Future<void> seedIfNeeded(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seedKey) ?? false) return;

    await db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: 'Burgers',
        color: const Value('#FF6B35'),
        icon: const Value('burger'),
        sortOrder: const Value(1),
      ),
    );
    await db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: 'Drinks',
        color: const Value('#3B82F6'),
        icon: const Value('cup'),
        sortOrder: const Value(2),
      ),
    );
    await db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: 'Fries',
        color: const Value('#F59E0B'),
        icon: const Value('french_fries'),
        sortOrder: const Value(3),
      ),
    );
    await db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: 'Desserts',
        color: const Value('#EC4899'),
        icon: const Value('ice_cream'),
        sortOrder: const Value(4),
      ),
    );
    await db.categoriesDao.insertCategory(
      CategoriesCompanion.insert(
        name: 'Extras',
        color: const Value('#22C55E'),
        icon: const Value('plus'),
        sortOrder: const Value(5),
      ),
    );

    await prefs.setBool(_seedKey, true);
    debugPrint('Drift POS: Seed categories inserted');
  }
}
