import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'api_key_repository.g.dart';

@riverpod
ApiKeyRepository apiKeyRepository(Ref ref) {
  return ApiKeyRepository();
}

@riverpod
Future<String?> apiKey(Ref ref) async {
  return ref.watch(apiKeyRepositoryProvider).getApiKey();
}

class ApiKeyRepository {
  final _storage = const FlutterSecureStorage();
  static const _key = 'gemini_api_key';

  Future<void> setApiKey(String apiKey) async {
    await _storage.write(key: _key, value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteApiKey() async {
    await _storage.delete(key: _key);
  }
}
