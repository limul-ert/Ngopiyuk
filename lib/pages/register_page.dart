
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color inputBorder = Color(0xFF2A2A2A);

  static const double heroHeight = 240;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar({
    required IconData icon,
    required String message,
  }) {
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
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  // ============================================
  // REGISTER FIREBASE
  // ============================================
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      _showSnackBar(
        icon: Icons.warning_amber_rounded,
        message: 'Centang dulu persetujuan syarat & ketentuan',
      );
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    bool accountCreated = false;

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // 1. Membuat akun Firebase dan menyimpan profil Firestore.
      await AuthService().register(
        name: name,
        email: email,
        password: password,
      );

      accountCreated = true;

      // 2. Simpan nama dan email untuk ProfilePage.
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);

      // 3. Logout dari Firebase.
      await AuthService().logout();

      if (!mounted) return;

      // 4. Kembali ke LoginPage.
      Navigator.of(context).pop();

      // 5. Tampilkan pesan setelah kembali ke LoginPage.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Pendaftaran berhasil! Silakan login.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      // Jika akun gagal dibuat, pastikan tidak ada sesi tertinggal.
      try {
        await AuthService().logout();
      } catch (_) {}

      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar. Silakan login.';
          break;

        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;

        case 'weak-password':
          message = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
          break;

        case 'network-request-failed':
          message = 'Koneksi internet bermasalah. Coba kembali.';
          break;

        case 'operation-not-allowed':
          message = 'Email/password belum diaktifkan di Firebase.';
          break;

        default:
          message = e.message ?? 'Pendaftaran gagal. Silakan coba lagi.';
      }

      _showSnackBar(
        icon: Icons.error_outline,
        message: message,
      );
    } on FirebaseException catch (e) {
      // Firestore gagal menyimpan profil.
      // Tetap logout agar AuthGate tidak membuka MainPage.
      try {
        await AuthService().logout();
      } catch (logoutError) {
        debugPrint('Logout error: $logoutError');
      }

      debugPrint('FIRESTORE ERROR CODE: ${e.code}');
      debugPrint('FIRESTORE ERROR MESSAGE: ${e.message}');

      if (!mounted) return;

      _showSnackBar(
        icon: Icons.error_outline,
        message: 'Firestore error (${e.code}): ${e.message ?? "Gagal menyimpan profil"}',
      );
    } catch (e) {
      // Jika akun sudah dibuat tetapi proses berikutnya gagal,
      // tetap akhiri sesi Firebase.
      if (accountCreated) {
        try {
          await AuthService().logout();
        } catch (logoutError) {
          debugPrint('Logout error: $logoutError');
        }
      }

      debugPrint('REGISTER ERROR: $e');

      if (!mounted) return;

      _showSnackBar(
        icon: Icons.error_outline,
        message: 'Terjadi kesalahan: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleSignup() {
    _showSnackBar(
      icon: Icons.info_outline,
      message: 'Sign up dengan Google - Coming Soon',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: isDesktop
            ? _buildDesktopLayout()
            : _buildMobileLayout(),
      ),
    );
  }

  // ============================================
  // DESKTOP LAYOUT
  // ============================================
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 50),
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftar dulu buat mulai jelajah cafe terbaik di Madiun',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                _buildFormSection(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=1200&q=80',
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(color: cardColor);
              },
              errorWidget: (context, url, error) {
                return _buildImageFallback();
              },
            ),
          ),
        ),
      ],
    );
  }

  // ============================================
  // MOBILE LAYOUT
  // ============================================
  Widget _buildMobileLayout() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80',
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(color: cardColor);
                },
                errorWidget: (context, url, error) {
                  return _buildImageFallback();
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      bgColor.withValues(alpha: 0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Center(
                child: _buildLogo(size: 100),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: heroHeight),
              Container(
                color: bgColor,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Daftar dulu buat mulai jelajah cafe terbaik di Madiun',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildFormSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: _buildBackButton(),
        ),
      ],
    );
  }

  // ============================================
  // HEADER DESKTOP
  // ============================================
  Widget _buildHeader() {
    return Row(
      children: [
        _buildBackButton(),
        const SizedBox(width: 12),
        _buildLogo(size: 56),
        const SizedBox(width: 12),
        const Text(
          'NgopiYuk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.4),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.4,
          child: Image.asset(
            'assets/images/kopi.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleBack,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: cardColor,
      alignment: Alignment.center,
      child: const Icon(
        Icons.coffee,
        color: primaryColor,
        size: 70,
      ),
    );
  }

  // ============================================
  // FORM SECTION
  // ============================================
  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            controller: _nameController,
            hint: 'Nama lengkap',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama tidak boleh kosong';
              }

              if (value.trim().length < 3) {
                return 'Nama minimal 3 karakter';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _emailController,
            hint: 'contoh@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email tidak boleh kosong';
              }

              if (!value.contains('@') || !value.contains('.')) {
                return 'Format email tidak valid';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _passwordController,
            hint: 'Minimal 6 karakter',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }

              if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }

              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _agreeTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeTerms = value ?? false;
                    });
                  },
                  activeColor: primaryColor,
                  checkColor: Colors.black,
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(text: 'Saya setuju dengan '),
                      TextSpan(
                        text: 'Syarat & Ketentuan',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
                disabledBackgroundColor:
                    primaryColor.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                  height: 1,
                  thickness: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Or Sign up with',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                  height: 1,
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: _handleGoogleSignup,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                backgroundColor: cardColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Sign up with Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: _handleBack,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // INPUT FIELD
  // ============================================
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
        ),
      ),
    );
  }
}