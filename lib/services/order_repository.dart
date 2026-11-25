
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  final String _collectionName = 'orders';

  // ==========================================
  // SIMPAN PESANAN KE FIRESTORE
  // ==========================================
  Future<Order> saveOrder({
    required Order order,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID tidak boleh kosong.');
    }

    // Gunakan ID dokumen otomatis agar tidak mudah bentrok.
    final docRef = _firestore.collection(_collectionName).doc();

    // Buat objek pesanan dengan ID Firestore.
    final savedOrder = Order(
      id: docRef.id,
      items: order.items,
      subtotal: order.subtotal,
      serviceFee: order.serviceFee,
      total: order.total,
      namaPenerima: order.namaPenerima,
      nomorHp: order.nomorHp,
      cafeName: order.cafeName,
      metodeBayar: order.metodeBayar,
      catatan: order.catatan,
      tanggal: order.tanggal,
      status: order.status,
      pickupTime: order.pickupTime,
    );

    final data = savedOrder.toJson();

    // Tambahkan identitas pemilik pesanan.
    data['userId'] = userId;

    // Gunakan Timestamp Firestore untuk tanggal.
    data['tanggal'] = Timestamp.fromDate(savedOrder.tanggal);

    data['pickupTime'] = savedOrder.pickupTime != null
        ? Timestamp.fromDate(savedOrder.pickupTime!)
        : null;

    data['createdAt'] = FieldValue.serverTimestamp();

    // Simpan dokumen.
    await docRef.set(data);

    return savedOrder;
  }

  // ==========================================
  // AMBIL RIWAYAT PESANAN PENGGUNA
  // ==========================================
  Future<List<Order>> getOrders(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID tidak boleh kosong.');
    }

    final snapshot = await _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .get();

    final orders = snapshot.docs.map((doc) {
      return _orderFromFirestore(doc.data(), doc.id);
    }).toList();

    // Urutkan dari pesanan terbaru.
    orders.sort(
      (a, b) => b.tanggal.compareTo(a.tanggal),
    );

    return orders;
  }

  // ==========================================
  // PANTAU RIWAYAT PESANAN SECARA REAL-TIME
  // ==========================================
  Stream<List<Order>> watchOrders(String userId) {
    if (userId.isEmpty) {
      throw Exception('User ID tidak boleh kosong.');
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        return _orderFromFirestore(doc.data(), doc.id);
      }).toList();

      orders.sort(
        (a, b) => b.tanggal.compareTo(a.tanggal),
      );

      return orders;
    });
  }

  // ==========================================
  // KONVERSI DATA FIRESTORE MENJADI ORDER
  // ==========================================
  Order _orderFromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    final convertedData = Map<String, dynamic>.from(data);

    convertedData['id'] = documentId;

    final tanggal = convertedData['tanggal'];

    if (tanggal is Timestamp) {
      convertedData['tanggal'] =
          tanggal.toDate().toIso8601String();
    }

    final pickupTime = convertedData['pickupTime'];

    if (pickupTime is Timestamp) {
      convertedData['pickupTime'] =
          pickupTime.toDate().toIso8601String();
    }

    return Order.fromJson(convertedData);
  }
}