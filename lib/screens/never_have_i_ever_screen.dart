import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../providers/mini_games_provider.dart';
import '../providers/language_provider.dart';
import '../models/game_item.dart';

class NeverHaveIEverScreen extends ConsumerStatefulWidget {
  const NeverHaveIEverScreen({super.key});

  @override
  ConsumerState<NeverHaveIEverScreen> createState() =>
      _NeverHaveIEverScreenState();
}

class _NeverHaveIEverScreenState extends ConsumerState<NeverHaveIEverScreen> {
  int _slideDirection = 1;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = ref.read(nhieGameSessionProvider);
      if (session.current == null && !session.isExhausted) {
        await ref.read(nhieGameSessionProvider.notifier).init();
      }
      if (mounted) setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(nhieGameSessionProvider);
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
                    isMl ? 'ഒരിക്കലും ഇല്ല' : 'NEVER HAVE I EVER',
                    style: const TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                  // Translate toggle button
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
                  : _buildCard(context, ref, session, language),
            ),
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
            isMl
                ? 'എല്ലാ statements-ഉം കഴിഞ്ഞു!'
                : "You've gone through all the statements.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          OutlinedButton(
            onPressed: () async {
              await ref.read(nhieGameSessionProvider.notifier).reset();
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

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    NhieSession session,
    AppLanguage language,
  ) {
    if (session.current == null) return const SizedBox.shrink();

    // Use a custom NHIE card instead of the SquishyCard
    final item = session.current!;
    return Center(
      child: NhieCard(
        item: item,
        slideDirection: _slideDirection,
        language: language,
        onSwipeLeft: () {
          setState(() => _slideDirection = 1);
          ref.read(nhieGameSessionProvider.notifier).next();
        },
        onSwipeRight: () {
          setState(() => _slideDirection = -1);
          ref.read(nhieGameSessionProvider.notifier).previous();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  NhieCard — swipe-based NHIE card
// ─────────────────────────────────────────────
class NhieCard extends StatefulWidget {
  final GameItem item;
  final int slideDirection;
  final AppLanguage language;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const NhieCard({
    super.key,
    required this.item,
    required this.slideDirection,
    required this.language,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<NhieCard> createState() => _NhieCardState();
}

class _NhieCardState extends State<NhieCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  Offset _startDragOffset = Offset.zero;
  Axis? _lockedAxis;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    _controller.stop();
    _startDragOffset = details.globalPosition;
    _lockedAxis = null;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      final totalDelta = details.globalPosition - _startDragOffset;
      if (_lockedAxis == null && totalDelta.distance > 10) {
        _lockedAxis = totalDelta.dx.abs() > totalDelta.dy.abs()
            ? Axis.horizontal
            : Axis.vertical;
      }
      if (_lockedAxis == Axis.horizontal) {
        _dragOffset = Offset(totalDelta.dx * 0.8, 0);
      } else if (_lockedAxis == Axis.vertical) {
        _dragOffset = Offset(0, totalDelta.dy * 0.8);
      } else {
        _dragOffset = totalDelta * 0.8;
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    const threshold = 100.0;
    if (_dragOffset.dx.abs() > _dragOffset.dy.abs()) {
      if (_dragOffset.dx > threshold) {
        widget.onSwipeRight();
        _springBack();
      } else if (_dragOffset.dx < -threshold) {
        widget.onSwipeLeft();
        _springBack();
      } else {
        _springBack();
      }
    } else {
      _springBack();
    }
  }

  void _springBack() {
    final start = _dragOffset;
    _controller.reset();
    final animation = Tween<Offset>(begin: start, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    animation.addListener(() {
      if (mounted) setState(() => _dragOffset = animation.value);
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final dx = _dragOffset.dx;
    final isMl = widget.language == AppLanguage.malayalam;
    final rightOpacity = (dx / 100).clamp(0.0, 1.0);
    final leftOpacity = (-dx / 100).clamp(0.0, 1.0);
    final cardSize = MediaQuery.of(context).size.width * 0.85;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // RIGHT - Previous
        Positioned(
          right: -80,
          child: Opacity(
            opacity: rightOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_forward, color: Colors.blueAccent, size: 40),
                Text(isMl ? 'ചരിത്രം' : 'BACK',
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        // LEFT - Next
        Positioned(
          left: -80,
          child: Opacity(
            opacity: leftOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white24, size: 40),
                Text(isMl ? 'അടുത്തത്' : 'NEXT',
                    style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
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
              width: cardSize,
              constraints: BoxConstraints(
                minHeight: cardSize * 0.6,
                maxHeight: cardSize * 1.1,
              ),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: const Color(0xFF22C55E).withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMl && widget.item.textMl != null) ...[
                      Text(
                        widget.item.textMl!,
                        key: ValueKey('ml_${widget.item.id}'),
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE4E4E7),
                          fontFamily: 'NotoSansMalayalam',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(14),
                      Text(
                        widget.item.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else
                      Text(
                        widget.item.text,
                        key: ValueKey('en_${widget.item.id}'),
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE4E4E7),
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
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
