import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../data/questions.dart';

import '../providers/language_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIdsAsync = ref.watch(favoriteIdsProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        title: Text(
          language == AppLanguage.malayalam ? 'പ്രിയപ്പെട്ടവ' : 'Favorites', 
          style: TextStyle(
            letterSpacing: 1,
            fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
          )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: favoriteIdsAsync.when(
        data: (ids) {
          if (ids.isEmpty) {
            return Center(child: Text(
              language == AppLanguage.malayalam ? 'ശൂന്യം' : "No favorites yet", 
              style: const TextStyle(color: Colors.white38)
            ));
          }

          final allQuestions = DataService.allQuestions;
          final favorites = allQuestions.where((q) => ids.contains(q.id)).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final question = favorites[index];
              return Dismissible(
                key: ValueKey(question.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref.read(favoriteIdsProvider.notifier).toggle(question.id);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red.withOpacity(0.2),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18181B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF27272A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.getLocalizedText(language),
                        style: TextStyle(
                           fontSize: 16, 
                           color: const Color(0xFFE4E4E7),
                           fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        question.category.getDisplayName(language),
                        style: TextStyle(
                           fontSize: 12, 
                           color: Colors.white24,
                           fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Error loading favorites")),
      ),
    );
  }
}
