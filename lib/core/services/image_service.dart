import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_service.g.dart';

@riverpod
class ImageService extends _$ImageService {
  @override
  void build() {
    return;
  }

  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      // In a real app, we might log this or show a snackbar via a notifier
      // specifically handling the case where Camera is not available
      return null;
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      // Create a target path for the compressed image
      final targetPath = p.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 768,
        minHeight: 768,
      );

      if (result == null) {
        return file; // Fallback to original if compression fails
      }
      return File(result.path);
    } catch (e) {
      // Fallback to original if anything goes wrong
      return file;
    }
  }
}
