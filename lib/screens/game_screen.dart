import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../models/question.dart';
import 'favorites_screen.dart';
import '../widgets/squishy_card.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int _slideDirection = 1; // 1: Next (Right to Left), -1: Previous (Left to Right)

  void _showOverlay(IconData icon, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Icon(icon, color: Colors.white),
        backgroundColor: color.withValues(alpha: 0.8),
        duration: 500.ms,
        behavior: SnackBarBehavior.floating,
        shape: const CircleBorder(),
        width: 60,
      )
    );
  }

  void _shareQuestion(String text) {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameSessionProvider);
    final category = ref.watch(currentCategoryProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Immersive black
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white38),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Hero(
                    tag: 'category_${category?.name ?? ""}',
                    child: Text(
                      category?.getDisplayName(language).toUpperCase() ?? "",
                      style: TextStyle(
                        letterSpacing: 2, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white38,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                         fontFamily: language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
// ... rest remains same ...
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white38),
                        onPressed: () {
                           if (session.current != null) {
                             _shareQuestion(session.current!.text);
                           }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white38),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: session.isFinished 
                ? _buildEmptyState(context, ref, category) 
                : _buildCardStack(context, ref, session, language),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  // ... rest of the file remains the same ...

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, Category? category) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
                "THE END",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                   fontWeight: FontWeight.bold,
                   color: Colors.white10
                ),
             ),
             const Gap(24),
             if (category != null)
               TextButton(
                 onPressed: () {
                    ref.read(gameSessionProvider.notifier).resetCategory(category);
                 },
                 child: const Text("RESET VOID", style: TextStyle(color: Colors.white38)),
               )
          ],
        ).animate().fadeIn(duration: 800.ms),
      );
  }

  Widget _buildCardStack(BuildContext context, WidgetRef ref, GameSessionState session, AppLanguage language) {
    if (session.current == null) return const SizedBox.shrink();

    return Center(
      child: SquishyCard(
        question: session.current!,
        slideDirection: _slideDirection,
        language: language,
        onSwipeLeft: () {
           setState(() => _slideDirection = 1); // Next -> New comes from Right
           ref.read(gameSessionProvider.notifier).next();
        },
        onSwipeRight: () {
           setState(() => _slideDirection = -1); // Previous -> New comes from Left
           ref.read(gameSessionProvider.notifier).previous();
        },
        onSwipeUp: () {
           ref.read(favoriteIdsProvider.notifier).toggle(session.current!.id); 
           _showOverlay(Icons.favorite, Colors.pinkAccent);
        },
        onSwipeDown: () {
           ref.read(bannedIdsProvider.notifier).add(session.current!.id);
           ref.read(gameSessionProvider.notifier).next();
           _showOverlay(Icons.delete, Colors.redAccent);
        },
      ),
    );
  }
}
