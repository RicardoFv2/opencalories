import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../history/data/app_database.dart';
import '../../analysis/domain/food_analysis.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with WidgetsBindingObserver {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = _getDateOnly(DateTime.now());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = _getDateOnly(DateTime.now());
      if (now != _currentDate) {
        setState(() {
          _currentDate = now;
        });
      }
    }
  }

  DateTime _getDateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  void _previousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    final now = _getDateOnly(DateTime.now());
    final next = _currentDate.add(const Duration(days: 1));
    if (next.isAfter(now)) return; // No future logs
    setState(() {
      _currentDate = next;
    });
  }

  String _formatDateLabel(DateTime date) {
    final now = _getDateOnly(DateTime.now());
    if (date == now) {
      return 'Today, ${DateFormat('MMM d').format(date)}';
    } else if (date == now.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat('MMM d').format(date)}';
    }
    return DateFormat('EEE, MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final mealsStream = ref
        .watch(mealsDaoProvider)
        .watchMealsForDate(_currentDate);

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealOptions(context),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          'HISTORY',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/weekly'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: StreamBuilder<List<MealWithItems>>(
        stream: mealsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meals = snapshot.data!;
          if (meals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No meals logged today',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Calculate daily total
          final dailyCalories = meals.fold<int>(
            0,
            (sum, m) => sum + m.meal.totalCalories,
          );

          return Column(
            children: [
              // Summary Header
              // Date Navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: _previousDay,
                    ),
                    Text(
                      _formatDateLabel(_currentDate),
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
                            _currentDate.year == DateTime.now().year &&
                                _currentDate.month == DateTime.now().month &&
                                _currentDate.day == DateTime.now().day
                            ? Colors.grey.withValues(alpha: 0.3)
                            : Colors.white,
                      ),
                      onPressed: _nextDay,
                    ),
                  ],
                ),
              ),

              // Summary Header with Macros
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.1),
                      Colors.black,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'DAILY TOTAL',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$dailyCalories',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    // Macros
                    FutureBuilder<Map<String, int>>(
                      future: ref
                          .watch(mealsDaoProvider)
                          .getDailyMacros(_currentDate),
                      builder: (context, snapshot) {
                        final macros =
                            snapshot.data ??
                            {'protein': 0, 'carbs': 0, 'fat': 0};
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _MacroItem(
                              label: 'Protein',
                              value: '${macros['protein']}g',
                              color: Colors.greenAccent,
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white24,
                            ),
                            _MacroItem(
                              label: 'Carbs',
                              value: '${macros['carbs']}g',
                              color: Colors.blueAccent,
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white24,
                            ),
                            _MacroItem(
                              label: 'Fat',
                              value: '${macros['fat']}g',
                              color: Colors.orangeAccent,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 80,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Dismissible(
                      key: ValueKey(meal.meal.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text('Delete Meal?'),
                            content: const Text(
                              'This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        await ref
                            .read(mealsDaoProvider)
                            .deleteMeal(meal.meal.id);
                        if (context.mounted) {
                          context.showAppSnackBar('Meal deleted');
                        }
                      },
                      child: _MealCard(meal: meal),
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

  void _showAddMealOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppTheme.primary),
                ),
                title: const Text(
                  'Scan Meal',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Use AI to analyze your food photo',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/scan');
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_note, color: Colors.blue),
                ),
                title: const Text(
                  'Manual Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Type in food name and portion',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/manual-entry');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealWithItems meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: () {
          final analysis = FoodAnalysis(
            items: meal.items
                .map(
                  (i) => FoodItem(
                    name: i.name,
                    calories: i.calories,
                    protein: i.protein,
                    carbs: i.carbs,
                    fat: i.fat,
                    portionEstimate: '1 serving',
                  ),
                )
                .toList(),
          );
          context.push(
            '/analysis',
            extra: {
              'analysis': analysis,
              'image': meal.meal.imagePath != null
                  ? File(meal.meal.imagePath!)
                  : null,
              'isViewOnly': true,
            },
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: meal.meal.imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(meal.meal.imagePath!),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey,
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.error),
                  ),
                ),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_note, color: AppTheme.primary),
              ),
        title: Text(
          DateFormat('h:mm a').format(meal.meal.createdAt),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        subtitle: Text(
          meal.items.map((i) => i.name).join(', '),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.3),
            ), // Matched bracket here
          ),
          child: Text(
            '${meal.meal.totalCalories} kcal',
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
