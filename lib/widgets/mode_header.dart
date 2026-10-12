import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../models/app_mode.dart';

class ModeHeader extends StatelessWidget {
  const ModeHeader({super.key, required this.mode});

  final AppMode mode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          mode.label,
          style: const TextStyle(
            fontSize: AppSizes.fontModeLabel,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 18),
        if (mode == AppMode.ai)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF76A7FF), size: 32),
              const SizedBox(width: 12),
              const Text(
                'Gemini',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
