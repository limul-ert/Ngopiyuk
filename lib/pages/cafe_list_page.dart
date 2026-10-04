import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../widgets/cafe_card.dart';
import 'cafe_detail_page.dart';

class CafeListPage extends StatelessWidget {
  final String title;
  final List<Cafe> cafes;
  final Set<String> favoriteCafeNames;
  final void Function(String) onToggleFavorite;

  const CafeListPage({
    super.key,
    required this.title,
    required this.cafes,
    required this.favoriteCafeNames,
    required this.onToggleFavorite,
  });

  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF181818);
  static const Color primaryColor = Color(0xFFC8956D);

  void _onCafeTap(BuildContext context, Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeDetailPage(
          cafe: cafe,
          isFavorite: favoriteCafeNames.contains(cafe.name),
          onToggleFavorite: () => onToggleFavorite(cafe.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // ===== COUNT =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${cafes.length} cafe ditemukan',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ===== LIST =====
            Expanded(
              child: cafes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cafes.length,
                itemBuilder: (context, index) {
                  final cafe = cafes[index];
                  return CafeCardVertical(
                    cafe: cafe,
                    onTap: () => _onCafeTap(context, cafe),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_cafe, color: Colors.grey, size: 60),
          SizedBox(height: 12),
          Text(
            'Belum ada cafe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}