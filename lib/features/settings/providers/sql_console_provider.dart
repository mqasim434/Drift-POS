import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/sql_execution_result.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/sql_console_service.dart';
import '../../analytics/providers/analytics_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../products/providers/products_provider.dart';

final sqlConsoleUnlockedProvider = StateProvider<bool>((ref) => false);

final sqlConsoleServiceProvider =
    Provider<SqlConsoleService>((ref) => const SqlConsoleService());

final sqlConsoleProvider = Provider<SqlConsoleController>((ref) {
  return SqlConsoleController(ref);
});

class SqlConsoleController {
  SqlConsoleController(this.ref);

  final Ref ref;

  Future<SqlExecutionResult> execute(String sql) async {
    final db = ref.read(databaseProvider);
    final result = await ref.read(sqlConsoleServiceProvider).execute(db, sql);
    if (result.isSuccess && !result.isQuery) {
      _refreshDerivedProviders();
    }
    return result;
  }

  void _refreshDerivedProviders() {
    ref.invalidate(productVariantsProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(analyticsDataProvider);
  }
}
