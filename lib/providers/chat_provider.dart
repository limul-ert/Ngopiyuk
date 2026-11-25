import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';

import '../models/cafe.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Random _random = Random();

  final Map<String, List<ChatMessage>> _chats = {};
  final Map<String, Cafe> _cafes = {};
  final Map<String, String> _cafeIds = {};

  final Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      _subscriptions = {};

  String? _activeUserId;
  bool _isDisposed = false;

  // ===== UID PENGGUNA =====

  String? get _userId => _auth.currentUser?.uid;

  // ===== COLLECTION FIRESTORE =====

  CollectionReference<Map<String, dynamic>> _messagesCollection(
    String userId,
  ) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages');
  }

  // ===== ID CAFE =====

  String _getCafeId(Cafe cafe) {
    if (cafe.id != null && cafe.id!.isNotEmpty) {
      return cafe.id!;
    }

    return Uri.encodeComponent(cafe.name);
  }

  // ===== GET PESAN =====

  List<ChatMessage> getMessages(String cafeName) {
    return List.unmodifiable(_chats[cafeName] ?? []);
  }

  bool hasChat(String cafeName) {
    return (_chats[cafeName]?.isNotEmpty ?? false);
  }

  // ===== NOTIFY LISTENERS =====

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ===== RESET KETIKA AKUN BERGANTI =====

  Future<void> _checkUser() async {
    final userId = _userId;

    if (userId == null) {
      throw Exception('Silakan login terlebih dahulu untuk menggunakan chat.');
    }

    if (_activeUserId != userId) {
      for (final subscription in _subscriptions.values) {
        await subscription.cancel();
      }

      _subscriptions.clear();
      _chats.clear();
      _cafes.clear();
      _cafeIds.clear();

      _activeUserId = userId;
    }
  }

  // ===== LOAD CHAT DARI FIRESTORE =====

  Future<void> loadChat(Cafe cafe) async {
    await _checkUser();

    final userId = _userId!;
    final cafeName = cafe.name;
    final cafeId = _getCafeId(cafe);

    _cafes[cafeName] = cafe;
    _cafeIds[cafeName] = cafeId;

    // Jangan membuat listener yang sama berulang kali.
    if (_subscriptions.containsKey(cafeName)) {
      return;
    }

    final collection = _messagesCollection(userId);

    // Ambil pesan dari Firestore.
    final snapshot = await collection
        .where('cafeId', isEqualTo: cafeId)
        .get();

    // Pastikan akun belum berubah selama proses pengambilan data.
    if (_userId != userId) return;

    final messages = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;

      return ChatMessage.fromJson(data);
    }).toList();

    messages.sort(
      (a, b) => a.timestamp.compareTo(b.timestamp),
    );

    _chats[cafeName] = messages;

    // Jika belum ada pesan, buat pesan sambutan.
    if (messages.isEmpty) {
      await _saveMessage(
        userId: userId,
        cafeId: cafeId,
        message: _buildWelcomeMessage(cafe),
      );
    }

    _notify();

    // Dengarkan perubahan pesan secara realtime.
    _subscriptions[cafeName] = collection
        .where('cafeId', isEqualTo: cafeId)
        .snapshots()
        .listen(
      (snapshot) {
        if (_userId != userId) return;

        final updatedMessages = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;

          return ChatMessage.fromJson(data);
        }).toList();

        updatedMessages.sort(
          (a, b) => a.timestamp.compareTo(b.timestamp),
        );

        _chats[cafeName] = updatedMessages;
        _notify();
      },
      onError: (error) {
        debugPrint('Error realtime chat: $error');
      },
    );
  }

  // ===== SIMPAN PESAN KE FIRESTORE =====

  Future<void> _saveMessage({
    required String userId,
    required String cafeId,
    required ChatMessage message,
  }) async {
    final collection = _messagesCollection(userId);
    final document = collection.doc();

    await document.set({
      'cafeId': cafeId,
      'text': message.text,
      'isUser': message.isUser,
      'timestamp': Timestamp.fromDate(message.timestamp),
    });
  }

  // ===== KIRIM PESAN USER + AUTO REPLY =====

  Future<void> sendMessage(Cafe cafe, String text) async {
    await _checkUser();

    if (text.trim().isEmpty) return;

    final userId = _userId!;
    final cafeId = _getCafeId(cafe);

    _cafes[cafe.name] = cafe;
    _cafeIds[cafe.name] = cafeId;

    // Pastikan chat sudah dimuat.
    if (!_subscriptions.containsKey(cafe.name)) {
      await loadChat(cafe);
    }

    if (_userId != userId) return;

    // 1. Simpan pesan pengguna.
    final userMessage = ChatMessage(
      id: '',
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    await _saveMessage(
      userId: userId,
      cafeId: cafeId,
      message: userMessage,
    );

    // 2. Tunggu agar indikator typing tetap terlihat.
    await Future.delayed(const Duration(milliseconds: 1200));

    // Pastikan pengguna belum berganti akun.
    if (_userId != userId) return;

    // 3. Buat balasan otomatis.
    final replyText = _generateReply(cafe, text);

    final cafeMessage = ChatMessage(
      id: '',
      text: replyText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    await _saveMessage(
      userId: userId,
      cafeId: cafeId,
      message: cafeMessage,
    );
  }

  // ===== HAPUS CHAT SATU CAFE =====

  Future<void> clearChat(String cafeName) async {
    await _checkUser();

    final userId = _userId!;
    final cafeId = _cafeIds[cafeName] ??
        Uri.encodeComponent(cafeName);

    final collection = _messagesCollection(userId);

    final snapshot = await collection
        .where('cafeId', isEqualTo: cafeId)
        .get();

    // Firestore batch maksimal 500 operasi.
    for (var i = 0; i < snapshot.docs.length; i += 500) {
      final batch = _firestore.batch();
      final end = min(i + 500, snapshot.docs.length);

      for (var j = i; j < end; j++) {
        batch.delete(snapshot.docs[j].reference);
      }

      await batch.commit();
    }

    _chats[cafeName] = [];
    _notify();

    // Pesan sambutan akan dibuat kembali saat chat dibuka.
  }

  // ===== GENERATE ID UNIK =====

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(9999)}';
  }

  // ===== WELCOME MESSAGE =====

  ChatMessage _buildWelcomeMessage(Cafe cafe) {
    return ChatMessage(
      id: _generateId(),
      text:
          'Halo! Selamat datang di ${cafe.name} ☕\n\n'
          'Ada yang bisa kami bantu? Kamu bisa tanya soal:\n'
          '• Reservasi meja\n'
          '• Pesan untuk acara / rombongan\n'
          '• Jam operasional\n'
          '• Menu & harga',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  // ============================================
  // AUTO-REPLY BERDASARKAN KEYWORD
  // ============================================

  String _generateReply(Cafe cafe, String userText) {
    final text = userText.toLowerCase();

    // ---- RESERVASI ----
    if (_contains(text, [
      'reservasi',
      'booking',
      'book',
      'meja',
      'table',
      'tempat duduk',
    ])) {
      return _pick([
        'Baik, untuk reservasi boleh info:\n'
            '• Tanggal & jam kedatangan\n'
            '• Jumlah orang\n'
            '• Nama atas nama siapa\n\n'
            'Nanti admin kami konfirmasi ya 😊',
        'Siap! Untuk reservasi meja, tolong sebutkan tanggal, jam, dan jumlah orangnya ya Kak 🙏',
      ]);
    }

    // ---- ACARA / EVENT ----
    if (_contains(text, [
      'acara',
      'event',
      'rombongan',
      'party',
      'ulang tahun',
      'kantor',
      'komunitas',
      'arisan',
    ])) {
      return _pick([
        'Wah, untuk acara kami siap bantu! 🎉\n\n'
            'Boleh info:\n'
            '• Tanggal acara\n'
            '• Perkiraan jumlah orang\n'
            '• Jenis acara\n\n'
            'Nanti kami kirim penawaran paketnya ya.',
        'Terima kasih infonya! Untuk pesanan acara/rombongan, admin kami akan hubungi untuk detail paket dan harga spesialnya ya Kak 😊',
      ]);
    }

    // ---- JAM BUKA ----
    if (_contains(text, [
      'buka',
      'tutup',
      'jam',
      'operasional',
      'open',
      'close',
    ])) {
      return 'Jam operasional ${cafe.name} adalah *${cafe.openHours}* ya Kak 🕐\n\nAda lagi yang bisa dibantu?';
    }

    // ---- MENU ----
    if (_contains(text, [
      'menu',
      'makanan',
      'minuman',
      'food',
      'drink',
    ])) {
      return 'Menu lengkap kami bisa dilihat di halaman cafe ya Kak 📋\n\n'
          'Kalau ada menu tertentu yang mau ditanyakan, tulis aja nama menunya 😊';
    }

    // ---- HARGA ----
    if (_contains(text, [
      'harga',
      'biaya',
      'price',
      'berapa',
      'tarif',
    ])) {
      return 'Range harga menu di ${cafe.name}: *${cafe.priceRange}* 💰\n\n'
          'Untuk paket acara, harga bisa nego sesuai jumlah pesanan ya.';
    }

    // ---- ALAMAT / LOKASI ----
    if (_contains(text, [
      'alamat',
      'lokasi',
      'dimana',
      'di mana',
      'maps',
      'map',
    ])) {
      return 'Lokasi kami di:\n📍 ${cafe.address}\n\n'
          'Bisa juga klik tombol "Buka di Maps" di halaman cafe untuk navigasi langsung ya 🗺️';
    }

    // ---- KONTAK ----
    if (_contains(text, [
      'kontak',
      'nomor',
      'telepon',
      'telp',
      'wa',
      'whatsapp',
      'hubungi',
    ])) {
      return 'Nomor yang bisa dihubungi: *${cafe.phone}* ☎️\n\nTapi kamu juga bisa langsung chat di sini kok 😊';
    }

    // ---- SAPAAN ----
    if (_contains(text, [
      'halo',
      'hai',
      'hi',
      'hello',
      'assalamualaikum',
      'pagi',
      'siang',
      'sore',
      'malam',
    ])) {
      return _pick([
        'Halo juga! 👋 Ada yang bisa kami bantu?',
        'Hai! Selamat datang di ${cafe.name} ☕ Ada yang ingin ditanyakan?',
        'Halo Kak! Ada yang bisa kami bantu hari ini? 😊',
      ]);
    }

    // ---- TERIMA KASIH ----
    if (_contains(text, [
      'terima kasih',
      'thanks',
      'thank you',
      'makasih',
      'thx',
      'tq',
    ])) {
      return _pick([
        'Sama-sama Kak! 🙏 Semoga harimu menyenangkan ☕',
        'Dengan senang hati 😊 Kalau ada pertanyaan lain, chat aja ya!',
      ]);
    }

    // ---- OK / SIAP ----
    if (_contains(text, [
      'oke',
      'ok',
      'siap',
      'baik',
      'yes',
      'ya',
    ])) {
      return 'Baik Kak, ditunggu ya! Kalau ada yang perlu ditanyakan lagi, langsung chat aja 😊';
    }

    // ---- DEFAULT ----
    return _pick([
      'Terima kasih atas pesannya! Admin kami akan segera membalas 🙏',
      'Pesan kamu sudah kami terima. Admin akan segera merespon ya Kak 😊',
      'Noted Kak! Admin kami akan segera balas pesanmu 🙏',
    ]);
  }

  // ===== HELPER: CEK KEYWORD =====

  bool _contains(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  // ===== HELPER: PILIH RANDOM =====

  String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }

  // ===== DISPOSE =====

  @override
  void dispose() {
    _isDisposed = true;

    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }

    _subscriptions.clear();

    super.dispose();
  }
}
