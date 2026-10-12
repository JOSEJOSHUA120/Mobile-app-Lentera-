import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../models/voice_state.dart';

class StatusIndicator extends StatefulWidget {
  const StatusIndicator({super.key, required this.state, this.message});

  final VoiceState state;
  final String? message;

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldAnimate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!_shouldAnimate && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _shouldAnimate =>
      widget.state == VoiceState.listening || widget.state == VoiceState.processing;

  @override
  Widget build(BuildContext context) {
    final color = widget.state == VoiceState.error ? AppColors.error : AppColors.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _shouldAnimate ? 6 * _animation.value : 6,
              height: _shouldAnimate ? 6 * _animation.value : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: _shouldAnimate
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.6),
                          blurRadius: 8 * _animation.value,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            widget.message ?? widget.state.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: AppSizes.fontStatus,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
