import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../settings/data/api_key_repository.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenCalories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(apiKeyRepositoryProvider).deleteApiKey();
              ref.invalidate(apiKeyProvider);
            },
          ),
        ],
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
