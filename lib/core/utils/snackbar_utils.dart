import 'package:flutter/material.dart';

extension SnackBarUtils on BuildContext {
  void showAppSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar(); // Dismiss previous
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(this).hideCurrentSnackBar();
          },
          child: Container(
            color: Colors.transparent, // Hit test for transparent areas
            child: Text(message),
          ),
        ),
        backgroundColor: isError
            ? Colors.red
            : null, // Use theme default if not error
        behavior: SnackBarBehavior
            .floating, // Ensure floating even if theme overrides
      ),
    );
  }
}
