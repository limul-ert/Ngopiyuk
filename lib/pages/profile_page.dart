import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
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

  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF181818);
  static const Color dividerColor = Color(0xFF252525);
  static const Color toggleActiveColor = Color(0xFFC7F464);
  static const Color toggleInactiveTrack = Color(0xFF2A2A2A);
  static const Color logoutTextColor = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
      _userEmail = prefs.getString('user_email') ?? 'user@email.com';
      _userAvatar = prefs.getString('user_avatar') ?? '😀';
      _avatarImageBytes = bytes;
    });
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    );
    if (updated == true) {
      _loadUserData();
    }
  }

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
            Icon(Icons.logout, color: logoutTextColor, size: 22),
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
              backgroundColor: logoutTextColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 18),

                    // ===== GROUP 1: NOTIFIKASI + MENU =====
                    _buildGroup([
                      _buildSwitchTile(
                        icon: Icons.notifications_none,
                        title: 'Jeda Notifikasi',
                        value: _pauseNotifications,
                        onChanged: (val) {
                          setState(() => _pauseNotifications = val);
                        },
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

                    // ===== GROUP 2: MENU INFO =====
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

  Widget _buildHeader() {
    return Padding(
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
              Padding(
                padding: const EdgeInsets.only(left: 48),
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
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
              activeColor: Colors.white,
              activeTrackColor: toggleActiveColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: toggleInactiveTrack,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
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

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _handleLogout,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: logoutTextColor,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Keluar',
              style: TextStyle(
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