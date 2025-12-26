import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:opencalories/features/api_key/data/api_key_repository.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyController = useTextEditingController();
    final isLoading = useState(false);

    // Initial load of the key if it exists
    useEffect(() {
      ref.read(apiKeyProvider.future).then((key) {
        if (key != null) {
          apiKeyController.text = key;
        }
      });
      return null;
    }, []);

    Future<void> saveApiKey() async {
      if (apiKeyController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid API Key')),
        );
        return;
      }

      isLoading.value = true;
      try {
        await ref
            .read(apiKeyRepositoryProvider)
            .setApiKey(apiKeyController.text.trim());

        // Invalidate the provider so the router picks up the change
        ref.invalidate(apiKeyProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('API Key Saved!')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving API Key: $e')));
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your Google AI Studio API Key',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading.value ? null : saveApiKey,
              child: isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Save API Key'),
            ),
            const Spacer(),
            const Text(
              'Your API key is stored securely on your device and is never sent to our servers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
