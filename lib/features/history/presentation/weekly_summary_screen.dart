import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:opencalories/core/theme/app_theme.dart';
import '../data/app_database.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/services/tutorial_service.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  ConsumerState<WeeklySummaryScreen> createState() =>
      _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  late DateTime _startOfWeek;
  final GlobalKey _navKey = GlobalKey();
  final GlobalKey _gridKey = GlobalKey();
  bool _tutorialStarted = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _startOfWeek = DateTime(
      _startOfWeek.year,
      _startOfWeek.month,
      _startOfWeek.day,
    );
  }

  void _previousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    final now = DateTime.now();
    final nextWeekStart = _startOfWeek.add(const Duration(days: 7));
    if (nextWeekStart.isAfter(now)) return;

    setState(() {
      _startOfWeek = nextWeekStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weeklyDataFuture = ref
        .watch(mealsDaoProvider)
        .getWeeklySummary(_startOfWeek);

    final endOfWeek = _startOfWeek.add(const Duration(days: 6));
    final locale = Localizations.localeOf(context).toString();
    final dateRangeStr =
        '${DateFormat('MMM d', locale).format(_startOfWeek)} - ${DateFormat('MMM d', locale).format(endOfWeek)}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.weeklyInsights,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ShowCaseWidget(
        onFinish: () {
          ref.read(tutorialServiceProvider.notifier).markWeeklyTutorialShown();
        },
        builder: (context) {
          if (!_tutorialStarted) {
            _tutorialStarted = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await ref.read(tutorialServiceProvider.future);
              final tutorialService = ref.read(
                tutorialServiceProvider.notifier,
              );

              if (!tutorialService.hasShownWeeklyTutorial && context.mounted) {
                // ignore: use_build_context_synchronously
                ShowCaseWidget.of(context).startShowCase([_navKey, _gridKey]);
              }
            });
          }

          return Column(
            children: [
              // Week Selector
              Showcase(
                key: _navKey,
                title: AppLocalizations.of(context)!.tutorialTimeTravelTitle,
                description: AppLocalizations.of(
                  context,
                )!.tutorialTimeTravelDesc,
                tooltipBackgroundColor: _tutorialBg,
                titleTextStyle: const TextStyle(
                  color: _tutorialText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                descTextStyle: TextStyle(
                  color: _tutorialText.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        onPressed: _previousWeek,
                      ),
                      Text(
                        dateRangeStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color:
                              _startOfWeek
                                  .add(const Duration(days: 7))
                                  .isAfter(DateTime.now())
                              ? Colors.grey.withValues(alpha: 0.3)
                              : Colors.white,
                        ),
                        onPressed: _nextWeek,
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: weeklyDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.errorWithMessage(snapshot.error.toString()),
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final data = snapshot.data ?? [];

                    return MasonryGridView.count(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom:
                            100, // Extra padding to ensure the last item is not cut off
                      ),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final dayData = data[index];
                        final widget = Padding(
                          padding: EdgeInsets.only(
                            top: index == 1 ? 40.0 : 0.0,
                          ),
                          child: _DayGridItem(dayData: dayData),
                        );

                        if (index == 0) {
                          return Showcase(
                            key: _gridKey,
                            title: AppLocalizations.of(
                              context,
                            )!.tutorialSelectDayTitle,
                            description: AppLocalizations.of(
                              context,
                            )!.tutorialSelectDayDesc,
                            tooltipBackgroundColor: _tutorialBg,
                            titleTextStyle: const TextStyle(
                              color: _tutorialText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            descTextStyle: TextStyle(
                              color: _tutorialText.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                            child: widget,
                          );
                        }
                        return widget;
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DayGridItem extends StatelessWidget {
  final Map<String, dynamic> dayData;

  const _DayGridItem({required this.dayData});

  @override
  Widget build(BuildContext context) {
    final date = dayData['date'] as DateTime;
    final totalCalories = dayData['totalCalories'] as int;
    final imagePath = dayData['imagePath'] as String?;

    final isToday =
        DateTime.now().difference(date).inDays == 0 &&
        DateTime.now().day == date.day;

    return GestureDetector(
      onTap: () {
        context.pop(date);
      },
      child: Container(
        height: 220, // Fixed height for consistent stepped look
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(24),
          image: imagePath != null
              ? DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
          border: isToday
              ? Border.all(color: AppTheme.primary, width: 2)
              : Border.all(color: Colors.white10),
        ),
        child: Stack(
          children: [
            if (imagePath == null)
              Center(
                child: Icon(
                  Icons.restaurant,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat(
                      'EEEE',
                      Localizations.localeOf(context).toString(),
                    ).format(date).toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'MMM d',
                      Localizations.localeOf(context).toString(),
                    ).format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$totalCalories ${AppLocalizations.of(context)!.kcal}',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
