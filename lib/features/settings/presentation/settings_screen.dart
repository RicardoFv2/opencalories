import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/api_key_repository.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyController = useTextEditingController();
    final isLoading = useState(false);

    useEffect(() {
      ref.read(apiKeyRepositoryProvider).getApiKey().then((val) {
        if (val != null) apiKeyController.text = val;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter your Google Generative AI API Key'),
            const SizedBox(height: 10),
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading.value
                  ? null
                  : () async {
                      isLoading.value = true;
                      try {
                        await ref
                            .read(apiKeyRepositoryProvider)
                            .setApiKey(apiKeyController.text);
                        ref.invalidate(apiKeyProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('API Key Saved')),
                          );
                        }
                      } finally {
                        isLoading.value = false;
                      }
                    },
              child: isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
