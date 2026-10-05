import 'cafe.dart';

class CartItem {
  final MenuItem item;
  final String cafeName;
  int quantity;

  CartItem({
    required this.item,
    required this.cafeName,
    this.quantity = 1,
  });

  int get subtotal => item.price * quantity;

  // Convert ke JSON untuk SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'name': item.name,
      'price': item.price,
      'imageUrl': item.imageUrl,
      'category': item.category,
      'cafeName': cafeName,
      'quantity': quantity,
    };
  }

  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: MenuItem(
        name: json['name'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        category: json['category'],
      ),
      cafeName: json['cafeName'],
      quantity: json['quantity'],
    );
  }
}