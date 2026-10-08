import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cafe.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _chats = {};
  final Random _random = Random();

  // ===== GET PESAN UNTUK CAFE TERTENTU =====
  List<ChatMessage> getMessages(String cafeName) {
    return _chats[cafeName] ?? [];
  }

  bool hasChat(String cafeName) {
    return _chats.containsKey(cafeName) &&
        (_chats[cafeName]?.isNotEmpty ?? false);
  }

  // ===== LOAD CHAT DARI SHARED PREFERENCES =====
  Future<void> loadChat(Cafe cafe) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'chat_${cafe.name}';
    final raw = prefs.getString(key);

    if (raw != null) {
      try {
        final List<dynamic> decoded = jsonDecode(raw);
        _chats[cafe.name] =
            decoded.map((e) => ChatMessage.fromJson(e)).toList();
      } catch (_) {
        _chats[cafe.name] = [];
      }
    } else {
      _chats[cafe.name] = [];
    }

    // Kalau kosong → kirim welcome message otomatis
    if (_chats[cafe.name]!.isEmpty) {
      _chats[cafe.name]!.add(_buildWelcomeMessage(cafe));
      await _saveChat(cafe.name);
    }

    notifyListeners();
  }

  // ===== SIMPAN KE SHARED PREFERENCES =====
  Future<void> _saveChat(String cafeName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'chat_$cafeName';
    await prefs.setString(
      key,
      jsonEncode(_chats[cafeName]!.map((m) => m.toJson()).toList()),
    );
  }

  // ===== KIRIM PESAN USER + AUTO-REPLY =====
  Future<void> sendMessage(Cafe cafe, String text) async {
    if (text.trim().isEmpty) return;

    // 1. Tambah pesan user
    _chats[cafe.name] ??= [];
    _chats[cafe.name]!.add(ChatMessage(
      id: _generateId(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
    await _saveChat(cafe.name);

    // 2. Tunggu biar keliatan natural (typing)
    await Future.delayed(const Duration(milliseconds: 1200));

    // 3. Auto-reply dari cafe
    final replyText = _generateReply(cafe, text);
    _chats[cafe.name]!.add(ChatMessage(
      id: _generateId(),
      text: replyText,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
    await _saveChat(cafe.name);
  }

  // ===== HAPUS CHAT SATU CAFE =====
  Future<void> clearChat(String cafeName) async {
    _chats[cafeName] = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_$cafeName');
    notifyListeners();
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
    if (_contains(text, ['reservasi', 'booking', 'book', 'meja', 'table', 'tempat duduk'])) {
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
    if (_contains(text, ['acara', 'event', 'rombongan', 'party', 'ulang tahun', 'kantor', 'komunitas', 'arisan'])) {
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
    if (_contains(text, ['buka', 'tutup', 'jam', 'operasional', 'open', 'close'])) {
      return 'Jam operasional ${cafe.name} adalah *${cafe.openHours}* ya Kak 🕐\n\nAda lagi yang bisa dibantu?';
    }

    // ---- MENU ----
    if (_contains(text, ['menu', 'makanan', 'minuman', 'food', 'drink'])) {
      return 'Menu lengkap kami bisa dilihat di halaman cafe ya Kak 📋\n\n'
          'Kalau ada menu tertentu yang mau ditanyakan, tulis aja nama menunya 😊';
    }

    // ---- HARGA ----
    if (_contains(text, ['harga', 'biaya', 'price', 'berapa', 'tarif'])) {
      return 'Range harga menu di ${cafe.name}: *${cafe.priceRange}* 💰\n\n'
          'Untuk paket acara, harga bisa nego sesuai jumlah pesanan ya.';
    }

    // ---- ALAMAT / LOKASI ----
    if (_contains(text, ['alamat', 'lokasi', 'dimana', 'di mana', 'maps', 'map'])) {
      return 'Lokasi kami di:\n📍 ${cafe.address}\n\n'
          'Bisa juga klik tombol "Buka di Maps" di halaman cafe untuk navigasi langsung ya 🗺️';
    }

    // ---- KONTAK ----
    if (_contains(text, ['kontak', 'nomor', 'telepon', 'telp', 'wa', 'whatsapp', 'hubungi'])) {
      return 'Nomor yang bisa dihubungi: *${cafe.phone}* ☎️\n\nTapi kamu juga bisa langsung chat di sini kok 😊';
    }

    // ---- SAPAAN ----
    if (_contains(text, ['halo', 'hai', 'hi', 'hello', 'assalamualaikum', 'pagi', 'siang', 'sore', 'malam'])) {
      return _pick([
        'Halo juga! 👋 Ada yang bisa kami bantu?',
        'Hai! Selamat datang di ${cafe.name} ☕ Ada yang ingin ditanyakan?',
        'Halo Kak! Ada yang bisa kami bantu hari ini? 😊',
      ]);
    }

    // ---- TERIMA KASIH ----
    if (_contains(text, ['terima kasih', 'thanks', 'thank you', 'makasih', 'thx', 'tq'])) {
      return _pick([
        'Sama-sama Kak! 🙏 Semoga harimu menyenangkan ☕',
        'Dengan senang hati 😊 Kalau ada pertanyaan lain, chat aja ya!',
      ]);
    }

    // ---- OK / SIAP ----
    if (_contains(text, ['oke', 'ok', 'siap', 'baik', 'yes', 'ya'])) {
      return 'Baik Kak, ditunggu ya! Kalau ada yang perlu ditanyakan lagi, langsung chat aja 😊';
    }

    // ---- DEFAULT ----
    return _pick([
      'Terima kasih atas pesannya! Admin kami akan segera membalas 🙏',
      'Pesan kamu sudah kami terima. Admin akan segera merespon ya Kak 😊',
      'Noted Kak! Admin kami akan segera balas pesanmu 🙏',
    ]);
  }

  // ===== HELPER: CEK APAKAH TEXT MENGANDUNG SALAH SATU KEYWORD =====
  bool _contains(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  // ===== HELPER: PILIH RANDOM DARI LIST =====
  String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}