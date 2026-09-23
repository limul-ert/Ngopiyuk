import '../models/cafe.dart';

// ============================================
// 6 KAFE MADIUN (Data Dummy)
// ============================================
final List<Cafe> dummyCafes = [
  const Cafe(
    name: 'Freen House',
    address: 'Jl. Ahmad Yani No. 45, Madiun',
    description:
    'Kafe 24 jam yang nyaman buat nugas, meeting, atau sekadar nongkrong. '
        'WiFi cepat, colokan banyak, dan kopi yang enak.',
    imageUrl: 'https://picsum.photos/seed/freenhouse/600/400',
    rating: 4.8,
    reviewCount: 342,
    openHours: '24 Jam',
    priceRange: 'Rp 15.000 - Rp 50.000',
    categories: ['24 Jam', 'Nugas', 'WiFi Cepat'],
    latitude: -7.6298,
    longitude: 111.5239,
    menu: [
      MenuItem(
        name: 'Kopi Susu Gula Aren',
        price: 18000,
        imageUrl: 'https://picsum.photos/seed/kopisusu/200',
      ),
      MenuItem(
        name: 'Matcha Latte',
        price: 25000,
        imageUrl: 'https://picsum.photos/seed/matcha/200',
      ),
      MenuItem(
        name: 'French Fries',
        price: 15000,
        imageUrl: 'https://picsum.photos/seed/fries/200',
      ),
    ],
  ),
  const Cafe(
    name: 'The Forest Cafe',
    address: 'Jl. Raya Madiun - Ponorogo, Madiun',
    description:
    'Kafe dengan pemandangan alam hijau dan udara segar. '
        'Cocok buat healing dari hiruk pikuk kota.',
    imageUrl: 'https://picsum.photos/seed/forestcafe/600/400',
    rating: 4.7,
    reviewCount: 218,
    openHours: '10.00 - 22.00',
    priceRange: 'Rp 20.000 - Rp 60.000',
    categories: ['View Alam', 'Healing', 'Outdoor'],
    latitude: -7.6500,
    longitude: 111.5000,
    menu: [
      MenuItem(
        name: 'Americano',
        price: 20000,
        imageUrl: 'https://picsum.photos/seed/americano/200',
      ),
      MenuItem(
        name: 'Chocolate Hazelnut',
        price: 28000,
        imageUrl: 'https://picsum.photos/seed/hazelnut/200',
      ),
    ],
  ),
  const Cafe(
    name: 'Hey House',
    address: 'Jl. Pahlawan No. 12, Madiun',
    description:
    'Kafe estetik dengan interior modern dan spot foto instagramable. '
        'Cocok buat hangout bareng teman.',
    imageUrl: 'https://picsum.photos/seed/heyhouse/600/400',
    rating: 4.6,
    reviewCount: 156,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 18.000 - Rp 55.000',
    categories: ['Estetik', 'Instagramable', 'Indoor'],
    latitude: -7.6300,
    longitude: 111.5200,
    menu: [
      MenuItem(
        name: 'Es Kopi Susu',
        price: 18000,
        imageUrl: 'https://picsum.photos/seed/eskopi/200',
      ),
      MenuItem(
        name: 'Red Velvet Latte',
        price: 30000,
        imageUrl: 'https://picsum.photos/seed/redvelvet/200',
      ),
    ],
  ),
  const Cafe(
    name: 'Karpen Coffee',
    address: 'Jl. Diponegoro No. 78, Madiun',
    description:
    'Suasana hijau dengan tanaman yang rimbun. Tempat santai untuk '
        'menikmati kopi sambil membaca buku.',
    imageUrl: 'https://picsum.photos/seed/karpen/600/400',
    rating: 4.5,
    reviewCount: 98,
    openHours: '11.00 - 22.00',
    priceRange: 'Rp 15.000 - Rp 45.000',
    categories: ['View Alam', 'Tenang', 'Baca Buku'],
    latitude: -7.6250,
    longitude: 111.5150,
    menu: [
      MenuItem(
        name: 'Espresso',
        price: 15000,
        imageUrl: 'https://picsum.photos/seed/espresso/200',
      ),
      MenuItem(
        name: 'Cappuccino',
        price: 22000,
        imageUrl: 'https://picsum.photos/seed/cappuccino/200',
      ),
    ],
  ),
  const Cafe(
    name: 'Gulali Coffee',
    address: 'Jl. Cokroaminoto No. 33, Madiun',
    description:
    'Kafe dengan interior unik dan vintage. Sering jadi tempat '
        'workshop dan komunitas kreatif Madiun.',
    imageUrl: 'https://picsum.photos/seed/gulali/600/400',
    rating: 4.6,
    reviewCount: 127,
    openHours: '10.00 - 23.00',
    priceRange: 'Rp 17.000 - Rp 50.000',
    categories: ['Vintage', 'Komunitas', 'Workshop'],
    latitude: -7.6280,
    longitude: 111.5240,
    menu: [
      MenuItem(
        name: 'Kopi Tubruk',
        price: 12000,
        imageUrl: 'https://picsum.photos/seed/tubruk/200',
      ),
      MenuItem(
        name: 'Cafe Latte',
        price: 24000,
        imageUrl: 'https://picsum.photos/seed/cafelatte/200',
      ),
    ],
  ),
  const Cafe(
    name: 'Kopi Kita',
    address: 'Jl. Sumatra No. 21, Madiun',
    description:
    'Kafe dengan harga terjangkau dan tempat luas. Cocok buat '
        'nongkrong bareng teman atau keluarga.',
    imageUrl: 'https://picsum.photos/seed/kopikita/600/400',
    rating: 4.4,
    reviewCount: 189,
    openHours: '08.00 - 24.00',
    priceRange: 'Rp 10.000 - Rp 40.000',
    categories: ['Murah', 'Luas', 'Keluarga'],
    latitude: -7.6320,
    longitude: 111.5220,
    menu: [
      MenuItem(
        name: 'Kopi Hitam',
        price: 10000,
        imageUrl: 'https://picsum.photos/seed/kopihitam/200',
      ),
      MenuItem(
        name: 'Es Teh Manis',
        price: 8000,
        imageUrl: 'https://picsum.photos/seed/esteh/200',
      ),
    ],
  ),
];

// ============================================
// 4 PROMO UNTUK CAROUSEL
// ============================================
final List<Promo> dummyPromos = [
  const Promo(
    title: 'Diskon 30%',
    subtitle: 'Kopi Susu Gula Aren',
    imageUrl: 'https://picsum.photos/seed/promo1/800/400',
    cafeName: 'Freen House',
  ),
  const Promo(
    title: 'Beli 1 Gratis 1',
    subtitle: 'Semua Varian Latte',
    imageUrl: 'https://picsum.photos/seed/promo2/800/400',
    cafeName: 'Hey House',
  ),
  const Promo(
    title: 'Paket Nugas',
    subtitle: 'Kopi + Snack Rp 25.000',
    imageUrl: 'https://picsum.photos/seed/promo3/800/400',
    cafeName: 'Karpen Coffee',
  ),
  const Promo(
    title: 'Happy Hour',
    subtitle: 'Diskon 20% jam 3-5 sore',
    imageUrl: 'https://picsum.photos/seed/promo4/800/400',
    cafeName: 'The Forest Cafe',
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