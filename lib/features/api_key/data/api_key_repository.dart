import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_key_repository.g.dart';

const _kApiKeyKey = 'user_api_key';

class ApiKeyRepository {
  final FlutterSecureStorage _storage;

  ApiKeyRepository(this._storage);

  Future<String?> getApiKey() async {
    return await _storage.read(key: _kApiKeyKey);
  }

  Future<void> setApiKey(String apiKey) async {
    await _storage.write(key: _kApiKeyKey, value: apiKey);
  }

  Future<void> deleteApiKey() async {
    await _storage.delete(key: _kApiKeyKey);
  }
}

@riverpod
ApiKeyRepository apiKeyRepository(ApiKeyRepositoryRef ref) {
  return ApiKeyRepository(const FlutterSecureStorage());
}

@riverpod
Future<String?> apiKey(ApiKeyRef ref) async {
  final repository = ref.watch(apiKeyRepositoryProvider);
  return await repository.getApiKey();
}
