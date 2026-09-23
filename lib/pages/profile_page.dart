import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'User';
  String _userEmail = 'user@email.com';
  String _userAvatar = '😀';

  // Daftar emoji avatar preset
  static const List<String> _avatarOptions = [
    '😀', '😎', '🤓', '🥰', '😇', '🤠',
  ];

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _userEmail = prefs.getString('user_email') ?? 'user@email.com';
      _userAvatar = prefs.getString('user_avatar') ?? '😀';
    });
  }

  // ===== EDIT NAMA (DIALOG) =====
  Future<void> _editName() async {
    final controller = TextEditingController(text: _userName);

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Ubah Nama',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Masukkan nama baru',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: bgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                Navigator.pop(dialogContext, val);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', newName);
      if (!mounted) return;
      setState(() => _userName = newName);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama berhasil diubah'),
          backgroundColor: cardColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ===== GANTI AVATAR (BOTTOM SHEET) =====
  Future<void> _changeAvatar() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Avatar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Grid 3x2 emoji
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _avatarOptions.map((emoji) {
                final isSelected = emoji == _userAvatar;
                return GestureDetector(
                  onTap: () => Navigator.pop(sheetContext, emoji),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.25)
                          : bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : Colors.white.withValues(alpha: 0.08),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (selected != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar', selected);
      if (!mounted) return;
      setState(() => _userAvatar = selected);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avatar berhasil diubah'),
          backgroundColor: cardColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ===== KELUAR =====
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 22),
            SizedBox(width: 10),
            Text(
              'Keluar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Yakin mau keluar dari akunmu?',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_logged_in', false);
              if (!mounted) return;
              Navigator.pop(dialogContext);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  // ===== TENTANG APLIKASI =====
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/kopi.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'NgopiYuk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi discovery cafe terbaik di Madiun. '
                  'Temukan cafe favoritmu, lihat menu, dan kunjungi langsung.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '© 2024 NgopiYuk',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PENGATURAN =====
  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pengaturan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _settingsTile(Icons.notifications_outlined, 'Notifikasi',
                'Aktifkan notifikasi promo'),
            _settingsTile(Icons.dark_mode_outlined, 'Mode Gelap',
                'Selalu aktif'),
            _settingsTile(Icons.language_outlined, 'Bahasa', 'Indonesia'),
            _settingsTile(Icons.storage_outlined, 'Hapus Cache',
                'Bersihkan data sementara'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () {},
    );
  }

  void _openHelpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _HelpPage()),
    );
  }

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
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ===== AVATAR (BISA DI-TAP GANTI) =====
              GestureDetector(
                onTap: _changeAvatar,
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _userAvatar,
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                    // Icon edit kecil di pojok
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: bgColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap avatar untuk ganti',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 12),

              // ===== NAMA (BISA DI-TAP EDIT) =====
              GestureDetector(
                onTap: _editName,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit_outlined,
                      color: primaryColor.withValues(alpha: 0.8),
                      size: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // ===== EMAIL =====
              Text(
                _userEmail,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 12),

              // Badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  '☕ COFFEE LOVER',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ===== MENU =====
              _menuTile(
                Icons.settings_outlined,
                'Pengaturan',
                'Atur preferensi aplikasi',
                onTap: () => _showSettingsDialog(),
              ),
              _menuTile(
                Icons.help_outline,
                'Bantuan',
                'FAQ & dukungan',
                onTap: () => _openHelpPage(),
              ),
              _menuTile(
                Icons.info_outline,
                'Tentang Aplikasi',
                'Versi 1.0.0',
                onTap: () => _showAboutDialog(),
              ),

              const SizedBox(height: 20),

              // ===== LOGOUT =====
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _handleLogout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(
      IconData icon,
      String title,
      String subtitle, {
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
        trailing:
        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}

// ============================================
// HALAMAN BANTUAN (FAQ)
// ============================================
class _HelpPage extends StatelessWidget {
  const _HelpPage();

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'Bagaimana cara mencari cafe?',
      'a': 'Gunakan search bar di halaman Beranda atau tap icon 🔍 di header. '
          'Ketik nama cafe, kategori, atau alamat.',
    },
    {
      'q': 'Bagaimana cara menambahkan cafe ke favorit?',
      'a': 'Buka halaman detail cafe, lalu tap icon ❤️ di kanan atas. '
          'Cafe akan muncul di halaman Favorit.',
    },
    {
      'q': 'Apakah data cafe ini real?',
      'a': 'Data cafe di aplikasi ini bersifat dummy untuk keperluan '
          'pembelajaran/demo, namun terinspirasi dari cafe nyata di Madiun.',
    },
    {
      'q': 'Bagaimana cara buka lokasi cafe?',
      'a': 'Di halaman detail cafe, tap tombol "Buka di Maps" untuk membuka '
          'Google Maps dengan lokasi cafe.',
    },
    {
      'q': 'Apakah aplikasi ini gratis?',
      'a': 'Ya, aplikasi ini 100% gratis untuk semua pengguna.',
    },
  ];

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
        title: const Text(
          'Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'FAQ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pertanyaan yang sering ditanyakan',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ..._faqs.map((faq) => _buildFaqItem(faq['q']!, faq['a']!)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent,
                    color: primaryColor, size: 40),
                const SizedBox(height: 8),
                const Text(
                  'Masih butuh bantuan?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hubungi kami di support@ngopiyuk.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ExpansionTile(
        iconColor: primaryColor,
        collapsedIconColor: Colors.grey,
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}