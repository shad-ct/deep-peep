import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../models/question.dart';
import '../providers/language_provider.dart';

class SquishyCard extends StatefulWidget {
  final Question question;
  final int slideDirection; // 1: From Right (Next), -1: From Left (Previous)
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;
  final AppLanguage language;

  const SquishyCard({
    super.key,
    required this.question,
    required this.slideDirection,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onSwipeDown,
    required this.language,
  });

  @override
  State<SquishyCard> createState() => _SquishyCardState();
}

class _SquishyCardState extends State<SquishyCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  Offset _startDragOffset = Offset.zero;
  Axis? _lockedAxis;
  // removed random animation state

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _controller.addListener(() {
      setState(() {
        _dragOffset = Offset.lerp(_dragOffset, Offset.zero, _controller.value)!;
      });
    });
  }

  @override
  void didUpdateWidget(SquishyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Direction logic is handled by parent's passed parameter
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    _controller.stop();
    _startDragOffset = details.globalPosition;
    _lockedAxis = null; // Reset lock
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      final totalDelta = details.globalPosition - _startDragOffset;
      
      // Axis Locking Logic
      if (_lockedAxis == null) {
        if (totalDelta.distance > 10) { // Threshold to determine axis
          if (totalDelta.dx.abs() > totalDelta.dy.abs()) {
            _lockedAxis = Axis.horizontal;
          } else {
            _lockedAxis = Axis.vertical;
          }
        }
      }

      // Apply drag only on locked axis
      if (_lockedAxis == Axis.horizontal) {
        _dragOffset = Offset(totalDelta.dx * 0.8, 0); // Lock Y to 0
      } else if (_lockedAxis == Axis.vertical) {
        _dragOffset = Offset(0, totalDelta.dy * 0.8); // Lock X to 0
      } else {
         // Before lock, move slightly in both (optional, or stay 0)
         _dragOffset = totalDelta * 0.8;
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    final threshold = 100.0;

    if (_dragOffset.dx.abs() > _dragOffset.dy.abs()) {
      // Horizontal
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
      // Vertical
      if (_dragOffset.dy < -threshold) {
        // Up -> Favorite
        widget.onSwipeUp();
        _springBack();
      } else if (_dragOffset.dy > threshold) {
        // Down -> Ban
        widget.onSwipeDown();
        _springBack();
      } else {
        _springBack();
      }
    }
  }

  void _springBack() {
    final start = _dragOffset;
    _controller.reset();

    Animation<Offset> animation = Tween<Offset>(begin: start, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );

    animation.addListener(() {
      setState(() {
        _dragOffset = animation.value;
      });
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Physics Calculations
    final dx = _dragOffset.dx;
    final dy = _dragOffset.dy;
    
    // Visual Hint Opacity
    double heartOpacity = (-dy / 100).clamp(0.0, 1.0); // More sensitive
    double trashOpacity = (dy / 100).clamp(0.0, 1.0);
    double rightOpacity = (dx / 100).clamp(0.0, 1.0); // Previous (Drag Right)
    double leftOpacity = (-dx / 100).clamp(0.0, 1.0); // Next (Drag Left)

    final double cardSize = MediaQuery.of(context).size.width * 0.85;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // --- VISUAL HINTS (Outside & Stationary) ---
        
        // Up - FAVORITE
        Positioned(
          top: -100,
          child: Opacity(
            opacity: heartOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.pinkAccent, size: 50),
                const Gap(8),
                Text(
                  widget.language == AppLanguage.malayalam ? "ഇഷ്ടനായി" : "FAVORITE", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.pinkAccent, fontSize: 16)
                ),
              ],
            ),
          ),
        ),

        // Down - REMOVE
        Positioned(
          bottom: -100,
          child: Opacity(
            opacity: trashOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.language == AppLanguage.malayalam ? "നീക്കം ചെയ്യുക" : "REMOVE", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16)
                ),
                const Gap(8),
                const Icon(Icons.delete, color: Colors.redAccent, size: 50),
              ],
            ),
          ),
        ),

        // Right - HISTORY (Target is Right)
        Positioned(
          right: -80, // Outside Right
          child: Opacity(
            opacity: rightOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_forward, color: Colors.blueAccent, size: 40),
                Text(
                  widget.language == AppLanguage.malayalam ? "ചരിത്രം" : "HISTORY", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12)
                ),
              ],
            ),
          ),
        ),

        // Left - NEXT (Target is Left)
        Positioned(
          left: -80, // Outside Left
          child: Opacity(
            opacity: leftOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 const Icon(Icons.arrow_back, color: Colors.white24, size: 40),
                 Text(
                   widget.language == AppLanguage.malayalam ? "അടുത്തത്" : "NEXT", 
                   style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white24, fontSize: 12)
                 ),
              ],
            ),
          ),
        ),

        // --- THE CARD ---
        GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: Transform.translate(
            offset: _dragOffset,
            child: Container(
              width: cardSize,
              height: cardSize, // Square
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF27272A), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  widget.question.getLocalizedText(widget.language),
                  key: ValueKey(widget.question.getLocalizedText(widget.language)),
                  style: TextStyle(
                      fontSize: 22,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE4E4E7), // Zinc 200
                      fontFamily: widget.language == AppLanguage.malayalam ? 'GoogleFonts.notoSansMalayalam' : 'Inter'
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
