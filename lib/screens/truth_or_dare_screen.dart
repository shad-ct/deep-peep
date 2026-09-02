import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../providers/mini_games_provider.dart';
import '../providers/language_provider.dart';

class TruthOrDareScreen extends ConsumerStatefulWidget {
  const TruthOrDareScreen({super.key});

  @override
  ConsumerState<TruthOrDareScreen> createState() => _TruthOrDareScreenState();
}

class _TruthOrDareScreenState extends ConsumerState<TruthOrDareScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mode = ref.read(truthOrDareMode_Provider);
      if (mode == TruthOrDareMode.none) {
        // Reset to selection on first enter
        _initialized = true;
      } else {
        _initialized = true;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(truthOrDareMode_Provider);
    final language = ref.watch(languageProvider);
    final isMl = language == AppLanguage.malayalam;

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF09090B),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (mode == TruthOrDareMode.none) {
      return _buildModeSelection(context, isMl);
    }

    if (mode == TruthOrDareMode.truth) {
      return _buildTruthDareGame(context, ref, language, isMl, isTruth: true);
    } else {
      return _buildTruthDareGame(context, ref, language, isMl, isTruth: false);
    }
  }

  Widget _buildModeSelection(BuildContext context, bool isMl) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Gap(16),
              Text(
                isMl ? 'ട്രൂത്ത് ഓർ ഡെയർ' : 'Truth or Dare',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                isMl ? 'ഒന്ന് തിരഞ്ഞെടുക്കൂ' : 'Choose your fate',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              const Spacer(),
              // TRUTH button
              _ModeButton(
                label: isMl ? 'ട്രൂത്ത്' : 'TRUTH',
                emoji: '🤍',
                color: const Color(0xFF3B82F6),
                onTap: () async {
                  ref.read(truthOrDareMode_Provider.notifier).setTruth();
                  await ref.read(truthSessionProvider.notifier).init();
                },
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
              const Gap(20),
              // DARE button
              _ModeButton(
                label: isMl ? 'ഡെയർ' : 'DARE',
                emoji: '🔥',
                color: const Color(0xFFEF4444),
                onTap: () async {
                  ref.read(truthOrDareMode_Provider.notifier).setDare();
                  await ref.read(dareSessionProvider.notifier).init();
                },
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTruthDareGame(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    bool isMl, {
    required bool isTruth,
  }) {
    final session = isTruth
        ? ref.watch(truthSessionProvider)
        : ref.watch(dareSessionProvider);

    final color = isTruth ? const Color(0xFF3B82F6) : const Color(0xFFEF4444);
    final typeLabel = isTruth
        ? (isMl ? 'ട്രൂത്ത്' : 'TRUTH')
        : (isMl ? 'ഡെയർ' : 'DARE');
    final exhaustedMsg = isTruth
        ? (isMl ? 'എല്ലാ ചോദ്യങ്ങളും തീർന്നു!' : "All Truths completed!")
        : (isMl ? 'എല്ലാ ഡെയറുകളും തീർന്നു!' : "All Dares completed!");
    final resetLabel = isTruth
        ? (isMl ? 'ട്രൂത്ത് റീസ്റ്റാർട്ട്' : 'Restart Truths')
        : (isMl ? 'ഡെയർ റീസ്റ്റാർട്ട്' : 'Restart Dares');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.white38),
                    label: Text(isMl ? 'മടങ്ങുക' : 'Back',
                        style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    onPressed: () {
                      ref.read(truthOrDareMode_Provider.notifier).reset();
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Switch mode button
                  TextButton(
                    onPressed: () async {
                      if (isTruth) {
                        ref.read(truthOrDareMode_Provider.notifier).setDare();
                        await ref.read(dareSessionProvider.notifier).init();
                      } else {
                        ref.read(truthOrDareMode_Provider.notifier).setTruth();
                        await ref.read(truthSessionProvider.notifier).init();
                      }
                    },
                    child: Text(
                      isTruth
                          ? (isMl ? 'ഡെയർ' : 'Dare')
                          : (isMl ? 'ട്രൂത്ത്' : 'Truth'),
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            if (session.isExhausted)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exhaustedMsg,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(24),
                      ElevatedButton(
                        onPressed: () async {
                          if (isTruth) {
                            await ref.read(truthSessionProvider.notifier).reset();
                          } else {
                            await ref.read(dareSessionProvider.notifier).reset();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.withOpacity(0.2),
                          foregroundColor: color,
                          side: BorderSide(color: color.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(resetLabel),
                      ),
                    ],
                  ).animate().fadeIn(duration: 600.ms),
                ),
              )
            else if (session.current != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Show Malayalam primary if in ML mode and has translation
                            if (isMl && session.current!.textMl != null) ...[
                              Text(
                                session.current!.textMl!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE4E4E7),
                                  fontFamily: 'NotoSansMalayalam',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(16),
                              Text(
                                session.current!.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.white.withOpacity(0.7),
                                  fontFamily: 'Inter',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ] else
                              Text(
                                session.current!.text,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE4E4E7),
                                  fontFamily: 'Inter',
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1.0, 1.0),
                          ),
                      const Gap(40),
                      // Controls
                      Row(
                        children: [
                          // Skip
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (isTruth) {
                                  ref.read(truthSessionProvider.notifier).next();
                                } else {
                                  ref.read(dareSessionProvider.notifier).next();
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white38,
                                side: const BorderSide(color: Color(0xFF27272A)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(isMl ? 'സ്കിപ്പ്' : 'Skip'),
                            ),
                          ),
                          const Gap(12),
                          // Done
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isTruth) {
                                  ref.read(truthSessionProvider.notifier).next();
                                } else {
                                  ref.read(dareSessionProvider.notifier).next();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                isMl ? 'പൂർത്തിയായി ✓' : 'Done ✓',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
