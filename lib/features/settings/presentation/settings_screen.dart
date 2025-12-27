import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/api_key_repository.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentKey = ref.read(apiKeyProvider).valueOrNull;
    if (currentKey != null) {
      _apiKeyController.text = currentKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Connect Intelligence',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Graphic
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    blurRadius: 15,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCyQpXAOclKcePKfVsBD87ITisJezg4kpOcFKaLUM_H_vvnnE99DxDbPTEcK3MVzatJapxNntZ80lDpS7buLyig3_IG79Z83mgyxzWbpeXrApUCO5Gizpphnq76RNfjDBklQabqMe-xlyUO72jL0ulyJ5jvHCcsMOTBh1JEHhNxb6lGUGDsRPRvaf92xrwGgl5TS8Q3-5JJyqhKJOu1TiljSEyYvLFvXsEphXlomRVR9hum5hdHt0mITzByvPwiMCedmlj5YIcBuVM',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppTheme.backgroundDark, Colors.transparent],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Headline
            Text(
              'Unlock Gemini AI',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Text(
                'To analyze your food with the Nano Banana Pro, we need to connect to Google\'s Gemini brain.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], height: 1.5),
              ),
            ),

            const SizedBox(height: 24),

            // 3. API Key Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'API Key',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: _apiKeyController,
                    style: const TextStyle(fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      hintText: 'AIzaSy...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 2,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.content_paste,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Helper Link
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () {}, // TODO: Launch URL
                icon: const Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: AppTheme.primary,
                ),
                label: const Text(
                  'Don\'t have a key? Get one from Google AI Studio',
                  style: TextStyle(color: AppTheme.primary, fontSize: 12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 5. Connect Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () async {
                    final key = _apiKeyController.text.trim();
                    if (key.isNotEmpty) {
                      await ref.read(apiKeyRepositoryProvider).setApiKey(key);
                      ref.invalidate(apiKeyProvider);
                      if (context.mounted) {
                        context.go('/'); // Go to scanner
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.backgroundDark,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                    elevation: 8,
                  ),
                  child: const Text('Connect & Continue'),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Your key is stored locally on device and never shared.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
