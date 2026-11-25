import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loading untuk HomePage (package: shimmer).
/// Bentuknya meniru layout asli: header, promo, rating tertinggi,
/// kategori, dan daftar cafe.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const Color _base = Color(0xFF1E1E1E);
  static const Color _highlight = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1400),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 16),
            _promo(),
            const SizedBox(height: 24),
            _sectionTitle(110),
            const SizedBox(height: 12),
            _horizontalCards(),
            const SizedBox(height: 24),
            _sectionTitle(80),
            const SizedBox(height: 12),
            _categories(),
            const SizedBox(height: 24),
            _sectionTitle(110),
            const SizedBox(height: 12),
            for (int i = 0; i < 4; i++) _verticalCard(),
          ],
        ),
      ),
    );
  }

  // Kotak dasar. Warna harus solid; shimmer yang mewarnai.
  Widget _box({
    double? width,
    double? height,
    double radius = 8,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              _box(width: 44, height: 44, shape: BoxShape.circle),
              const SizedBox(width: 12),
              Expanded(child: _box(height: 16, radius: 6)),
              const SizedBox(width: 40),
              _box(width: 40, height: 40, shape: BoxShape.circle),
              const SizedBox(width: 6),
              _box(width: 40, height: 40, shape: BoxShape.circle),
            ],
          ),
          const SizedBox(height: 14),
          _box(height: 44, radius: 22),
        ],
      ),
    );
  }

  Widget _promo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _box(height: 170, radius: 16),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _box(width: 22, height: 8, radius: 4),
              const SizedBox(width: 6),
              _box(width: 8, height: 8, radius: 4),
              const SizedBox(width: 6),
              _box(width: 8, height: 8, radius: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _box(width: width, height: 20, radius: 6),
          _box(width: 60, height: 14, radius: 6),
        ],
      ),
    );
  }

  Widget _horizontalCards() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 180, height: 110, radius: 14),
              const SizedBox(height: 10),
              _box(width: 140, height: 14, radius: 6),
              const SizedBox(height: 8),
              _box(width: 90, height: 12, radius: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _box(width: 84, height: 40, radius: 20),
        ),
      ),
    );
  }

  Widget _verticalCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _box(width: 80, height: 80, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(height: 16, radius: 6),
                const SizedBox(height: 10),
                _box(width: 120, height: 12, radius: 6),
                const SizedBox(height: 8),
                _box(width: 80, height: 12, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
