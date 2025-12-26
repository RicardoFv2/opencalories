# DEVELOPMENT SPRINTS

## SPRINT 1: The Foundation & Security (BYOK)
**Goal:** A secure app shell that manages the User's API Key and navigation state.
**Stack:** Riverpod Generator, Flutter Secure Storage, GoRouter.

**Tasks:**
1.  **Project Setup:**
    * Initialize Flutter project `nano_calorie`.
    * Add dependencies: `flutter_riverpod`, `riverpod_annotation`, `flutter_secure_storage`, `go_router`, `freezed_annotation`, `json_annotation`.
    * Add dev dependencies: `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`.
2.  **Security Layer:**
    * Create `ApiKeyRepository` using `flutter_secure_storage`.
    * Generate a provider `@riverpod Future<String?> apiKey(ApiKeyRef ref)`.
3.  **Settings Feature:**
    * Create `SettingsScreen` using `HookConsumerWidget`.
    * Implement a `TextEditingController` (via hooks) for input.
    * Add a "Save" button that writes to secure storage and invalidates the `apiKey` provider.
4.  **Navigation:**
    * Setup `GoRouter`.
    * Implement a `redirect` logic: If `apiKey` is null/empty, force redirect to `/settings`. Otherwise, allow `/home`.

## SPRINT 2: Vision & Capture
**Goal:** Capture an image, compress it, and prepare it for analysis.
**Stack:** Image Picker, Flutter Hooks.

**Tasks:**
1.  **Camera Logic:**
    * Add `image_picker` and `permission_handler`.
    * Create `ImageService` class.
    * Implement `pickImage(source)` and `compressImage(file)` (resize to max 1024px to save tokens/bandwidth).
2.  **Scanner Screen:**
    * Create `ScannerScreen`.
    * Add a large FAB (Floating Action Button) to open the camera.
    * Show the selected image in a preview container (use `FileImage`).
    * Add an "Analyze Food" button (disabled if no image selected).

## SPRINT 3: The Brain (Nano Banana Integration)
**Goal:** Send the image to Gemini 1.5/3.0 and parse the JSON response.
**Stack:** Google Generative AI SDK, Freezed.

**Tasks:**
1.  **Data Modeling:**
    * Create `FoodAnalysis` and `FoodItem` classes using `@freezed` and `@JsonSerializable`.
    * Fields: `name`, `calories` (int), `protein` (int), `carbs` (int), `fat` (int), `portion_estimate` (String).
2.  **AI Service:**
    * Create `AiRepository`.
    * Define the **System Prompt** constant: *"Identify food. Estimate portion visually. Return strictly JSON."*
    * Implement `analyzeImage(File image, String apiKey)` which returns `Future<FoodAnalysis>`.
3.  **Results Screen:**
    * Create `AnalysisResultScreen`.
    * Display a loading skeleton while waiting.
    * Render the list of detected items using a custom `_FoodItemCard` widget.
    * Show a summary card (Total Calories & Macros).

## SPRINT 4: Persistence (Drift / Local-First)
**Goal:** Save meals locally using SQLite so the user has a permanent history without a cloud server.
**Stack:** Drift, SQLite3 Flutter Libs.

**Tasks:**
1.  **Drift Setup:**
    * Add `drift`, `sqlite3_flutter_libs`, `drift_flutter`.
    * Run `dart run build_runner build`.
2.  **Database Schema:**
    * Create `Meals` table: `id` (Int, AutoInc), `createdAt` (DateTime), `imagePath` (String), `totalCalories` (Int).
    * Create `FoodItems` table: `id`, `mealId` (References Meals), `name`, `calories`, `macros` (Store JSON string or separate columns).
3.  **DAOs & Repositories:**
    * Create `MealsDao` with methods: `insertMealWithItems`, `watchAllMeals`, `getDailyCalories(DateTime date)`.
    * Create a Riverpod provider `mealRepositoryProvider` that exposes the DAO.
4.  **Wiring it up:**
    * On `AnalysisResultScreen`, add a "Save to Log" button.
    * Action: Copy the temporary image to the app's `ApplicationDocumentsDirectory`, then insert data into Drift.
5.  **History Screen:**
    * Create `HistoryScreen` (The new Home).
    * Use `ref.watch(dailyMealsProvider)` to show a list of today's food.
    * Show a progress bar for daily calorie goals.

## SPRINT 5: Polish & Release
**Goal:** Clean up the UI, error handling, and documentation.
**Stack:** Material 3, Markdown.

**Tasks:**
1.  **Theming:**
    * Define a global `ThemeData` (Green/Yellow "Banana" accent colors).
    * Ensure Dark Mode support.
2.  **Error Handling:**
    * Wrap API calls in `try/catch`.
    * Show `SnackBar` if the API Key is invalid or Quota is exceeded.
3.  **Documentation:**
    * Write `README.md` with "How to get a Key" instructions.
    * Add `LICENSE` (MIT).
    * Run `dart format .` and `flutter analyze` to ensure code quality rules are met.