import '../providers/language_provider.dart';

enum Category {
  // ... existing values ...
  void_vibe, mirror, taboo, end, spark, roots, crew, journey, ghost, drift, shadow, night, glitch, chaos, hustle;

  String getDisplayName(AppLanguage lang) {
    if (lang == AppLanguage.malayalam) {
       switch (this) {
        case Category.void_vibe: return 'ശൂന്യത (The Void)';
        case Category.mirror: return 'കണ്ണാടി (The Mirror)';
        case Category.taboo: return 'വിലക്കപ്പെട്ടത് (The Taboo)';
        case Category.end: return 'അവസാനം (The End)';
        case Category.spark: return 'സ്പാർക്ക് (The Spark)';
        case Category.roots: return 'വേരുകൾ (The Roots)';
        case Category.crew: return 'കൂട്ടുകാര് (The Crew)';
        case Category.journey: return 'യാത്ര (The Journey)';
        case Category.ghost: return 'ഭൂതം (The Ghost)';
        case Category.drift: return 'ഒഴുകിപ്പോക്ക് (The Drift)';
        case Category.shadow: return 'നിഴൽ (The Shadow)';
        case Category.night: return 'രാത്രി (The Midnight)';
        case Category.glitch: return 'തകരാർ (The Glitch)';
        case Category.chaos: return 'ബഹളം (The Chaos)';
        case Category.hustle: return 'അധ്വാനം (The Hustle)';
      }
    }
    // English Fallback
    switch (this) {
      case Category.void_vibe: return 'The Void';
      case Category.mirror: return 'The Mirror';
      case Category.taboo: return 'The Taboo';
      case Category.end: return 'The End';
      case Category.spark: return 'The Spark';
      case Category.roots: return 'The Roots';
      case Category.crew: return 'The Crew';
      case Category.journey: return 'The Journey';
      case Category.ghost: return 'The Ghost';
      case Category.drift: return 'The Drift';
      case Category.shadow: return 'The Shadow';
      case Category.night: return 'The Midnight';
      case Category.glitch: return 'The Glitch';
      case Category.chaos: return 'The Chaos';
      case Category.hustle: return 'The Hustle';
    }
  }

  String getDescription(AppLanguage lang) {
    if (lang == AppLanguage.malayalam) {
       switch (this) {
        case Category.void_vibe: return 'അസ്തിത്വം';
        case Category.mirror: return 'സ്വയം ചിന്ത';
        case Category.taboo: return 'രഹസ്യങ്ങൾ';
        case Category.end: return 'മരണം';
        case Category.spark: return 'ബന്ധങ്ങൾ';
        case Category.roots: return 'കുടുംബം';
        case Category.crew: return 'സുഹൃത്തുക്കൾ';
        case Category.journey: return 'യാത്ര';
        case Category.ghost: return 'മുൻ അധ്യായങ്ങൾ';
        case Category.drift: return 'ഓർമ്മകൾ';
        case Category.shadow: return 'ഭയങ്ങൾ';
        case Category.night: return 'രാത്രി ചിന്തകൾ';
        case Category.glitch: return 'സിമുലേഷൻ';
        case Category.chaos: return 'വട്ടൻ ചിന്തകൾ';
        case Category.hustle: return 'കരിയർ';
      }
    }
    switch (this) {
      case Category.void_vibe: return 'Existential';
      case Category.mirror: return 'Self-Reflection';
      case Category.taboo: return 'Social/Moral';
      case Category.end: return 'Mortality';
      case Category.spark: return 'Relationships';
      case Category.roots: return 'Family';
      case Category.crew: return 'Friends';
      case Category.journey: return 'Travel';
      case Category.ghost: return 'Exes';
      case Category.drift: return 'Nostalgia';
      case Category.shadow: return 'Fears';
      case Category.night: return '3AM Thoughts';
      case Category.glitch: return 'Simulation';
      case Category.chaos: return 'Unhinged';
      case Category.hustle: return 'Career';
    }
  }
}

class Question {
  final String id;
  final String text;
  final String? textMl;
  final Category category;

  const Question({
    required this.id,
    required this.text,
    this.textMl,
    required this.category,
  });

  String getLocalizedText(AppLanguage lang) {
    if (lang == AppLanguage.malayalam && textMl != null && textMl!.isNotEmpty) {
      return textMl!;
    }
    return text;
  }
}
