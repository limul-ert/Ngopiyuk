class Cafe {
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
}

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
}

class Promo {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String cafeName;
  final int price; // ← ✅ BARU

  const Promo({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.cafeName,
    required this.price,
  });
}