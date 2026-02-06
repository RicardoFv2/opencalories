# Contributing to OpenCalories

Thank you for your interest in contributing to **OpenCalories**! This project aims to provide a fast, private, and open-source way for people to track their nutrition using AI.

## 🚀 Getting Started

1. **Fork** the repository and clone it locally.
2. **Setup Flutter**: Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and running.
3. **API Key**: You'll need a [Gemini API Key](https://aistudio.google.com/app/apikey) to test the food analysis features.
4. **Environment**:
   - Run `flutter pub get` to install dependencies.
   - Run `dart run build_runner build` to generate models (Freezed/Drift).

## 🛠️ Development Workflow

- **Branching**: Use descriptive branch names like `feature/xxx` or `fix/xxx`.
- **Coding Style**:
  - Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style).
  - Use `dart format .` before committing.
  - Prefer `@riverpod` annotations for state management.
- **Testing**:
  - Run `flutter test` to ensure no regressions.
  - Add tests for new features where possible.

## 📥 Pull Request Process

1. Ensure all tests pass.
2. Update the `README.md` if you are adding new features.
3. Describe your changes clearly in the PR description.
4. Link any related issues using `#issue-number`.

## 🎨 UI/UX Standards

- Respect the **Cyberpunk theme**:
  - Primary: Neon Green (`#13EC5B`)
  - Background: Deep Forest (`#102216`)
- Use **DesignTokens** for all spacing, colors, and radii.
- Ensure all buttons have **haptic feedback** and **semantic labels**.

## ⚖️ License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
