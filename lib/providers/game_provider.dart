import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../data/questions.dart';

part 'game_provider.g.dart';

// --- Shared Preferences ---
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) {
  return SharedPreferences.getInstance();
}

// --- Banned Questions ---
@Riverpod(keepAlive: true)
class BannedIds extends _$BannedIds {
  @override
  Future<List<String>> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getStringList('banned_ids') ?? [];
  }

  Future<void> add(String id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final current = state.value ?? [];
    if (!current.contains(id)) {
      final newList = [...current, id];
      await prefs.setStringList('banned_ids', newList);
      state = AsyncData(newList);
    }
  }
}

// --- Favorite Questions ---
@Riverpod(keepAlive: true)
class FavoriteIds extends _$FavoriteIds {
  @override
  Future<List<String>> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getStringList('favorite_ids') ?? [];
  }

  Future<void> toggle(String id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final current = state.value ?? [];
    List<String> newList;
    if (current.contains(id)) {
      newList = current.where((element) => element != id).toList();
    } else {
      newList = [...current, id];
    }
    await prefs.setStringList('favorite_ids', newList);
    state = AsyncData(newList);
  }

  Future<void> add(String id) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final current = state.value ?? [];
    if (!current.contains(id)) {
      final newList = [...current, id];
      await prefs.setStringList('favorite_ids', newList);
      state = AsyncData(newList);
    }
  }
}

// --- Current Category ---
@Riverpod(keepAlive: true)
class CurrentCategory extends _$CurrentCategory {
  @override
  Category? build() => null;

  void set(Category category) {
    state = category;
  }
  
  void clear() {
    state = null;
  }
}

// --- Game Session State ---
class GameSessionState {
  final List<Question> queue;
  final List<Question> history;
  final Question? current;
  final bool isFinished;

  const GameSessionState({
    this.queue = const [],
    this.history = const [],
    this.current,
    this.isFinished = false,
  });

  GameSessionState copyWith({
    List<Question>? queue,
    List<Question>? history,
    Question? current,
    bool? isFinished,
  }) {
    return GameSessionState(
      queue: queue ?? this.queue,
      history: history ?? this.history,
      current: current ?? this.current,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

@Riverpod(keepAlive: true)
class GameSession extends _$GameSession {
  @override
  GameSessionState build() {
    return const GameSessionState();
  }

  Future<void> init(Category category) async {
    final bannedIds = await ref.read(bannedIdsProvider.future);
    final allQuestions = DataService.getQuestionsForCategory(category);
    
    // Filter and shuffle
    final available = allQuestions.where((q) => !bannedIds.contains(q.id)).toList();
    available.shuffle();

    if (available.isEmpty) {
      state = const GameSessionState(isFinished: true);
    } else {
      final first = available.removeAt(0);
      state = GameSessionState(
        queue: available,
        current: first,
        history: [],
      );
    }
  }

  void next() {
    final current = state.current;
    if (current == null) return;

    final history = [...state.history, current];
    final queue = [...state.queue];

    if (queue.isEmpty) {
      state = state.copyWith(
        history: history,
        current: null,
        isFinished: true,
      );
    } else {
      final nextQuestion = queue.removeAt(0);
      state = state.copyWith(
        history: history,
        queue: queue,
        current: nextQuestion,
      );
    }
  }

  void previous() {
    final history = [...state.history];
    if (history.isEmpty) return;

    final previousQuestion = history.removeLast();
    final queue = state.current != null ? [state.current!, ...state.queue] : [...state.queue];

    state = state.copyWith(
      history: history,
      queue: queue,
      current: previousQuestion,
      isFinished: false,
    );
  }

  Future<void> banCurrent() async {
    final current = state.current;
    if (current == null) return;

    await ref.read(bannedIdsProvider.notifier).add(current.id);
    next();
  }
  
  Future<void> resetCategory(Category category) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final bannedIds = await ref.read(bannedIdsProvider.future);
    final categoryQuestionIds = DataService.getQuestionsForCategory(category).map((q) => q.id).toSet();
    
    final newBannedIds = bannedIds.where((id) => !categoryQuestionIds.contains(id)).toList();
    await prefs.setStringList('banned_ids', newBannedIds);
    ref.invalidate(bannedIdsProvider);
    
    await init(category);
  }
}
