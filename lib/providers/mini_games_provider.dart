import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/game_item.dart';
import '../data/truth_questions.dart';
import '../data/dare_questions.dart';
import '../data/never_have_i_ever_questions.dart';
import '../data/this_or_that_questions.dart';
import 'game_provider.dart';

part 'mini_games_provider.g.dart';

// ─────────────────────────────────────────────
//  Generic session state for simple item games
// ─────────────────────────────────────────────
class SimpleGameSession {
  final List<GameItem> available;
  final List<String> usedIds; // persisted
  final GameItem? current;
  final bool isExhausted;

  const SimpleGameSession({
    this.available = const [],
    this.usedIds = const [],
    this.current,
    this.isExhausted = false,
  });

  SimpleGameSession copyWith({
    List<GameItem>? available,
    List<String>? usedIds,
    GameItem? current,
    bool? isExhausted,
    bool clearCurrent = false,
  }) {
    return SimpleGameSession(
      available: available ?? this.available,
      usedIds: usedIds ?? this.usedIds,
      current: clearCurrent ? null : (current ?? this.current),
      isExhausted: isExhausted ?? this.isExhausted,
    );
  }
}

// ─────────────────────────────────────────────
//  TRUTH OR DARE — current mode selection
// ─────────────────────────────────────────────
enum TruthOrDareMode { none, truth, dare }

@Riverpod(keepAlive: true)
class TruthOrDareMode_ extends _$TruthOrDareMode_ {
  @override
  TruthOrDareMode build() => TruthOrDareMode.none;

  void setTruth() => state = TruthOrDareMode.truth;
  void setDare() => state = TruthOrDareMode.dare;
  void reset() => state = TruthOrDareMode.none;
}

// ─────────────────────────────────────────────
//  Helper: persistence keys
// ─────────────────────────────────────────────
String _usedKey(GameType type) => 'used_${type.persistenceKey}';

// ─────────────────────────────────────────────
//  TRUTH SESSION
// ─────────────────────────────────────────────
@Riverpod(keepAlive: true)
class TruthSession extends _$TruthSession {
  @override
  SimpleGameSession build() {
    return const SimpleGameSession();
  }

  Future<void> init() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final usedIds = prefs.getStringList(_usedKey(GameType.truth)) ?? [];
    final available = truthItems
        .where((item) => !usedIds.contains(item.id))
        .toList()
      ..shuffle();

    if (available.isEmpty) {
      state = SimpleGameSession(usedIds: usedIds, isExhausted: true);
      return;
    }

    final first = available.removeAt(0);
    state = SimpleGameSession(
      available: available,
      usedIds: usedIds,
      current: first,
    );
  }

  Future<void> markUsed(String id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final newUsed = [...state.usedIds, id];
    await prefs.setStringList(_usedKey(GameType.truth), newUsed);

    final available = [...state.available];
    if (available.isEmpty) {
      state = state.copyWith(
        usedIds: newUsed,
        isExhausted: true,
        clearCurrent: true,
      );
      return;
    }
    final next = available.removeAt(0);
    state = state.copyWith(
      available: available,
      usedIds: newUsed,
      current: next,
    );
  }

  Future<void> reset() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_usedKey(GameType.truth));
    await init();
  }

  void next() {
    if (state.current != null) {
      markUsed(state.current!.id);
    }
  }
}

// ─────────────────────────────────────────────
//  DARE SESSION
// ─────────────────────────────────────────────
@Riverpod(keepAlive: true)
class DareSession extends _$DareSession {
  @override
  SimpleGameSession build() {
    return const SimpleGameSession();
  }

  Future<void> init() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final usedIds = prefs.getStringList(_usedKey(GameType.dare)) ?? [];
    final available = dareItems
        .where((item) => !usedIds.contains(item.id))
        .toList()
      ..shuffle();

    if (available.isEmpty) {
      state = SimpleGameSession(usedIds: usedIds, isExhausted: true);
      return;
    }

    final first = available.removeAt(0);
    state = SimpleGameSession(
      available: available,
      usedIds: usedIds,
      current: first,
    );
  }

  Future<void> markUsed(String id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final newUsed = [...state.usedIds, id];
    await prefs.setStringList(_usedKey(GameType.dare), newUsed);

    final available = [...state.available];
    if (available.isEmpty) {
      state = state.copyWith(
        usedIds: newUsed,
        isExhausted: true,
        clearCurrent: true,
      );
      return;
    }
    final next = available.removeAt(0);
    state = state.copyWith(
      available: available,
      usedIds: newUsed,
      current: next,
    );
  }

  Future<void> reset() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_usedKey(GameType.dare));
    await init();
  }

  void next() {
    if (state.current != null) {
      markUsed(state.current!.id);
    }
  }
}

// ─────────────────────────────────────────────
//  NEVER HAVE I EVER SESSION
// ─────────────────────────────────────────────
class NhieSession {
  final List<GameItem> queue;
  final List<GameItem> history;
  final GameItem? current;
  final bool isExhausted;
  final List<String> seenIds;

  const NhieSession({
    this.queue = const [],
    this.history = const [],
    this.current,
    this.isExhausted = false,
    this.seenIds = const [],
  });

  NhieSession copyWith({
    List<GameItem>? queue,
    List<GameItem>? history,
    GameItem? current,
    bool? isExhausted,
    List<String>? seenIds,
    bool clearCurrent = false,
  }) {
    return NhieSession(
      queue: queue ?? this.queue,
      history: history ?? this.history,
      current: clearCurrent ? null : (current ?? this.current),
      isExhausted: isExhausted ?? this.isExhausted,
      seenIds: seenIds ?? this.seenIds,
    );
  }
}

@Riverpod(keepAlive: true)
class NhieGameSession extends _$NhieGameSession {
  @override
  NhieSession build() => const NhieSession();

  Future<void> init() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final seenIds = prefs.getStringList(_usedKey(GameType.neverHaveIEver)) ?? [];
    final available = nhieItems
        .where((item) => !seenIds.contains(item.id))
        .toList()
      ..shuffle();

    if (available.isEmpty) {
      state = NhieSession(seenIds: seenIds, isExhausted: true);
      return;
    }

    final first = available.removeAt(0);
    final newSeenIds = [...seenIds, first.id];
    await prefs.setStringList(_usedKey(GameType.neverHaveIEver), newSeenIds);
    state = NhieSession(
      queue: available,
      history: [],
      current: first,
      seenIds: newSeenIds,
    );
  }

  Future<void> next() async {
    final current = state.current;
    if (current == null) return;

    final history = [...state.history, current];
    final queue = [...state.queue];

    if (queue.isEmpty) {
      state = state.copyWith(
        history: history,
        isExhausted: true,
        clearCurrent: true,
      );
      return;
    }

    final nextItem = queue.removeAt(0);
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final newSeenIds = [...state.seenIds, nextItem.id];
    await prefs.setStringList(_usedKey(GameType.neverHaveIEver), newSeenIds);
    state = state.copyWith(
      queue: queue,
      history: history,
      current: nextItem,
      seenIds: newSeenIds,
    );
  }

  void previous() {
    final history = [...state.history];
    if (history.isEmpty) return;
    final prev = history.removeLast();
    final queue = state.current != null
        ? [state.current!, ...state.queue]
        : [...state.queue];
    state = state.copyWith(
      queue: queue,
      history: history,
      current: prev,
      isExhausted: false,
    );
  }

  Future<void> reset() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_usedKey(GameType.neverHaveIEver));
    await init();
  }
}

// ─────────────────────────────────────────────
//  THIS OR THAT SESSION
// ─────────────────────────────────────────────
class TotSession {
  final List<ThisOrThatItem> queue;
  final List<ThisOrThatItem> history;
  final ThisOrThatItem? current;
  final bool isExhausted;
  final List<String> seenIds;

  const TotSession({
    this.queue = const [],
    this.history = const [],
    this.current,
    this.isExhausted = false,
    this.seenIds = const [],
  });

  TotSession copyWith({
    List<ThisOrThatItem>? queue,
    List<ThisOrThatItem>? history,
    ThisOrThatItem? current,
    bool? isExhausted,
    List<String>? seenIds,
    bool clearCurrent = false,
  }) {
    return TotSession(
      queue: queue ?? this.queue,
      history: history ?? this.history,
      current: clearCurrent ? null : (current ?? this.current),
      isExhausted: isExhausted ?? this.isExhausted,
      seenIds: seenIds ?? this.seenIds,
    );
  }
}

@Riverpod(keepAlive: true)
class TotGameSession extends _$TotGameSession {
  @override
  TotSession build() => const TotSession();

  Future<void> init() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final seenIds = prefs.getStringList(_usedKey(GameType.thisOrThat)) ?? [];
    final available = thisOrThatItems
        .where((item) => !seenIds.contains(item.id))
        .toList()
      ..shuffle();

    if (available.isEmpty) {
      state = TotSession(seenIds: seenIds, isExhausted: true);
      return;
    }

    final first = available.removeAt(0);
    final newSeenIds = [...seenIds, first.id];
    await prefs.setStringList(_usedKey(GameType.thisOrThat), newSeenIds);
    state = TotSession(
      queue: available,
      history: [],
      current: first,
      seenIds: newSeenIds,
    );
  }

  Future<void> next() async {
    final current = state.current;
    if (current == null) return;

    final history = [...state.history, current];
    final queue = [...state.queue];

    if (queue.isEmpty) {
      state = state.copyWith(
        history: history,
        isExhausted: true,
        clearCurrent: true,
      );
      return;
    }

    final nextItem = queue.removeAt(0);
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final newSeenIds = [...state.seenIds, nextItem.id];
    await prefs.setStringList(_usedKey(GameType.thisOrThat), newSeenIds);
    state = state.copyWith(
      queue: queue,
      history: history,
      current: nextItem,
      seenIds: newSeenIds,
    );
  }

  void previous() {
    final history = [...state.history];
    if (history.isEmpty) return;
    final prev = history.removeLast();
    final queue = state.current != null
        ? [state.current!, ...state.queue]
        : [...state.queue];
    state = state.copyWith(
      queue: queue,
      history: history,
      current: prev,
      isExhausted: false,
    );
  }

  Future<void> reset() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_usedKey(GameType.thisOrThat));
    await init();
  }
}
