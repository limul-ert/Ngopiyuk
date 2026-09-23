import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_cafes.dart';
import '../models/cafe.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_row.dart';
import '../widgets/cafe_card.dart';
import 'cafe_detail_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  String _userName = 'User';
  String _userAvatar = '😀';

  // ===== STATE FAVORIT =====
  final Set<String> _favoriteCafeNames = {};

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ===== BACA NAMA & AVATAR DARI SHARED PREFERENCES =====
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _userAvatar = prefs.getString('user_avatar') ?? '😀';
    });
  }

  // ===== GETTERS =====
  List<Cafe> get _filteredCafes {
    if (_selectedCategory == 'All') return dummyCafes;
    return dummyCafes.where((cafe) {
      return cafe.categories.any((cat) =>
          cat.toLowerCase().contains(_selectedCategory.toLowerCase()));
    }).toList();
  }

  List<Cafe> get _topRatedCafes {
    final sorted = List<Cafe>.from(dummyCafes);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<Cafe> get _favoriteCafes {
    return dummyCafes
        .where((c) => _favoriteCafeNames.contains(c.name))
        .toList();
  }

  // ===== FAVORIT =====
  bool _isFavorite(String cafeName) => _favoriteCafeNames.contains(cafeName);

  void _toggleFavorite(String cafeName) {
    setState(() {
      if (_favoriteCafeNames.contains(cafeName)) {
        _favoriteCafeNames.remove(cafeName);
      } else {
        _favoriteCafeNames.add(cafeName);
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ===== NAVIGASI =====
  void _onCafeTap(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeDetailPage(
          cafe: cafe,
          isFavorite: _isFavorite(cafe.name),
          onToggleFavorite: () => _toggleFavorite(cafe.name),
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(
          favoriteCafes: _favoriteCafes,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    ).then((_) => _loadUserData()); // ← reload nama & avatar setelah balik
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          favoriteCafeNames: _favoriteCafeNames,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  void _showComingSoon(String title) {
    _showSnackBar('$title - Coming Soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              PromoCarousel(promos: dummyPromos),
              const SizedBox(height: 24),
              _buildSectionTitle('Rating Tertinggi', showViewAll: true),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _topRatedCafes.length,
                  itemBuilder: (context, index) {
                    final cafe = _topRatedCafes[index];
                    return CafeCardHorizontal(
                      cafe: cafe,
                      onTap: () => _onCafeTap(cafe),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Kategori'),
              const SizedBox(height: 12),
              CategoryRow(
                categories: dummyCategories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (cat) {
                  setState(() => _selectedCategory = cat);
                },
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Semua Cafe', showViewAll: true),
              const SizedBox(height: 12),
              _buildCafeList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ===== AVATAR EMOJI (DARI PREFS) =====
              GestureDetector(
                onTap: _openProfile,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _userAvatar,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting (nama dinamis dari prefs)
              Expanded(
                child: Text(
                  'Halo, $_userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Icon Favorit
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white, size: 20),
                      onPressed: _openFavorites,
                    ),
                    if (_favoriteCafes.isNotEmpty)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${_favoriteCafes.length}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Icon Notifikasi
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white, size: 20),
                  onPressed: () => _showComingSoon('Notifikasi'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Search bar
          GestureDetector(
            onTap: _openSearch,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mau ngopi apa hari ini?',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
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

  Widget _buildSectionTitle(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: () => _showComingSoon(title),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 30),
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(color: primaryColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCafeList() {
    final cafes = _filteredCafes;

    if (cafes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, color: Colors.grey, size: 48),
              SizedBox(height: 12),
              Text(
                'Belum ada cafe di kategori ini',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: cafes
            .map((cafe) => CafeCardVertical(
          cafe: cafe,
          onTap: () => _onCafeTap(cafe),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.coffee, color: primaryColor, size: 32),
                SizedBox(width: 10),
                Text(
                  'NgopiYuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Beranda', active: true),
          _buildDrawerItem(
            Icons.search,
            'Cari',
            onTap: () {
              Navigator.pop(context);
              _openSearch();
            },
          ),
          _buildDrawerItem(
            Icons.favorite_border,
            'Favorit',
            onTap: () {
              Navigator.pop(context);
              _openFavorites();
            },
          ),
          _buildDrawerItem(
            Icons.person_outline,
            'Profil',
            onTap: () {
              Navigator.pop(context);
              _openProfile();
            },
          ),
          _buildDrawerItem(
            Icons.settings_outlined,
            'Pengaturan',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('Pengaturan');
            },
          ),
          _buildDrawerItem(
            Icons.info_outline,
            'Tentang',
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('Tentang');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon,
      String title, {
        bool active = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: active ? primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}