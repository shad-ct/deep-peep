import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../providers/mini_games_provider.dart';
import '../providers/language_provider.dart';
import '../models/game_item.dart';

class ThisOrThatScreen extends ConsumerStatefulWidget {
  const ThisOrThatScreen({super.key});

  @override
  ConsumerState<ThisOrThatScreen> createState() => _ThisOrThatScreenState();
}

class _ThisOrThatScreenState extends ConsumerState<ThisOrThatScreen> {
  int _slideDirection = 1;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = ref.read(totGameSessionProvider);
      if (session.current == null && !session.isExhausted) {
        await ref.read(totGameSessionProvider.notifier).init();
      }
      if (mounted) setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(totGameSessionProvider);
    final language = ref.watch(languageProvider);
    final isMl = language == AppLanguage.malayalam;

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF09090B),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isMl ? 'ഇതോ അതോ' : 'THIS OR THAT',
                    style: const TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.translate, color: Colors.white38, size: 20),
                    onPressed: () => ref.read(languageProvider.notifier).toggle(),
                    tooltip: isMl ? 'English' : 'മലയാളം',
                  ),
                ],
              ),
            ),
            Expanded(
              child: session.isExhausted
                  ? _buildExhausted(context, ref, isMl)
                  : (session.current != null
                      ? _buildCard(context, ref, session, language, isMl)
                      : const Center(child: CircularProgressIndicator())),
            ),
            if (!session.isExhausted && session.current != null)
              _buildDirectionHints(isMl, session.current!),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildExhausted(BuildContext context, WidgetRef ref, bool isMl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isMl ? 'എല്ലാ ചോദ്യങ്ങളും കഴിഞ്ഞു!' : "All questions completed!",
            style: const TextStyle(
                color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          OutlinedButton(
            onPressed: () async {
              await ref.read(totGameSessionProvider.notifier).reset();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Color(0xFF27272A)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isMl ? 'വീണ്ടും കളിക്കുക' : 'Play Again'),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms),
    );
  }

  Widget _buildDirectionHints(bool isMl, ThisOrThatItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Colors.white24, size: 14),
                const Gap(4),
                Expanded(
                  child: Text(
                    isMl ? (item.optionAMl ?? item.optionA) : item.optionA,
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontFamily: 'NotoSansMalayalam',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    isMl ? (item.optionBMl ?? item.optionB) : item.optionB,
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontFamily: 'NotoSansMalayalam',
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(4),
                const Icon(Icons.arrow_forward, color: Colors.white24, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    TotSession session,
    AppLanguage language,
    bool isMl,
  ) {
    final item = session.current!;
    return Center(
      child: TotCard(
        item: item,
        slideDirection: _slideDirection,
        language: language,
        onSwipeLeft: () {
          // Left → Option A
          setState(() => _slideDirection = 1);
          ref.read(totGameSessionProvider.notifier).next();
        },
        onSwipeRight: () {
          // Right → Option B (or history)
          setState(() => _slideDirection = -1);
          ref.read(totGameSessionProvider.notifier).next();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TotCard — swipe-based This or That card
// ─────────────────────────────────────────────
class TotCard extends StatefulWidget {
  final ThisOrThatItem item;
  final int slideDirection;
  final AppLanguage language;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const TotCard({
    super.key,
    required this.item,
    required this.slideDirection,
    required this.language,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<TotCard> createState() => _TotCardState();
}

class _TotCardState extends State<TotCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  Offset _startDragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails d) {
    _controller.stop();
    _startDragOffset = d.globalPosition;
  }

  void _handlePanUpdate(DragUpdateDetails d) {
    setState(() {
      final dx = (d.globalPosition - _startDragOffset).dx;
      _dragOffset = Offset(dx * 0.8, 0);
    });
  }

  void _handlePanEnd(DragEndDetails d) {
    const threshold = 100.0;
    if (_dragOffset.dx > threshold) {
      widget.onSwipeRight();
      _springBack();
    } else if (_dragOffset.dx < -threshold) {
      widget.onSwipeLeft();
      _springBack();
    } else {
      _springBack();
    }
  }

  void _springBack() {
    final start = _dragOffset;
    _controller.reset();
    final anim = Tween<Offset>(begin: start, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    anim.addListener(() {
      if (mounted) setState(() => _dragOffset = anim.value);
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final dx = _dragOffset.dx;
    final isMl = widget.language == AppLanguage.malayalam;
    final leftHighlight = (-dx / 150).clamp(0.0, 1.0); // option A
    final rightHighlight = (dx / 150).clamp(0.0, 1.0); // option B
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    final item = widget.item;

    final optA = isMl ? (item.optionAMl ?? item.optionA) : item.optionA;
    final optB = isMl ? (item.optionBMl ?? item.optionB) : item.optionB;
    final optAEn = item.optionA;
    final optBEn = item.optionB;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Left hint — Option A
        Positioned(
          left: -90,
          child: Opacity(
            opacity: leftHighlight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'A',
                style: TextStyle(
                    color: const Color(0xFF6366F1).withOpacity(1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
        // Right hint — Option B
        Positioned(
          right: -90,
          child: Opacity(
            opacity: rightHighlight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'B',
                style: TextStyle(
                    color: const Color(0xFFF59E0B).withOpacity(1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
        // Card
        GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: Transform.translate(
            offset: _dragOffset,
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF27272A), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Option A — top half (swipe left)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          const Color(0xFF1E1E24),
                          const Color(0xFF6366F1).withOpacity(0.3),
                          leftHighlight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.arrow_back, color: Colors.white24, size: 14),
                              const SizedBox(width: 4),
                              Text('A',
                                  style: TextStyle(
                                      color: const Color(0xFF6366F1).withOpacity(0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            optA,
                            key: ValueKey('optA_${item.id}'),
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: isMl ? 'NotoSansMalayalam' : 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isMl && item.optionAMl != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              optAEn,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFF27272A),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18181B),
                            border: Border.all(color: const Color(0xFF27272A)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isMl ? 'VS' : 'VS',
                            style: const TextStyle(
                                color: Colors.white24,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Option B — bottom half (swipe right)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          const Color(0xFF1A1A1F),
                          const Color(0xFFF59E0B).withOpacity(0.3),
                          rightHighlight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            optB,
                            key: ValueKey('optB_${item.id}'),
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: isMl ? 'NotoSansMalayalam' : 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isMl && item.optionBMl != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              optBEn,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('B',
                                  style: TextStyle(
                                      color: const Color(0xFFF59E0B).withOpacity(0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, color: Colors.white24, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
