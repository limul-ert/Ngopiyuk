import 'package:flutter/material.dart';
import '../data/dummy_cafes.dart';
import '../models/cafe.dart';
import 'cafe_detail_page.dart';

class SearchPage extends StatefulWidget {
  final Set<String> favoriteCafeNames;
  final void Function(String) onToggleFavorite;

  const SearchPage({
    super.key,
    required this.favoriteCafeNames,
    required this.onToggleFavorite,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  // ===== FILTER KAFE =====
  List<Cafe> get _results {
    if (_query.trim().isEmpty) return dummyCafes;
    final q = _query.toLowerCase();
    return dummyCafes.where((cafe) {
      return cafe.name.toLowerCase().contains(q) ||
          cafe.address.toLowerCase().contains(q) ||
          cafe.categories.any((cat) => cat.toLowerCase().contains(q));
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isFavorite(String cafeName) =>
      widget.favoriteCafeNames.contains(cafeName);

  void _onCafeTap(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeDetailPage(
          cafe: cafe,
          isFavorite: _isFavorite(cafe.name),
          onToggleFavorite: () => widget.onToggleFavorite(cafe.name),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cari Kafe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (val) => setState(() => _query = val),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari nama kafe, kategori, atau alamat...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryColor,
                      size: 22,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: Colors.grey, size: 20),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // ===== HASIL / EMPTY STATE =====
            Expanded(
              child: results.isEmpty
                  ? _buildEmptyState()
                  : _buildResultList(results),
            ),
          ],
        ),
      ),
    );
  }

  // ===== EMPTY STATE =====
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.grey, size: 80),
          SizedBox(height: 16),
          Text(
            'Kafe tidak ditemukan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ===== LIST HASIL =====
  Widget _buildResultList(List<Cafe> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${results.length} kafe ditemukan',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final cafe = results[index];
              return _buildResultItem(cafe);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(Cafe cafe) {
    final isFav = _isFavorite(cafe.name);

    return GestureDetector(
      onTap: () => _onCafeTap(cafe),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cafe.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: 70,
                    height: 70,
                    color: bgColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
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
            // Info
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cafe.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tombol favorit
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? primaryColor : Colors.grey,
                size: 22,
              ),
              onPressed: () {
                widget.onToggleFavorite(cafe.name);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}