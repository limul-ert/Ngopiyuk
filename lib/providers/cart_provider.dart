import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cafe.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get subtotal {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  static const int serviceFee = 5000;
  int get total => subtotal + serviceFee;

  // ===== LOAD DARI SHARED PREFERENCES =====
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    final ordersJson = prefs.getString('orders');

    if (cartJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items.clear();
        _items.addAll(decoded.map((i) => CartItem.fromJson(i)));
      } catch (_) {}
    }

    if (ordersJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(ordersJson);
        _orders.clear();
        _orders.addAll(decoded.map((i) => Order.fromJson(i)));
      } catch (_) {}
    }

    notifyListeners();
  }

  // ===== SIMPAN KE SHARED PREFERENCES =====
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'cart',
      jsonEncode(_items.map((i) => i.toJson()).toList()),
    );
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'orders',
      jsonEncode(_orders.map((i) => i.toJson()).toList()),
    );
  }

  // ===== TAMBAH ITEM =====
  void addItem(MenuItem item, String cafeName) {
    // Cek apakah item sudah ada (berdasarkan nama + cafe)
    final existingIndex = _items.indexWhere((i) =>
    i.item.name == item.name && i.cafeName == cafeName);

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(item: item, cafeName: cafeName));
    }

    _saveCart();
    notifyListeners();
  }

  // ===== TAMBAH QUANTITY =====
  void increment(int index) {
    _items[index].quantity++;
    _saveCart();
    notifyListeners();
  }

  // ===== KURANGI QUANTITY =====
  void decrement(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    _saveCart();
    notifyListeners();
  }

  // ===== HAPUS ITEM =====
  void removeItem(int index) {
    _items.removeAt(index);
    _saveCart();
    notifyListeners();
  }

  // ===== CLEAR CART =====
  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  // ===== BUAT ORDER BARU =====
  Future<Order> createOrder({
    required String namaPenerima,
    required String nomorHp,
    required String alamat,
    required String metodeBayar,
    required String catatan,
  }) async {
    final orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final order = Order(
      id: orderId,
      items: List.from(_items),
      subtotal: subtotal,
      serviceFee: serviceFee,
      total: total,
      namaPenerima: namaPenerima,
      nomorHp: nomorHp,
      alamat: alamat,
      metodeBayar: metodeBayar,
      catatan: catatan,
      tanggal: DateTime.now(),
    );

    _orders.insert(0, order); // Terbaru di atas
    await _saveOrders();

    // Clear cart setelah checkout
    _items.clear();
    await _saveCart();
    notifyListeners();

    return order;
  }
}