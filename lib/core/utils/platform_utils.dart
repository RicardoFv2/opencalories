import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Utility to detect if the app is running in a test environment.
bool get kIsTest {
  // Check if we are in debug mode and the binding is a TestWidgetsFlutterBinding
  // This is a robust way to detect flutter_test environment without importing it.
  if (!kDebugMode) return false;

  final bindingType = WidgetsBinding.instance.runtimeType.toString();
  return bindingType.contains('TestWidgetsFlutterBinding') ||
      bindingType.contains('AutomatedTestWidgetsFlutterBinding');
}
