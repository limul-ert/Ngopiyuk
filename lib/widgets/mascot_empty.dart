import 'package:flutter/material.dart';

// ============================================
// MASKOT EMPTY STATE — reusable widget
// Bisa custom gambar per halaman
// ============================================
class MascotEmpty extends StatefulWidget {
  final String imagePath;
  final double width;

  const MascotEmpty({
    super.key,
    required this.imagePath,
    this.width = 180,
  });

  @override
  State<MascotEmpty> createState() => _MascotEmptyState();
}

class _MascotEmptyState extends State<MascotEmpty>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bobController;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bobController,
      builder: (context, _) {
        // Bob naik-turun halus
        final bob = _bobController.value * 10 - 5;

        return Transform.translate(
          offset: Offset(0, bob),
          child: Image.asset(
            widget.imagePath,
            width: widget.width,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported_outlined,
              size: widget.width * 0.5,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}