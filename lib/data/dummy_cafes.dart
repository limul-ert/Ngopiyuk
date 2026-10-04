import '../models/cafe.dart';

// ============================================
// 20 CAFE REAL MADIUN — dengan 5 menu per cafe
// ============================================
final List<Cafe> dummyCafes = [
  // ============ 🌿 KATEGORI ALAM & ASRI ============

  // 1. THE FOREST CAFE & D'ARBORETUM
  const Cafe(
    name: "The Forest Cafe & D'Arboretum",
    address: 'Jl. Rimba Karya, Kartoharjo, Madiun',
    description:
    'Suasana rimbun di tengah hutan kota Perhutani. Tempat sempurna '
        'buat healing dan menikmati kopi dengan udara segar.',
    imageUrl: 'https://picsum.photos/seed/forestcafe/600/400',
    rating: 4.8,
    reviewCount: 287,
    openHours: '08.00 - 21.00',
    priceRange: 'Rp 18.000 - Rp 25.000',
    categories: ['Alam', 'Healing', 'Outdoor'],
    latitude: -7.6350,
    longitude: 111.5150,
    menu: [
      MenuItem(name: 'Forest Signatures', price: 20000,
          imageUrl: 'https://picsum.photos/seed/forestsig/200'),
      MenuItem(name: 'Matcha Green Tea Latte', price: 22000,
          imageUrl: 'https://picsum.photos/seed/matchagreen/200'),
      MenuItem(name: 'Avocado Coffee', price: 25000,
          imageUrl: 'https://picsum.photos/seed/avocoffee/200'),
      MenuItem(name: 'Lychee Ice Tea', price: 18000,
          imageUrl: 'https://picsum.photos/seed/lycheetea/200'),
      MenuItem(name: 'Taro Latte', price: 20000,
          imageUrl: 'https://picsum.photos/seed/tarolatte/200'),
    ],
  ),

  // 2. SEA COFFEE
  const Cafe(
    name: 'Sea Coffee',
    address: 'Jl. Diponegoro (Area Cagar Budaya Bosbow), Manguharjo',
    description:
    'Konsep rustic-natural dipenuhi tanaman hijau dan kolam. '
        'Nikmati kopi dengan suasana alam yang menenangkan.',
    imageUrl: 'https://picsum.photos/seed/seacoffee/600/400',
    rating: 4.7,
    reviewCount: 213,
    openHours: '08.00 - 24.00',
    priceRange: 'Rp 20.000 - Rp 25.000',
    categories: ['Alam', 'Rustic', 'Outdoor'],
    latitude: -7.6240,
    longitude: 111.5180,
    menu: [
      MenuItem(name: 'Sea Salt Latte', price: 25000,
          imageUrl: 'https://picsum.photos/seed/seasalt/200'),
      MenuItem(name: 'Es Kopi Bosbow', price: 20000,
          imageUrl: 'https://picsum.photos/seed/eskopibos/200'),
      MenuItem(name: 'Berry Blossom', price: 22000,
          imageUrl: 'https://picsum.photos/seed/berryblossom/200'),
      MenuItem(name: 'Cappuccino Warm', price: 22000,
          imageUrl: 'https://picsum.photos/seed/cappwarm/200'),
      MenuItem(name: 'Choco Hazelnut', price: 24000,
          imageUrl: 'https://picsum.photos/seed/chocohazel/200'),
    ],
  ),

  // 3. SIBITREM MADIUN
  const Cafe(
    name: 'Sibitrem Madiun',
    address: 'Jl. Rimba Karya, Kartoharjo, Madiun',
    description:
    'Area outdoor rindang di kawasan Perhutani. Adem, tenang, '
        'dan cocok buat bersantai jauh dari hiruk pikuk kota.',
    imageUrl: 'https://picsum.photos/seed/sibitrem/600/400',
    rating: 4.6,
    reviewCount: 156,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 12.000 - Rp 20.000',
    categories: ['Alam', 'Tenang', 'Outdoor'],
    latitude: -7.6360,
    longitude: 111.5145,
    menu: [
      MenuItem(name: 'Kopi Susu Sibitrem', price: 18000,
          imageUrl: 'https://picsum.photos/seed/kopisibitrem/200'),
      MenuItem(name: 'Mango Smoothies', price: 20000,
          imageUrl: 'https://picsum.photos/seed/mangosmooth/200'),
      MenuItem(name: 'Lemon Tea Fresh', price: 12000,
          imageUrl: 'https://picsum.photos/seed/lemontea/200'),
      MenuItem(name: 'Mocaccino Ice', price: 20000,
          imageUrl: 'https://picsum.photos/seed/mocaccino/200'),
      MenuItem(name: 'Red Velvet Ice', price: 20000,
          imageUrl: 'https://picsum.photos/seed/redvelvetice/200'),
    ],
  ),

  // 4. THE CEMILAND
  const Cafe(
    name: 'The Cemiland',
    address: 'Jl. Serayu Timur, Pandean, Taman, Madiun',
    description:
    'Menyuguhkan pemandangan sawah hijau yang sejuk. Cocok buat '
        'menikmati senja sambil ngemil dan ngopi santai.',
    imageUrl: 'https://picsum.photos/seed/cemiland/600/400',
    rating: 4.5,
    reviewCount: 178,
    openHours: '10.00 - 22.00',
    priceRange: 'Rp 15.000 - Rp 18.000',
    categories: ['Alam', 'Sawah', 'Healing'],
    latitude: -7.6420,
    longitude: 111.5320,
    menu: [
      MenuItem(name: 'Kopi Sawah', price: 18000,
          imageUrl: 'https://picsum.photos/seed/kopisawah/200'),
      MenuItem(name: 'Es Kelapa Muda Jeruk', price: 15000,
          imageUrl: 'https://picsum.photos/seed/eskelapajeruk/200'),
      MenuItem(name: 'Cokelat Klasik Cold', price: 18000,
          imageUrl: 'https://picsum.photos/seed/coklatklasik/200'),
      MenuItem(name: 'Strawberry Sparkle', price: 18000,
          imageUrl: 'https://picsum.photos/seed/strawsparkle/200'),
      MenuItem(name: 'Teh Tarik Aceh', price: 15000,
          imageUrl: 'https://picsum.photos/seed/tehtarik/200'),
    ],
  ),

  // 5. WARUNG SETASIYUN KAWAK
  const Cafe(
    name: 'Warung Setasiyun Kawak',
    address: 'Jl. Setasiyun Kawak, Madiun',
    description:
    'Momen ngopi santai di tepi perlintasan kereta dengan view sawah. '
        'Suasana tradisional yang bikin kangen kampung halaman.',
    imageUrl: 'https://picsum.photos/seed/setasiyun/600/400',
    rating: 4.4,
    reviewCount: 134,
    openHours: '09.00 - 22.00',
    priceRange: 'Rp 8.000 - Rp 15.000',
    categories: ['Alam', 'Tradisional', 'Sawah'],
    latitude: -7.6380,
    longitude: 111.5380,
    menu: [
      MenuItem(name: 'Kopi Tubruk Kawak', price: 8000,
          imageUrl: 'https://picsum.photos/seed/kopikawak/200'),
      MenuItem(name: 'Es Vedang Jahe Sereh', price: 10000,
          imageUrl: 'https://picsum.photos/seed/vedangjahe/200'),
      MenuItem(name: 'Es Kopi Susu Tradisional', price: 12000,
          imageUrl: 'https://picsum.photos/seed/eskopitrad/200'),
      MenuItem(name: 'Es Cucur / Es Cendol', price: 12000,
          imageUrl: 'https://picsum.photos/seed/escendol/200'),
      MenuItem(name: 'Susu Telur Bebek (STMJ)', price: 15000,
          imageUrl: 'https://picsum.photos/seed/stmj/200'),
    ],
  ),

  // ============ ✨ KATEGORI ESTETIK & INSTAGRAMABLE ============

  // 6. PARATAMU COFFEE
  const Cafe(
    name: 'Paratamu Coffee',
    address: 'Jl. Terate, Manisan, Munggut, Wungu, Madiun',
    description:
    'Desain arsitektur modern minimalis dipadu aksen kayu asri. '
        'Setiap sudutnya instagramable banget!',
    imageUrl: 'https://picsum.photos/seed/paratamu/600/400',
    rating: 4.7,
    reviewCount: 198,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 25.000 - Rp 37.000',
    categories: ['Estetik', 'Minimalis', 'Instagramable'],
    latitude: -7.6480,
    longitude: 111.5420,
    menu: [
      MenuItem(name: 'Paratamu Aren', price: 28000,
          imageUrl: 'https://picsum.photos/seed/paratamuaren/200'),
      MenuItem(name: 'Butterscotch Latte', price: 37300,
          imageUrl: 'https://picsum.photos/seed/butterscotch/200'),
      MenuItem(name: 'Peach Blossom Tea', price: 25400,
          imageUrl: 'https://picsum.photos/seed/peachblossom/200'),
      MenuItem(name: 'Pistachio Cream Latte', price: 33900,
          imageUrl: 'https://picsum.photos/seed/pistachio/200'),
      MenuItem(name: 'Dark Chocolate', price: 30500,
          imageUrl: 'https://picsum.photos/seed/darkchoco/200'),
    ],
  ),

  // 7. WAROENG LATTE
  const Cafe(
    name: 'Waroeng Latte',
    address: 'Jl. H.O.S. Cokroaminoto, Taman, Madiun',
    description:
    'Kafe dengan atap penuh tumbuhan rambat warna-warni. '
        'Cocok buat foto-foto estetik dan santai sore.',
    imageUrl: 'https://picsum.photos/seed/waroenglatte/600/400',
    rating: 4.6,
    reviewCount: 224,
    openHours: '11.00 - 23.00',
    priceRange: 'Rp 20.000 - Rp 28.000',
    categories: ['Estetik', 'Instagramable', 'Indoor'],
    latitude: -7.6280,
    longitude: 111.5270,
    menu: [
      MenuItem(name: 'Caramel Macchiato', price: 28000,
          imageUrl: 'https://picsum.photos/seed/caramelmac/200'),
      MenuItem(name: 'Hazelnut Coffee Latte', price: 26000,
          imageUrl: 'https://picsum.photos/seed/hazelnutlatte/200'),
      MenuItem(name: 'Greentea Ice Cream Shake', price: 28000,
          imageUrl: 'https://picsum.photos/seed/greenteashake/200'),
      MenuItem(name: 'Blue Citrus Soda', price: 22000,
          imageUrl: 'https://picsum.photos/seed/bluecitrus/200'),
      MenuItem(name: 'Americano On Ice', price: 20000,
          imageUrl: 'https://picsum.photos/seed/americanoice/200'),
    ],
  ),

  // 8. HYANG THE LOCAL FINEST
  const Cafe(
    name: 'Hyang The Local Finest',
    address: 'Jl. Terate, Munggut, Madiun',
    description:
    'Perpaduan gaya minimalis modern dan sentuhan tradisional. '
        'Menyajikan hidangan lokal dengan plating premium.',
    imageUrl: 'https://picsum.photos/seed/hyang/600/400',
    rating: 4.7,
    reviewCount: 167,
    openHours: '10.00 - 22.00',
    priceRange: 'Rp 22.000 - Rp 25.000',
    categories: ['Estetik', 'Modern', 'Tradisional'],
    latitude: -7.6470,
    longitude: 111.5410,
    menu: [
      MenuItem(name: 'Hyang Signature Milk Tea', price: 22000,
          imageUrl: 'https://picsum.photos/seed/hyangsig/200'),
      MenuItem(name: 'Kopi Susu Hyang', price: 22000,
          imageUrl: 'https://picsum.photos/seed/kopihyang/200'),
      MenuItem(name: 'Artisan White Tea', price: 25000,
          imageUrl: 'https://picsum.photos/seed/whitetea/200'),
      MenuItem(name: 'Kopi Pandan', price: 24000,
          imageUrl: 'https://picsum.photos/seed/kopipandan/200'),
      MenuItem(name: 'Berry Lime Mocktail', price: 25000,
          imageUrl: 'https://picsum.photos/seed/berrylime/200'),
    ],
  ),

  // 9. DJOHN COFFEE MADIUN
  const Cafe(
    name: 'Djohn Coffee Madiun',
    address: 'Jl. Mojopahit, Mojorejo, Taman, Madiun',
    description:
    'Konsep vintage modern dengan spot foto estetik dan live music. '
        'Tempat nongkrong favorit anak muda Madiun.',
    imageUrl: 'https://picsum.photos/seed/djohn/600/400',
    rating: 4.6,
    reviewCount: 245,
    openHours: '15.00 - 23.00',
    priceRange: 'Rp 22.000 - Rp 26.000',
    categories: ['Estetik', 'Vintage', 'Live Music'],
    latitude: -7.6260,
    longitude: 111.5280,
    menu: [
      MenuItem(name: 'Djohn Signature Aren', price: 22000,
          imageUrl: 'https://picsum.photos/seed/djohnaren/200'),
      MenuItem(name: 'Rum Raisin Latte', price: 25000,
          imageUrl: 'https://picsum.photos/seed/rumraisin/200'),
      MenuItem(name: 'Matcha Espresso Fusion', price: 26000,
          imageUrl: 'https://picsum.photos/seed/matchafusion/200'),
      MenuItem(name: 'Fresh Virgin Mojito', price: 22000,
          imageUrl: 'https://picsum.photos/seed/virginmojito/200'),
      MenuItem(name: 'Choco Vanilla Milkshake', price: 25000,
          imageUrl: 'https://picsum.photos/seed/chocovanilla/200'),
    ],
  ),

  // 10. KOHAN CAFE AND EATERY
  const Cafe(
    name: 'Kohan Cafe and Eatery',
    address: 'Jl. Sulawesi No. 41, Kartoharjo, Madiun',
    description:
    'Interior kekinian bernuansa hangat dan nyaman untuk rapat atau nugas. '
        'Menu makanan lengkap dengan cita rasa tinggi.',
    imageUrl: 'https://picsum.photos/seed/kohan/600/400',
    rating: 4.5,
    reviewCount: 178,
    openHours: '10.00 - 22.00',
    priceRange: 'Rp 22.000 - Rp 26.000',
    categories: ['Estetik', 'Nugas', 'Meeting'],
    latitude: -7.6300,
    longitude: 111.5230,
    menu: [
      MenuItem(name: 'Kohan Creamy Latte', price: 24000,
          imageUrl: 'https://picsum.photos/seed/kohanlatte/200'),
      MenuItem(name: 'Salted Caramel Coffee', price: 26000,
          imageUrl: 'https://picsum.photos/seed/saltedcaramel/200'),
      MenuItem(name: 'Earl Grey Milk Tea', price: 22000,
          imageUrl: 'https://picsum.photos/seed/earlgrey/200'),
      MenuItem(name: 'Lychee Sparkling Mocktail', price: 24000,
          imageUrl: 'https://picsum.photos/seed/lycheesparkle/200'),
      MenuItem(name: 'Vanilla Milk Ice', price: 22000,
          imageUrl: 'https://picsum.photos/seed/vanillamilk/200'),
    ],
  ),

  // ============ 🪙 KATEGORI MURAH & RAMAH KANTONG ============

  // 11. WARUNG NDEMUG
  const Cafe(
    name: 'Warung Ndemug',
    address: 'Jl. Imam Bonjol No. 44, Klegen, Madiun',
    description:
    'Menu masakan rumah murah meriah dengan nuansa kayu ramah kantong. '
        'Porsi besar, harga bersahabat.',
    imageUrl: 'https://picsum.photos/seed/ndemug/600/400',
    rating: 4.4,
    reviewCount: 189,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 5.000 - Rp 12.000',
    categories: ['Murah', 'Masakan Rumah', 'Tradisional'],
    latitude: -7.6330,
    longitude: 111.5260,
    menu: [
      MenuItem(name: 'Es Kopi Susu Ndemug', price: 12000,
          imageUrl: 'https://picsum.photos/seed/eskopindemug/200'),
      MenuItem(name: 'Es Teh Kampul', price: 6000,
          imageUrl: 'https://picsum.photos/seed/estehkampul/200'),
      MenuItem(name: 'Es Nutrisari Jeruk', price: 5000,
          imageUrl: 'https://picsum.photos/seed/nutrisari/200'),
      MenuItem(name: 'Kopi Hitam Cangkir', price: 5000,
          imageUrl: 'https://picsum.photos/seed/kopihitamcangkir/200'),
      MenuItem(name: 'Susu Kedelai', price: 7000,
          imageUrl: 'https://picsum.photos/seed/susukedelai/200'),
    ],
  ),

  // 12. JIERO WEDANGAN
  const Cafe(
    name: 'Jiero Wedangan',
    address: 'Jl. Bali No. 17, Kartoharjo, Madiun',
    description:
    'Konsep angkringan-kedai modern dengan variasi minuman murah. '
        'Suasana santai cocok buat cerita panjang.',
    imageUrl: 'https://picsum.photos/seed/jiero/600/400',
    rating: 4.3,
    reviewCount: 145,
    openHours: '10.00 - 23.00',
    priceRange: 'Rp 6.000 - Rp 12.000',
    categories: ['Murah', 'Angkringan', 'Nongkrong'],
    latitude: -7.6295,
    longitude: 111.5210,
    menu: [
      MenuItem(name: 'Wedang Uwuh', price: 8000,
          imageUrl: 'https://picsum.photos/seed/wedanguwuh/200'),
      MenuItem(name: 'Es Wedang Ronde', price: 12000,
          imageUrl: 'https://picsum.photos/seed/eskopirond/200'),
      MenuItem(name: 'Es Susu Cokelat', price: 10000,
          imageUrl: 'https://picsum.photos/seed/esusucoklat/200'),
      MenuItem(name: 'Kopi Joss', price: 8000,
          imageUrl: 'https://picsum.photos/seed/kopijoss/200'),
      MenuItem(name: 'Teh Manis Jumbo', price: 6000,
          imageUrl: 'https://picsum.photos/seed/tehmanisjumbo/200'),
    ],
  ),

  // 13. ANGKRINGAN RUTE 57
  const Cafe(
    name: 'Angkringan Rute 57',
    address: 'Jl. Mayjen Sungkono, Nambangan Kidul, Madiun',
    description:
    'Perpaduan angkringan tradisional dan tempat nongkrong kekinian. '
        'Buka sampai tengah malam, harga tetap ramah.',
    imageUrl: 'https://picsum.photos/seed/rute57/600/400',
    rating: 4.4,
    reviewCount: 167,
    openHours: '16.00 - 00.00',
    priceRange: 'Rp 8.000 - Rp 10.000',
    categories: ['Murah', 'Angkringan', 'Malam'],
    latitude: -7.6210,
    longitude: 111.5240,
    menu: [
      MenuItem(name: 'Es Kopi Jos', price: 8000,
          imageUrl: 'https://picsum.photos/seed/eskopijos/200'),
      MenuItem(name: 'Es Susu Jahe', price: 10000,
          imageUrl: 'https://picsum.photos/seed/esusujahe/200'),
      MenuItem(name: 'Teh Tarik Ice', price: 10000,
          imageUrl: 'https://picsum.photos/seed/tehtarikice/200'),
      MenuItem(name: 'Wedang Sereh Lemon', price: 8000,
          imageUrl: 'https://picsum.photos/seed/serehlemon/200'),
      MenuItem(name: 'Es Good Day Freeze', price: 8000,
          imageUrl: 'https://picsum.photos/seed/goodday/200'),
    ],
  ),

  // 14. CAFE UPSIDE DOWN
  const Cafe(
    name: 'Cafe Upside Down',
    address: 'Jl. Taman Praja No. 26, Taman, Madiun',
    description:
    'Area outdoor bean bag santai dengan harga ramah mahasiswa. '
        'Tempat rebahan sambil ngopi dan nonton langit.',
    imageUrl: 'https://picsum.photos/seed/upsidedown/600/400',
    rating: 4.5,
    reviewCount: 198,
    openHours: '10.00 - 22.00',
    priceRange: 'Rp 10.000 - Rp 15.000',
    categories: ['Murah', 'Outdoor', 'Santai'],
    latitude: -7.6255,
    longitude: 111.5290,
    menu: [
      MenuItem(name: 'Iced Mochaccino Murah', price: 15000,
          imageUrl: 'https://picsum.photos/seed/mochamurah/200'),
      MenuItem(name: 'Thai Tea Ice', price: 12000,
          imageUrl: 'https://picsum.photos/seed/thaiteaice/200'),
      MenuItem(name: 'Taro Ice Boba', price: 15000,
          imageUrl: 'https://picsum.photos/seed/taroboba/200'),
      MenuItem(name: 'Strawberry Tea', price: 10000,
          imageUrl: 'https://picsum.photos/seed/strawtea/200'),
      MenuItem(name: 'Kopi Susu Tubruk', price: 10000,
          imageUrl: 'https://picsum.photos/seed/kopitubruk/200'),
    ],
  ),

  // 15. SOCIAL CAFE MADIUN
  const Cafe(
    name: 'Social Cafe Madiun',
    address: 'Jl. Pahlawan (Area Malioboro Madiun)',
    description:
    'Terkenal dengan menu porsi besar dan harga terjangkau. '
        'Tempat kumpul favorit komunitas dan mahasiswa.',
    imageUrl: 'https://picsum.photos/seed/socialcafe/600/400',
    rating: 4.4,
    reviewCount: 234,
    openHours: '10.00 - 23.00',
    priceRange: 'Rp 10.000 - Rp 16.000',
    categories: ['Murah', 'Porsi Besar', 'Komunitas'],
    latitude: -7.6270,
    longitude: 111.5225,
    menu: [
      MenuItem(name: 'Social Signature Ice Coffee', price: 15000,
          imageUrl: 'https://picsum.photos/seed/socialsig/200'),
      MenuItem(name: 'Milky Squash Melon', price: 14000,
          imageUrl: 'https://picsum.photos/seed/milkysquash/200'),
      MenuItem(name: 'Iced Lemon Tea Jumbo', price: 10000,
          imageUrl: 'https://picsum.photos/seed/lemonteajumbo/200'),
      MenuItem(name: 'Chocolate Ice Blend', price: 16000,
          imageUrl: 'https://picsum.photos/seed/chocoblend/200'),
      MenuItem(name: 'Cappuccino Ice', price: 15000,
          imageUrl: 'https://picsum.photos/seed/cappice/200'),
    ],
  ),

  // ============ ⏰ KATEGORI BUKA 24 JAM ============

  // 16. FREEN HOUSE
  const Cafe(
    name: 'Freen House',
    address: 'Jl. Ahmad Yani No. 45, Madiun',
    description:
    'Kafe estetik 24 jam dengan Wi-Fi cepat, nyaman untuk working space. '
        'Colokan banyak dan kopi yang enak.',
    imageUrl: 'https://picsum.photos/seed/freenhouse/600/400',
    rating: 4.8,
    reviewCount: 342,
    openHours: '24 Jam',
    priceRange: 'Rp 18.000 - Rp 24.000',
    categories: ['24 Jam', 'Nugas', 'WiFi Cepat'],
    latitude: -7.6298,
    longitude: 111.5239,
    menu: [
      MenuItem(name: 'Freen Signature Iced Coffee', price: 20000,
          imageUrl: 'https://picsum.photos/seed/freensig/200'),
      MenuItem(name: 'V60 Manual Brew', price: 22000,
          imageUrl: 'https://picsum.photos/seed/v60/200'),
      MenuItem(name: 'Choco Creamy Late', price: 22000,
          imageUrl: 'https://picsum.photos/seed/chocoreamy/200'),
      MenuItem(name: 'Matcha Cold Foam', price: 24000,
          imageUrl: 'https://picsum.photos/seed/matchacold/200'),
      MenuItem(name: 'Americano Cold', price: 18000,
          imageUrl: 'https://picsum.photos/seed/americancold/200'),
    ],
  ),

  // 17. MIDNIGHT COFFEE CORNER
  const Cafe(
    name: 'Midnight Coffee Corner',
    address: 'Jl. Biliton No. 10, Kartoharjo, Madiun',
    description:
    'Coffee shop minimalis favorit anak muda buat nugas sampai pagi. '
        'Buka 24 jam, cocok buat begadang.',
    imageUrl: 'https://picsum.photos/seed/midnight/600/400',
    rating: 4.6,
    reviewCount: 189,
    openHours: '24 Jam',
    priceRange: 'Rp 18.000 - Rp 22.000',
    categories: ['24 Jam', 'Nugas', 'Minimalis'],
    latitude: -7.6310,
    longitude: 111.5245,
    menu: [
      MenuItem(name: 'Midnight Strong Coffee', price: 18000,
          imageUrl: 'https://picsum.photos/seed/midstrong/200'),
      MenuItem(name: 'Iced Caramel Coffee', price: 20000,
          imageUrl: 'https://picsum.photos/seed/caramelcoffee/200'),
      MenuItem(name: 'Red Velvet Cream', price: 20000,
          imageUrl: 'https://picsum.photos/seed/redvelvetcream/200'),
      MenuItem(name: 'Green Tea Latte', price: 20000,
          imageUrl: 'https://picsum.photos/seed/greenlatte/200'),
      MenuItem(name: 'Fresh Watermelon Mojito', price: 22000,
          imageUrl: 'https://picsum.photos/seed/watermelonmoj/200'),
    ],
  ),

  // 18. TOMORO COFFEE - MADIUN STATION
  const Cafe(
    name: 'Tomoro Coffee - Madiun Station',
    address: 'Jl. Kompol Sunaryo No. 14 (Depan Stasiun Madiun)',
    description:
    'Modern coffee shop dekat stasiun dengan colokan melimpah. '
        'Buka 24 jam, cocok buat nunggu kereta atau WFC.',
    imageUrl: 'https://picsum.photos/seed/tomoro/600/400',
    rating: 4.5,
    reviewCount: 267,
    openHours: '24 Jam',
    priceRange: 'Rp 12.000 - Rp 28.000',
    categories: ['24 Jam', 'Modern', 'Nugas'],
    latitude: -7.6180,
    longitude: 111.5250,
    menu: [
      MenuItem(name: 'Tomoro Aren Latte', price: 18000,
          imageUrl: 'https://picsum.photos/seed/tomoroaren/200'),
      MenuItem(name: 'Tomoro Coconut Latte', price: 20000,
          imageUrl: 'https://picsum.photos/seed/coconutlatte/200'),
      MenuItem(name: 'Oatside Butterscotch Latte', price: 28000,
          imageUrl: 'https://picsum.photos/seed/oatside/200'),
      MenuItem(name: 'Caffe Americano', price: 15000,
          imageUrl: 'https://picsum.photos/seed/caffeamer/200'),
      MenuItem(name: 'Pink Pop Lemonade', price: 12000,
          imageUrl: 'https://picsum.photos/seed/pinkpop/200'),
    ],
  ),

  // 19. ANGKRINGAN A24
  const Cafe(
    name: 'Angkringan A24',
    address: 'Area Pom Bensin Nambangan Lor, Madiun',
    description:
    'Tempat nongkrong santai dengan menu angkringan murah meriah. '
        'Buka 24 jam, cocok buat nongkrong kapan aja.',
    imageUrl: 'https://picsum.photos/seed/angkringana24/600/400',
    rating: 4.3,
    reviewCount: 156,
    openHours: '24 Jam',
    priceRange: 'Rp 5.000 - Rp 8.000',
    categories: ['24 Jam', 'Murah', 'Angkringan'],
    latitude: -7.6150,
    longitude: 111.5220,
    menu: [
      MenuItem(name: 'Kopi Hitam Cangkir A24', price: 5000,
          imageUrl: 'https://picsum.photos/seed/kopia24/200'),
      MenuItem(name: 'Wedang Jahe Geprek', price: 7000,
          imageUrl: 'https://picsum.photos/seed/jahegeprek/200'),
      MenuItem(name: 'Es Extra Joss Susu', price: 8000,
          imageUrl: 'https://picsum.photos/seed/extrajoss/200'),
      MenuItem(name: 'Teh Tubruk Manis', price: 5000,
          imageUrl: 'https://picsum.photos/seed/tehtubruk/200'),
      MenuItem(name: 'Susu Putih / Cokelat Panas', price: 7000,
          imageUrl: 'https://picsum.photos/seed/susupanas/200'),
    ],
  ),

  // 20. ANGKRINGAN KARTU
  const Cafe(
    name: 'Angkringan Kartu',
    address: 'Selatan Lapangan Gulun, Kartoharjo, Madiun',
    description:
    'Tempat lesehan favorit anak muda untuk ngobrol santai hingga '
        'larut malam. Suasana hangat khas angkringan.',
    imageUrl: 'https://picsum.photos/seed/angkringankartu/600/400',
    rating: 4.4,
    reviewCount: 178,
    openHours: '24 Jam',
    priceRange: 'Rp 4.000 - Rp 8.000',
    categories: ['24 Jam', 'Murah', 'Lesehan'],
    latitude: -7.6265,
    longitude: 111.5235,
    menu: [
      MenuItem(name: 'Kopi Jos Arang', price: 7000,
          imageUrl: 'https://picsum.photos/seed/kopijosarang/200'),
      MenuItem(name: 'Wedang Rempah Kartu', price: 8000,
          imageUrl: 'https://picsum.photos/seed/wedangrempah/200'),
      MenuItem(name: 'Es Teh Manis Mantap', price: 4000,
          imageUrl: 'https://picsum.photos/seed/estehmantap/200'),
      MenuItem(name: 'Susu Jahe Merah', price: 8000,
          imageUrl: 'https://picsum.photos/seed/susujahemerah/200'),
      MenuItem(name: 'Es Kopi Susu Sederhana', price: 8000,
          imageUrl: 'https://picsum.photos/seed/eskopisederhana/200'),
    ],
  ),
];

// ============================================
// 4 PROMO UNTUK CAROUSEL
// ============================================
final List<Promo> dummyPromos = [
  const Promo(
    title: 'Diskon 30%',
    subtitle: 'Freen Signature Iced Coffee',
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
    cafeName: 'Midnight Coffee Corner',
  ),
  const Promo(
    title: 'Happy Hour',
    subtitle: 'Diskon 20% jam 3-5 sore',
    imageUrl: 'https://picsum.photos/seed/promo4/800/400',
    cafeName: "The Forest Cafe & D'Arboretum",
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