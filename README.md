# 🥑 OpenCalories

**OpenCalories** is an AI-powered nutrition tracker built with Flutter. It leverages **Google's gemini-1.5-flash** model to analyze food images in real-time, estimating calories and macronutrients (Protein, Carbs, Fat) with remarkable accuracy.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Riverpod](https://img.shields.io/badge/State-Riverpod-purple)
![Drift](https://img.shields.io/badge/Database-Drift-lightgrey)

## ✨ Features

- **📸 AI Food Analysis**: Snap a photo or upload from gallery. The app identifies the food and breaks down its nutritional value using Generative AI.
- **🔒 Privacy First**: Your **Gemini API Key** is stored securely on your device using `flutter_secure_storage`. It is never sent to any third-party server other than Google's API directly.
- **💾 Local Persistence**: Meal history is saved locally using **Drift (SQLite)**. No account creation or cloud sync required—your data owns you.
- **🌔 Modern UI**: Sleek dark/light mode adaptable design with glassmorphism elements and smooth animations (`flutter_animate`).
- **📊 Macro Tracking**: Visual breakdown of your daily macronutrient intake.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Riverpod (Generator & Hooks)](https://riverpod.dev/)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) + `sqlite3`
- **AI Integration**: [google_generative_ai](https://pub.dev/packages/google_generative_ai)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Code Generation**: [Freezed](https://pub.dev/packages/freezed) & `build_runner`

## 🚀 Getting Started

### Prerequisites

1.  **Flutter SDK**: Ensure you have Flutter installed (`flutter doctor`).
2.  **Gemini API Key**: You need a free API key from [Google AI Studio](https://aistudio.google.com/app/apikey).

### Installation

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/RicardoFv2/opencalories.git
    cd opencalories
    ```

2.  **Install Dependencies**:

    ```bash
    flutter pub get
    ```

3.  **Run the App**:

    ```bash
    # For Windows
    flutter run -d windows

    # For Mobile (Android/iOS)
    flutter run -d <device_id>
    ```

4.  **Connect AI**:
    - On launch, tap **"Get one from Google AI Studio"** if you don't have a key.
    - Paste your API Key to unlock the scanner.

## 📱 Screenshots

|                  Welcome                  |                     Scanner                     |                   Analysis                    |
| :---------------------------------------: | :---------------------------------------------: | :-------------------------------------------: |
| _Start your journey with a secure login._ | _Real-time camera overlay with history access._ | _Detailed macro breakdown and calorie count._ |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
