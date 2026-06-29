import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);

  db.customSelect('SELECT 1').get().then((_) {
    debugPrint('DriftPOS: Database opened successfully');
  }).catchError((Object error) {
    debugPrint('DriftPOS: Database failed to open — $error');
  });

  return db;
});
