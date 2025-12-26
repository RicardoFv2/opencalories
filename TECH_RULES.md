You are an expert in Flutter, Dart, Riverpod, Freezed, Flutter Hooks, and Local Persistence (Drift/Sqflite).

Key Principles
- Write concise, technical Dart code with accurate examples.
- Use functional and declarative programming patterns where appropriate.
- Prefer composition over inheritance.
- Use descriptive variable names with auxiliary verbs (e.g., isLoading, hasError).
- Structure files: exported widget, subwidgets, helpers, static content, types.

Dart/Flutter
- Use const constructors for immutable widgets.
- Leverage Freezed for immutable state classes and unions.
- Use arrow syntax for simple functions and methods.
- Prefer expression bodies for one-line getters and setters.
- Use trailing commas for better formatting.

Error Handling and Validation
- For Form/Input errors: Display inline using errorText or red SelectableText.
- For System/Network errors: Use SnackBar with a retry action.
- Handle empty states within the displaying screen (e.g., "No meals logged yet").
- Use AsyncValue for proper error handling and loading states in Riverpod.

Riverpod-Specific Guidelines (Modern)
- Use @riverpod annotation (Riverpod Generator) for ALL providers.
- Prefer AsyncNotifierProvider and NotifierProvider.
- STRICTLY AVOID StateProvider, StateNotifierProvider, and ChangeNotifierProvider.
- Use ref.invalidate() for manually triggering provider updates.

Performance Optimization
- Use const widgets to optimize rebuilds.
- Use ListView.builder for long lists.
- Use 'flutter_image_compress' before sending images to API to save bandwidth.

Key Conventions
1. Use GoRouter for navigation.
2. Optimize for "First Meaningful Paint" (Skeleton loaders while AI thinks).
3. Prefer stateless widgets:
   - Use ConsumerWidget for standard state.
   - Use HookConsumerWidget when you need `useEffect` or `useTextEditingController`.

UI and Styling
- Use Material 3 conventions.
- Use Theme.of(context).textTheme... for consistent typography.
- Create small, private widget classes instead of helper methods (e.g., `class _FoodItem extends StatelessWidget` NOT `Widget _buildFoodItem()`).

Model and Database Conventions (Local / Offline First)
- Use **Drift** (SQL) for local storage.
- Tables should include: id (auto-increment), createdAt, json_data (for the full AI blob).
- Use @JsonSerializable(fieldRename: FieldRename.snake) for API DTOs.

Miscellaneous
- Use log instead of print.
- Keep lines no longer than 120 characters.
- Code Generation: Run 'dart run build_runner build --delete-conflicting-outputs'.