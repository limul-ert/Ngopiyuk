import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan gambar cafe.
///
/// Otomatis mendeteksi:
/// - **Asset lokal**: kalau `source` dimulai dengan `assets/`
/// - **Network**: kalau `source` dimulai dengan `http://` atau `https://`
///
/// Fitur:
/// - Built-in loading indicator
/// - Built-in error fallback (icon cafe)
/// - Support `borderRadius`
class CafeImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final IconData fallbackIcon;

  const CafeImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.fallbackIcon = Icons.local_cafe,
  });

  static const Color _primaryColor = Color(0xFFC8956D);
  static const Color _fallbackBg = Color(0xFF1A1A1A);

  bool get _isAsset => source.startsWith('assets/');

  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    Widget image = _buildImage();

    // Wrap dengan borderRadius kalau dikasih
    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    // Wrap dengan SizedBox kalau width/height dikasih
    if (width != null || height != null) {
      image = SizedBox(
        width: width,
        height: height,
        child: image,
      );
    }

    return image;
  }

  Widget _buildImage() {
    if (_isAsset) {
      return Image.asset(
        source,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (_isNetwork) {
      return Image.network(
        source,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _buildLoading();
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    // Kalau bukan asset & bukan network → langsung fallback
    return _buildFallback();
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? _fallbackBg,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: _primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? _fallbackBg,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        color: _primaryColor,
        size: _fallbackIconSize,
      ),
    );
  }

  double get _fallbackIconSize {
    if (width != null && width! < 100) return 24;
    if (width != null && width! < 200) return 36;
    return 60;
  }
}