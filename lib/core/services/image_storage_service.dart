import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageStorageService {
  ImageStorageService._();

  static const _productImagesDir = 'product_images';
  static const _uuid = Uuid();

  static Future<String?> pickAndSaveProductImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return null;

    final source = File(result.files.single.path!);
    final directory = await _productImagesDirectory();
    final extension = p.extension(source.path);
    final fileName = '${_uuid.v4()}$extension';
    final destination = File(p.join(directory.path, fileName));
    await source.copy(destination.path);
    return p.join(_productImagesDir, fileName);
  }

  static Future<File?> resolveImageFile(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) return null;
    final documents = await getApplicationDocumentsDirectory();
    final file = File(p.join(documents.path, relativePath));
    if (!file.existsSync()) return null;
    return file;
  }

  static Future<Directory> _productImagesDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(documents.path, _productImagesDir));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
