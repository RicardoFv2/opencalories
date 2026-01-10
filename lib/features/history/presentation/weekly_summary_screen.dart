import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
    // Default to current week's Monday (or Sunday depending on preference, let's say Monday)
    // Or simpler: Show the last 7 days including today?
    // The plan said "7-day calendar strip showing each day's calorie total".
    // Let's go with "previous 7 days" ending today for "Trends", or a fixed week views.
    // "Weekly Summary" usually implies a fixed week (Mon-Sun).
    // Let's do Monday start of current week.
    final now = DateTime.now();
    _startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _startOfWeek = DateTime(
      _startOfWeek.year,
      _startOfWeek.month,
      _startOfWeek.day,
    ); // Strip time
  }

  void _previousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    final now = DateTime.now();
    final nextWeekStart = _startOfWeek.add(const Duration(days: 7));
    if (nextWeekStart.isAfter(now)) return; // Don't go to future weeks

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
          // Calculate totals
          final totalWeeklyCalories = data.fold<int>(
            0,
            (sum, item) => sum + (item['totalCalories'] as int),
          );
          final avgDailyCalories = (totalWeeklyCalories / 7).round();

          // Find max for bar scaling
          final maxCalories = data.fold<int>(
            1, // Avoid div by zero
            (max, item) => (item['totalCalories'] as int) > max
                ? (item['totalCalories'] as int)
                : max,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Week Selector
                Row(
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
                const SizedBox(height: 24),

                // Aggregated Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        value: '$avgDailyCalories',
                        label: 'Avg Calories',
                        unit: 'kcal/day',
                      ),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _StatItem(
                        value: '$totalWeeklyCalories',
                        label: 'Total Calories',
                        unit: 'kcal/week',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Chart Title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'CALORIE TREND',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bar Chart
                SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.map((dayData) {
                      final date = dayData['date'] as DateTime;
                      final calories = dayData['totalCalories'] as int;
                      final heightFactor = calories / maxCalories;
                      final isToday =
                          DateTime.now().difference(date).inDays == 0 &&
                          DateTime.now().day == date.day;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (calories > 0)
                            Text(
                              '$calories',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            width: 32, // Fixed width bars
                            height: 150 * heightFactor, // Max height 150
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppTheme.primary
                                  : AppTheme.primary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat(
                              'EEE',
                            ).format(date).toUpperCase(), // Mon, Tue...
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.grey,
                              fontSize: 12,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.grey[700],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final String unit;

  const _StatItem({
    required this.value,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
