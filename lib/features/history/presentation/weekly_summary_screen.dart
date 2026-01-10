import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/app_theme.dart';
import '../data/app_database.dart';

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  ConsumerState<WeeklySummaryScreen> createState() =>
      _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  late DateTime _startOfWeek;

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
    final dateRangeStr =
        '${DateFormat('MMM d').format(_startOfWeek)} - ${DateFormat('MMM d').format(endOfWeek)}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'WEEKLY INSIGHTS',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Week Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
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
                      'Error: ${snapshot.error}',
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
                    // Add top padding to the second item (Tuesday) to create the "stepped" look
                    // where the right column is shifted down relative to the left.
                    return Padding(
                      padding: EdgeInsets.only(top: index == 1 ? 40.0 : 0.0),
                      child: _DayGridItem(dayData: dayData),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                    DateFormat('EEEE').format(date).toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d').format(date),
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
                      '$totalCalories kcal',
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
