import 'dart:convert';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Controller password
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  String _userAvatar = '😀';
  Uint8List? _avatarImageBytes;

  bool _isLoading = true;
  bool _isSaving = false;

  bool _isSettingPassword = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const List<String> _avatarOptions = [
    '😀', '😎', '🤓', '🥰', '😇',
    '🤠', '🧑', '👨', '👩', '🧔',
  ];

  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF181818);
  static const Color dividerColor = Color(0xFF252525);
  static const Color limeColor = Color(0xFFC7F464);
  static const Color deleteColor = Color(0xFFE53935);

  User? get _currentUser => FirebaseAuth.instance.currentUser;
  String get _uid => _currentUser?.uid ?? '';

  String get _avatarKey => 'user_avatar_$_uid';
  String get _avatarBase64Key => 'user_avatar_base64_$_uid';

  // Periksa apakah akun sudah memiliki provider email/password.
  bool get _hasPasswordProvider {
    return _currentUser?.providerData.any(
          (provider) => provider.providerId == 'password',
        ) ??
        false;
  }

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================
  // LOAD USER DATA
  // ============================================

  Future<void> _loadUserData() async {
    try {
      final user = _currentUser;

      if (user == null) {
        throw Exception('Silakan login terlebih dahulu.');
      }

      final prefs = await SharedPreferences.getInstance();

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data() ?? {};

      final name = (data['name'] ??
              prefs.getString('user_name') ??
              'User')
          .toString();

      final email = user.email ?? '';

      final username = (data['username'] ??
              prefs.getString('user_username') ??
              '@${name.toLowerCase().replaceAll(' ', '')}')
          .toString();

      final phone = (data['phone'] ??
              prefs.getString('user_phone') ??
              '')
          .toString();

      final firestoreAvatar = data['avatar']?.toString();
      final firestoreAvatarBase64 =
          data['avatarBase64']?.toString();

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
          debugPrint('Gagal membaca avatar: $e');
        }
      }

      if (!mounted) return;

      setState(() {
        _nameController.text = name;
        _emailController.text = email;
        _usernameController.text = username;
        _phoneController.text = phone;
        _userAvatar = avatar;
        _avatarImageBytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat profil: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        'Gagal memuat profil: $e',
        Icons.error_outline,
      );
    }
  }

  // ============================================
  // SAVE PROFILE
  // ============================================

  Future<void> _saveChanges() async {
    if (_isSaving) return;

    final user = _currentUser;

    if (user == null) {
      _showSnackBar(
        'Silakan login kembali.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showSnackBar(
        'Nama tidak boleh kosong.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      final avatarBase64 = _avatarImageBytes != null
          ? base64Encode(_avatarImageBytes!)
          : null;

      if (avatarBase64 != null &&
          avatarBase64.length > 700000) {
        throw Exception(
          'Ukuran foto terlalu besar. Silakan pilih foto lain.',
        );
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'username': username,
        'phone': phone,
        'avatar': _userAvatar,
        'avatarBase64': avatarBase64,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await prefs.setString(_avatarKey, _userAvatar);

      if (avatarBase64 != null) {
        await prefs.setString(
          _avatarBase64Key,
          avatarBase64,
        );
      } else {
        await prefs.remove(_avatarBase64Key);
      }

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', user.email ?? '');
      await prefs.setString('user_username', username);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_avatar', _userAvatar);

      if (avatarBase64 != null) {
        await prefs.setString(
          'user_avatar_base64',
          avatarBase64,
        );
      } else {
        await prefs.remove('user_avatar_base64');
      }

      if (!mounted) return;

      _showSnackBar(
        'Profil berhasil diperbarui.',
        Icons.check_circle,
      );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Gagal menyimpan profil: $e');

      if (!mounted) return;

      _showSnackBar(
        'Gagal menyimpan profil: $e',
        Icons.error_outline,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================
  // SET EMAIL AND PASSWORD
  // ============================================

  Future<void> _setEmailPassword() async {
    if (_isSettingPassword) return;

    final user = _currentUser;

    if (user == null || user.email == null) {
      _showSnackBar(
        'Silakan login kembali.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    if (_hasPasswordProvider) {
      _showSnackBar(
        'Akun ini sudah memiliki password.',
        Icons.info_outline,
      );
      return;
    }

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 6) {
      _showSnackBar(
        'Password minimal 6 karakter.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar(
        'Konfirmasi password tidak cocok.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    setState(() {
      _isSettingPassword = true;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Hubungkan email/password ke akun Google yang sedang login.
      // UID akun tetap sama.
      await user.linkWithCredential(credential);

      // Muat ulang informasi provider dari Firebase.
      await FirebaseAuth.instance.currentUser?.reload();

      if (!mounted) return;

      _passwordController.clear();
      _confirmPasswordController.clear();

      setState(() {});

      _showSnackBar(
        'Password berhasil dibuat. Sekarang kamu bisa login dengan email dan password.',
        Icons.check_circle,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'provider-already-linked':
          message = 'Akun ini sudah memiliki password.';
          break;

        case 'credential-already-in-use':
        case 'email-already-in-use':
          message =
              'Email ini sudah terhubung dengan akun lain.';
          break;

        case 'weak-password':
          message = 'Password terlalu lemah.';
          break;

        case 'requires-recent-login':
          message =
              'Silakan login ulang menggunakan Google, lalu coba kembali.';
          break;

        default:
          message = e.message ?? 'Gagal membuat password.';
      }

      if (mounted) {
        _showSnackBar(message, Icons.error_outline);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          'Terjadi kesalahan: $e',
          Icons.error_outline,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSettingPassword = false;
        });
      }
    }
  }

  // ============================================
  // PASSWORD SECTION
  // ============================================

  Widget _buildPasswordSection() {
    if (_hasPasswordProvider) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: limeColor.withValues(alpha: 0.25),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: limeColor,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Akun sudah memiliki password. Kamu bisa login menggunakan email dan password.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: limeColor,
              ),
              SizedBox(width: 10),
              Text(
                'Buat Password Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat password agar kamu bisa login menggunakan email dan password tanpa menekan tombol Google Login.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),

          _buildPasswordField(
            label: 'Password Baru',
            controller: _passwordController,
            obscure: _obscurePassword,
            onToggle: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildPasswordField(
            label: 'Konfirmasi Password',
            controller: _confirmPasswordController,
            obscure: _obscureConfirmPassword,
            onToggle: () {
              setState(() {
                _obscureConfirmPassword =
                    !_obscureConfirmPassword;
              });
            },
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: _isSettingPassword
                ? null
                : _setEmailPassword,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: limeColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: _isSettingPassword
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Buat Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            hintText: 'Minimal 6 karakter',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
                size: 19,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================
  // DELETE ACCOUNT
  // ============================================

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
            Icon(
              Icons.warning_amber_rounded,
              color: deleteColor,
              size: 22,
            ),
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
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
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

  // ============================================
  // SNACKBAR
  // ============================================

  void _showSnackBar(String message, IconData icon) {
    if (!mounted) return;

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
  // CHANGE AVATAR
  // ============================================

  Future<void> _changeAvatar() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(sheetContext).size.height * 0.85,
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
                  onTap: () =>
                      Navigator.pop(sheetContext, 'camera'),
                ),
                const SizedBox(height: 10),
                _buildSheetOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Pilih dari Galeri',
                  subtitle: 'Ambil dari penyimpanan',
                  onTap: () =>
                      Navigator.pop(sheetContext, 'gallery'),
                ),
                const SizedBox(height: 10),
                _buildSheetOption(
                  icon: Icons.emoji_emotions_outlined,
                  title: 'Pakai Emoji',
                  subtitle: 'Pilih emoji preset',
                  onTap: () =>
                      Navigator.pop(sheetContext, 'emoji'),
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

  // ============================================
  // PICK IMAGE
  // ============================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (picked == null || !mounted) return;

      final bytes = await picked.readAsBytes();

      if (!mounted) return;

      setState(() {
        _avatarImageBytes = bytes;
      });

      _showSnackBar(
        'Foto profil dipilih.',
        Icons.check_circle,
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(
        'Gagal mengambil foto: $e',
        Icons.error_outline,
      );
    }
  }

  // ============================================
  // PICK EMOJI
  // ============================================

  Future<void> _pickEmoji() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(sheetContext).size.height * 0.85,
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
                        emoji == _userAvatar &&
                        _avatarImageBytes == null;

                    return GestureDetector(
                      onTap: () =>
                          Navigator.pop(sheetContext, emoji),
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

  // ============================================
  // BOTTOM SHEET OPTION
  // ============================================

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

  // ============================================
  // BUILD
  // ============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: limeColor,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        16, 8, 16, 24,
                      ),
                      child: Column(
                        children: [
                          _buildAvatarSection(),
                          const SizedBox(height: 28),
                          _buildFieldsGroup(),
                          const SizedBox(height: 20),

                          // Bagian membuat password
                          _buildPasswordSection(),

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
                border: Border.all(color: limeColor, width: 2),
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
                  border: Border.all(color: bgColor, width: 3),
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
            readOnly: true,
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
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
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
              readOnly: readOnly,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: readOnly ? Colors.grey : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                isDense: true,
                suffixIcon: readOnly
                    ? const Icon(
                        Icons.lock_outline,
                        size: 15,
                        color: Colors.grey,
                      )
                    : null,
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
      onTap: _isSaving ? null : _saveChanges,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isSaving
              ? limeColor.withValues(alpha: 0.6)
              : limeColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: limeColor.withValues(alpha: 0.25),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
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