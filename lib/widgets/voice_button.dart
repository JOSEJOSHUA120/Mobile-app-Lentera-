import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.mic_none_rounded,
    this.size = 108,
    this.isListening = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final bool isListening;

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Tombol perintah suara',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: widget.isListening ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: widget.size * 1.95,
              height: widget.size * 1.95,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x331F0208),
                boxShadow: [
                  BoxShadow(
                    color: widget.isListening
                        ? AppColors.primaryGlow.withOpacity(0.6)
                        : AppColors.primaryGlow,
                    blurRadius: widget.isListening ? 48 : 38,
                    spreadRadius: widget.isListening ? 10 : 6,
                  ),
                ],
              ),
              child: Container(
                width: widget.size * 1.35,
                height: widget.size * 1.35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x552B0610)),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.logoGradient,
                  ),
                  child: Icon(widget.icon, color: Colors.black, size: widget.size * 0.45),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
