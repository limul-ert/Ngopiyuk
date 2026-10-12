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
  late final AnimationController _progressController;
  Timer? _navTimer;

  // ===== WARNA SETEMA APP =====
  static const Color _primary = Color(0xFFC8956D);
  static const Color _bgColor = Color(0xFF0F0F0F);
  static const Color _progressTrack = Color(0xFF2A2A2A);

  // ============================================
  // FRAMES
  // ============================================
  static const List<String> _frames = [
    'assets/images/mascot/frame1.png',
    'assets/images/mascot/frame2.png',
    'assets/images/mascot/frame3.png',
    'assets/images/mascot/frame4.png',
    'assets/images/mascot/frame5.png',
  ];

  static const int _frameDurationMs = 550;
  static const int _totalLoadingMs = 5000;

  @override
  void initState() {
    super.initState();

    _frameController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _frames.length * _frameDurationMs),
    )..repeat();

    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _totalLoadingMs),
    )..forward();

    _navTimer = Timer(Duration(milliseconds: _totalLoadingMs + 200), () {
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
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final mascotSize = w * 1.15;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // ===== PARTICLES =====
          ..._buildParticles(w, h),

          // ===== MAIN CONTENT (maskot + progress, centered) =====
          Center(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== MASKOT =====
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _frameController,
                      _bobController,
                    ]),
                    builder: (context, _) {
                      final bob = _bobController.value * 12 - 6;
                      final sway = math.sin(
                        _frameController.value * math.pi * 2,
                      ) *
                          6;
                      final tilt = math.sin(
                        _frameController.value * math.pi * 2,
                      ) *
                          0.03;

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
                              width: mascotSize,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ===== GAP antara maskot & progress bar =====
                  SizedBox(height: h * 0.04),

                  // ===== PROGRESS BAR + LABEL =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, _) {
                        final percent =
                        (_progressController.value * 100).toInt();

                        return Column(
                          children: [
                            // Label "Loading..." di atas bar
                            Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Progress bar
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: _progressTrack,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor:
                                    _progressController.value.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFC8956D),
                                            Color(0xFFE5B98D),
                                          ],
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _primary
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Percent
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                color: _primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
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
          final opacity = 0.10 +
              (math.sin(_bobController.value * math.pi * 2 + i) * 0.5 + 0.5) *
                  0.20;

          return Positioned(
            left: px,
            top: py,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    });
  }
}