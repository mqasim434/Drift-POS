import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/providers/database_init_provider.dart';
import 'core/services/device_binding_service.dart';
import 'features/device/device_blocked_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleFonts.pendingFonts([GoogleFonts.inter()]);

  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final binding = await DeviceBindingService.ensureAuthorized();
  if (!binding.isAuthorized) {
    runApp(
      DeviceBlockedApp(
        reason: binding.reason!,
        onReauthorized: _startApp,
      ),
    );
    return;
  }

  await _startApp();
}

Future<void> _startApp() async {
  final container = ProviderContainer();
  await container.read(databaseInitProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const POSApp(),
    ),
  );
}
