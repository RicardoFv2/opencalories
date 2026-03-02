import 'lib/features/settings/data/model_preference_service.dart';

void main() {
  print(ModelPreferenceService.getFriendlyName('gemini-2.5-flash'));
  print(ModelPreferenceService.getFriendlyName('gemini-3-flash-preview'));
  print(ModelPreferenceService.getFriendlyName('gemini-3.1-pro-preview'));
}
