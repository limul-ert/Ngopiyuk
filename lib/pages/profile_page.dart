
import 'dart:convert';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'edit_profile_page.dart';
import 'info_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'User';
  String _userEmail = 'user@email.com';
  String _userAvatar = '😀';
  Uint8List? _avatarImageBytes;

  bool _pauseNotifications = true;
  bool _isLoggingOut = false;
  bool _isLoading = true;

  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF181818);
  static const Color dividerColor = Color(0xFF252525);
  static const Color toggleActiveColor = Color(0xFFC7F464);
  static const Color toggleInactiveTrack = Color(0xFF2A2A2A);
  static const Color logoutTextColor = Color(0xFFE53935);

  String get _uid => AuthService().currentUser?.uid ?? '';

  String get _avatarKey => 'user_avatar_$_uid';
  String get _avatarBase64Key => 'user_avatar_base64_$_uid';
  String get _notificationKey => 'pause_notifications_$_uid';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ============================================
  // LOAD USER DATA
  // ============================================

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = AuthService().currentUser;

      String name = 'User';
      String email = currentUser?.email ?? 'user@email.com';

      String? firestoreAvatar;
      String? firestoreAvatarBase64;

      if (currentUser != null) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data();

            name = userData?['name']?.toString() ?? 'User';

            email = currentUser.email ??
                userData?['email']?.toString() ??
                email;

            firestoreAvatar =
                userData?['avatar']?.toString();

            firestoreAvatarBase64 =
                userData?['avatarBase64']?.toString();
          }
        } catch (e) {
          debugPrint('Gagal mengambil data profil Firestore: $e');
        }
      }

      // Prioritaskan avatar dari Firestore.
      final avatar = firestoreAvatar ??
          prefs.getString(_avatarKey) ??
          prefs.getString('user_avatar') ??
          '😀';

      final avatarBase64 = firestoreAvatarBase64 ??
          prefs.getString(_avatarBase64Key) ??
          prefs.getString('user_avatar_base64');

      Uint8List? bytes;

      if (avatarBase64 != null && avatarBase64.isNotEmpty) {
        try {
          bytes = base64Decode(avatarBase64);
        } catch (e) {
          debugPrint('Gagal membaca avatar Base64: $e');
        }
      }

      // Pengaturan notifikasi berdasarkan UID.
      final pauseNotifications =
          prefs.getBool(_notificationKey) ?? true;

      if (!mounted) return;

      setState(() {
        _userName = name;
        _userEmail = email;
        _userAvatar = avatar;
        _avatarImageBytes = bytes;
        _pauseNotifications = pauseNotifications;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat profil: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ============================================
  // SAVE NOTIFICATION SETTING
  // ============================================

  Future<void> _updateNotificationSetting(bool value) async {
    if (_uid.isEmpty) return;

    setState(() {
      _pauseNotifications = value;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_notificationKey, value);

      debugPrint(
        'Pengaturan notifikasi berhasil disimpan: $value',
      );
    } catch (e) {
      debugPrint('Gagal menyimpan pengaturan notifikasi: $e');

      if (!mounted) return;

      setState(() {
        _pauseNotifications = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan pengaturan: $e'),
          backgroundColor: cardColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================
  // EDIT PROFILE
  // ============================================

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
      ),
    );

    if (updated == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      await _loadUserData();
    }
  }

  // ============================================
  // LOGOUT
  // ============================================

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout,
                color: logoutTextColor,
                size: 22,
              ),
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
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: logoutTextColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await AuthService().logout();

      debugPrint('LOGOUT BERHASIL');
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
          backgroundColor: cardColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  // ============================================
  // BUILD
  // ============================================

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(canPop),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: toggleActiveColor,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        120,
                      ),
                      child: Column(
                        children: [
                          _buildProfileCard(),
                          const SizedBox(height: 18),
                          _buildGroup([
                            _buildSwitchTile(
                              icon: Icons.notifications_none,
                              title: 'Jeda Notifikasi',
                              value: _pauseNotifications,
                              onChanged: _updateNotificationSetting,
                            ),
                            _buildArrowTile(
                              icon: Icons.people_outline,
                              title: 'Kontak Saya',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ContactPage(),
                                  ),
                                );
                              },
                            ),
                          ]),
                          const SizedBox(height: 14),
                          _buildGroup([
                            _buildArrowTile(
                              icon: Icons.info_outline,
                              title: 'Tentang Aplikasi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutAppPage(),
                                  ),
                                );
                              },
                            ),
                            _buildArrowTile(
                              icon: Icons.description_outlined,
                              title: 'Syarat & Ketentuan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TermsPage(),
                                  ),
                                );
                              },
                            ),
                            _buildArrowTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Kebijakan Privasi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyPage(),
                                  ),
                                );
                              },
                            ),
                          ]),
                          const SizedBox(height: 20),
                          _buildLogoutButton(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // HEADER
  // ============================================

  Widget _buildHeader(bool canPop) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          if (canPop)
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
            )
          else
            const SizedBox(width: 44),
          const Expanded(
            child: Text(
              'Profil',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ============================================
  // PROFILE CARD
  // ============================================

  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: _openEditProfile,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF3A2E22),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B6F47),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              child: _buildAvatarContent(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (_avatarImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          _avatarImageBytes!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      );
    }

    return Text(
      _userAvatar,
      style: const TextStyle(fontSize: 26),
    );
  }

  // ============================================
  // GROUP
  // ============================================

  Widget _buildGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 48),
                child: Divider(
                  color: dividerColor,
                  height: 1,
                  thickness: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ============================================
  // SWITCH TILE
  // ============================================

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: toggleActiveColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: toggleInactiveTrack,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // ARROW TILE
  // ============================================

  Widget _buildArrowTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // LOGOUT BUTTON
  // ============================================

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _isLoggingOut ? null : _handleLogout,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoggingOut)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: logoutTextColor,
                ),
              )
            else
              const Icon(
                Icons.logout,
                color: logoutTextColor,
                size: 20,
              ),
            const SizedBox(width: 10),
            Text(
              _isLoggingOut ? 'Sedang keluar...' : 'Keluar',
              style: const TextStyle(
                color: logoutTextColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}