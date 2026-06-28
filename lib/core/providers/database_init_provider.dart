import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seed_service.dart';
import 'database_provider.dart';

final databaseInitProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  await db.customSelect('SELECT 1').get();
  await SeedService.seedIfNeeded(db);
});
