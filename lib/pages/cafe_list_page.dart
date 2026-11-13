import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../widgets/cafe_card.dart';
import 'cafe_detail_page.dart';

class CafeListPage extends StatefulWidget {
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

  @override
  State<CafeListPage> createState() => _CafeListPageState();
}

class _CafeListPageState extends State<CafeListPage> {
  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF181818);
  static const Color primaryColor = Color(0xFFC8956D);

  // 0 = Default, 1 = Rating Tertinggi, 2 = Nama A-Z
  int _sortBy = 0;

  void _onCafeTap(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeDetailPage(
          cafe: cafe,
          isFavorite: widget.favoriteCafeNames.contains(cafe.name),
          onToggleFavorite: () => widget.onToggleFavorite(cafe.name),
        ),
      ),
    );
  }

  List<Cafe> get _sortedCafes {
    final list = List<Cafe>.from(widget.cafes);
    if (_sortBy == 1) {
      list.sort((a, b) => b.rating.compareTo(a.rating)); // Rating Tertinggi
    } else if (_sortBy == 2) {
      list.sort((a, b) => a.name.compareTo(b.name)); // Abjad A-Z
    }
    return list;
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                      widget.title,
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

            // ===== COUNT & SORT =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.cafes.length} cafe ditemukan',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  // Dropdown Sortir
                  DropdownButton<int>(
                    value: _sortBy,
                    dropdownColor: cardColor,
                    icon: const Icon(Icons.sort, color: primaryColor, size: 20),
                    underline: const SizedBox(),
                    style: const TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() => _sortBy = newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Default')),
                      DropdownMenuItem(value: 1, child: Text('Rating Tertinggi')),
                      DropdownMenuItem(value: 2, child: Text('Nama A-Z')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== LIST =====
            Expanded(
              child: widget.cafes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sortedCafes.length,
                itemBuilder: (context, index) {
                  final cafe = _sortedCafes[index];
                  return CafeCardVertical(
                    cafe: cafe,
                    onTap: () => _onCafeTap(cafe),
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