import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ProcessingIndicator extends StatelessWidget {
  const ProcessingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(strokeWidth: 4, color: AppColors.text),
    );
  }
}
