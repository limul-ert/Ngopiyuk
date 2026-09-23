import 'package:flutter/material.dart';
import '../models/cafe.dart';

class FavoritesPage extends StatelessWidget {
  final List<Cafe> favoriteCafes;
  final void Function(String) onToggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favoriteCafes,
    required this.onToggleFavorite,
  });

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favorit (${favoriteCafes.length})',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: favoriteCafes.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoriteList(context),
    );
  }

  // ===== EMPTY STATE (TANPA ICON) =====
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Judul
            const Text(
              'Belum Ada Favorit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            const Text(
              'Simpan cafe favoritmu di sini biar gampang\ndicari kapan aja kamu mau ngopi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Tombol CTA
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Cari Cafe'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== LIST FAVORIT =====
  Widget _buildFavoriteList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteCafes.length,
      itemBuilder: (context, index) {
        final cafe = favoriteCafes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  cafe.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: bgColor,
                    child: const Icon(Icons.local_cafe,
                        color: primaryColor, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cafe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: primaryColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${cafe.rating}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cafe.openHours,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: primaryColor),
                onPressed: () {
                  onToggleFavorite(cafe.name);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}