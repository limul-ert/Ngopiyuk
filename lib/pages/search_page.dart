import 'package:flutter/material.dart';
import '../data/dummy_cafes.dart';
import '../models/cafe.dart';
import '../widgets/cafe_image.dart';
import '../widgets/mascot_empty.dart';
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

  // ============================================
  // EMPTY STATE — pakai maskot penelusuran
  // ============================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ← ✅ MASKOT PENELUSURAN
            const MascotEmpty(
              imagePath: 'assets/images/mascot/mascot_penelusuran.png',
              width: 290,
            ),

            const SizedBox(height: 24),

            const Text(
              'Kafe tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coba kata kunci lain atau cek\nkategori yang tersedia ya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            CafeImage(
              source: cafe.imageUrl,
              width: 70,
              height: 70,
              borderRadius: BorderRadius.circular(10),
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