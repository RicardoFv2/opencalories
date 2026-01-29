// test_driver/app.dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:opencalories/main.dart' as app;

void main() {
  // Enable the extension
  enableFlutterDriverExtension();

  // Run the app
  app.main();
}
