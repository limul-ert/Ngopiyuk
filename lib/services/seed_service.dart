
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/dummy_cafes.dart';

class SeedService {
  SeedService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> seedFirestore() async {
    final batch = _firestore.batch();

    // Memasukkan data kafe.
    for (final cafe in dummyCafes) {
      final docRef = cafe.id != null && cafe.id!.isNotEmpty
          ? _firestore.collection('cafes').doc(cafe.id)
          : _firestore.collection('cafes').doc();

      batch.set(docRef, cafe.toMap());
    }

    // Memasukkan data promo.
    for (var i = 0; i < dummyPromos.length; i++) {
      final promo = dummyPromos[i];
      final docRef = _firestore.collection('promos').doc('promo_$i');

      batch.set(docRef, promo.toMap());
    }

    await batch.commit();
  }
}