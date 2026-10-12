import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AnswerPanel extends StatelessWidget {
  const AnswerPanel({
    super.key,
    required this.answer,
    this.question,
    this.onRepeat,
    this.onDismiss,
  });

  final String answer;
  final String? question;
  final VoidCallback? onRepeat;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (question != null && question!.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                question!,
                style: const TextStyle(fontSize: AppSizes.fontQuestion, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        if (question != null && question!.isNotEmpty) const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.cardPadding, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1B22),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            answer,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppSizes.fontAnswer,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (onRepeat != null || onDismiss != null) ...[
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              if (onRepeat != null)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: onRepeat,
                    icon: const Icon(Icons.volume_up_rounded, size: 36),
                  ),
                ),
              if (onDismiss != null)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF24252E),
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Kembali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Ketuk 2× di layar untuk kembali',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.dimText, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
