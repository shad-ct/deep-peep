import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../models/question.dart';
import '../providers/game_provider.dart';
import '../providers/language_provider.dart';
import 'game_screen.dart';
import 'favorites_screen.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Image.asset(
                     'lib/assets/deep.png',
                     height: 40,
                   ),
                   Row(
                     children: [
                       TextButton(
                         onPressed: () {
                           ref.read(languageProvider.notifier).toggle();
                         },
                         child: Text(
                           language == AppLanguage.malayalam ? 'English' : 'മലയാളം',
                           style: const TextStyle(color: Colors.white70),
                         ),
                       ),
                       IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white70),
                        onPressed: () {
                           Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const FavoritesScreen(),
                                ),
                              );
                        },
                      ),
                     ],
                   )
                ],
              ),
              const Gap(10),

              Expanded(
                child: ListView(
                  children: Category.values.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _CategoryButton(
                        category: category,
                        language: language,
                        onTap: () async {
                          ref.read(currentCategoryProvider.notifier).set(category);
                          await ref.read(gameSessionProvider.notifier).init(category);
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final AppLanguage language;

  const _CategoryButton({
    required this.category, 
    required this.onTap, 
    required this.language
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B), // Zinc 900
          border: Border.all(color: const Color(0xFF27272A)), // Zinc 800
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'category_${category.name}',
                  child: Text(
                    category.getDisplayName(language),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
                    ),
                  ),
                ),
                Text(
                  category.getDescription(language),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
