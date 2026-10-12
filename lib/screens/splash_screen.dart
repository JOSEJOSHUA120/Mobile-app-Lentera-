import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_config.dart';
import '../constants/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/lentera_logo.svg', width: 112, height: 112),
            const SizedBox(height: 28),
            const Text(
              AppConfig.appName,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 0.4),
            ),
            const SizedBox(height: 10),
            const Text(
              'Layanan Informasi Harian\nuntuk Tunanetra',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText, fontSize: 13, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
