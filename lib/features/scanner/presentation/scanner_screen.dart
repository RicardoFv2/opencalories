import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/image_service.dart';

class ScannerScreen extends HookConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need to watch the provider to ensure it's initialized,
    // but the method call doesn't need a watch.
    // However, ImageService is a class provider.
    final imageService = ref.read(imageServiceProvider.notifier);
    final selectedImage = useState<File?>(null);
    final isProcessing = useState(false);

    Future<void> pickAndProcessImage(ImageSource source) async {
      isProcessing.value = true;
      try {
        final picked = await imageService.pickImage(source);
        if (picked != null) {
          final compressed = await imageService.compressImage(picked);
          selectedImage.value = compressed;
        }
      } finally {
        isProcessing.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings if needed, or logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: selectedImage.value == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No image selected',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedImage.value!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'camera_fab',
                  onPressed: isProcessing.value
                      ? null
                      : () => pickAndProcessImage(ImageSource.camera),
                  label: const Text('Take Photo'),
                  icon: const Icon(Icons.camera_alt),
                ),
                FloatingActionButton.extended(
                  heroTag: 'gallery_fab',
                  onPressed: isProcessing.value
                      ? null
                      : () => pickAndProcessImage(ImageSource.gallery),
                  label: const Text('Upload File'),
                  icon: const Icon(Icons.photo_library),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: selectedImage.value == null || isProcessing.value
                    ? null
                    : () {
                        // TODO: Implement analysis in next sprint
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Verification: Analysis button clicked!',
                            ),
                          ),
                        );
                      },
                child: isProcessing.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Analyze Food',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
