// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'48e60558ea6530114ea20ea03e69b9fb339ab129';

@ProviderFor(BannedIds)
final bannedIdsProvider = BannedIdsProvider._();

final class BannedIdsProvider
    extends $AsyncNotifierProvider<BannedIds, List<String>> {
  BannedIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannedIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannedIdsHash();

  @$internal
  @override
  BannedIds create() => BannedIds();
}

String _$bannedIdsHash() => r'fd4ba2b1fce8021bad7885cf7ede81562a5690d3';

abstract class _$BannedIds extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FavoriteIds)
final favoriteIdsProvider = FavoriteIdsProvider._();

final class FavoriteIdsProvider
    extends $AsyncNotifierProvider<FavoriteIds, List<String>> {
  FavoriteIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteIdsHash();

  @$internal
  @override
  FavoriteIds create() => FavoriteIds();
}

String _$favoriteIdsHash() => r'7ccad6e59b4ae6cb144a3c31975db0cfdcd4a6cd';

abstract class _$FavoriteIds extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CurrentCategory)
final currentCategoryProvider = CurrentCategoryProvider._();

final class CurrentCategoryProvider
    extends $NotifierProvider<CurrentCategory, Category?> {
  CurrentCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCategoryHash();

  @$internal
  @override
  CurrentCategory create() => CurrentCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Category? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Category?>(value),
    );
  }
}

String _$currentCategoryHash() => r'869d93074ad2203c69c8255960731550224056bf';

abstract class _$CurrentCategory extends $Notifier<Category?> {
  Category? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Category?, Category?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Category?, Category?>,
              Category?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(GameSession)
final gameSessionProvider = GameSessionProvider._();

final class GameSessionProvider
    extends $NotifierProvider<GameSession, GameSessionState> {
  GameSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameSessionHash();

  @$internal
  @override
  GameSession create() => GameSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameSessionState>(value),
    );
  }
}

String _$gameSessionHash() => r'e5f9c79a0cb79571553b8f5b7384c4758e06f903';

abstract class _$GameSession extends $Notifier<GameSessionState> {
  GameSessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameSessionState, GameSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameSessionState, GameSessionState>,
              GameSessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
