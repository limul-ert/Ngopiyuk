import 'package:flutter/material.dart';

// ============================================
// COLOR PALETTE
// ============================================
class _Colors {
  static const bgColor = Color(0xFF0A0A0A);
  static const cardColor = Color(0xFF181818);
  static const dividerColor = Color(0xFF252525);
  static const limeColor = Color(0xFFC7F464);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.grey;
}

// ============================================
// HEADER REUSABLE
// ============================================
class _InfoHeader extends StatelessWidget {
  final String title;
  const _InfoHeader({required this.title});

  @override
  Widget build(BuildContext context) {
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
                color: _Colors.cardColor,
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
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
}

// ============================================
// 1. HALAMAN KONTAK SAYA
// ============================================
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const _InfoHeader(title: 'Kontak Saya'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hero
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _Colors.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: _Colors.limeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: _Colors.limeColor,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Butuh Bantuan?',
                            style: TextStyle(
                              color: _Colors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tim NgopiYuk siap bantu kamu setiap hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _Colors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact items
                    _buildContactCard(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: 'support@ngopiyuk.com',
                    ),
                    _buildContactCard(
                      icon: Icons.phone_outlined,
                      title: 'Telepon',
                      value: '+62 812-3456-7890',
                    ),
                    _buildContactCard(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      value: 'Jl. Ahmad Yani No. 45, Madiun, Jawa Timur',
                    ),
                    _buildContactCard(
                      icon: Icons.access_time,
                      title: 'Jam Operasional',
                      value: 'Senin - Minggu, 08.00 - 22.00 WIB',
                    ),
                    const SizedBox(height: 16),

                    // Social Media
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _Colors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ikuti Kami',
                            style: TextStyle(
                              color: _Colors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSocialIcon(Icons.camera_alt_outlined,
                                  'Instagram'),
                              _buildSocialIcon(
                                  Icons.facebook_outlined, 'Facebook'),
                              _buildSocialIcon(Icons.public, 'Website'),
                              _buildSocialIcon(
                                  Icons.chat_bubble_outline, 'WhatsApp'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _Colors.limeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _Colors.limeColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _Colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: _Colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _Colors.bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Icon(icon, color: _Colors.textPrimary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: _Colors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ============================================
// 2. HALAMAN TENTANG APLIKASI
// ============================================
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const _InfoHeader(title: 'Tentang Aplikasi'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App logo & name
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: _Colors.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _Colors.limeColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: ClipOval(
                              child: Transform.scale(
                                scale: 1.4,
                                child: Image.asset(
                                  'assets/images/kopi.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'NgopiYuk',
                            style: TextStyle(
                              color: _Colors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _Colors.limeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Versi 1.0.0',
                              style: TextStyle(
                                color: _Colors.limeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildSection(
                      icon: Icons.description_outlined,
                      title: 'Deskripsi',
                      content:
                      'NgopiYuk adalah aplikasi discovery cafe terbaik di Madiun. '
                          'Temukan cafe favoritmu berdasarkan kategori, rating, '
                          'dan jam operasional. Lihat menu, buka lokasi lewat Google '
                          'Maps, dan simpan cafe favoritmu untuk dikunjungi nanti.',
                    ),
                    const SizedBox(height: 12),

                    // Features
                    _buildSection(
                      icon: Icons.star_outline,
                      title: 'Fitur Utama',
                      content:
                      '• Jelajah cafe dengan kategori (Alam, Estetik, Murah, 24 Jam)\n'
                          '• Rating tertinggi dari pengguna\n'
                          '• Pencarian real-time\n'
                          '• Simpan cafe favorit\n'
                          '• Buka lokasi di Google Maps\n'
                          '• Panggil cafe langsung dari aplikasi',
                    ),
                    const SizedBox(height: 12),

                    // Developer
                    _buildSection(
                      icon: Icons.code,
                      title: 'Developer',
                      content:
                      'Dibuat dengan Flutter & Dart\n'
                          'Oleh: Maulana Halim\n'
                          'Program Studi Teknik Informatika\n'
                          'Universitas Negeri Surabaya',
                    ),
                    const SizedBox(height: 12),

                    // Copyright
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _Colors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.copyright,
                            color: _Colors.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '2025 NgopiYuk. All rights reserved.',
                            style: TextStyle(
                              color: _Colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _Colors.limeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _Colors.limeColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: _Colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: _Colors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 3. HALAMAN SYARAT & KETENTUAN
// ============================================
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const _InfoHeader(title: 'Syarat & Ketentuan'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(
                      icon: Icons.description_outlined,
                      title: 'Syarat & Ketentuan Penggunaan',
                      subtitle: 'Berlaku sejak 1 Januari 2025',
                    ),
                    const SizedBox(height: 16),
                    _buildTextSection(
                      '1. Penerimaan Syarat',
                      'Dengan mengunduh, mengakses, atau menggunakan aplikasi NgopiYuk, '
                          'kamu dianggap telah membaca, memahami, dan menyetujui seluruh '
                          'syarat dan ketentuan yang tercantum dalam halaman ini. Jika kamu '
                          'tidak setuju, mohon untuk tidak menggunakan aplikasi ini.',
                    ),
                    _buildTextSection(
                      '2. Penggunaan Aplikasi',
                      'Aplikasi NgopiYuk disediakan untuk keperluan pencarian informasi '
                          'cafe di wilayah Madiun dan sekitarnya. Pengguna setuju untuk '
                          'menggunakan aplikasi ini secara wajar dan tidak menyalahgunakan '
                          'fitur yang tersedia.',
                    ),
                    _buildTextSection(
                      '3. Akun Pengguna',
                      'Pengguna bertanggung jawab penuh atas keamanan akun dan data yang '
                          'dimasukkan ke dalam aplikasi. Kami tidak bertanggung jawab atas '
                          'kerugian yang timbul akibat kelalaian pengguna dalam menjaga '
                          'keamanan akun.',
                    ),
                    _buildTextSection(
                      '4. Konten dan Informasi',
                      'Seluruh informasi cafe yang ditampilkan bersifat informatif. Data '
                          'cafe bersifat dummy untuk keperluan pembelajaran/demo. Kami tidak '
                          'menjamin keakuratan informasi terkait jam operasional, harga, atau '
                          'ketersediaan menu.',
                    ),
                    _buildTextSection(
                      '5. Perubahan Syarat',
                      'Kami berhak mengubah syarat dan ketentuan ini sewaktu-waktu tanpa '
                          'pemberitahuan terlebih dahulu. Pengguna disarankan untuk memeriksa '
                          'halaman ini secara berkala.',
                    ),
                    _buildTextSection(
                      '6. Hubungi Kami',
                      'Untuk pertanyaan terkait syarat dan ketentuan ini, silakan hubungi '
                          'kami di support@ngopiyuk.com.',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _Colors.limeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _Colors.limeColor, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: _Colors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _Colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: _Colors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 4. HALAMAN KEBIJAKAN PRIVASI
// ============================================
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const _InfoHeader(title: 'Kebijakan Privasi'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Kebijakan Privasi',
                      subtitle: 'Terakhir diperbarui: 1 Januari 2025',
                    ),
                    const SizedBox(height: 16),
                    _buildTextSection(
                      '1. Data yang Kami Kumpulkan',
                      'Kami mengumpulkan data terbatas untuk keperluan fungsionalitas '
                          'aplikasi, meliputi:\n\n'
                          '• Nama pengguna (untuk personalisasi sapaan)\n'
                          '• Alamat email (untuk identifikasi akun)\n'
                          '• Foto profil (opsional, disimpan lokal di perangkatmu)\n'
                          '• Daftar cafe favorit',
                    ),
                    _buildTextSection(
                      '2. Cara Kami Menyimpan Data',
                      'Seluruh data pengguna disimpan secara lokal di perangkatmu '
                          'menggunakan SharedPreferences. Kami tidak mengirim data ke server '
                          'manapun. Data hanya dapat diakses oleh aplikasi NgopiYuk di '
                          'perangkatmu.',
                    ),
                    _buildTextSection(
                      '3. Penggunaan Data',
                      'Data yang kami kumpulkan digunakan hanya untuk:\n\n'
                          '• Menampilkan nama dan foto di halaman profil\n'
                          '• Menyimpan daftar cafe favoritmu\n'
                          '• Menjaga sesi login agar kamu tidak perlu login berulang kali',
                    ),
                    _buildTextSection(
                      '4. Keamanan Data',
                      'Kami berkomitmen menjaga keamanan data pengguna. Meskipun data '
                          'disimpan secara lokal, kami sarankan kamu untuk tidak membagikan '
                          'perangkatmu kepada orang lain tanpa pengawasan.',
                    ),
                    _buildTextSection(
                      '5. Izin Aplikasi',
                      'Aplikasi NgopiYuk meminta izin berikut:\n\n'
                          '• Akses kamera & galeri (untuk foto profil)\n'
                          '• Akses internet (untuk memuat gambar cafe)\n\n'
                          'Semua izin hanya digunakan untuk fungsionalitas yang disebutkan di atas.',
                    ),
                    _buildTextSection(
                      '6. Hak Pengguna',
                      'Kamu berhak untuk:\n\n'
                          '• Menghapus akun dan seluruh data terkait\n'
                          '• Mengubah atau menghapus foto profil\n'
                          '• Menghapus daftar cafe favorit\n'
                          '• Keluar dari aplikasi kapan saja',
                    ),
                    _buildTextSection(
                      '7. Hubungi Kami',
                      'Jika kamu memiliki pertanyaan tentang kebijakan privasi ini, '
                          'silakan hubungi kami di privacy@ngopiyuk.com.',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _Colors.limeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _Colors.limeColor, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: _Colors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _Colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: _Colors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}