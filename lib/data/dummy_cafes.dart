import '../models/cafe.dart';

// ============================================
// 10 CAFE REAL MADIUN — 15 menu per cafe
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
    imageUrl: 'https://picsum.photos/seed/seacoffee/600/400',
    rating: 4.7,
    reviewCount: 213,
    openHours: '08.00 - 24.00',
    priceRange: 'Rp 18.000 - Rp 30.000',
    categories: ['Alam', 'Rustic', 'Outdoor'],
    latitude: -7.6240,
    longitude: 111.5180,
    menu: [
      MenuItem(name: 'Sea Salt Latte', price: 25000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/seasalt/200'),
      MenuItem(name: 'Es Kopi Bosbow', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/eskopibos/200'),
      MenuItem(name: 'Berry Blossom', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/berryblossom/200'),
      MenuItem(name: 'Cappuccino', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/cappwarm/200'),
      MenuItem(name: 'Choco Hazelnut', price: 24000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/chocohazel/200'),
      MenuItem(name: 'Nasi Goreng Sea Special', price: 28000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorsea/200'),
      MenuItem(name: 'Rice Bowl Chicken Teriyaki', price: 27000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlteri/200'),
      MenuItem(name: 'Spaghetti Carbonara', price: 30000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/spagcarbonara/200'),
      MenuItem(name: 'Chicken Katsu Curry', price: 29000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/katsucurry/200'),
      MenuItem(name: 'Mie Goreng Jawa', price: 23000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/miegorengjawa/200'),
      MenuItem(name: 'French Fries', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/fries/200'),
      MenuItem(name: 'Mix Platter', price: 25000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/mixplatter/200'),
      MenuItem(name: 'Cireng Bumbu Rujak', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/cirengrujak/200'),
      MenuItem(name: 'Potato Wedges', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/potatowedges/200'),
      MenuItem(name: 'Churros Dip Chocolate', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/churros/200'),
    ],
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
    imageUrl: 'https://picsum.photos/seed/hollycafe/600/400',
    rating: 4.6,
    reviewCount: 178,
    openHours: '09.00 - 22.00',
    priceRange: 'Rp 15.000 - Rp 32.000',
    categories: ['Alam', 'Healing', 'Outdoor'],
    latitude: -7.6360,
    longitude: 111.5145,
    menu: [
      MenuItem(name: 'Holly Signature Coffee', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/hollysig/200'),
      MenuItem(name: 'Matcha Green Tea', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/matchagreen/200'),
      MenuItem(name: 'Peach Tea', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/peachtea/200'),
      MenuItem(name: 'Cafe Latte', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/cafelatte/200'),
      MenuItem(name: 'Chocolate Ice', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/chocoice/200'),
      MenuItem(name: 'Nasi Goreng Rempah', price: 25000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorrempah/200'),
      MenuItem(name: 'Rice Bowl Sambal Matah', price: 26000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlsambal/200'),
      MenuItem(name: 'Spaghetti Aglio Olio', price: 28000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/spagaglio/200'),
      MenuItem(name: 'Beef Blackpepper Rice', price: 32000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/beefblack/200'),
      MenuItem(name: 'Mie Nyemek Holly', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/mienyemek/200'),
      MenuItem(name: 'Tahu Cabe Garam', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/tahucabe/200'),
      MenuItem(name: 'Singkong Goreng Keju', price: 15000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/singkongkeju/200'),
      MenuItem(name: 'French Fries & Sausage', price: 22000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/friesausage/200'),
      MenuItem(name: 'Pisang Goreng Karamel', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/pisangkaramel/200'),
      MenuItem(name: 'Onion Rings', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/onionrings/200'),
    ],
  ),

  // ============ 3. PARATAMU COFFEE ============  ← ✅ UBAH
  const Cafe(
    name: 'Paratamu Coffee',
    address:
    'Jl. Terate No. 55, Munggut, Kec. Wungu, Kabupaten Madiun, Jawa Timur 63181',
    phone: '0813-5789-0123',
    description:
    'Desain arsitektur modern minimalis dipadu aksen kayu asri. '
        'Setiap sudutnya instagramable banget!',
    imageUrl: 'assets/images/cafe/paratamu.png', // ← ✅ UBAH
    rating: 4.7,
    reviewCount: 198,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 20.000 - Rp 42.000',
    categories: ['Estetik', 'Minimalis', 'Instagramable'],
    latitude: -7.6480,
    longitude: 111.5420,
    menu: [
      MenuItem(name: 'Paratamu Aren', price: 28000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/paratamuaren/200'),
      MenuItem(name: 'Butterscotch Latte', price: 37300, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/butterscotch/200'),
      MenuItem(name: 'Peach Blossom Tea', price: 25400, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/peachblossom/200'),
      MenuItem(name: 'Pistachio Cream Latte', price: 33900, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/pistachio/200'),
      MenuItem(name: 'Dark Chocolate', price: 30500, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/darkchoco/200'),
      MenuItem(name: 'Nasi Daging Sapi Lada Hitam', price: 38000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasdaginglada/200'),
      MenuItem(name: 'Chicken Steak Creamy Sauce', price: 42000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/chickensteak/200'),
      MenuItem(name: 'Spaghetti Bolognese', price: 35000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/spagbolo/200'),
      MenuItem(name: 'Nasi Goreng Kecombrang', price: 32000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorkecom/200'),
      MenuItem(name: 'Rice Bowl Chicken Salted Egg', price: 36000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlsalted/200'),
      MenuItem(name: 'Croissant Butter', price: 22000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/croissantbutter/200'),
      MenuItem(name: 'Truffle Fries', price: 25000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/trufflefries/200'),
      MenuItem(name: 'Cinnamon Roll', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/cinnamonroll/200'),
      MenuItem(name: 'Chicken Wings BBQ', price: 28000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/wingsbbq/200'),
      MenuItem(name: 'Nachos Cheese Dip', price: 26000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/nachos/200'),
    ],
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
    imageUrl: 'https://picsum.photos/seed/hakuicoffee/600/400',
    rating: 4.5,
    reviewCount: 156,
    openHours: '10.00 - 23.00',
    priceRange: 'Rp 18.000 - Rp 38.000',
    categories: ['Estetik', 'Instagramable', 'Indoor'],
    latitude: -7.6355,
    longitude: 111.5230,
    menu: [
      MenuItem(name: 'Hakui White Cold Brew', price: 26000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/hakuiwhite/200'),
      MenuItem(name: 'Dirty Matcha', price: 28000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/dirtymatcha/200'),
      MenuItem(name: 'Spanish Latte', price: 27000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/spanishlatte/200'),
      MenuItem(name: 'Berry Lemonade', price: 24000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/berrylemonade/200'),
      MenuItem(name: 'Americano Ice', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/americanoice/200'),
      MenuItem(name: 'Chicken Nanban Rice Bowl', price: 32000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nanban/200'),
      MenuItem(name: 'Nasi Goreng Hakui', price: 28000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorhakui/200'),
      MenuItem(name: 'Pasta Creamy Mushroom', price: 34000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/pastamushroom/200'),
      MenuItem(name: 'Gyudon Beef Rice Bowl', price: 38000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/gyudon/200'),
      MenuItem(name: 'Katsu Curry Rice', price: 35000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/katsucurryrice/200'),
      MenuItem(name: 'Gyoza Crispy', price: 22000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/gyoza/200'),
      MenuItem(name: 'French Fries Cheese', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/friescheese/200'),
      MenuItem(name: 'Waffle Ice Cream', price: 24000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/waffleice/200'),
      MenuItem(name: 'Risoles Mayo (3 pcs)', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/risolesmayo/200'),
      MenuItem(name: 'Garlic Bread', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/garlicbread/200'),
    ],
  ),

  // ============ 5. WAROENG LATTE ============  ← ✅ UBAH
  const Cafe(
    name: 'Waroeng Latte',
    address:
    'Jl. H.O.S. Cokroaminoto No. 88, Josenan, Kec. Taman, Kota Madiun, Jawa Timur 63131',
    phone: '0857-1234-5678',
    description:
    'Kafe dengan atap penuh tumbuhan rambat warna-warni. '
        'Cocok buat foto-foto estetik dan santai sore dengan harga terjangkau.',
    imageUrl: 'assets/images/cafe/warung_latte.jpg', // ← ✅ UBAH
    rating: 4.6,
    reviewCount: 224,
    openHours: '11.00 - 23.00',
    priceRange: 'Rp 12.000 - Rp 28.000',
    categories: ['Murah'],
    latitude: -7.6280,
    longitude: 111.5270,
    menu: [
      MenuItem(name: 'Caramel Macchiato', price: 28000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/caramelmac/200'),
      MenuItem(name: 'Hazelnut Coffee Latte', price: 26000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/hazelnutlatte/200'),
      MenuItem(name: 'Greentea Ice Cream Shake', price: 28000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/greenteashake/200'),
      MenuItem(name: 'Blue Citrus Soda', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/bluecitrus/200'),
      MenuItem(name: 'Americano On Ice', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/americanoice2/200'),
      MenuItem(name: 'Nasi Goreng Spesial', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorsp/200'),
      MenuItem(name: 'Chicken Rice Bowl Teriyaki', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/chickenteri/200'),
      MenuItem(name: 'Mie Goreng Telur', price: 18000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/miegorengtelur/200'),
      MenuItem(name: 'Nasi Ayam Geprek', price: 20000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ayamgeprek/200'),
      MenuItem(name: 'Kwetiau Goreng Ayam', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/kwetiauayam/200'),
      MenuItem(name: 'Jamur Crispy', price: 14000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/jamurcrispy/200'),
      MenuItem(name: 'Tahu Crispy', price: 12000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/tahucrispy/200'),
      MenuItem(name: 'Sosis Goreng', price: 14000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/sosisgoreng/200'),
      MenuItem(name: 'French Fries', price: 15000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/fries2/200'),
      MenuItem(name: 'Roti Bakar Cokelat Keju', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/rotibakarcoklat/200'),
    ],
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
    imageUrl: 'https://picsum.photos/seed/lokatara/600/400',
    rating: 4.4,
    reviewCount: 189,
    openHours: '09.00 - 23.00',
    priceRange: 'Rp 12.000 - Rp 22.000',
    categories: ['Murah', 'Nugas', 'WiFi Cepat'],
    latitude: -7.6265,
    longitude: 111.5280,
    menu: [
      MenuItem(name: 'Es Kopi Lokatara', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/eskopiloka/200'),
      MenuItem(name: 'Taro Latte', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/tarolatte/200'),
      MenuItem(name: 'Red Velvet', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/redvelvet/200'),
      MenuItem(name: 'Thai Tea', price: 15000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/thaitea/200'),
      MenuItem(name: 'Lemon Tea Ice', price: 12000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/lemonteaice/200'),
      MenuItem(name: 'Rice Bowl Ayam Sambal Matah', price: 20000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlayam/200'),
      MenuItem(name: 'Nasi Goreng Jawa', price: 18000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorjawa/200'),
      MenuItem(name: 'Rice Bowl Egg Chicken Roll', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlegg/200'),
      MenuItem(name: 'Indomie Goreng Doppel/Jumbo', price: 15000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/indomiejumbo/200'),
      MenuItem(name: 'Nasi Ayam Blackpepper', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ayamblack/200'),
      MenuItem(name: 'Cireng Crispy', price: 12000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/cirengcrispy/200'),
      MenuItem(name: 'French Fries Original', price: 14000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/friesorig/200'),
      MenuItem(name: 'Pisang Cokelat Lumer', price: 15000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/pisangcoklat/200'),
      MenuItem(name: 'Otak-otak Goreng', price: 13000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/otakotak/200'),
      MenuItem(name: 'Nugget Goreng', price: 14000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/nugget/200'),
    ],
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
    menu: [
      MenuItem(name: 'Kopi Tubruk Brewok', price: 6000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/kopibrewok/200'),
      MenuItem(name: 'Es Kopi Susu Kampung', price: 10000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/eskopikampung/200'),
      MenuItem(name: 'Es Teh Kampul', price: 6000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/estehkampul/200'),
      MenuItem(name: 'Es Extra Joss Susu', price: 8000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/extrajoss/200'),
      MenuItem(name: 'Wedang Jahe', price: 7000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/wedangjahe/200'),
      MenuItem(name: 'Mie Instant Kornet Telur (Internet)', price: 14000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/mieinternet/200'),
      MenuItem(name: 'Nasi Oreg Tempe Telur', price: 12000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasoreg/200'),
      MenuItem(name: 'Nasi Magelangan', price: 15000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasmagelangan/200'),
      MenuItem(name: 'Nasi Ayam Geprek Sambal Bawang', price: 16000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/geprekbawang/200'),
      MenuItem(name: 'Kwetiau Kuah Telur', price: 15000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/kwetiaukuah/200'),
      MenuItem(name: 'Mendoan Anget (5 pcs)', price: 10000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/mendoan/200'),
      MenuItem(name: 'Tahu Walik', price: 12000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/tahuwalik/200'),
      MenuItem(name: 'Bakwan Jagung', price: 10000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/bakwanjagung/200'),
      MenuItem(name: 'Pisang Goreng Ori', price: 10000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/pisanggoreng/200'),
      MenuItem(name: 'Sosis Bakar Jumbo', price: 12000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/sosisbakar/200'),
    ],
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
    menu: [
      MenuItem(name: 'Tomoro Aren Latte', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/tomoroaren/200'),
      MenuItem(name: 'Tomoro Coconut Latte', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/coconutlatte/200'),
      MenuItem(name: 'Oatside Butterscotch Latte', price: 28000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/oatside/200'),
      MenuItem(name: 'Caffe Americano', price: 15000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/caffeamer/200'),
      MenuItem(name: 'Pink Pop Lemonade', price: 12000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/pinkpop/200'),
      MenuItem(name: 'Chicken Mayo Toast', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/chickenmayo/200'),
      MenuItem(name: 'Egg & Cheese Toast', price: 18000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/eggcheese/200'),
      MenuItem(name: 'Smoked Beef Cheese Toast', price: 24000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/smokedbeef/200'),
      MenuItem(name: 'Tuna Melt Toast', price: 24000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/tunamelt/200'),
      MenuItem(name: 'Beef Teriyaki Rice Bowl', price: 28000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/beefteri/200'),
      MenuItem(name: 'Butter Croissant', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/buttercrois/200'),
      MenuItem(name: 'Pain Au Chocolat', price: 22000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/painauchoc/200'),
      MenuItem(name: 'Cinnamon Roll', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/cinnamon2/200'),
      MenuItem(name: 'Chocolate Muffin', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/chocomuffin/200'),
      MenuItem(name: 'Almond Croissant', price: 25000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/almondcrois/200'),
    ],
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
    menu: [
      MenuItem(name: 'Freen Signature Coffee', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/freensig/200'),
      MenuItem(name: 'V60 Manual Brew', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/v60/200'),
      MenuItem(name: 'Choco Creamy Late', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/chocoreamy/200'),
      MenuItem(name: 'Matcha Cold Foam', price: 24000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/matchacold/200'),
      MenuItem(name: 'Americano Cold', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/americancold/200'),
      MenuItem(name: 'Nasi Goreng Freen', price: 24000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorfreen/200'),
      MenuItem(name: 'Rice Bowl Chicken Blackpepper', price: 25000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ricebowlblack/200'),
      MenuItem(name: 'Spaghetti Bolognese', price: 26000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/spagbolo2/200'),
      MenuItem(name: 'Nasi Ayam Crispy Sambal Bawang', price: 22000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ayamcrispy/200'),
      MenuItem(name: 'Mie Nyemek Freen', price: 20000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/mienyemekfreen/200'),
      MenuItem(name: 'French Fries BBQ', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/friesbbq/200'),
      MenuItem(name: 'Mix Platter', price: 24000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/mixplatter2/200'),
      MenuItem(name: 'Toast Cokelat Keju', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/toastcoklat/200'),
      MenuItem(name: 'Tahu Crispy Tabur Cabai', price: 15000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/tahucrispycabe/200'),
      MenuItem(name: 'Pancake Maple Syrup', price: 20000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/pancake/200'),
    ],
  ),

  // ============ 10. WARUNK WOW KWB ============  ← ✅ UBAH
  const Cafe(
    name: 'Warunk Wow KWB',
    address:
    'Jl. Mawar No. 12, Oro-Oro Ombo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63119',
    phone: '0812-4900-1122',
    description:
    'Warung kekinian yang buka 24 jam dengan menu variatif dan harga murah. '
        'Tempat nongkrong santai kapan pun kamu mau.',
    imageUrl: 'assets/images/cafe/wow.jpg', // ← ✅ UBAH
    rating: 4.4,
    reviewCount: 198,
    openHours: '24 Jam',
    priceRange: 'Rp 10.000 - Rp 30.000',
    categories: ['24 Jam'],
    latitude: -7.6320,
    longitude: 111.5270,
    menu: [
      MenuItem(name: 'Es Kopi Susu Wow', price: 18000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/eskopiwow/200'),
      MenuItem(name: 'Ice Taro Latte', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/icetaro/200'),
      MenuItem(name: 'Lychee Mojito', price: 22000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/lycheemojito/200'),
      MenuItem(name: 'Es Teh Manis Jumbo', price: 10000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/estehjumbo2/200'),
      MenuItem(name: 'Choco Ice Blend', price: 20000, category: 'Minuman', imageUrl: 'https://picsum.photos/seed/chocoiceblend/200'),
      MenuItem(name: 'Nasi Goreng Wow Spesial', price: 25000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/nasgorwow/200'),
      MenuItem(name: 'Nasi Ayam Bakar Madu', price: 28000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/ayambakarmadu/200'),
      MenuItem(name: 'Rice Bowl Beef Teriyaki', price: 30000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/beefteri2/200'),
      MenuItem(name: 'Mie Instant Dok-Dok', price: 18000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/miedokdok/200'),
      MenuItem(name: 'Spaghetti Aglio Olio', price: 25000, category: 'Makanan', imageUrl: 'https://picsum.photos/seed/spagaglio2/200'),
      MenuItem(name: 'Roti Bakar Milo Keju', price: 18000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/rotimilokeju/200'),
      MenuItem(name: 'Tahu Cabe Garam', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/tahucabe2/200'),
      MenuItem(name: 'French Fries', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/fries3/200'),
      MenuItem(name: 'Cireng Salju Bumbu Rujak', price: 15000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/cirengsalju/200'),
      MenuItem(name: 'Pisang Bakar Cokelat', price: 16000, category: 'Snack', imageUrl: 'https://picsum.photos/seed/pisangbakar/200'),
    ],
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