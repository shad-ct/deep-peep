import '../providers/language_provider.dart';

enum Category {
  algorithm,
  mirror,
  confession,
  courtroom,
  chaos,
  glitch,
  spark,
  crew,
  roots,
  shadow,
  blueprint,
  frequency,
  rift,
  heist,
  oracle,
  taboo,
  nostalgia,
  imagination,
  gratitude,
  voidVibe;

  String getDisplayName(AppLanguage lang) {
    if (lang == AppLanguage.malayalam) {
       switch (this) {
        case Category.algorithm: return 'അൽഗോരിതം (The Algorithm)';
        case Category.mirror: return 'കണ്ണാടി (The Mirror)';
        case Category.confession: return 'കുറ്റസമ്മതം (The Confession)';
        case Category.courtroom: return 'കോടതി (The Courtroom)';
        case Category.chaos: return 'അരാജകത്വം (The Chaos)';
        case Category.glitch: return 'തകരാർ (The Glitch)';
        case Category.spark: return 'സ്പാർക്ക് (The Spark)';
        case Category.crew: return 'കൂട്ടുകാർ (The Crew)';
        case Category.roots: return 'വേരുകൾ (The Roots)';
        case Category.shadow: return 'നിഴൽ (The Shadow)';
        case Category.blueprint: return 'ബ്ലൂപ്രിന്റ് (The Blueprint)';
        case Category.frequency: return 'ഫ്രീക്വൻസി (The Frequency)';
        case Category.rift: return 'വിള്ളൽ (The Rift)';
        case Category.heist: return 'മോഷണം (The Heist)';
        case Category.oracle: return 'പ്രവചനം (The Oracle)';
        case Category.taboo: return 'വിലക്കപ്പെട്ടത് (The Taboo)';
        case Category.nostalgia: return 'ഓർമ്മകൾ (The Nostalgia)';
        case Category.imagination: return 'ഭാവന (The Imagination)';
        case Category.gratitude: return 'നന്ദി (The Gratitude)';
        case Category.voidVibe: return 'ശൂന്യത (The Void)';
      }
    }
    // English Fallback
    switch (this) {
      case Category.algorithm: return 'The Algorithm';
      case Category.mirror: return 'The Mirror';
      case Category.confession: return 'The Confession';
      case Category.courtroom: return 'The Courtroom';
      case Category.chaos: return 'The Chaos';
      case Category.glitch: return 'The Glitch';
      case Category.spark: return 'The Spark';
      case Category.crew: return 'The Crew';
      case Category.roots: return 'The Roots';
      case Category.shadow: return 'The Shadow';
      case Category.blueprint: return 'The Blueprint';
      case Category.frequency: return 'The Frequency';
      case Category.rift: return 'The Rift';
      case Category.heist: return 'The Heist';
      case Category.oracle: return 'The Oracle';
      case Category.taboo: return 'The Taboo';
      case Category.nostalgia: return 'The Nostalgia';
      case Category.imagination: return 'The Imagination';
      case Category.gratitude: return 'The Gratitude';
      case Category.voidVibe: return 'The Void';
    }
  }

  String getDescription(AppLanguage lang) {
    if (lang == AppLanguage.malayalam) {
       switch (this) {
        case Category.algorithm: return 'ഡിജിറ്റൽ ജീവിതം';
        case Category.mirror: return 'സ്വയം ചിന്ത';
        case Category.confession: return 'രഹസ്യങ്ങൾ';
        case Category.courtroom: return 'ധാർമ്മികത';
        case Category.chaos: return 'വട്ടൻ ചിന്തകൾ';
        case Category.glitch: return 'യാഥാർത്ഥ്യം';
        case Category.spark: return 'പ്രണയം';
        case Category.crew: return 'സൗഹൃദം';
        case Category.roots: return 'കുടുംബം';
        case Category.shadow: return 'ഭയങ്ങൾ';
        case Category.blueprint: return 'ലക്ഷ്യങ്ങൾ';
        case Category.frequency: return 'കലയും സംസ്കാരവും';
        case Category.rift: return 'തർക്കങ്ങൾ';
        case Category.heist: return 'നിയമലംഘനം';
        case Category.oracle: return 'ഭാവി';
        case Category.taboo: return 'വിലക്കപ്പെട്ട ചിന്തകൾ';
        case Category.nostalgia: return 'ഗൃഹാതുരത്വം';
        case Category.imagination: return 'സങ്കല്പങ്ങൾ';
        case Category.gratitude: return 'സന്തോഷം';
        case Category.voidVibe: return 'അസ്തിത്വം';
      }
    }
    switch (this) {
       case Category.algorithm: return 'Digital Footprint';
       case Category.mirror: return 'Self-Reflection';
       case Category.confession: return 'Secrets & Guilt';
       case Category.courtroom: return 'Moral Dilemmas';
       case Category.chaos: return 'Unhinged & Absurd';
       case Category.glitch: return 'Simulation & Reality';
       case Category.spark: return 'Romance & Exes';
       case Category.crew: return 'Friendship & Loyalty';
       case Category.roots: return 'Family & Upbringing';
       case Category.shadow: return 'Fears & Dark Thoughts';
       case Category.blueprint: return 'Ambitions & Hustle';
       case Category.frequency: return 'Art & Taste';
       case Category.rift: return 'Conflict & Tension';
       case Category.heist: return 'Schemes & Rules';
       case Category.oracle: return 'Future Predictions';
       case Category.taboo: return 'Dark Psychology';
       case Category.nostalgia: return 'Memories & Past';
       case Category.imagination: return 'Creative World-building';
       case Category.gratitude: return 'Joy & Peace';
       case Category.voidVibe: return 'Deep Philosophy';
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
