import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Color(0xFF08090D);
  static const surface = Color(0xFF101116);
  static const surfaceSoft = Color(0xFF171821);
  static const primary = Color(0xFFFF3038);
  static const primaryDark = Color(0xFFD9234D);
  static const primaryGlow = Color(0x55FF3038);
  static const text = Color(0xFFFFFFFF);
  static const mutedText = Color(0xFFB8B8C2);
  static const dimText = Color(0xFF73737F);
  static const error = Color(0xFFFF6B6B);
  static const success = Color(0xFF68D391);

  static const logoGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
