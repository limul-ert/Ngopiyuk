
class Cafe {
  final String? id;
  final String name;
  final String address;
  final String phone;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String openHours;
  final String priceRange;
  final List<String> categories;
  final List<MenuItem> menu;
  final double latitude;
  final double longitude;
  final Promo? promo;

  const Cafe({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.openHours,
    required this.priceRange,
    required this.categories,
    required this.menu,
    required this.latitude,
    required this.longitude,
    this.promo,
  });

  // ============================================
  // FIRESTORE: FROM MAP
  // ============================================

  factory Cafe.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    final menuData = map['menu'];
    final promoData = map['promo'];

    return Cafe(
      id: id ?? map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      rating: _toDouble(map['rating']),
      reviewCount: _toInt(map['reviewCount']),
      openHours: map['openHours']?.toString() ?? '',
      priceRange: map['priceRange']?.toString() ?? '',
      categories: map['categories'] is List
          ? List<String>.from(
              (map['categories'] as List).map(
                (item) => item.toString(),
              ),
            )
          : [],
      menu: menuData is List
          ? menuData
              .whereType<Map>()
              .map(
                (item) => MenuItem.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      promo: promoData is Map
          ? Promo.fromMap(
              Map<String, dynamic>.from(promoData),
            )
          : null,
    );
  }

  // ============================================
  // FIRESTORE: TO MAP
  // ============================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'openHours': openHours,
      'priceRange': priceRange,
      'categories': categories,
      'menu': menu.map((item) => item.toMap()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'promo': promo?.toMap(),
    };
  }
}

// ============================================
// MENU ITEM
// ============================================

class MenuItem {
  final String name;
  final int price;
  final String imageUrl;
  final String category;

  const MenuItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name']?.toString() ?? '',
      price: _toInt(map['price']),
      imageUrl: map['imageUrl']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}

// ============================================
// PROMO
// ============================================

class Promo {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String cafeName;
  final int price;

  const Promo({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.cafeName,
    required this.price,
  });

  factory Promo.fromMap(Map<String, dynamic> map) {
    return Promo(
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      cafeName: map['cafeName']?.toString() ?? '',
      price: _toInt(map['price']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'cafeName': cafeName,
      'price': price,
    };
  }
}

// ============================================
// HELPER KONVERSI ANGKA
// ============================================

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

int _toInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}