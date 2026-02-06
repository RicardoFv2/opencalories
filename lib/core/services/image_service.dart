import 'dart:io';
import 'package:flutter/foundation.dart';
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

  /// Picks an image from the specified [source] with native resizing applied.
  ///
  /// Uses ImagePicker's native resizing (maxWidth: 768, quality: 70) which is
  /// faster than a separate compression step. This reduces API payload size
  /// while maintaining quality for food recognition.
  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile == null) return null;

      final file = File(pickedFile.path);
      // Even if image_picker resized it, we run it through our compressor
      // to ensure it's a JPEG and meets our size/quality targets.
      return await compressImage(file);
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
        format: CompressFormat.jpeg,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        return file; // Fallback to original if compression fails
      }
      final compressedFile = File(result.path);
      final sizeAfter = (await compressedFile.length()) / 1024 / 1024;
      debugPrint('📸 Image Compressed: ${sizeAfter.toStringAsFixed(2)}MB');
      return compressedFile;
    } catch (e) {
      // Fallback to original if anything goes wrong
      return file;
    }
  }
}
