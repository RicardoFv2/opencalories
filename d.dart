import 'dart:io';

void main() {
  var file = File('lib/features/settings/presentation/settings_screen.dart');
  var lines = file.readAsLinesSync();
  for (var line in lines) {
    if (line.contains('getFriendlyName(')) {
      print(line.trim());
    }
  }
}
