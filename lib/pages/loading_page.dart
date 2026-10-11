import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'main_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late final AnimationController _frameController;
  late final AnimationController _bobController;
  late final AnimationController _fadeController;
  Timer? _navTimer;

  static const Color _bg = Color(0xFF1B4A5A);

  // ============================================
  // 5 FRAMES — semua pose diikutkan
  // ============================================
  static const List<String> _frames = [
    'assets/images/mascot/frame1.png', // Persiapan
    'assets/images/mascot/frame2.png', // Langkah 1
    'assets/images/mascot/frame3.png', // Langkah 2
    'assets/images/mascot/frame4.png', // Tunjuk HP
    'assets/images/mascot/frame5.png', // Lompat
  ];

  // Durasi per frame
  static const int _frameDurationMs = 300;

  @override
  void initState() {
    super.initState();

    _frameController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _frames.length * _frameDurationMs,
      ),
    )..repeat();

    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _navTimer = Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const MainPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final path in _frames) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _frameController.dispose();
    _bobController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // ← ✅ Ukuran maskot: 95% dari lebar layar
    final mascotSize = w * 0.95;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ===== PARTICLES =====
          ..._buildParticles(w, h),

          // ===== GROUND SHADOW =====
          Positioned(
            left: 0,
            right: 0,
            bottom: h * 0.28,
            child: AnimatedBuilder(
              animation: _bobController,
              builder: (context, _) {
                final scaleX = 1.0 - _bobController.value * 0.15;
                return Center(
                  child: Transform.scale(
                    scaleX: scaleX,
                    child: Container(
                      width: mascotSize * 0.55,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ===== MASKOT (frame-by-frame) =====
          Align(
            alignment: const Alignment(0, -0.05), // sedikit ke atas
            child: FadeTransition(
              opacity: _fadeController,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _frameController,
                  _bobController,
                ]),
                builder: (context, _) {
                  final bob = _bobController.value * 10 - 5;
                  final sway = math.sin(
                    _frameController.value * math.pi * 2,
                  ) *
                      5;
                  final tilt = math.sin(
                    _frameController.value * math.pi * 2,
                  ) *
                      0.025;

                  final frameIndex =
                      (_frameController.value * _frames.length).floor() %
                          _frames.length;

                  return Transform.translate(
                    offset: Offset(sway, bob),
                    child: Transform.rotate(
                      angle: tilt,
                      child: AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: _frameDurationMs ~/ 2,
                        ),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: Image.asset(
                          _frames[frameIndex],
                          key: ValueKey(frameIndex),
                          width: mascotSize, // ← ✅ 95% lebar layar
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== LOADING TEXT =====
          Positioned(
            left: 0,
            right: 0,
            bottom: h * 0.10,
            child: FadeTransition(
              opacity: _fadeController,
              child: AnimatedBuilder(
                animation: _frameController,
                builder: (context, _) {
                  final dotsPhase = (_frameController.value * 3) % 1.0;
                  final dotCount = (dotsPhase * 3).floor() + 1;
                  return Text(
                    'Loading${'.' * dotCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // PARTICLES
  // ============================================
  List<Widget> _buildParticles(double w, double h) {
    return List.generate(15, (i) {
      final seed = i * 137.5;
      final px = (seed * 7.3) % w;
      final py = (seed * 11.1) % h;
      final size = 2.0 + (i % 3) * 1.0;

      return AnimatedBuilder(
        animation: _bobController,
        builder: (context, _) {
          final opacity = 0.15 +
              (math.sin(_bobController.value * math.pi * 2 + i) * 0.5 + 0.5) *
                  0.25;

          return Positioned(
            left: px,
            top: py,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    });
  }
}