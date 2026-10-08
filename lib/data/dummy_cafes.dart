import '../models/cafe.dart';

// ============================================
// MENU STANDAR — dipakai semua cafe
// Foto dari Unsplash (support CORS, aman di Flutter Web)
// ============================================
const List<MenuItem> _menuStandar = [
  // ============ MINUMAN ============
  MenuItem(
    name: 'Es Kopi Susu',
    price: 18000,
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&q=80',
  ),
  MenuItem(
    name: 'Americano',
    price: 20000,
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1551030173-122aabc4489c?w=400&q=80',
  ),
  MenuItem(
    name: 'Cappuccino',
    price: 22000,
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&q=80',
  ),
  MenuItem(
    name: 'Matcha Latte',
    price: 25000,
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&q=80',
  ),
  MenuItem(
    name: 'Chocolate Ice',
    price: 22000,
    category: 'Minuman',
    imageUrl: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400&q=80',
  ),

  // ============ MAKANAN ============
  MenuItem(
    name: 'Nasi Goreng Spesial',
    price: 25000,
    category: 'Makanan',
    imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&q=80',
  ),
  MenuItem(
    name: 'Rice Bowl Chicken Teriyaki',
    price: 25000,
    category: 'Makanan',
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
  ),
  MenuItem(
    name: 'Spaghetti Bolognese',
    price: 28000,
    category: 'Makanan',
    imageUrl: 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&q=80',
  ),
  MenuItem(
    name: 'Mie Goreng Jawa',
    price: 22000,
    category: 'Makanan',
    imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&q=80',
  ),
  MenuItem(
    name: 'Chicken Katsu Curry',
    price: 30000,
    category: 'Makanan',
    imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&q=80',
  ),

  // ============ SNACK ============
  MenuItem(
    name: 'French Fries',
    price: 18000,
    category: 'Snack',
    imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80',
  ),
  MenuItem(
    name: 'Tahu Crispy',
    price: 15000,
    category: 'Snack',
    imageUrl: 'https://images.unsplash.com/photo-1547496502-affa22d38842?w=400&q=80',
  ),
  MenuItem(
    name: 'Pisang Goreng',
    price: 15000,
    category: 'Snack',
    imageUrl: 'https://images.unsplash.com/photo-1603052875302-d376b7c0638a?w=400&q=80',
  ),
  MenuItem(
    name: 'Cireng Bumbu Rujak',
    price: 15000,
    category: 'Snack',
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&q=80',
  ),
  MenuItem(
    name: 'Mix Platter',
    price: 25000,
    category: 'Snack',
    imageUrl: 'https://images.unsplash.com/photo-1541014741259-de529411b96a?w=400&q=80',
  ),
];

// ============================================
// 10 CAFE REAL MADIUN — menu disamakan
// ============================================
final List<Cafe> dummyCafes = [
  // ============ 1. SEA COFFEE ============
  const Cafe(
    name: 'Sea Coffee',
    address:
    'Cagar Budaya Bosbow, Jl. Diponegoro No. 39, Manguharjo, Kec. Manguharjo, Kota Madiun, Jawa Timur 63121',
    phone: '0812-3023-4567',
    description:
    'Kafe dengan konsep rustic-natural dipenuhi tanaman hijau dan kolam. '
        'Nikmati kopi dengan suasana alam yang menenangkan di area cagar budaya.',
    imageUrl: 'assets/images/cafe/sea_coffee.jpg', // ← ✅ .jpg
    rating: 4.7,
    reviewCount: 213,
    openHours: '08.00 - 24.00',
    priceRange: 'Rp 18.000 - Rp 30.000',
    categories: ['Alam', 'Rustic', 'Outdoor'],
    latitude: -7.6240,
    longitude: 111.5180,
    menu: _menuStandar,
  ),

  // ============ 2. HOLLY CAFE ============
  const Cafe(
    name: 'Holly Cafe',
    address:
    'Jl. Rimba Karya No. 1, Kartoharjo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63117',
    phone: '0822-4567-8901',
    description:
    'Kafe asri dengan pepohonan rimbun di kawasan Perhutani. '
        'Suasana sejuk, cocok buat healing dan menyegarkan pikiran.',
    imageUrl: 'assets/images/cafe/holly_cafe.jpeg', // ← ✅ .jpeg
    rating: 4.6,
    reviewCount: 178,
    openHours: '09.00 - 22.00',
    priceRange: 'Rp 15.000 - Rp 32.000',
    categories: ['Alam', 'Healing', 'Outdoor'],
    latitude: -7.6360,
    longitude: 111.5145,
    menu: _menuStandar,
  ),

  // ============ 3. PARATAMU COFFEE ============
  const Cafe(
    name: 'Paratamu Coffee',
    address:
    'Jl. Terate No. 55, Munggut, Kec. Wungu, Kabupaten Madiun, Jawa Timur 63181',
    phone: '0813-5789-0123',
    description:
    'Desain arsitektur modern minimalis dipadu aksen kayu asri. '
        'Setiap sudutnya instagramable banget!',
    imageUrl: 'assets/images/cafe/paratamu.png', // ← ✅ .png
    rating: 4.7,
    reviewCount: 198,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 20.000 - Rp 42.000',
    categories: ['Estetik', 'Minimalis', 'Instagramable'],
    latitude: -7.6480,
    longitude: 111.5420,
    menu: _menuStandar,
  ),

  // ============ 4. HAKUI COFFEE ============
  const Cafe(
    name: 'Hakui Coffee',
    address:
    'Jl. Rimba Mulya No. 9, Kartoharjo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63117',
    phone: '0812-9876-5432',
    description:
    'Kafe estetik dengan desain interior modern dan spot foto kekinian. '
        'Cocok buat nongkrong dan konten sosmed.',
    imageUrl: 'assets/images/cafe/hakui_coffee.jpeg', // ← ✅ .jpeg
    rating: 4.5,
    reviewCount: 156,
    openHours: '10.00 - 23.00',
    priceRange: 'Rp 18.000 - Rp 38.000',
    categories: ['Estetik', 'Instagramable', 'Indoor'],
    latitude: -7.6355,
    longitude: 111.5230,
    menu: _menuStandar,
  ),

  // ============ 5. WAROENG LATTE ============
  const Cafe(
    name: 'Waroeng Latte',
    address:
    'Jl. H.O.S. Cokroaminoto No. 88, Josenan, Kec. Taman, Kota Madiun, Jawa Timur 63131',
    phone: '0857-1234-5678',
    description:
    'Kafe dengan atap penuh tumbuhan rambat warna-warni. '
        'Cocok buat foto-foto estetik dan santai sore dengan harga terjangkau.',
    imageUrl: 'assets/images/cafe/warung_latte.jpg', // ← ✅ .jpg
    rating: 4.6,
    reviewCount: 224,
    openHours: '11.00 - 23.00',
    priceRange: 'Rp 12.000 - Rp 28.000',
    categories: ['Murah'],
    latitude: -7.6280,
    longitude: 111.5270,
    menu: _menuStandar,
  ),

  // ============ 6. LOKATARA COFFEE ============
  const Cafe(
    name: 'Lokatara Coffee',
    address:
    'Jl. Mastrip No. 42, Mojorejo, Kec. Taman, Kota Madiun, Jawa Timur 63139',
    phone: '0821-3456-7890',
    description:
    'Coffee shop dengan harga ramah kantong dan suasana nyaman. '
        'Tempat favorit mahasiswa buat nugas dan diskusi.',
    imageUrl: 'assets/images/cafe/lokatara_coffee.jpeg', // ← ✅ .jpeg
    rating: 4.4,
    reviewCount: 189,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 12.000 - Rp 22.000',
    categories: ['Murah', 'Nugas', 'WiFi Cepat'],
    latitude: -7.6265,
    longitude: 111.5280,
    menu: _menuStandar,
  ),

  // ============ 7. WARKOP BREWOK ============
  const Cafe(
    name: 'Warkop Brewok',
    address:
    'Jl. Trunojoyo No. 92, Nambangan Kidul, Kec. Manguharjo, Kota Madiun, Jawa Timur 63128',
    phone: '0813-2345-6789',
    description:
    'Warung kopi dengan cita rasa otentik dan harga merakyat. '
        'Suasana santai cocok buat cerita panjang sampai malam.',
    imageUrl: 'https://cdn-jpr.jawapos.com/images/14/2023/09/04/warkop-brewok-madiun-2662897356.jpg',
    rating: 4.3,
    reviewCount: 156,
    openHours: '10.00 - 24.00',
    priceRange: 'Rp 6.000 - Rp 16.000',
    categories: ['Murah', 'Tradisional', 'Nongkrong'],
    latitude: -7.6235,
    longitude: 111.5240,
    menu: _menuStandar,
  ),

  // ============ 8. TOMORO COFFEE ============
  const Cafe(
    name: 'Tomoro Coffee (Stasiun Madiun)',
    address:
    'Jl. Kompol Sunaryo No. 14, Madiun Lor, Kec. Manguharjo, Kota Madiun, Jawa Timur 63122',
    phone: '0811-3000-888',
    description:
    'Modern coffee shop dekat stasiun dengan colokan melimpah. '
        'Buka 24 jam, cocok buat nunggu kereta atau WFC.',
    imageUrl: 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/05/31/3695262831.jpg',
    rating: 4.5,
    reviewCount: 267,
    openHours: '24 Jam',
    priceRange: 'Rp 12.000 - Rp 28.000',
    categories: ['24 Jam', 'Modern', 'Nugas'],
    latitude: -7.6180,
    longitude: 111.5250,
    menu: _menuStandar,
  ),

  // ============ 9. FREEN HOUSE ============
  const Cafe(
    name: 'Freen House',
    address:
    'Jl. Ahmad Yani No. 45, Pangongangan, Kec. Manguharjo, Kota Madiun, Jawa Timur 63121',
    phone: '0852-9012-3456',
    description:
    'Kafe estetik 24 jam dengan Wi-Fi cepat, nyaman untuk working space. '
        'Colokan banyak dan kopi yang enak.',
    imageUrl: 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2025/05/31/3117452384.jpg',
    rating: 4.8,
    reviewCount: 342,
    openHours: '24 Jam',
    priceRange: 'Rp 15.000 - Rp 26.000',
    categories: ['24 Jam', 'Nugas', 'WiFi Cepat'],
    latitude: -7.6298,
    longitude: 111.5239,
    menu: _menuStandar,
  ),

  // ============ 10. WARUNK WOW KWB ============
  const Cafe(
    name: 'Warunk Wow KWB',
    address:
    'Jl. Mawar No. 12, Oro-Oro Ombo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63119',
    phone: '0812-4900-1122',
    description:
    'Warung kekinian yang buka 24 jam dengan menu variatif dan harga murah. '
        'Tempat nongkrong santai kapan pun kamu mau.',
    imageUrl: 'assets/images/cafe/wow.jpg', // ← ✅ .jpg
    rating: 4.4,
    reviewCount: 198,
    openHours: '24 Jam',
    priceRange: 'Rp 10.000 - Rp 30.000',
    categories: ['24 Jam'],
    latitude: -7.6320,
    longitude: 111.5270,
    menu: _menuStandar,
  ),
];

// ============================================
// 4 PROMO UNTUK CAROUSEL
// ============================================
final List<Promo> dummyPromos = [
  const Promo(
    title: 'Diskon 30%',
    subtitle: 'Freen Signature Coffee',
    imageUrl: 'https://picsum.photos/seed/promo1/800/400',
    cafeName: 'Freen House',
  ),
  const Promo(
    title: 'Beli 1 Gratis 1',
    subtitle: 'Semua Varian Latte',
    imageUrl: 'https://picsum.photos/seed/promo2/800/400',
    cafeName: 'Waroeng Latte',
  ),
  const Promo(
    title: 'Paket Nugas',
    subtitle: 'Kopi + Snack Rp 25.000',
    imageUrl: 'https://picsum.photos/seed/promo3/800/400',
    cafeName: 'Lokatara Coffee',
  ),
  const Promo(
    title: 'Happy Hour',
    subtitle: 'Diskon 20% jam 3-5 sore',
    imageUrl: 'https://picsum.photos/seed/promo4/800/400',
    cafeName: 'Sea Coffee',
  ),
];

// ============================================
// 5 KATEGORI UNTUK CHIPS
// ============================================
final List<Map<String, dynamic>> dummyCategories = [
  {'name': 'All', 'icon': 'coffee'},
  {'name': 'Alam', 'icon': 'leaf'},
  {'name': 'Estetik', 'icon': 'palette'},
  {'name': 'Murah', 'icon': 'money'},
  {'name': '24 Jam', 'icon': 'clock'},
];