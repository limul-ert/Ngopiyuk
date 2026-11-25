
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cafe.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/order_repository.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({OrderRepository? orderRepository})
      : _orderRepository = orderRepository ?? OrderRepository();

  final OrderRepository _orderRepository;

  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;

  bool _isLoadingOrders = false;
  bool get isLoadingOrders => _isLoadingOrders;

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get subtotal {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  static const int serviceFee = 5000;
  int get total => subtotal + serviceFee;

  // ===== NAMA CAFE =====
  String get cafeName {
    if (_items.isEmpty) return 'Cafe';
    return _items.first.cafeName;
  }

  bool get hasMultipleCafes {
    if (_items.isEmpty) return false;

    final firstCafe = _items.first.cafeName;
    return _items.any((item) => item.cafeName != firstCafe);
  }

  // ===== LOAD KERANJANG LOKAL =====
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');

    if (cartJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items.clear();
        _items.addAll(
          decoded.map(
            (item) => CartItem.fromJson(item),
          ),
        );
      } catch (e) {
        debugPrint('Gagal memuat keranjang: $e');
      }
    }

    notifyListeners();
  }

  // ===== SIMPAN KERANJANG LOKAL =====
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'cart',
      jsonEncode(
        _items.map((item) => item.toJson()).toList(),
      ),
    );
  }

  // ===== LOAD RIWAYAT DARI FIRESTORE =====
  Future<void> loadOrders() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _orders.clear();
      notifyListeners();
      return;
    }

    _isLoadingOrders = true;
    notifyListeners();

    try {
      final result = await _orderRepository.getOrders(user.uid);

      _orders
        ..clear()
        ..addAll(result);
    } catch (e) {
      debugPrint('Gagal memuat riwayat pesanan: $e');
      rethrow;
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  // ===== TAMBAH ITEM =====
  void addItem(MenuItem item, String cafeName) {
    final existingIndex = _items.indexWhere(
      (i) => i.item.name == item.name && i.cafeName == cafeName,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItem(item: item, cafeName: cafeName),
      );
    }

    _saveCart();
    notifyListeners();
  }

  // ===== TAMBAH JUMLAH =====
  void increment(int index) {
    _items[index].quantity++;
    _saveCart();
    notifyListeners();
  }

  // ===== KURANGI JUMLAH =====
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

  // ===== KOSONGKAN KERANJANG =====
  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  // ===== BUAT PESANAN DAN SIMPAN KE FIRESTORE =====
  Future<Order> createOrder({
    required String namaPenerima,
    required String nomorHp,
    required String metodeBayar,
    required String catatan,
    DateTime? pickupTime,
  }) async {
    // Pastikan pengguna sudah login.
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    // Pastikan keranjang tidak kosong.
    if (_items.isEmpty) {
      throw Exception('Keranjang masih kosong.');
    }

    // Satu pesanan hanya untuk satu kafe.
    if (hasMultipleCafes) {
      throw Exception(
        'Pesanan harus berasal dari satu kafe.',
      );
    }

    // Buat objek pesanan sementara.
    final order = Order(
      id: 'PENDING',
      items: _items.map((item) {
        return CartItem(
          item: item.item,
          cafeName: item.cafeName,
          quantity: item.quantity,
        );
      }).toList(),
      subtotal: subtotal,
      serviceFee: serviceFee,
      total: total,
      namaPenerima: namaPenerima,
      nomorHp: nomorHp,
      cafeName: cafeName,
      metodeBayar: metodeBayar,
      catatan: catatan,
      tanggal: DateTime.now(),
      pickupTime: pickupTime,
    );

    // Simpan ke Firestore.
    // Jika gagal, keranjang tidak akan dikosongkan.
    final savedOrder = await _orderRepository.saveOrder(
      order: order,
      userId: user.uid,
    );

    // Tambahkan pesanan yang berhasil disimpan.
    _orders.insert(0, savedOrder);

    // Kosongkan keranjang setelah penyimpanan berhasil.
    _items.clear();
    await _saveCart();

    notifyListeners();

    return savedOrder;
  }
}