// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiKeyRepository)
final apiKeyRepositoryProvider = ApiKeyRepositoryProvider._();

final class ApiKeyRepositoryProvider
    extends
        $FunctionalProvider<
          ApiKeyRepository,
          ApiKeyRepository,
          ApiKeyRepository
        >
    with $Provider<ApiKeyRepository> {
  ApiKeyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiKeyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiKeyRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApiKeyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiKeyRepository create(Ref ref) {
    return apiKeyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiKeyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiKeyRepository>(value),
    );
  }
}

String _$apiKeyRepositoryHash() => r'251f9eae9ef4e138c1c3e45fb40935dea699536b';

@ProviderFor(apiKey)
final apiKeyProvider = ApiKeyProvider._();

final class ApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  ApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return apiKey(ref);
  }
}

String _$apiKeyHash() => r'0a83abe9a815e481637d3c01ed950e271147f0d7';
