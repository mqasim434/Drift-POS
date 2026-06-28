import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

/// Ensures the database is initialized when the app starts.
final databaseInitProvider = FutureProvider<void>((ref) async {
  ref.watch(databaseProvider);
  await ref.read(databaseProvider).customSelect('SELECT 1').get();
});
