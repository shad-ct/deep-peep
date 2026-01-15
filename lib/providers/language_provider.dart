import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_provider.dart';

part 'language_provider.g.dart';

enum AppLanguage {
  english,
  malayalam;

  String get code => this == AppLanguage.malayalam ? 'ml' : 'en';
  String get displayName => this == AppLanguage.malayalam ? 'മലയാളം' : 'English';
}

@Riverpod(keepAlive: true)
class Language extends _$Language {
  @override
  AppLanguage build() {
    _load();
    return AppLanguage.english;
  }

  Future<void> _load() async {
     try {
       final prefs = await ref.read(sharedPreferencesProvider.future);
       final code = prefs.getString('app_language');
       if (code == 'ml') {
         state = AppLanguage.malayalam;
       }
     } catch (_) {}
  }
  
  void toggle() {
    state = state == AppLanguage.english ? AppLanguage.malayalam : AppLanguage.english;
    ref.read(sharedPreferencesProvider.future).then((prefs) {
       prefs.setString('app_language', state.code);
    });
  }
}
