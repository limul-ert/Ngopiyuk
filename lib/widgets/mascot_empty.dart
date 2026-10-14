import 'package:flutter/material.dart';

// ============================================
// MASKOT EMPTY STATE — statis, tanpa animasi
// ============================================
class MascotEmpty extends StatelessWidget {
  final String imagePath;
  final double width;

  const MascotEmpty({
    super.key,
    required this.imagePath,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imagePath,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported_outlined,
          size: width * 0.5,
          color: Colors.grey,
        ),
      ),
    );
  }
}