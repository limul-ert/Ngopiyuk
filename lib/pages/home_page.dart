import 'dart:convert';
import 'dart:typed_data';
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
import 'cafe_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  String _userName = 'User';
  String _userAvatar = '😀';
  Uint8List? _avatarImageBytes;

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

  // ===== GREETING DINAMIS =====
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Selamat Pagi';
    if (hour >= 11 && hour < 15) return 'Selamat Siang';
    if (hour >= 15 && hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // ===== BACA NAMA & AVATAR =====
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final avatarBase64 = prefs.getString('user_avatar_base64');
    Uint8List? bytes;
    if (avatarBase64 != null && avatarBase64.isNotEmpty) {
      try {
        bytes = base64Decode(avatarBase64);
      } catch (_) {
        bytes = null;
      }
    }

    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _userAvatar = prefs.getString('user_avatar') ?? '😀';
      _avatarImageBytes = bytes;
    });
  }

  // ===== AVATAR CONTENT =====
  Widget _buildAvatarContent() {
    if (_avatarImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          _avatarImageBytes!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
        ),
      );
    }
    return Text(
      _userAvatar,
      style: const TextStyle(fontSize: 24),
    );
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
    ).then((_) => _loadUserData());
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

  // ===== BUKA HALAMAN CAFE LIST =====
  void _openTopRatedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeListPage(
          title: 'Rating Tertinggi',
          cafes: _topRatedCafes,
          favoriteCafeNames: _favoriteCafeNames,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  void _openAllCafesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeListPage(
          title: 'Semua Cafe',
          cafes: _filteredCafes,
          favoriteCafeNames: _favoriteCafeNames,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  void _showComingSoon(String title) {
    _showSnackBar('$title - Segera Hadir');
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

              // ===== RATING TERTINGGI =====
              _buildSectionTitle(
                'Rating Tertinggi',
                onViewAll: _openTopRatedPage,
              ),
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

              // ===== KATEGORI =====
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

              // ===== SEMUA CAFE (max 8) =====
              _buildSectionTitle(
                'Semua Cafe',
                onViewAll: _openAllCafesPage,
              ),
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
                  clipBehavior: Clip.antiAlias,
                  child: _buildAvatarContent(),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting dinamis (tanpa emoji)
              Expanded(
                child: Text(
                  '$_greeting, $_userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Favorit
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
              // Notifikasi
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

  // ===== SECTION TITLE =====
  Widget _buildSectionTitle(String title, {VoidCallback? onViewAll}) {
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
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
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

  // ===== LIST CAFE (MAX 8) =====
  Widget _buildCafeList() {
    final allCafes = _filteredCafes;

    if (allCafes.isEmpty) {
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

    // Ambil max 8 cafe aja buat preview di Home
    final cafes = allCafes.take(8).toList();

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

  // ===== DRAWER =====
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