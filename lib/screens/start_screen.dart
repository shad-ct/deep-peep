import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _FollowMeButton(),
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
                  ),
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
                      fontFamily: language == AppLanguage.malayalam ? 'NotoSansMalayalam' : 'Inter',
                    ),
                  ),
                ),
                Text(
                  category.getDescription(language),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontFamily: language == AppLanguage.malayalam ? 'NotoSansMalayalam' : 'Inter',
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

class _FollowMeButton extends StatefulWidget {
  const _FollowMeButton();

  @override
  State<_FollowMeButton> createState() => _FollowMeButtonState();
}

class _FollowMeButtonState extends State<_FollowMeButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  Future<void> _launch() async {
    final uri = Uri.parse('https://github.com/shad-ct');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // fallback: try platform default
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _launch();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF27272A),
                const Color(0xFF3F3F46),
              ],
            ),
            border: Border.all(color: const Color(0xFF52525B), width: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.code_rounded, color: Colors.white, size: 12),
              SizedBox(width: 5),
              Text(
                'Follow me',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              delay: const Duration(seconds: 2),
              duration: const Duration(milliseconds: 1200),
              color: Colors.white.withOpacity(0.15),
            ),
      ),
    );
  }
}
