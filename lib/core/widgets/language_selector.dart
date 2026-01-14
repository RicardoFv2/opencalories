import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageServiceProvider).valueOrNull;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.language,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: currentLocale?.languageCode,
                dropdownColor: AppTheme.surfaceDark,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SpaceGrotesk',
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                onChanged: (String? value) {
                  ref
                      .read(languageServiceProvider.notifier)
                      .setLocale(value != null ? Locale(value) : null);
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.systemDefault),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(children: [Text('🇺🇸 '), Text(l10n.english)]),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Row(children: [Text('🇪🇸 '), Text(l10n.spanish)]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
