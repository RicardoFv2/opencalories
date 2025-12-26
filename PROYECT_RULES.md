# PROJECT RULES: NanoCalorie (Open Source)

## 1. Core Philosophy
* **Bring Your Own Key (BYOK):** The app must NEVER ship with an API key. It must require the user to input their Google AI Studio Key on first launch.
* **Privacy First:** No backend servers. All data stays on the device or goes directly to Google's API.
* **Simplicity:** Minimalist UI. Focus on speed: Snap -> Analyze -> Log.
* **Open Source Friendly:** Code must be commented, modular, and use standard formatting (`dart format`).

## 2. Tech Stack
* **Framework:** Flutter (Latest Stable).
* **Language:** Dart.
* **State Management:** Riverpod (Code Generation variant preferred for type safety).
* **Navigation:** GoRouter.
* **Local Storage:**
    * `flutter_secure_storage`: STRICTLY for API Keys.
    * `sqflite` or `drift`: For storing food history/logs.
* **AI Integration:** `google_generative_ai` (Official Dart SDK) OR `http` (if raw REST access is needed for specific experimental models).
* **UI Library:** Material 3 (Use `ThemeData` extensively).

## 3. Coding Standards
* **File Structure:** Feature-based folder structure (e.g., `features/settings`, `features/scanner`, `features/history`).
* **Error Handling:** Never crash. If the API fails (quota exceeded, invalid key), show a user-friendly SnackBar or Dialog with a fix action.
* **Models:** All external data (AI responses) must be parsed into strong Dart Models (`@freezed` is recommended but simple data classes are acceptable).

## 4. The "Nano Banana" Prompt
* The system prompt must be centralized in a constant file.
* It must instruct the model to return **JSON ONLY** to ensure the UI can parse calories, protein, carbs, and fat reliably.