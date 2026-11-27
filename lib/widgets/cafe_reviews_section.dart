import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';

import '../models/cafe.dart';

/// Menyimpan / menghapus ulasan sekaligus memperbarui agregat di dokumen kafe
/// (rating, reviewCount, ratingTotal) dalam SATU transaksi.
///
/// [newRating] == null berarti hapus ulasan.
Future<void> _applyReview({
  required DocumentReference<Map<String, dynamic>> cafeRef,
  required DocumentReference<Map<String, dynamic>> reviewRef,
  int? newRating,
  Map<String, dynamic>? reviewData,
}) {
  return FirebaseFirestore.instance.runTransaction((tx) async {
    // Semua pembacaan harus dilakukan sebelum penulisan.
    final cafeSnap = await tx.get(cafeRef);
    final reviewSnap = await tx.get(reviewRef);

    final int? oldRating =
        reviewSnap.exists ? (reviewSnap.data()?['rating'] as num?)?.toInt() : null;

    if (newRating == null) {
      if (!reviewSnap.exists) return;
      tx.delete(reviewRef);
    } else {
      tx.set(reviewRef, reviewData!);
    }

    // Dokumen kafe belum ada (mis. data dummy) -> lewati agregat.
    if (!cafeSnap.exists) return;

    final data = cafeSnap.data()!;
    int count = (data['reviewCount'] as num?)?.toInt() ?? 0;
    final double oldAvg = (data['rating'] as num?)?.toDouble() ?? 0.0;

    // Jika ratingTotal belum ada, turunkan dari data lama (rating x jumlah).
    double total = (data['ratingTotal'] as num?)?.toDouble() ?? (oldAvg * count);

    if (oldRating != null) {
      total -= oldRating;
      count -= 1;
    }
    if (newRating != null) {
      total += newRating;
      count += 1;
    }

    if (count <= 0) {
      count = 0;
      total = 0;
    }

    final double avg = count == 0 ? 0.0 : total / count;

    tx.update(cafeRef, {
      'ratingTotal': total,
      'reviewCount': count,
      'rating': double.parse(avg.toStringAsFixed(1)),
    });
  });
}

/// Bagian "Ulasan" untuk halaman detail cafe.
///
/// Data disimpan di Firestore: cafes/{idCafe}/reviews/{uidUser}
/// Satu user = satu ulasan (menulis lagi akan memperbarui ulasan lamanya).
/// Field: userId, userName, rating (1-5), comment, createdAt.
class CafeReviewsSection extends StatefulWidget {
  final Cafe cafe;

  const CafeReviewsSection({super.key, required this.cafe});

  @override
  State<CafeReviewsSection> createState() => _CafeReviewsSectionState();
}

class _CafeReviewsSectionState extends State<CafeReviewsSection> {
  static const Color _primary = Color(0xFFC8956D);
  static const Color _card = Color(0xFF181818);
  static const int _previewCount = 5;

  bool _showAll = false;

  DocumentReference<Map<String, dynamic>> get _cafeRef {
    final cafe = widget.cafe;
    final docId = (cafe.id != null && cafe.id!.isNotEmpty)
        ? cafe.id!
        : Uri.encodeComponent(cafe.name);

    return FirebaseFirestore.instance.collection('cafes').doc(docId);
  }

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _cafeRef.collection('reviews');

  String get _myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  String _formatDate(dynamic value) {
    if (value is! Timestamp) return '';
    final d = value.toDate();
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> _openWriteSheet(Map<String, dynamic>? existing) async {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk menulis ulasan.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ReviewForm(
        cafeName: widget.cafe.name,
        cafeRef: _cafeRef,
        reviews: _reviews,
        existing: existing,
      ),
    );
  }

  Future<void> _deleteMine() async {
    try {
      await _applyReview(
        cafeRef: _cafeRef,
        reviewRef: _reviews.doc(_myUid),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus ulasan.')),
      );
    }
  }

  Widget _stars(num rating, {double size = 14}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.round() ? Icons.star : Icons.star_border,
          color: const Color(0xFFFFC107),
          size: size,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reviews
            .orderBy('createdAt', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          final data = docs.map((d) => d.data()).toList();

          double average = 0;
          if (data.isNotEmpty) {
            final total = data.fold<double>(
              0,
              (acc, r) => acc + ((r['rating'] as num?) ?? 0).toDouble(),
            );
            average = total / data.length;
          }

          Map<String, dynamic>? mine;
          for (final r in data) {
            if (r['userId'] == _myUid && _myUid.isNotEmpty) mine = r;
          }

          final visible = _showAll ? data : data.take(_previewCount).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: Color(0xFF252525), height: 32),
              Row(
                children: [
                  const Text(
                    'Ulasan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (data.isNotEmpty) ...[
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      average.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '  ·  ${data.length} ulasan',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              if (snapshot.hasError)
                const Text(
                  'Ulasan belum bisa dimuat. Periksa koneksi atau aturan Firestore.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              else if (snapshot.connectionState == ConnectionState.waiting &&
                  data.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(color: _primary),
                  ),
                )
              else if (data.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Belum ada ulasan. Jadilah yang pertama!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...visible.map((r) {
                  final isMine = _myUid.isNotEmpty && r['userId'] == _myUid;
                  final comment = (r['comment'] ?? '').toString();

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isMine ? _primary : const Color(0xFF252525),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isMine
                                    ? '${r['userName'] ?? 'Pengguna'} (kamu)'
                                    : (r['userName'] ?? 'Pengguna').toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              _formatDate(r['createdAt']),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            if (isMine)
                              GestureDetector(
                                onTap: _deleteMine,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _stars((r['rating'] as num?) ?? 0),
                        if (comment.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            comment,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              if (data.length > _previewCount)
                TextButton(
                  onPressed: () => setState(() => _showAll = !_showAll),
                  child: Text(
                    _showAll
                        ? 'Sembunyikan'
                        : 'Lihat ${data.length - _previewCount} ulasan lainnya',
                    style: const TextStyle(color: _primary),
                  ),
                ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openWriteSheet(mine),
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(mine == null ? 'Tulis Ulasan' : 'Ubah Ulasanku'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================
// FORM TULIS ULASAN (bottom sheet)
// ============================================
class _ReviewForm extends StatefulWidget {
  final String cafeName;
  final DocumentReference<Map<String, dynamic>> cafeRef;
  final CollectionReference<Map<String, dynamic>> reviews;
  final Map<String, dynamic>? existing;

  const _ReviewForm({
    required this.cafeName,
    required this.cafeRef,
    required this.reviews,
    this.existing,
  });

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  static const Color _primary = Color(0xFFC8956D);

  late int _rating;
  late final TextEditingController _comment;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = ((widget.existing?['rating'] as num?) ?? 0).toInt();
    _comment = TextEditingController(
      text: (widget.existing?['comment'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<String> _userName(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final name = (doc.data()?['name'] ?? '').toString().trim();
      if (name.isNotEmpty) return name;
    } catch (_) {}

    final display = (user.displayName ?? '').trim();
    if (display.isNotEmpty) return display;

    final email = user.email ?? '';
    return email.contains('@') ? email.split('@').first : 'Pengguna';
  }

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih bintang dulu ya.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final name = await _userName(user);

      await _applyReview(
        cafeRef: widget.cafeRef,
        reviewRef: widget.reviews.doc(user.uid),
        newRating: _rating,
        reviewData: {
          'userId': user.uid,
          'userName': name,
          'rating': _rating,
          'comment': _comment.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan gagal disimpan. Periksa koneksi dan aturan Firestore.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ulasan untuk ${widget.cafeName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFC107),
                    size: 36,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _comment,
            maxLines: 3,
            maxLength: 300,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ceritakan pengalamanmu (opsional)',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF121212),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text('Kirim Ulasan'),
            ),
          ),
        ],
      ),
    );
  }
}