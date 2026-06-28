import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable WAL mode for SQLite
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  runApp(
    const ProviderScope(
      child: POSApp(),
    ),
  );
}
