
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cafe.dart';

class CafeRepository {
  CafeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // ============================================
  // COLLECTION
  // ============================================

  CollectionReference<Map<String, dynamic>> get _cafesCollection =>
      _firestore.collection('cafes');

  CollectionReference<Map<String, dynamic>> get _promosCollection =>
      _firestore.collection('promos');

  // ============================================
  // AMBIL SEMUA DATA KAFE
  // ============================================

  Future<List<Cafe>> getCafes() async {
    final snapshot = await _cafesCollection.get();

    return snapshot.docs.map((doc) {
      return Cafe.fromMap(
        doc.data(),
        id: doc.id,
      );
    }).toList();
  }

  // ============================================
  // STREAM DATA KAFE
  // ============================================

  Stream<List<Cafe>> watchCafes() {
    return _cafesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cafe.fromMap(
          doc.data(),
          id: doc.id,
        );
      }).toList();
    });
  }

  // ============================================
  // AMBIL KAFE BERDASARKAN ID
  // ============================================

  Future<Cafe?> getCafeById(String id) async {
    final doc = await _cafesCollection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return Cafe.fromMap(
      doc.data()!,
      id: doc.id,
    );
  }

  // ============================================
  // AMBIL SEMUA PROMO
  // ============================================

  Future<List<Promo>> getPromos() async {
    final snapshot = await _promosCollection.get();

    return snapshot.docs.map((doc) {
      return Promo.fromMap(doc.data());
    }).toList();
  }

  // ============================================
  // STREAM DATA PROMO
  // ============================================

  Stream<List<Promo>> watchPromos() {
    return _promosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Promo.fromMap(doc.data());
      }).toList();
    });
  }
}