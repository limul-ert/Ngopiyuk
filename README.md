<div align="center">

# ☕ NgopiYuk

### Aplikasi Discovery Cafe Madiun

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://vercel.com)
[![License](https://img.shields.io/badge/License-MIT-C8956D?style=for-the-badge)](LICENSE)

**Temukan cafe terbaik di Madiun — dari yang asri, estetik, murah, sampai yang buka 24 jam!**

[🌐 Live Demo](https://ngopiyukk.vercel.app) · [📸 Screenshots](#-screenshots) · [🐛 Report Bug](https://github.com/limul-ert/ngopiyukk/issues)

</div>

---

## 📖 Tentang Aplikasi

**NgopiYuk** adalah aplikasi *discovery cafe* berbasis **Flutter Web** yang dirancang untuk membantu pengguna menemukan cafe-cafe terbaik di kota Madiun. Aplikasi ini menampilkan 10 cafe real Madiun lengkap dengan informasi menu, rating, jam operasional, dan lokasi.

Aplikasi ini dibuat sebagai **Tugas UTS mata kuliah Pemrograman Mobile** di Program Studi Teknik Informatika, Universitas Negeri Surabaya.

---

## ✨ Fitur Utama

### 🏠 Jelajah Cafe
- **10 Cafe Real Madiun** — lengkap dengan deskripsi, alamat, dan kontak
- **Kategori Cafe** — filter berdasarkan karakteristik: `Alam`, `Estetik`, `Murah`, `24 Jam`
- **Rating Tertinggi** — section khusus menampilkan cafe dengan rating terbaik
- **Pencarian Real-time** — cari cafe berdasarkan nama, alamat, atau kategori

### 🍽️ Detail Cafe
- **Menu Lengkap** — dikelompokkan per kategori: Minuman, Makanan, Snack
- **Tab Sticky** — navigasi antar kategori menu yang smooth
- **Gambar Menu** — visual menarik untuk setiap item
- **Buka di Google Maps** — langsung ke lokasi cafe dengan titik akurat

### 💬 Fitur Chat Reservasi
- **Chat dengan Cafe** — langsung dari halaman detail cafe
- **Auto-reply Pintar** — bot menjawab pertanyaan umum (reservasi, acara, jam buka, menu, harga)
- **Quick Reply Chips** — tombol pintas: Reservasi Meja, Pesan Acara, Jam Buka, Lihat Menu
- **Riwayat Chat Tersimpan** — history chat tersimpan per cafe
- **Typing Indicator** — animasi 3 titik saat bot "mengetik"

### 🛒 Keranjang & Checkout
- **Tambah ke Keranjang** — dari halaman detail cafe dengan satu klik
- **Kelola Quantity** — tambah/kurang/hapus item
- **Persistent Cart** — keranjang tersimpan meski aplikasi ditutup
- **Checkout Form** — info penerima, metode pembayaran (COD, Transfer, E-Wallet)
- **Riwayat Pesanan** — order history tersimpan otomatis

### 👤 Profil & Kustomisasi
- **Login & Register** — autentikasi sederhana dengan SharedPreferences
- **Edit Profil** — ganti nama, email, nomor HP
- **Foto Profil** — ambil dari kamera, galeri, atau pilih emoji
- **Favorit** — simpan cafe favoritmu

### 🎨 Desain
- **Dark Mode** — tema gelap dengan aksen warm coklat (`#C8956D`)
- **Responsive** — layout desktop & mobile yang berbeda
- **Animasi Smooth** — transisi yang halus di setiap interaksi
- **UI Konsisten** — design system yang seragam di seluruh halaman

---

## 📸 Screenshots

<div align="center">

| Login | Home | Detail Cafe |
|:---:|:---:|:---:|
| ![Login](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Login) | ![Home](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Home) | ![Detail](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Detail+Cafe) |

| Chat Reservasi | Keranjang | Checkout |
|:---:|:---:|:---:|
| ![Chat](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Chat) | ![Cart](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Keranjang) | ![Checkout](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Checkout) |

| Favorit | Profil | Edit Profil |
|:---:|:---:|:---:|
| ![Favorit](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Favorit) | ![Profil](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Profil) | ![Edit](https://via.placeholder.com/200x400/0F0F0F/C8956D?text=Edit+Profil) |

</div>

> 💡 **Tips:** Ganti gambar di atas dengan screenshot asli aplikasimu. Simpan di folder `screenshots/` dan update path-nya.

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|----------|-----------|
| **Framework** | Flutter 3.13+ |
| **Bahasa** | Dart 3.13+ |
| **State Management** | [Provider](https://pub.dev/packages/provider) |
| **Local Storage** | [SharedPreferences](https://pub.dev/packages/shared_preferences) |
| **HTTP / URL Launcher** | [url_launcher](https://pub.dev/packages/url_launcher) |
| **Image Picker** | [image_picker](https://pub.dev/packages/image_picker) |
| **Format Tanggal** | [intl](https://pub.dev/packages/intl) |
| **Deployment** | Vercel |

---

## 🚀 Cara Menjalankan

### Prasyarat
Pastikan kamu sudah menginstall:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.13+)
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- Git

### Langkah Instalasi

1. **Clone repository ini**
   ```bash
   git clone https://github.com/limul-ert/ngopiyukk.git
   cd ngopiyukk
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   # Untuk Chrome (Web)
   flutter run -d chrome

   # Untuk Android
   flutter run

   # Untuk list device yang tersedia
   flutter devices
   ```

4. **Build untuk production (Web)**
   ```bash
   flutter build web --release
   ```
   Output ada di folder `build/web/`

---

## 📁 Struktur Project

```
lib/
├── data/
│   └── dummy_cafes.dart          # Data 10 cafe + menu + promo
├── models/
│   ├── cafe.dart                 # Model Cafe, MenuItem, Promo
│   ├── cart_item.dart            # Model CartItem
│   ├── chat_message.dart         # Model ChatMessage
│   └── order.dart                # Model Order
├── pages/
│   ├── login_page.dart           # Halaman login
│   ├── register_page.dart        # Halaman register
│   ├── home_page.dart            # Halaman utama
│   ├── cafe_detail_page.dart     # Detail cafe + menu
│   ├── cafe_list_page.dart       # List cafe (view all)
│   ├── search_page.dart          # Pencarian
│   ├── favorites_page.dart       # Daftar favorit
│   ├── cart_page.dart            # Keranjang
│   ├── checkout_page.dart        # Checkout
│   ├── order_success_page.dart   # Sukses order
│   ├── chat_page.dart            # Chat dengan cafe
│   ├── profile_page.dart         # Profil user
│   ├── edit_profile_page.dart    # Edit profil
│   └── info_pages.dart           # Contact, About, Terms, Privacy
├── providers/
│   ├── cart_provider.dart        # State management cart
│   └── chat_provider.dart        # State management chat
├── widgets/
│   ├── cafe_card.dart            # Card cafe (horizontal & vertical)
│   ├── cafe_image.dart           # Image loader (asset/network)
│   ├── category_row.dart         # Row kategori
│   └── promo_carousel.dart       # Carousel promo
└── main.dart                     # Entry point + MultiProvider

assets/
├── images/
│   ├── kopi.png                  # Logo aplikasi
│   └── cafe/                     # Foto cafe lokal
│       ├── paratamu.png
│       ├── sea_coffee.jpg
│       ├── holly_cafe.jpeg
│       ├── hakui_coffee.jpeg
│       ├── lokatara_coffee.jpeg
│       ├── warung_latte.jpg
│       └── wow.jpg
```

---

## 🌐 Deployment

Project ini di-deploy otomatis ke **Vercel** melalui integrasi GitHub.

### Setup Awal
1. Push project ke GitHub
2. Import repository di [Vercel](https://vercel.com)
3. Setting di Vercel:
   - **Framework Preset**: `Other`
   - **Install Command**: 
     ```bash
     if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web
     ```
   - **Build Command**: 
     ```bash
     flutter/bin/flutter pub get && flutter/bin/flutter build web --release
     ```
   - **Output Directory**: `build/web`

### Update Otomatis
Setiap kali push ke branch `main`, Vercel otomatis rebuild & redeploy:
```bash
git add .
git commit -m "Update fitur X"
git push
```

---

## 📝 Lisensi

Project ini dilisensikan di bawah **MIT License** — bebas digunakan untuk keperluan pembelajaran.

---

## 👨‍💻 Developer

<div align="center">

**Maulana Halim**

Program Studi Teknik Informatika
Universitas Negeri Surabaya

[![GitHub](https://img.shields.io/badge/GitHub-limul--ert-181717?style=for-the-badge&logo=github)](https://github.com/limul-ert)

</div>

---

## 🙏 Ucapan Terima Kasih

- **Allah SWT** — atas segala rahmat dan karunia-Nya
- **Dosen Pengampu** — atas bimbingan selama perkuliahan
- **Flutter Community** — atas dokumentasi & package yang luar biasa
- **Pemilik Cafe Madiun** — atas inspirasi data cafe di aplikasi ini

---

<div align="center">

### ☕ Selamat Ngopi! 

**Kalau project ini bermanfaat, jangan lupa kasih ⭐ ya!**

Made with ❤️ using Flutter

</div>
