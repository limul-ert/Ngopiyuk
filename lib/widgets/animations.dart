import 'package:flutter/material.dart';

// ============================================
// 1. STAGGERED ENTRANCE
// Fade + slide up dengan delay berdasarkan index.
// Bikin efek cascading kayak feed Instagram/Airbnb.
// ============================================
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration stepDelay;
  final Duration duration;
  final double slideFrom;

  const StaggeredEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.stepDelay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
    this.slideFrom = 20,
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _offset = Tween<Offset>(
      begin: Offset(0, widget.slideFrom / 100),
      end: Offset.zero,
    ).animate(curve);

    // Cap index biar delay maksimal 400ms
    final cappedIndex = widget.index.clamp(0, 8);
    final delay = widget.stepDelay * cappedIndex;

    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

// ============================================
// 2. PRESSABLE CARD
// Subtle press-scale feedback (3% mengecil).
// Pakai Listener (raw pointer) biar gak
// konflik dengan GestureDetector di dalam.
// ============================================
class PressableCard extends StatefulWidget {
  final Widget child;
  final double pressScale;

  const PressableCard({
    super.key,
    required this.child,
    this.pressScale = 0.97,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressScale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}