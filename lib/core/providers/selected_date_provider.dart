import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Set by WeeklySummaryScreen when the user taps a day; consumed once by
/// HistoryScreen to jump to that date, then cleared.
///
/// Needed because History (`/`) and Weekly (`/weekly`) became sibling tabs
/// under a [StatefulShellRoute] — they're an IndexedStack, not a push/pop
/// stack, so a tapped date can no longer travel back through `context.pop()`.
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
