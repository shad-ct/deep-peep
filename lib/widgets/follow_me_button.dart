import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowMeButton extends StatefulWidget {
  const FollowMeButton({super.key});

  @override
  State<FollowMeButton> createState() => _FollowMeButtonState();
}

class _FollowMeButtonState extends State<FollowMeButton> {
  bool _pressed = false;

  Future<void> _launch() async {
    final uri = Uri.parse('https://github.com/shad-ct');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
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
            gradient: const LinearGradient(
              colors: [Color(0xFF27272A), Color(0xFF3F3F46)],
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
