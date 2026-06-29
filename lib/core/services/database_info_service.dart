import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseInfoService {
  DatabaseInfoService._();

  static const _dbFileName = 'pos.db';

  static Future<int> databaseFileSizeBytes() async {
    final file = await _databaseFile();
    if (!await file.exists()) return 0;
    return file.length();
  }

  static Future<File> _databaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _dbFileName));
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
