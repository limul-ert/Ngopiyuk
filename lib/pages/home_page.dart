import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/dummy_cafes.dart';
import '../models/cafe.dart';
import '../services/cafe_repository.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_row.dart';
import '../widgets/cafe_card.dart';
import '../widgets/animations.dart';
import '../widgets/home_skeleton.dart';
import 'cafe_detail_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
import 'cafe_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  String _userName = 'Pengguna';
  String _userAvatar = '😎';
  Uint8List? _avatarImageBytes;

  bool _isLoading = true;

  final CafeRepository _cafeRepository = CafeRepository();

  List<Cafe> _allCafes = [];
  List<Promo> _promos = [];

  final Set<String> _favoriteCafeNames = {};

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();

    _loadUserData();
    _loadData();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _checkForUpdate();
      }
    });
  }

  // ============================================
  // FITUR AUTO UPDATE
  // ============================================

  Future<void> _checkForUpdate() async {
    const cacheKey = 'github_latest_release_cache';
    const cacheTimeKey = 'github_latest_release_cache_time';
    const cacheDuration = Duration(hours: 6);

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? releaseData;
      final cachedJson = prefs.getString(cacheKey);
      final cachedTime = prefs.getInt(cacheTimeKey);

      // Gunakan cache selama maksimal 6 jam.
      if (cachedJson != null && cachedTime != null) {
        final cacheAge =
            DateTime.now().millisecondsSinceEpoch - cachedTime;

        if (cacheAge >= 0 && cacheAge < cacheDuration.inMilliseconds) {
          final decodedCache = jsonDecode(cachedJson);
          if (decodedCache is Map<String, dynamic>) {
            releaseData = decodedCache;
          }
        }
      }

      // Hubungi GitHub hanya jika cache tidak tersedia atau kedaluwarsa.
      if (releaseData == null) {
        final response = await http
            .get(
              Uri.parse(
                'https://api.github.com/repos/limul-ert/Ngopiyuk/releases/latest',
              ),
              headers: const {
                'Accept': 'application/vnd.github+json',
                'User-Agent': 'NgopiYuk-App',
                'X-GitHub-Api-Version': '2022-11-28',
              },
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);

          if (decoded is! Map<String, dynamic> ||
              decoded['tag_name'] == null) {
            throw const FormatException(
              'Format data release GitHub tidak sesuai.',
            );
          }

          releaseData = decoded;

          await prefs.setString(cacheKey, jsonEncode(releaseData));
          await prefs.setInt(
            cacheTimeKey,
            DateTime.now().millisecondsSinceEpoch,
          );
        } else if (response.statusCode == 403 ||
            response.statusCode == 429) {
          // Jika terkena rate limit, gunakan cache lama bila ada.
          if (cachedJson != null) {
            final decodedCache = jsonDecode(cachedJson);
            if (decodedCache is Map<String, dynamic>) {
              releaseData = decodedCache;
            }
          }

          if (releaseData == null) {
            debugPrint(
              'GitHub API rate limit tercapai: HTTP ${response.statusCode}',
            );
            return;
          }
        } else {
          debugPrint(
            'Gagal memeriksa update: HTTP ${response.statusCode}',
          );
          return;
        }
      }

      final rawTag = releaseData['tag_name']?.toString();
      if (rawTag == null || rawTag.trim().isEmpty) {
        debugPrint('Tag versi terbaru GitHub tidak ditemukan.');
        return;
      }

      final latestVersionString = rawTag.trim().replaceFirst(
        RegExp(r'^[vV]'),
        '',
      );
      final latestVersion = Version.parse(latestVersionString);

      if (latestVersion > currentVersion) {
        String apkUrl =
            releaseData['html_url']?.toString() ??
            'https://github.com/limul-ert/Ngopiyuk/releases/latest';

        final assets = releaseData['assets'];
        if (assets is List && assets.isNotEmpty) {
          final firstAsset = assets.first;
          if (firstAsset is Map &&
              firstAsset['browser_download_url'] != null) {
            apkUrl = firstAsset['browser_download_url'].toString();
          }
        }

        if (mounted) {
          _showUpdateDialog(latestVersionString, apkUrl);
        }
      } else {
        debugPrint('NgopiYuk sudah menggunakan versi terbaru.');
      }
    } on TimeoutException {
      debugPrint('Pemeriksaan update GitHub timeout.');
    } on FormatException catch (e) {
      debugPrint('Format data GitHub tidak valid: $e');
    } catch (e) {
      debugPrint('Gagal memeriksa update GitHub: $e');
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showUpdateDialog(String newVersion, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Update Tersedia! 🚀',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Versi terbaru (v$newVersion) sudah tersedia.\n'
          'Silakan download versi barunya sekarang.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Nanti',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final url = Uri.parse(downloadUrl);

              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Download APK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // MEMUAT DATA PENGGUNA DARI FIRESTORE
  // ============================================

  Future<void> reloadUserData() async {
    await _loadUserData();
  }

  String get _greeting {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    }

    if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    }

    if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    }

    return 'Selamat Malam';
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _userName = 'Pengguna';
          _userAvatar = '😎';
          _avatarImageBytes = null;
        });

        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final prefs = await SharedPreferences.getInstance();

      final userData = userDoc.data();
      final firestoreName = userData?['name']?.toString().trim();

      String name;

      if (firestoreName != null && firestoreName.isNotEmpty) {
        name = firestoreName;
      } else if (user.displayName != null &&
          user.displayName!.trim().isNotEmpty) {
        name = user.displayName!.trim();
      } else {
        name = 'Pengguna';
      }

      final avatarBase64 = prefs.getString('user_avatar_base64');

      Uint8List? bytes;

      if (avatarBase64 != null && avatarBase64.isNotEmpty) {
        try {
          bytes = base64Decode(avatarBase64);
        } catch (e) {
          debugPrint('Gagal membaca avatar: $e');
          bytes = null;
        }
      }

      if (!mounted) return;

      setState(() {
        _userName = name;
        _userAvatar = prefs.getString('user_avatar') ?? '😎';
        _avatarImageBytes = bytes;
      });

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', user.email ?? '');

      debugPrint('Nama pengguna aktif: $name');
      debugPrint('UID pengguna aktif: ${user.uid}');
    } catch (e) {
      debugPrint('GAGAL MEMUAT DATA PENGGUNA: $e');

      if (!mounted) return;

      setState(() {
        _userName = 'Pengguna';
      });
    }
  }

  // ============================================
  // MEMUAT DATA CAFE DAN PROMO DARI FIRESTORE
  // ============================================

  Future<void> _loadData() async {
    try {
      final cafes = await _cafeRepository.getCafes();
      final promos = await _cafeRepository.getPromos();

      final user = FirebaseAuth.instance.currentUser;
      List<String> savedFavorites = [];

      if (user != null) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        final userDoc = await userRef.get();
        final userData = userDoc.data();
        final firestoreFavorites = userData?['favoriteCafeNames'];

        if (firestoreFavorites is List) {
          savedFavorites = firestoreFavorites
              .whereType<String>()
              .toList();
        } else {
          // Migrasikan favorit lama dari SharedPreferences ke Firestore.
          final prefs = await SharedPreferences.getInstance();
          savedFavorites =
              prefs.getStringList('favorite_cafe_names') ?? [];

          await userRef.set({
            'favoriteCafeNames': savedFavorites,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      if (!mounted) return;

      setState(() {
        _allCafes = cafes;
        _promos = promos;

        _favoriteCafeNames
          ..clear()
          ..addAll(savedFavorites);

        _isLoading = false;
      });

      debugPrint('Jumlah cafe dari Firestore: ${_allCafes.length}');
      debugPrint('Jumlah promo dari Firestore: ${_promos.length}');
    } catch (e) {
      debugPrint('GAGAL MEMUAT DATA FIRESTORE: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        'Gagal memuat data cafe. Periksa koneksi dan Firestore.',
        Colors.red,
      );
    }
  }

  // ============================================
  // AVATAR
  // ============================================

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

  // ============================================
  // DATA CAFE DARI FIRESTORE
  // ============================================

  List<Cafe> get _filteredCafes {
    if (_selectedCategory == 'All') {
      return _allCafes;
    }

    return _allCafes.where((cafe) {
      return cafe.categories.any(
        (cat) => cat.toLowerCase().contains(
          _selectedCategory.toLowerCase(),
        ),
      );
    }).toList();
  }

  List<Cafe> get _topRatedCafes {
    final sorted = List<Cafe>.from(_allCafes);

    sorted.sort(
      (a, b) => b.rating.compareTo(a.rating),
    );

    return sorted;
  }

  List<Cafe> get _favoriteCafes {
    return _allCafes
        .where((cafe) => _favoriteCafeNames.contains(cafe.name))
        .toList();
  }

  bool _isFavorite(String cafeName) {
    return _favoriteCafeNames.contains(cafeName);
  }

 
Future<void> _toggleFavorite(String cafeName) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    _showSnackBar(
      'Silakan login untuk menyimpan cafe favorit.',
      Colors.orange,
    );
    return;
  }

  final wasFavorite = _favoriteCafeNames.contains(cafeName);

  setState(() {
    if (wasFavorite) {
      _favoriteCafeNames.remove(cafeName);
    } else {
      _favoriteCafeNames.add(cafeName);
    }
  });

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'favoriteCafeNames': _favoriteCafeNames.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    debugPrint('Favorit berhasil disimpan ke Firestore: $cafeName');
  } catch (e) {
    // Kembalikan tampilan jika penyimpanan ke Firestore gagal.
    if (!mounted) return;

    setState(() {
      if (wasFavorite) {
        _favoriteCafeNames.add(cafeName);
      } else {
        _favoriteCafeNames.remove(cafeName);
      }
    });

    debugPrint('Gagal menyimpan favorit ke Firestore: $e');
    _showSnackBar(
      'Favorit gagal disimpan. Periksa koneksi dan aturan Firestore.',
      Colors.red,
    );
  }
}


  // ============================================
  // NAVIGASI CAFE
  // ============================================

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
    _showSnackBar(
      '$title - Segera Hadir',
      cardColor,
    );
  }

  // ============================================
  // BUILD HOME PAGE
  // ============================================

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 130;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: _buildDrawer(),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const HomeSkeleton()
            : SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: bottomPadding.toDouble(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader()
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 500.ms,
                        ),

                    const SizedBox(height: 16),

                    PromoCarousel(
                      promos: _promos,
                    )
                        .animate()
                        .fadeIn(
                          delay: 150.ms,
                          duration: 500.ms,
                        )
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          delay: 150.ms,
                        ),

                    const SizedBox(height: 24),

                    _buildSectionTitle(
                      'Rating Tertinggi',
                      onViewAll: _openTopRatedPage,
                    ).animate().fadeIn(
                      delay: 250.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount: _topRatedCafes.length,
                        itemBuilder: (context, index) {
                          final cafe = _topRatedCafes[index];

                          return PressableCard(
                            child: CafeCardHorizontal(
                              cafe: cafe,
                              onTap: () => _onCafeTap(cafe),
                            ),
                          );
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: 350.ms,
                          duration: 500.ms,
                        )
                        .slideX(
                          begin: 0.2,
                          end: 0,
                          delay: 350.ms,
                        ),

                    const SizedBox(height: 24),

                    _buildSectionTitle(
                      'Kategori',
                    ).animate().fadeIn(
                      delay: 450.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 12),

                    CategoryRow(
                      categories: dummyCategories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ).animate().fadeIn(
                      delay: 550.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionTitle(
                      'Semua Cafe',
                      onViewAll: _openAllCafesPage,
                    ).animate().fadeIn(
                      delay: 650.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 12),

                    _buildCafeList().animate().fadeIn(
                      delay: 750.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================
  // HEADER
  // ============================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                child: _buildAvatarContent(),
              ),

              const SizedBox(width: 12),

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
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
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

              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 20,
                  ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
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

  // ============================================
  // SECTION TITLE
  // ============================================

  Widget _buildSectionTitle(
    String title, {
    VoidCallback? onViewAll,
  }) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                minimumSize: const Size(0, 30),
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================
  // CAFE LIST
  // ============================================

  Widget _buildCafeList() {
    final allCafes = _filteredCafes;

    if (allCafes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                color: Colors.grey,
                size: 48,
              ),

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

    final cafes = allCafes.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < cafes.length; i++)
            PressableCard(
              child: CafeCardVertical(
                cafe: cafes[i],
                onTap: () => _onCafeTap(cafes[i]),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================
  // DRAWER
  // ============================================

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              48,
              16,
              24,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.coffee,
                  color: primaryColor,
                  size: 32,
                ),

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

          _buildDrawerItem(
            Icons.home,
            'Beranda',
            active: true,
          ),

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
          fontWeight: active
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}