import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String _userAvatar = '😀';
  Uint8List? _avatarImageBytes;

  static const List<String> _avatarOptions = [
    '😀', '😎', '🤓', '🥰', '😇', '🤠', '🧑', '👨', '👩', '🧔',
  ];

  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF181818);
  static const Color dividerColor = Color(0xFF252525);
  static const Color limeColor = Color(0xFFC7F464);
  static const Color deleteColor = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final name = prefs.getString('user_name') ?? 'User';
    final email = prefs.getString('user_email') ?? 'user@email.com';
    final avatar = prefs.getString('user_avatar') ?? '😀';
    final avatarBase64 = prefs.getString('user_avatar_base64');
    final phone = prefs.getString('user_phone') ?? '0812-3456-7890';
    final username = prefs.getString('user_username') ??
        '@${name.toLowerCase().replaceAll(' ', '')}';

    Uint8List? bytes;
    if (avatarBase64 != null && avatarBase64.isNotEmpty) {
      try {
        bytes = base64Decode(avatarBase64);
      } catch (_) {
        bytes = null;
      }
    }

    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _usernameController.text = username;
      _phoneController.text = phone;
      _userAvatar = avatar;
      _avatarImageBytes = bytes;
    });
  }

  // ===== SAVE =====
  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Nama tidak boleh kosong', Icons.warning_amber_rounded);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('user_username', _usernameController.text.trim());
    await prefs.setString('user_phone', _phoneController.text.trim());
    await prefs.setString('user_avatar', _userAvatar);

    if (_avatarImageBytes != null) {
      final base64String = base64Encode(_avatarImageBytes!);
      await prefs.setString('user_avatar_base64', base64String);
    } else {
      await prefs.remove('user_avatar_base64');
    }

    if (!mounted) return;
    _showSnackBar('Profil berhasil diperbarui', Icons.check_circle);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ===== DELETE =====
  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: deleteColor, size: 22),
            SizedBox(width: 10),
            Text(
              'Hapus Akun',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Yakin mau hapus akunmu? Tindakan ini tidak dapat dibatalkan.',
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
            onPressed: () {
              Navigator.pop(dialogContext);
              _showSnackBar(
                'Fitur Hapus Akun - Coming Soon',
                Icons.info_outline,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deleteColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: limeColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================
  // BOTTOM SHEET: PILIH SUMBER AVATAR (FIXED)
  // ============================================
  Future<void> _changeAvatar() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
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
                  'Ganti Foto Profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSheetOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Ambil dari Kamera',
                  subtitle: 'Foto langsung',
                  onTap: () => Navigator.pop(sheetContext, 'camera'),
                ),
                const SizedBox(height: 10),
                _buildSheetOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Pilih dari Galeri',
                  subtitle: 'Ambil dari penyimpanan',
                  onTap: () => Navigator.pop(sheetContext, 'gallery'),
                ),
                const SizedBox(height: 10),
                _buildSheetOption(
                  icon: Icons.emoji_emotions_outlined,
                  title: 'Pakai Emoji',
                  subtitle: 'Pilih emoji preset',
                  onTap: () => Navigator.pop(sheetContext, 'emoji'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );

    if (choice == null || !mounted) return;

    if (choice == 'camera') {
      await _pickImage(ImageSource.camera);
    } else if (choice == 'gallery') {
      await _pickImage(ImageSource.gallery);
    } else if (choice == 'emoji') {
      await _pickEmoji();
    }
  }

  // ===== PICK IMAGE =====
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      setState(() {
        _avatarImageBytes = bytes;
      });

      _showSnackBar('Foto profil dipilih', Icons.check_circle);
    } catch (e) {
      _showSnackBar('Gagal ambil foto: $e', Icons.error_outline);
    }
  }

  // ============================================
  // BOTTOM SHEET: PILIH EMOJI (FIXED)
  // ============================================
  Future<void> _pickEmoji() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
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
                  'Pilih Emoji',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: _avatarOptions.map((emoji) {
                    final isSelected =
                        emoji == _userAvatar && _avatarImageBytes == null;
                    return GestureDetector(
                      onTap: () => Navigator.pop(sheetContext, emoji),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? limeColor.withValues(alpha: 0.25)
                              : bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? limeColor
                                : Colors.white.withValues(alpha: 0.08),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _userAvatar = selected;
        _avatarImageBytes = null;
      });
    }
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: limeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: limeColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
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
                    _buildAvatarSection(),
                    const SizedBox(height: 28),
                    _buildFieldsGroup(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                    const SizedBox(height: 60),
                    _buildDeleteButton(),
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
              'Edit Profile',
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
  // AVATAR SECTION
  // ============================================
  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: _changeAvatar,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF3A2E22),
                shape: BoxShape.circle,
                border: Border.all(
                  color: limeColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: limeColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              child: _buildAvatarContent(),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: limeColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: bgColor,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 18,
                ),
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
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }
    return Text(
      _userAvatar,
      style: const TextStyle(fontSize: 60),
    );
  }

  // ============================================
  // FIELDS GROUP
  // ============================================
  Widget _buildFieldsGroup() {
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
          _buildFieldRow('Full name', _nameController),
          _buildDivider(),
          _buildFieldRow(
            'Phone number',
            _phoneController,
            keyboardType: TextInputType.phone,
          ),
          _buildDivider(),
          _buildFieldRow(
            'Email',
            _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildDivider(),
          _buildFieldRow('Username', _usernameController),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Divider(
        color: dividerColor,
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget _buildFieldRow(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // SAVE BUTTON
  // ============================================
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveChanges,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: limeColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: limeColor.withValues(alpha: 0.25),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Save Changes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // DELETE BUTTON
  // ============================================
  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _handleDeleteAccount,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: deleteColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: deleteColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'Delete Account',
            style: TextStyle(
              color: deleteColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}