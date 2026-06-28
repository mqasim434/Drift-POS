import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/providers/database_init_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleFonts.pendingFonts([GoogleFonts.inter()]);

  // Enable WAL mode for SQLite
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final container = ProviderContainer();
  await container.read(databaseInitProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const POSApp(),
    ),
  );
}
