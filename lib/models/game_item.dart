import '../providers/language_provider.dart';

// ─────────────────────────────────────────────
//  GameType enum — identifies each game
// ─────────────────────────────────────────────
enum GameType {
  deepPeep,
  truth,
  dare,
  neverHaveIEver,
  thisOrThat;

  String get persistenceKey {
    switch (this) {
      case GameType.deepPeep:
        return 'dp';
      case GameType.truth:
        return 'tod_truth';
      case GameType.dare:
        return 'tod_dare';
      case GameType.neverHaveIEver:
        return 'nhie';
      case GameType.thisOrThat:
        return 'tot';
    }
  }
}

// ─────────────────────────────────────────────
//  Simple bilingual prompt item (Truth / Dare / NHIE)
// ─────────────────────────────────────────────
class GameItem {
  final String id;
  final String text;
  final String? textMl;
  final GameType gameType;

  const GameItem({
    required this.id,
    required this.text,
    this.textMl,
    required this.gameType,
  });

  String getLocalizedText(AppLanguage lang) {
    if (lang == AppLanguage.malayalam && textMl != null && textMl!.isNotEmpty) {
      return textMl!;
    }
    return text;
  }
}

// ─────────────────────────────────────────────
//  This or That item — two choices per card
// ─────────────────────────────────────────────
class ThisOrThatItem {
  final String id;
  final String optionA;
  final String optionB;
  final String? optionAMl;
  final String? optionBMl;

  const ThisOrThatItem({
    required this.id,
    required this.optionA,
    required this.optionB,
    this.optionAMl,
    this.optionBMl,
  });

  String getLocalizedOptionA(AppLanguage lang) {
    if (lang == AppLanguage.malayalam && optionAMl != null && optionAMl!.isNotEmpty) {
      return optionAMl!;
    }
    return optionA;
  }

  String getLocalizedOptionB(AppLanguage lang) {
    if (lang == AppLanguage.malayalam && optionBMl != null && optionBMl!.isNotEmpty) {
      return optionBMl!;
    }
    return optionB;
  }
}
